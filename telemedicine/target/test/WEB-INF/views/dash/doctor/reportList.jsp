<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Patient Reports</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = { theme: { extend: { colors: { primary: '#2563eb', secondary: '#3b82f6' } } } };
  </script>
</head>
<body class="bg-gray-50">
  <div class="flex min-h-screen">
    <%-- Sidebar include --%>
    <main class="flex-1 p-6 lg:p-8">
      <h2 class="text-2xl font-semibold mb-4">Reports for Patient #<c:out value="${param.patientId}"/></h2>

      <c:if test="${not empty success}">
        <div class="mb-6 p-4 bg-green-100 text-green-700 rounded-lg">
          ${success}
        </div>
      </c:if>

      <div class="overflow-x-auto bg-white p-6 rounded-lg shadow">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-sm font-medium text-gray-500 uppercase">Date</th>
              <th class="px-6 py-3 text-left text-sm font-medium text-gray-500 uppercase">Format</th>
              <th class="px-6 py-3"></th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <c:forEach var="r" items="${reportList}">
              <tr>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">
                  <fmt:formatDate value="${r.generatedAtAsDate}" pattern="yyyy-MM-dd HH:mm"/>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">
                  ${fn:toUpperCase(r.format)}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm">
                  <a href="${pageContext.request.contextPath}/doctor/report/download?id=${r.id}" class="text-secondary hover:text-secondary/80">Download</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </main>
  </div>
  <script src="https://unpkg.com/intro.js/minified/intro.min.js"></script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <script>lucide.createIcons();</script>
</body>
</html>