package com.javaweb.controller.admin;

import com.javaweb.entity.FamilyTreeEntity;
import com.javaweb.model.dto.FamilyTreeMemberListItemDTO;
import com.javaweb.service.IPersonService;
import com.javaweb.service.impl.FamilyTreeContextService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
public class FamilyTreeMemberListController {
    private final IPersonService personService;
    private final FamilyTreeContextService familyTreeContextService;

    public FamilyTreeMemberListController(IPersonService personService,
                                          FamilyTreeContextService familyTreeContextService) {
        this.personService = personService;
        this.familyTreeContextService = familyTreeContextService;
    }

    @GetMapping("/admin/family-tree-members")
    public ModelAndView memberListPage(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId) {
        Long currentFamilyTreeId = familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        FamilyTreeEntity currentFamilyTree = familyTreeContextService.getCurrentFamilyTreeEntity();
        ModelAndView mav = new ModelAndView("admin/family-tree/member-list");
        mav.addObject("currentFamilyTreeId", currentFamilyTreeId);
        mav.addObject("currentFamilyTreeName", currentFamilyTree != null ? currentFamilyTree.getName() : "");
        mav.addObject("members", personService.findMemberDirectory(currentFamilyTreeId));
        return mav;
    }

    @GetMapping("/admin/family-tree-members/export")
    public void exportMemberList(@RequestParam(value = "familyTreeId", required = false) Long familyTreeId,
                                 HttpServletResponse response) throws IOException {
        Long currentFamilyTreeId = familyTreeContextService.resolveCurrentFamilyTreeId(familyTreeId);
        FamilyTreeEntity currentFamilyTree = familyTreeContextService.getCurrentFamilyTreeEntity();
        List<FamilyTreeMemberListItemDTO> members = personService.findMemberDirectory(currentFamilyTreeId);
        String familyTreeName = currentFamilyTree != null ? currentFamilyTree.getName() : "gia-pha";
        String fileName = "danh-sach-thanh-vien-" + sanitizeFileName(familyTreeName) + ".xls";

        response.setContentType("application/vnd.ms-excel");
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" +
                URLEncoder.encode(fileName, StandardCharsets.UTF_8.name()).replace("+", "%20"));
        response.getWriter().write(buildExcelHtml(members, familyTreeName));
    }

    private String sanitizeFileName(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "gia-pha";
        }
        String sanitized = value.trim().replaceAll("[\\\\/:*?\"<>|]+", "-");
        sanitized = sanitized.replaceAll("\\s+", "-");
        return sanitized.toLowerCase();
    }

    private String buildExcelHtml(List<FamilyTreeMemberListItemDTO> members, String familyTreeName) {
        StringBuilder html = new StringBuilder(8192);
        html.append("<html><head><meta charset=\"UTF-8\">");
        html.append("<style>");
        html.append("table{border-collapse:collapse;font-family:Arial,sans-serif;font-size:12px;}");
        html.append("th,td{border:1px solid #cfd8e3;padding:8px;vertical-align:top;}");
        html.append("th{background:#e9eef5;font-weight:700;text-align:center;}");
        html.append("caption{font-size:16px;font-weight:700;margin-bottom:12px;}");
        html.append("</style></head><body>");
        html.append("<table>");
        html.append("<caption>Danh s\u00e1ch th\u00e0nh vi\u00ean - ").append(escapeHtml(familyTreeName)).append("</caption>");
        html.append("<thead><tr>");
        html.append("<th>#</th>");
        html.append("<th>H\u1ecd v\u00e0 t\u00ean</th>");
        html.append("<th>\u0110\u1eddi</th>");
        html.append("<th>Gi\u1edbi t\u00ednh</th>");
        html.append("<th>Ng\u00e0y sinh</th>");
        html.append("<th>Ng\u00e0y m\u1ea5t</th>");
        html.append("<th>Th\u00e2n ph\u1ee5</th>");
        html.append("<th>Th\u00e2n m\u1eabu</th>");
        html.append("<th>Phu th\u00ea</th>");
        html.append("<th>T\u00ecnh tr\u1ea1ng h\u00f4n nh\u00e2n</th>");
        html.append("<th>H\u1ecdc v\u1ea5n</th>");
        html.append("<th>Nh\u00f3m m\u00e1u</th>");
        html.append("<th>S\u1ed1 \u0111i\u1ec7n tho\u1ea1i</th>");
        html.append("<th>\u0110\u1ecba ch\u1ec9</th>");
        html.append("</tr></thead><tbody>");

        for (int i = 0; i < members.size(); i++) {
            FamilyTreeMemberListItemDTO item = members.get(i);
            html.append("<tr>");
            appendCell(html, String.valueOf(i + 1));
            appendCell(html, item.getFullName());
            appendCell(html, item.getGeneration() == null ? "" : String.valueOf(item.getGeneration()));
            appendCell(html, item.getGender());
            appendCell(html, item.getDateOfBirth());
            appendCell(html, item.getDateOfDeath());
            appendCell(html, item.getFatherFullName());
            appendCell(html, item.getMotherFullName());
            appendCell(html, item.getSpouseFullName());
            appendCell(html, item.getMaritalStatus());
            appendCell(html, item.getEducation());
            appendCell(html, item.getBloodType());
            appendCell(html, item.getPhoneNumber());
            appendCell(html, item.getAddress());
            html.append("</tr>");
        }

        html.append("</tbody></table></body></html>");
        return html.toString();
    }

    private void appendCell(StringBuilder html, String value) {
        html.append("<td>").append(escapeHtml(value)).append("</td>");
    }

    private String escapeHtml(String value) {
        String text = value == null ? "" : value;
        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
