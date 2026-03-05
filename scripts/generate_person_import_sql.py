#!/usr/bin/env python3
"""
Generate SQL import script for the `person` table from an .xlsx file.

The SQL uses stable markers in `createdby`/`modifiedby` as `xlsx_tt_<TT>`
so relations can be updated safely after inserts.
"""

from __future__ import annotations

import argparse
import re
import zipfile
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
import unicodedata
from typing import Dict, List, Optional, Tuple


NS = {"a": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}


@dataclass
class Row:
    tt: int
    fullname: str
    gender_raw: str
    dob_raw: str
    dod_raw: str
    generation: Optional[int]
    branch_raw: str
    relation_note: str
    hometown: str
    current_residence: str
    occupation: str
    other_note: str
    father_name: str
    mother_name: str
    spouse_name: str
    child_names: List[str]

    branch_norm: str = ""
    gender_norm: Optional[str] = None
    dob_sql: str = "NULL"
    dod_sql: str = "NULL"
    father_tt: Optional[int] = None
    mother_tt: Optional[int] = None
    spouse_tt: Optional[int] = None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate person import SQL from XLSX")
    parser.add_argument("--xlsx", required=True, help="Path to source XLSX")
    parser.add_argument("--output", required=True, help="Path to output .sql file")
    return parser.parse_args()


def get_cell_value(cell: ET.Element, shared_strings: List[str]) -> str:
    cell_type = cell.attrib.get("t")
    value = cell.find("a:v", NS)
    if value is None:
        return ""
    text = (value.text or "").strip()
    if cell_type == "s":
        idx = int(text)
        return shared_strings[idx] if 0 <= idx < len(shared_strings) else ""
    return text


def load_sheet_rows(xlsx_path: Path) -> List[Dict[str, str]]:
    with zipfile.ZipFile(xlsx_path) as archive:
        shared_strings: List[str] = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
            for item in root.findall("a:si", NS):
                shared_strings.append("".join(node.text or "" for node in item.findall(".//a:t", NS)))

        sheet = ET.fromstring(archive.read("xl/worksheets/sheet1.xml"))
        rows: List[Dict[str, str]] = []
        for row in sheet.findall(".//a:sheetData/a:row", NS):
            data: Dict[str, str] = {}
            for cell in row.findall("a:c", NS):
                ref = cell.attrib.get("r", "")
                col = "".join(ch for ch in ref if ch.isalpha())
                if not col:
                    continue
                data[col] = get_cell_value(cell, shared_strings).strip()
            if any(v for v in data.values()):
                rows.append(data)
        return rows


def normalize_spaces(text: str) -> str:
    return re.sub(r"\s+", " ", text or "").strip()


def trim_only(text: str) -> str:
    return (text or "").strip()


def normalize_name(text: str) -> str:
    value = normalize_spaces(text).lower()
    value = value.replace(".", "")
    value = value.replace(",", "")
    return value


def fold_ascii(text: str) -> str:
    value = unicodedata.normalize("NFD", text or "")
    value = "".join(ch for ch in value if unicodedata.category(ch) != "Mn")
    return normalize_name(value)


def normalize_branch(text: str, generation: Optional[int]) -> str:
    value = normalize_spaces(text)
    if not value:
        return "Chinh"
    m = re.search(r"(\d+)", value)
    if m:
        return str(int(m.group(1)))
    if value.lower() in {"main", "chinh", "chi goc"}:
        return "Chinh"
    if generation is not None and generation <= 3:
        return "Chinh"
    return value


def normalize_gender(text: str) -> Optional[str]:
    value = normalize_spaces(text).lower()
    if not value:
        return None
    if value in {"male", "nam", "m"}:
        return "male"
    if value in {"female", "nu", "nữ", "f"}:
        return "female"
    return "other"


def parse_generation(text: str) -> Optional[int]:
    value = normalize_spaces(text)
    if not value:
        return None
    if value.isdigit():
        return int(value)
    return None


def parse_date_sql(text: str, allow_year: bool) -> str:
    value = normalize_spaces(text)
    if not value:
        return "NULL"
    if allow_year and re.fullmatch(r"\d{4}", value):
        year = int(value)
        if 1000 <= year <= 3000:
            return f"'{year:04d}-01-01'"
        return "NULL"
    if re.fullmatch(r"\d{1,2}/\d{1,2}/\d{4}", value):
        try:
            dt = datetime.strptime(value, "%d/%m/%Y")
            return f"'{dt:%Y-%m-%d}'"
        except ValueError:
            return "NULL"
    return "NULL"


