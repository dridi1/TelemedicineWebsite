<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime,java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Doctor Dashboard - Add Medical History</title>
  <!-- Intro.js CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/intro.js/minified/introjs.min.css" />
  <!-- Google Fonts & Tailwind -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#2563eb',
            secondary: '#3b82f6',
            accent: '#8b5cf6',
            success: '#22c55e',
            warning: '#f59e0b',
            danger: '#ef4444'
          }
        }
      }
    }
  </script>
</head>
<body class="bg-gray-50">
  <div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="hidden md:flex md:flex-col bg-white w-64 border-r border-gray-200 h-screen sticky top-0">
      <div class="p-6">
        <div class="flex items-center gap-2 mb-8">
          <i data-lucide="stethoscope" class="text-primary w-6 h-6"></i>
          <span class="text-xl font-semibold text-primary">Telemedicine</span>
        </div>
        <nav class="space-y-1">
          <a href="${pageContext.request.contextPath}/doctor/dashboard" class="flex items-center gap-3 px-4 py-3 rounded-lg bg-blue-50 text-primary font-medium border-l-4 border-primary">
            <i data-lucide="home" class="w-5 h-5"></i> Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/schedule" class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200">
            <i data-lucide="calendar" class="w-5 h-5"></i> Schedule
          </a>
          <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200">
            <i data-lucide="user" class="w-5 h-5"></i> Profile
          </a>
          <a href="${pageContext.request.contextPath}/settings" class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200">
            <i data-lucide="settings" class="w-5 h-5"></i> Settings
          </a>
          <a href="${pageContext.request.contextPath}/doctor/chat" class="flex items-center gap-3 px-4 py-3 rounded-lg text-gray-600 hover:bg-gray-100 transition-all duration-200">
            <i data-lucide="message-circle" class="w-5 h-5"></i> Chat
          </a>
          <div class="pt-6 mt-6 border-t border-gray-200">
            <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 px-4 py-3 text-gray-600 rounded-lg hover:bg-gray-100 transition-all duration-200">
              <i data-lucide="log-out" class="w-5 h-5"></i> Logout
            </a>
          </div>
        </nav>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-6 lg:p-8">
      <!-- Header -->
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8">
        <div>
          <h1 class="text-2xl font-bold text-gray-800">Add Medical History</h1>
          <p class="text-gray-600">Fill out the visit details below.</p>
        </div>
      </div>

      <c:if test="${not empty successMessage}">
        <div class="mb-6 p-4 bg-green-100 text-green-700 rounded animate-fade-in">
          ${successMessage}
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-100 text-red-700 rounded-lg">
          ${error}
        </div>
      </c:if>

      <!-- Form Card -->
      <div class="max-w-3xl mx-auto bg-white p-8 rounded-2xl shadow-lg">
        <form action="${pageContext.request.contextPath}/doctor/medical-history/add" method="post" class="space-y-8">
          <input type="hidden" name="patientId" value="${patientId}" />

          <div>
            <label for="visitDate" class="block text-sm font-medium text-gray-700">Visit Date &amp; Time</label>
            <input id="visitDate" name="visitDate" type="datetime-local" required 
                   min='<%= LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) %>'
                   class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent" />
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label for="chiefComplaint" class="block text-sm font-medium text-gray-700">Chief Complaint</label>
              <textarea id="chiefComplaint" name="chiefComplaint" rows="3" required 
                        class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
            </div>
            <div>
              <label for="hpi" class="block text-sm font-medium text-gray-700">History of Present Illness</label>
              <textarea id="hpi" name="hpi" rows="3"
                        class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
            </div>
            <div>
              <label for="ros" class="block text-sm font-medium text-gray-700">Review of Systems</label>
              <textarea id="ros" name="ros" rows="3"
                        class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
            </div>
            <div>
              <label for="diagnosis" class="block text-sm font-medium text-gray-700">Diagnosis</label>
              <input id="diagnosis" name="diagnosis" type="text"
                     class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent" />
            </div>
            <div>
              <label for="icdCode" class="block text-sm font-medium text-gray-700">ICD Code</label>
              <input id="icdCode" name="icdCode" type="text"
                     class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent" />
            </div>
          </div>

          <div class="space-y-6">
            <div>
              <label for="prescription" class="block text-sm font-medium text-gray-700">Prescription</label>
              <textarea id="prescription" name="prescription" rows="4"
                        class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
            </div>
            <div>
              <label for="plan" class="block text-sm font-medium text-gray-700">Plan</label>
              <textarea id="plan" name="plan" rows="4"
                        class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
            </div>
            <div>
              <label for="notes" class="block text-sm font-medium text-gray-700">Notes</label>
              <textarea id="notes" name="notes" rows="4"
                        class="mt-1 block w-full rounded-lg border border-gray-300 py-2 px-3 shadow-sm focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
            </div>
          </div>

          <div class="text-right">
            <button type="submit" class="inline-flex items-center px-6 py-2 bg-primary text-white text-sm font-medium rounded-lg hover:bg-primary/90 focus:ring-2 focus:ring-primary transition-shadow">
              Save Medical History
            </button>
          </div>
        </form>
      </div>

    </main>
  </div>

  <!-- Intro.js & Lucide Scripts -->
  <script src="https://unpkg.com/lucide@latest"></script>
  <script src="https://cdn.jsdelivr.net/npm/intro.js/minified/intro.min.js"></script>
  <script>
    lucide.createIcons();
  </script>
</body>
</html>
