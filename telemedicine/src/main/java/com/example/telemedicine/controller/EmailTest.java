package com.example.telemedicine.controller;

import java.io.UnsupportedEncodingException;

import com.example.telemedicine.service.EmailService;

public class EmailTest {
    public static void main(String[] args) throws UnsupportedEncodingException {
        String toAddress = "jedbelhajyahia@gmail.com";
        String subject   = "W from Telemedicine";

        String htmlBody =
                "<!DOCTYPE html>"
              + "<html xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" lang=\"en\">"
              + "<head>"
              + "  <title>Welcome to TeleHealth Pro</title>"
              + "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>"
              + "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>"
              + "  <!--[if mso]>"
              + "    <xml>"
              + "      <o:OfficeDocumentSettings>"
              + "        <o:PixelsPerInch>96</o:PixelsPerInch>"
              + "        <o:AllowPNG/>"
              + "      </o:OfficeDocumentSettings>"
              + "    </xml>"
              + "  <![endif]-->"
              + "  <style>"
              + "    * { box-sizing: border-box; }"
              + "    body { margin:0; padding:0; background-color:#f8f6ff; }"
              + "    a[x-apple-data-detectors] { color:inherit!important; text-decoration:none!important; }"
              + "    #MessageViewBody a { color:inherit; text-decoration:none; }"
              + "  </style>"
              + "</head>"
              + "<body style=\"background-color:#f8f6ff;margin:0;padding:0;-webkit-text-size-adjust:none;text-size-adjust:none;\">"
              + "  <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\">"
              + "    <tr><td align=\"center\">"
              + "      <!-- Header -->"
              + "      <table width=\"680\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#1E88E5;margin:0 auto;\">"
              + "        <tr><td style=\"padding:32px 48px;text-align:center;\">"
              + "          <img src=\"https://i.postimg.cc/3R661Bww/medical-logo-svgrepo-com.png\" alt=\"TeleHealth Pro Logo\" width=\"150\" style=\"display:block;\"/>"
              + "        </td></tr>"
              + "      </table>"
              + "      <!-- Hero image -->"
              + "      <table width=\"680\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#1E88E5;border-radius:0 0 12px 12px;overflow:hidden;margin:0 auto;\">"
              + "        <tr><td>"
              + "          <img src=\"https://i.postimg.cc/4xnd72V7/Email-Illustration.png\" alt=\"Telemedicine Illustration\" width=\"680\" style=\"display:block;width:100%;height:auto;\"/>"
              + "        </td></tr>"
              + "      </table>"
              + "      <!-- Greeting & Verify -->"
              + "      <table width=\"680\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#ffffff;margin:16px auto 0;border-radius:0;\">"
              + "        <tr><td style=\"padding:48px 48px 16px;font-family:Arial,sans-serif;\">"
              + "          <h1 style=\"margin:0;font-size:32px;color:#1E88E5;font-family:'Helvetica Neue',Arial,sans-serif;\">Hello, ${userName}!</h1>"
              + "        </td></tr>"
              + "        <tr><td style=\"padding:0 48px 32px;font-family:Arial,sans-serif;color:#333333;line-height:1.5;\">"
              + "          <p style=\"margin:0 0 16px;\">Thanks for joining <strong>TeleHealth Pro</strong>. Verify your email to unlock secure video consultations, appointment booking, and your personal health dashboard.</p>"
              + "          <p style=\"text-align:center;margin:24px 0 0;\">"
              + "            <a href=\"${verificationLink}\" style=\"background-color:#1E88E5;color:#ffffff;text-decoration:none;padding:16px 32px;font-size:16px;border-radius:8px;display:inline-block;\">Verify Your Email</a>"
              + "          </p>"
              + "        </td></tr>"
              + "      </table>"
              + "      <!-- Invite section -->"
              + "      <table width=\"680\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#e8e4ff;border-left:20px solid #ffffff;border-right:20px solid #ffffff;margin:16px auto;border-radius:0;\">"
              + "        <tr>"
              + "          <td width=\"80\" align=\"center\" style=\"padding:24px;\">"
              + "            <img src=\"https://cdn-icons-png.flaticon.com/512/290/290400.png\" alt=\"Invite\" width=\"34\" style=\"display:block;\"/>"
              + "          </td>"
              + "          <td style=\"padding:24px;font-family:Arial,sans-serif;color:#7860ff;line-height:1.5;\">"
              + "            <p style=\"margin:0;\">Invite friends and earn health credits! <a href=\"${shareLink}\" style=\"color:#3e2d9c;text-decoration:underline;font-weight:bold;\">Share Now</a></p>"
              + "          </td>"
              + "        </tr>"
              + "      </table>"
              + "      <!-- Footer -->"
              + "      <table width=\"680\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color:#f1f1f1;border-radius:0 0 12px 12px;margin:0 auto;\">"
              + "        <tr><td style=\"padding:24px 48px;font-family:Arial,sans-serif;color:#666666;font-size:14px;line-height:1.4;\">"
              + "          <p style=\"margin:0 0 8px;\">Questions? Reply or visit <a href=\"https://www.telehealthpro.example.com/support\" style=\"color:#1E88E5;text-decoration:none;\">Help Center</a>.</p>"
              + "          <p style=\"margin:0;font-size:12px;color:#999999;\">© 2025 TeleHealth Pro. 1234 Health Ave, Wellness City, WC 56789</p>"
              + "        </td></tr>"
              + "      </table>"
              + "    </td></tr>"
              + "  </table>"
              + "</body>"
              + "</html>";

        // Replace placeholders before sending
        htmlBody = htmlBody
            .replace("${userName}", "Jed belhajyahia")
            .replace("${verificationLink}", "https://yourapp/verify?token=ABC123")
            .replace("${shareLink}", "https://yourapp/share");

        EmailService.sendEmail(toAddress, subject, htmlBody);
    }
}