def sql_quote(text: str) -> str:
    return "'" + text.replace("\\", "\\\\").replace("'", "''") + "'"


def build_rows(raw_rows: List[Dict[str, str]]) -> List[Row]:
    out: List[Row] = []
    for idx, raw in enumerate(raw_rows):
        if idx == 0:
            continue
        tt_text = normalize_spaces(raw.get("A", ""))
        fullname = trim_only(raw.get("B", ""))
        if not tt_text.isdigit() or not fullname:
            continue
        row = Row(
            tt=int(tt_text),
            fullname=fullname,
            gender_raw=raw.get("C", ""),
            dob_raw=raw.get("D", ""),
            dod_raw=raw.get("E", ""),
            generation=parse_generation(raw.get("F", "")),
            branch_raw=raw.get("G", ""),
            relation_note=normalize_spaces(raw.get("H", "")),
            hometown=trim_only(raw.get("U", "")),
            current_residence=trim_only(raw.get("V", "")),
            occupation=trim_only(raw.get("W", "")),
            other_note=trim_only(raw.get("X", "")),
            father_name=normalize_spaces(raw.get("I", "")),
            mother_name=normalize_spaces(raw.get("J", "")),
            spouse_name=normalize_spaces(raw.get("K", "")),
            child_names=[normalize_spaces(raw.get(col, "")) for col in ["L", "M", "N", "O", "P", "Q", "R", "S", "T"] if normalize_spaces(raw.get(col, ""))],
        )
        row.branch_norm = normalize_branch(row.branch_raw, row.generation)
        row.gender_norm = normalize_gender(row.gender_raw)
        row.dob_sql = parse_date_sql(row.dob_raw, allow_year=True)
        row.dod_sql = parse_date_sql(row.dod_raw, allow_year=False)
        out.append(row)
    out.sort(key=lambda x: x.tt)
    return out


def score_candidate(src: Row, cand: Row, relation: str) -> Tuple[int, int, int, int, int]:
    # lower is better
    expected_gender = None
    if relation == "father":
        expected_gender = "male"
    elif relation == "mother":
        expected_gender = "female"
    elif relation == "spouse":
        if src.gender_norm == "male":
            expected_gender = "female"
        elif src.gender_norm == "female":
            expected_gender = "male"

    gender_penalty = 0
    if expected_gender and cand.gender_norm and cand.gender_norm != expected_gender:
        gender_penalty = 2

    gen_penalty = 0
    gen_distance = 99
    if src.generation is not None and cand.generation is not None:
        if relation in {"father", "mother"}:
            if cand.generation != src.generation - 1:
                gen_penalty = 1
            gen_distance = abs(cand.generation - (src.generation - 1))
        elif relation == "spouse":
            if cand.generation != src.generation:
                gen_penalty = 1
            gen_distance = abs(cand.generation - src.generation)
        elif relation == "child":
            if cand.generation != src.generation + 1:
                gen_penalty = 1
            gen_distance = abs(cand.generation - (src.generation + 1))
        else:
            gen_distance = abs(cand.generation - src.generation)

    branch_penalty = 0
    if src.branch_norm and cand.branch_norm and src.branch_norm != cand.branch_norm:
        branch_penalty = 1

    tt_distance = abs(src.tt - cand.tt)
    return (gender_penalty, gen_penalty, branch_penalty, gen_distance, tt_distance)


def resolve_relation(src: Row, target_name: str, relation: str, by_name: Dict[str, List[Row]]) -> Optional[int]:
    if not target_name:
        return None
    candidates = by_name.get(normalize_name(target_name), [])
    if not candidates:
        return None
    best = min(candidates, key=lambda cand: score_candidate(src, cand, relation))
    return best.tt


def infer_relation_from_note(src: Row, relation: str, rows: List[Row]) -> Optional[int]:
    note = fold_ascii(src.relation_note)
    if not note:
        return None
    if relation in {"father", "mother"} and "con" not in note:
        return None
    if relation == "spouse" and "vo" not in note and "chong" not in note:
        return None

    candidates: List[Row] = []
    for cand in rows:
        name_fold = fold_ascii(cand.fullname)
        if len(name_fold) < 6:
            continue
        if name_fold in note:
            candidates.append(cand)
    if not candidates:
        return None
    best = min(candidates, key=lambda cand: score_candidate(src, cand, relation))
    return best.tt


