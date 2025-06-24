package com.example.telemedicine.service;

import java.io.UnsupportedEncodingException;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {
    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";
    private static final String USERNAME = "dslimmp@gmail.com";
    private static final String PASSWORD = "dcybcqfvmvqdezpj";

    private static Session getSession() {
        var props = new java.util.Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
    }

    public static void sendEmail(String recipient, String subject, String htmlBody) throws UnsupportedEncodingException {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(USERNAME, "Telemedicine Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("Email sent to " + recipient + " with subject: " + subject);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Error sending email to " + recipient + ": " + e.getMessage());
        }
    }

    public static void sendWelcomeEmail(String recipient, String firstName, String verificationLink)
            throws UnsupportedEncodingException {
        String subject = "Welcome to Telemedicine, " + firstName + "!";

        String htmlBody =
            "<!DOCTYPE html>"
          + "<html xmlns:v='urn:schemas-microsoft-com:vml' xmlns:o='urn:schemas-microsoft-com:office:office' lang='en'>"
          + "<head>"
          + "  <title>Welcome to TeleHealth Pro</title>"
          + "  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>"
          + "  <meta name='viewport' content='width=device-width, initial-scale=1.0'/>"
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
          + "    img { pointer-events:none; -webkit-user-drag:none; user-select:none; }"
          + "  </style>"
          + "</head>"
          + "<body style='background-color:#f8f6ff;margin:0;padding:0;-webkit-text-size-adjust:none;text-size-adjust:none;'>"
          + "  <table width='100%' cellpadding='0' cellspacing='0' role='presentation'>"
          + "    <tr><td align='center'>"
          + "      <!-- Header -->"
          + "      <table width='680' cellpadding='0' cellspacing='0' style='background-color:#1E88E5;margin:0 auto;'>"
          + "        <tr><td style='padding:32px 48px;text-align:center;'>"
          + "          <img src='https://i.postimg.cc/3R661Bww/medical-logo-svgrepo-com.png' alt='TeleHealth Pro Logo' width='150' style='display:block;'/>"
          + "        </td></tr>"
          + "      </table>"
          + "      <!-- Hero image -->"
          + "      <table width='680' cellpadding='0' cellspacing='0' style='background-color:#1E88E5;border-radius:0 0 12px 12px;overflow:hidden;margin:0 auto;'>"
          + "        <tr><td>"
          + "          <img src='https://i.postimg.cc/4xnd72V7/Email-Illustration.png' alt='Telemedicine Illustration' width='680' style='display:block;width:100%;height:auto;'/>"
          + "        </td></tr>"
          + "      </table>"
          + "      <!-- Greeting & Verify -->"
          + "      <table width='680' cellpadding='0' cellspacing='0' style='background-color:#ffffff;margin:16px auto 0;border-radius:0;'>"
          + "        <tr><td style='padding:48px 48px 16px;font-family:Arial,sans-serif;'>"
          + "          <h1 style='margin:0;font-size:32px;color:#1E88E5;font-family:Helvetica Neue,Arial,sans-serif;'>Hello, ${userName}!</h1>"
          + "        </td></tr>"
          + "        <tr><td style='padding:0 48px 32px;font-family:Arial,sans-serif;color:#333333;line-height:1.5;'>"
          + "          <p style='margin:0 0 16px;'>Thanks for joining <strong>TeleHealth Pro</strong>. Verify your email to unlock secure video consultations, appointment booking, and your personal health dashboard.</p>"
          + "          <p style='text-align:center;margin:24px 0 0;'>"
          + "            <a href='${verificationLink}' style='background-color:#1E88E5;color:#ffffff;text-decoration:none;padding:16px 32px;font-size:16px;border-radius:8px;display:inline-block;'>Verify Your Email</a>"
          + "          </p>"
          + "        </td></tr>"
          + "      </table>"
          + "      <!-- Invite section -->"
          + "      <table width='680' cellpadding='0' cellspacing='0' style='background-color:#e8e4ff;border-left:20px solid #ffffff;border-right:20px solid #ffffff;margin:16px auto;border-radius:0;'>"
          + "        <tr><td width='80' align='center' style='padding:24px;'>"
          + "          <img src='https://cdn-icons-png.flaticon.com/512/290/290400.png' alt='Invite' width='34' style='display:block;'/>"
          + "        </td>"
          + "        <td style='padding:24px;font-family:Arial,sans-serif;color:#7860ff;line-height:1.5;'>"
          + "          <p style='margin:0;'>Invite friends and earn health credits! <a href='${shareLink}' style='color:#3e2d9c;text-decoration:underline;font-weight:bold;'>Share Now</a></p>"
          + "        </td></tr>"
          + "      </table>"
          + "      <!-- Footer -->"
          + "      <table width='680' cellpadding='0' cellspacing='0' style='background-color:#f1f1f1;border-radius:0 0 12px 12px;margin:0 auto;'>"
          + "        <tr><td style='padding:24px 48px;font-family:Arial,sans-serif;color:#666666;font-size:14px;line-height:1.4;'>"
          + "          <p style='margin:0 0 8px;'>Questions? Reply or visit <a href='https://www.telehealthpro.example.com/support' style='color:#1E88E5;text-decoration:none;'>Help Center</a>.</p>"
          + "          <p style='margin:0;font-size:12px;color:#999999;'>© 2025 TeleHealth Pro. 1234 Health Ave, Wellness City, WC 56789</p>"
          + "        </td></tr>"
          + "      </table>"
          + "    </td></tr>"
          + "  </table>"
          + "</body>"
          + "</html>";

        // Replace placeholders
        htmlBody = htmlBody
            .replace("${userName}", firstName)
            .replace("${verificationLink}", verificationLink)
            .replace("${shareLink}", "https://yourapp/share");

        sendEmail(recipient, subject, htmlBody);
    }
    
    /**
     * Send an appointment confirmation email.
     *
     * @param recipient        The patient's email address
     * @param firstName        The patient's first name
     * @param doctorName       The doctor's full name
     * @param appointmentDate  The appointment date/time, formatted by caller
     * @param appointmentLink  A link to view or manage the appointment
     */
    public static void sendAppointmentConfirmationEmail(
            String recipient,
            String firstName,
            String doctorName,
            String appointmentDate,
            String appointmentLink
    ) throws UnsupportedEncodingException {
        String subject = "Your Appointment is Confirmed, " + firstName + "!";
        // format date nicely if needed; here we assume appointmentDate is already a human-friendly string

        String htmlBody =
            "<!DOCTYPE html>"
          + "<html lang='en'>"
          + "<head>"
          + "  <meta charset='UTF-8'>"
          + "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
          + "  <title>Appointment Confirmation</title>"
          + "  <style>"
          + "    body { font-family: Arial, sans-serif; background-color: #f4f7fa; margin: 0; padding: 0; }"
          + "    .container { max-width: 600px; margin: 40px auto; background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }"
          + "    .header { background-color: #1E88E5; color: white; padding: 20px; text-align: center; }"
          + "    .content { padding: 30px; color: #333333; }"
          + "    .button { display: inline-block; padding: 12px 24px; margin-top: 20px; background-color: #1E88E5; color: white; text-decoration: none; border-radius: 6px; }"
          + "    .footer { padding: 20px; font-size: 12px; color: #777777; text-align: center; }"
          + "  </style>"
          + "</head>"
          + "<body>"
          + "  <div class='container'>"
          + "    <div class='header'>"
          + "      <h1>Appointment Confirmed</h1>"
          + "    </div>"
          + "    <div class='content'>"
          + "      <p>Hi <strong>${firstName}</strong>,</p>"
          + "      <p>Your appointment has been successfully booked with <strong>Dr. ${doctorName}</strong>.</p>"
          + "      <p><strong>Date & Time:</strong><br>${appointmentDate}</p>"
          + "      <p>To view or manage your appointment, click the button below:</p>"
          + "      <p style='text-align: center;'>"
          + "        <a href='${appointmentLink}' class='button'>View Appointment</a>"
          + "      </p>"
          + "      <p>If you have any questions, reply to this email or visit our <a href='https://www.telehealthpro.example.com/support'>Help Center</a>.</p>"
          + "      <p>Thank you for choosing TeleHealth Pro.</p>"
          + "    </div>"
          + "    <div class='footer'>"
          + "      © 2025 TeleHealth Pro. 1234 Health Ave, Wellness City, WC 56789"
          + "    </div>"
          + "  </div>"
          + "</body>"
          + "</html>";

        // Replace placeholders
        htmlBody = htmlBody
            .replace("${firstName}", firstName)
            .replace("${doctorName}", doctorName)
            .replace("${appointmentDate}", appointmentDate)
            .replace("${appointmentLink}", appointmentLink);

        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(USERNAME, "Telemedicine Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(message);
            System.out.println("Appointment confirmation email sent to " + recipient);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Error sending appointment email to " + recipient + ": " + e.getMessage());
        }
    }

}
