<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Your Medical History</title>
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <!-- DataTables CSS -->
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
</head>
<body>
  <div class="dashboard">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" flush="true"/>

    <main class="main">
      <div class="header">
        <div>
          <h1>Welcome, <c:out value="${sessionScope.user.username}"/></h1>
          <p>Here’s your medical history</p>
        </div>
      </div>

      <a href="${pageContext.request.contextPath}/patient/medical-history/add"
         class="btn-secondary">
        <i class="fas fa-plus"></i> Add New Entry
      </a>

      <table id="historyTable" class="display" style="width:100%">
        <thead>
          <tr>
            <th>Date</th>
            <th>Complaint</th>
            <th>Diagnosis</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="h" items="${historyList}">
            <tr>
              <td>
                <fmt:formatDate value="${h.visitDateAsDate}"
                pattern="yyyy-MM-dd HH:mm"/>

              </td>
              <td>${fn:escapeXml(h.chiefComplaint)}</td>
              <td>${fn:escapeXml(h.diagnosis)}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </main>
  </div>

  <!-- jQuery & DataTables JS -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    $(document).ready(function() {
      $('#historyTable').DataTable({
        pageLength: 5,
        lengthChange: false
      });
    });
  </script>
</body>
</html>