def resolve_links(rows: List[Row]) -> Dict[str, int]:
    by_name: Dict[str, List[Row]] = {}
    for row in rows:
        by_name.setdefault(normalize_name(row.fullname), []).append(row)

    unresolved_father = 0
    unresolved_mother = 0
    unresolved_spouse = 0

    for row in rows:
        row.father_tt = resolve_relation(row, row.father_name, "father", by_name)
        row.mother_tt = resolve_relation(row, row.mother_name, "mother", by_name)
        row.spouse_tt = resolve_relation(row, row.spouse_name, "spouse", by_name)
        if row.father_tt is None:
            row.father_tt = infer_relation_from_note(row, "father", rows)
        if row.spouse_tt is None:
            row.spouse_tt = infer_relation_from_note(row, "spouse", rows)
        if row.father_name and row.father_tt is None:
            unresolved_father += 1
        if row.mother_name and row.mother_tt is None:
            unresolved_mother += 1
        if row.spouse_name and row.spouse_tt is None:
            unresolved_spouse += 1

    # Backfill parent links from parent rows listing children (L..T columns)
    row_by_tt = {row.tt: row for row in rows}
    for parent in rows:
        for child_name in parent.child_names:
            child_tt = resolve_relation(parent, child_name, "child", by_name)
            if child_tt is None:
                continue
            child = row_by_tt.get(child_tt)
            if child is None:
                continue
            if parent.gender_norm == "male" and child.father_tt is None:
                child.father_tt = parent.tt
                if parent.spouse_tt is not None and child.mother_tt is None:
                    child.mother_tt = parent.spouse_tt
            if parent.gender_norm == "female" and child.mother_tt is None:
                child.mother_tt = parent.tt
                if parent.spouse_tt is not None and child.father_tt is None:
                    child.father_tt = parent.spouse_tt

    # enforce one-to-one spouse assignment
    partner_for: Dict[int, int] = {}
    for row in rows:
        if row.spouse_tt is None:
            continue
        a, b = row.tt, row.spouse_tt
        if a == b:
            row.spouse_tt = None
            continue
        if a in partner_for and partner_for[a] != b:
            row.spouse_tt = None
            continue
        if b in partner_for and partner_for[b] != a:
            row.spouse_tt = None
            continue
        partner_for[a] = b
        partner_for[b] = a

    # make spouse links symmetric
    for a, b in partner_for.items():
        if a in row_by_tt:
            row_by_tt[a].spouse_tt = b

    unresolved_father = sum(1 for row in rows if row.father_name and row.father_tt is None)
    unresolved_mother = sum(1 for row in rows if row.mother_name and row.mother_tt is None)
    unresolved_spouse = sum(1 for row in rows if row.spouse_name and row.spouse_tt is None)

    return {
        "unresolved_father": unresolved_father,
        "unresolved_mother": unresolved_mother,
        "unresolved_spouse": unresolved_spouse,
    }


