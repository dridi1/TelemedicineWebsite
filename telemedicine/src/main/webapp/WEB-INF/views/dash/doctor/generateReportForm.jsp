<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDateTime,java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Generate Patient Report</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: { extend: { colors: { primary: '#2563eb', secondary: '#3b82f6' } } }
    };
  </script>
</head>
<body class="bg-gray-50">
  <div class="flex min-h-screen">
    <%-- Sidebar include --%>
    <main class="flex-1 p-6 lg:p-8">
      <h2 class="text-2xl font-semibold mb-4">Generate Report for Patient #<c:out value="${param.patientId}"/></h2>

      <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-100 text-red-700 rounded-lg">
          ${error}
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/doctor/report/generate" method="post" class="space-y-6 max-w-3xl bg-white p-6 rounded-lg shadow">
        <input type="hidden" name="patientId" value="${param.patientId}" />

        <div>
          <label class="block text-sm font-medium text-gray-700">Select Visits to Include:</label>
          <div class="mt-2 space-y-2 max-h-48 overflow-y-auto">
            <c:forEach var="h" items="${historyList}">
              <label class="flex items-center">
                <input type="checkbox" name="historyIds" value="${h.id}" class="form-checkbox h-4 w-4 text-primary" />
                <span class="ml-2 text-gray-800">
                  <fmt:formatDate value="${h.visitDateAsDate}" pattern="yyyy-MM-dd HH:mm"/> – ${fn:escapeXml(h.chiefComplaint)}
                </span>
              </label>
            </c:forEach>
          </div>
        </div>

        <div>
          <label for="format" class="block text-sm font-medium text-gray-700">Output Format:</label>
          <select id="format" name="format" class="mt-1 form-select block w-1/3 rounded-lg border-gray-300">
            <option>PDF</option>
            <option>HTML</option>
          </select>
        </div>

        <div class="text-right">
          <button type="submit" class="inline-flex items-center px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary/90">
            Generate Report
          </button>
        </div>
      </form>
    </main>
  </div>
  <script src="https://unpkg.com/intro.js/minified/intro.min.js"></script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <script>lucide.createIcons();</script>
</body>
</html>