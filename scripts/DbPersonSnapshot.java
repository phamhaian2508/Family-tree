import java.io.BufferedWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;

public class DbPersonSnapshot {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3306/family_tree_db?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        String user = "root";
        String pass = "12345";
        String out = "database/person_db_snapshot.tsv";

        Class.forName("com.mysql.cj.jdbc.Driver");
        String sql = "SELECT p.id, p.createdby, p.fullname, p.gender, p.dob, p.dod, p.generation, b.name AS branch_name, " +
                "f.createdby AS father_createdby, m.createdby AS mother_createdby, s.createdby AS spouse_createdby " +
                "FROM person p " +
                "LEFT JOIN branch b ON b.id = p.branch_id " +
                "LEFT JOIN person f ON f.id = p.father_id " +
                "LEFT JOIN person m ON m.id = p.mother_id " +
                "LEFT JOIN person s ON s.id = p.spouse_id " +
                "WHERE p.createdby LIKE 'xlsx_tt_%' " +
                "ORDER BY p.id ASC";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();
             BufferedWriter w = Files.newBufferedWriter(Path.of(out), StandardCharsets.UTF_8)) {
            w.write("id\tcreatedby\tfullname\tgender\tdob\tdod\tgeneration\tbranch\tfather_createdby\tmother_createdby\tspouse_createdby\n");
            while (rs.next()) {
                w.write(val(rs, "id") + "\t" +
                        val(rs, "createdby") + "\t" +
                        val(rs, "fullname") + "\t" +
                        val(rs, "gender") + "\t" +
                        val(rs, "dob") + "\t" +
                        val(rs, "dod") + "\t" +
                        val(rs, "generation") + "\t" +
                        val(rs, "branch_name") + "\t" +
                        val(rs, "father_createdby") + "\t" +
                        val(rs, "mother_createdby") + "\t" +
                        val(rs, "spouse_createdby") + "\n");
            }
        }
        System.out.println("OK");
    }

    private static String val(ResultSet rs, String c) throws SQLException {
        String v = rs.getString(c);
        if (v == null) return "";
        return v.replace("\t", " ").replace("\r", " ").replace("\n", " ");
    }
}