def build_sql(rows: List[Row], stats: Dict[str, int]) -> str:
    branch_names = sorted({row.branch_norm for row in rows if row.branch_norm}, key=lambda x: (x != "Chinh", x))
    lines: List[str] = []
    lines.append("-- Auto-generated by scripts/generate_person_import_sql.py")
    lines.append("-- Source: data.xlsx")
    lines.append(f"-- Rows: {len(rows)}")
    lines.append(
        "-- Unresolved refs: father={unresolved_father}, mother={unresolved_mother}, spouse={unresolved_spouse}".format(
            **stats
        )
    )
    lines.append("")
    lines.append("START TRANSACTION;")
    lines.append("SET SQL_SAFE_UPDATES = 0;")
    lines.append("")
    lines.append("-- Ensure required branches exist")
    for name in branch_names:
        lines.append(
            "INSERT INTO `branch` (`name`, `description`, `createddate`, `modifieddate`, `createdby`, `modifiedby`)\n"
            f"SELECT {sql_quote(name)}, 'Imported from data.xlsx', NOW(), NOW(), 'xlsx_import', 'xlsx_import'\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM `branch` b WHERE b.`name` = {sql_quote(name)});"
        )
    lines.append("")
    lines.append("-- Insert persons (idempotent by createdby marker)")
    for row in rows:
        marker = f"xlsx_tt_{row.tt}"
        gender_sql = "NULL" if row.gender_norm is None else sql_quote(row.gender_norm)
        generation_sql = "NULL" if row.generation is None else str(row.generation)
        lines.append(
            "INSERT INTO `person` (\n"
            "  `branch_id`, `user_id`, `fullname`, `gender`, `avatar`, `dob`, `dod`, `generation`,\n"
            "  `hometown`, `current_residence`, `occupation`, `other_note`,\n"
            "  `father_id`, `mother_id`, `spouse_id`, `createddate`, `modifieddate`, `createdby`, `modifiedby`\n"
            ")\n"
            "SELECT\n"
            f"  (SELECT b.`id` FROM `branch` b WHERE b.`name` = {sql_quote(row.branch_norm)} ORDER BY b.`id` ASC LIMIT 1),\n"
            "  NULL,\n"
            f"  {sql_quote(row.fullname)},\n"
            f"  {gender_sql},\n"
            "  NULL,\n"
            f"  {row.dob_sql},\n"
            f"  {row.dod_sql},\n"
            f"  {generation_sql},\n"
            f"  {sql_quote(row.hometown) if row.hometown else 'NULL'},\n"
            f"  {sql_quote(row.current_residence) if row.current_residence else 'NULL'},\n"
            f"  {sql_quote(row.occupation) if row.occupation else 'NULL'},\n"
            f"  {sql_quote(row.other_note) if row.other_note else 'NULL'},\n"
            "  NULL,\n"
            "  NULL,\n"
            "  NULL,\n"
            "  NOW(),\n"
            "  NOW(),\n"
            f"  {sql_quote(marker)},\n"
            f"  {sql_quote(marker)}\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`createdby` = {sql_quote(marker)});"
        )
    lines.append("")
    lines.append("-- Link father / mother")
    for row in rows:
        marker = f"xlsx_tt_{row.tt}"
        if row.father_tt is not None:
            lines.append(
                "UPDATE `person` c\n"
                "JOIN `person` f ON f.`createdby` = "
                f"{sql_quote(f'xlsx_tt_{row.father_tt}')}\n"
                "SET c.`father_id` = f.`id`\n"
                f"WHERE c.`createdby` = {sql_quote(marker)};"
            )
        if row.mother_tt is not None:
            lines.append(
                "UPDATE `person` c\n"
                "JOIN `person` m ON m.`createdby` = "
                f"{sql_quote(f'xlsx_tt_{row.mother_tt}')}\n"
                "SET c.`mother_id` = m.`id`\n"
                f"WHERE c.`createdby` = {sql_quote(marker)};"
            )
    lines.append("")
    lines.append("-- Link spouse (symmetric)")
    processed = set()
    for row in rows:
        if row.spouse_tt is None:
            continue
        a = row.tt
        b = row.spouse_tt
        pair = tuple(sorted((a, b)))
        if pair in processed:
            continue
        processed.add(pair)
        lines.append(
            "UPDATE `person` p\n"
            "JOIN `person` s ON s.`createdby` = "
            f"{sql_quote(f'xlsx_tt_{b}')}\n"
            "SET p.`spouse_id` = s.`id`\n"
            f"WHERE p.`createdby` = {sql_quote(f'xlsx_tt_{a}')};"
        )
        lines.append(
            "UPDATE `person` p\n"
            "JOIN `person` s ON s.`createdby` = "
            f"{sql_quote(f'xlsx_tt_{a}')}\n"
            "SET p.`spouse_id` = s.`id`\n"
            f"WHERE p.`createdby` = {sql_quote(f'xlsx_tt_{b}')};"
        )
    lines.append("")
    lines.append("COMMIT;")
    lines.append("SET SQL_SAFE_UPDATES = 1;")
    lines.append("")
    lines.append("-- Optional cleanup after verification:")
    lines.append("-- UPDATE `person` SET `createdby` = 'system', `modifiedby` = 'system' WHERE `createdby` LIKE 'xlsx_tt_%';")
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    xlsx_path = Path(args.xlsx).resolve()
    output_path = Path(args.output).resolve()
    raw_rows = load_sheet_rows(xlsx_path)
    rows = build_rows(raw_rows)
    stats = resolve_links(rows)
    sql_text = build_sql(rows, stats)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(sql_text, encoding="utf-8")

    print(f"Generated: {output_path}")
    print(f"Rows: {len(rows)}")
    print(
        "Unresolved refs: father={unresolved_father}, mother={unresolved_mother}, spouse={unresolved_spouse}".format(
            **stats
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
