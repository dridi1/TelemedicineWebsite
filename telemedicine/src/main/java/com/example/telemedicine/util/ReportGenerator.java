package com.example.telemedicine.util;

import com.example.telemedicine.model.MedicalHistory;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Utility to generate report content (PDF or HTML) from medical history entries.
 */
public class ReportGenerator {
    private static final DateTimeFormatter DATE_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    /**
     * Generates a report for the given patient and visit IDs in the specified format.
     */
    public static byte[] generate(int patientId, List<Integer> historyIds, String format) throws Exception {
        // Fetch & filter history entries
        List<MedicalHistory> all = MedicalHistory.findByPatient(patientId);
        List<MedicalHistory> entries = all.stream()
                .filter(h -> historyIds.contains(h.getId()))
                .sorted((a, b) -> a.getVisitDate().compareTo(b.getVisitDate()))
                .collect(Collectors.toList());

        if ("PDF".equalsIgnoreCase(format)) {
            try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                Document doc = new Document(PageSize.LETTER, 50, 50, 50, 50);
                PdfWriter.getInstance(doc, baos);
                doc.open();

                // Title
                Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, Font.BOLD, null);
                Paragraph title = new Paragraph("Patient Report (ID: " + patientId + ")", titleFont);
                title.setAlignment(Element.ALIGN_CENTER);
                title.setSpacingAfter(20);
                doc.add(title);

                for (MedicalHistory h : entries) {
                    // Table for each entry
                    PdfPTable table = new PdfPTable(2);
                    table.setWidthPercentage(100);
                    table.setSpacingBefore(10f);
                    table.setSpacingAfter(10f);
                    table.setWidths(new float[]{1f, 3f});

                    // Header row
                    addCell(table, "Field", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Font.BOLD, null), 0.75f);
                    addCell(table, "Value", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Font.BOLD, null), 0.75f);

                    // Data rows
                    String[][] rows = {
                            {"Visit Date", DATE_FMT.format(h.getVisitDate())},
                            {"Doctor ID", String.valueOf(h.getDoctorId())},
                            {"Chief Complaint", h.getChiefComplaint()},
                            {"History of Present Illness", h.getHpi()},
                            {"Review of Systems", h.getRos()},
                            {"Diagnosis", h.getDiagnosis()},
                            {"ICD Code", h.getIcdCode()},
                            {"Prescription", h.getPrescription()},
                            {"Plan", h.getPlan()},
                            {"Notes", h.getNotes()}
                    };
                    for (int i = 0; i < rows.length; i++) {
                        float shade = (i % 2 == 0) ? 0.90f : -1f;
                        addCell(table, rows[i][0], FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, null), shade);
                        addCell(table, rows[i][1], FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, null), shade);
                    }

                    doc.add(table);
                }

                doc.close();
                return baos.toByteArray();
            }
        } else {
            // HTML fallback with enhanced styling
            StringBuilder html = new StringBuilder();
            html.append("<!DOCTYPE html><html><head>")
                    .append("<meta charset=\"UTF-8\"><title>Patient Report</title>")
                    .append("<style>")
                    .append("body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f9f9f9; margin: 20px; }")
                    .append("h1 { text-align: center; color: #444; margin-bottom: 30px; }")
                    .append(".entry-card { background: #fff; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }")
                    .append(".entry-card table { width: 100%; border-collapse: collapse; }")
                    .append(".entry-card th, .entry-card td { padding: 12px; }")
                    .append(".entry-card th { background: #666; color: #fff; text-align: left; }")
                    .append(".entry-card tr:nth-child(even) td { background: #f2f2f2; }")
                    .append(".entry-card td:first-child { width: 25%; font-weight: bold; color: #333; }")
                    .append("</style></head><body>")
                    .append("<h1>Patient Report (ID: ").append(patientId).append(")</h1>");

            for (MedicalHistory h : entries) {
                html.append("<div class=\"entry-card\">")
                        .append("<table>")
                        .append("<tr><th>Field</th><th>Value</th></tr>")
                        .append(fieldRow("Visit Date", DATE_FMT.format(h.getVisitDate())))
                        .append(fieldRow("Doctor ID", String.valueOf(h.getDoctorId())))
                        .append(fieldRow("Chief Complaint", h.getChiefComplaint()))
                        .append(fieldRow("History of Present Illness", h.getHpi()))
                        .append(fieldRow("Review of Systems", h.getRos()))
                        .append(fieldRow("Diagnosis", h.getDiagnosis()))
                        .append(fieldRow("ICD Code", h.getIcdCode()))
                        .append(fieldRow("Prescription", h.getPrescription()))
                        .append(fieldRow("Plan", h.getPlan()))
                        .append(fieldRow("Notes", h.getNotes()))
                        .append("</table></div>");
            }
            html.append("</body></html>");
            return html.toString().getBytes(StandardCharsets.UTF_8);
        }
    }

    private static void addCell(PdfPTable table, String text, Font font, float grayFill) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        if (grayFill >= 0) {
            cell.setGrayFill(grayFill);
        }
        cell.setPadding(8);
        table.addCell(cell);
    }

    private static String fieldRow(String field, String value) {
        return "<tr><td>" + field + "</td><td>" + value + "</td></tr>";
    }
}
