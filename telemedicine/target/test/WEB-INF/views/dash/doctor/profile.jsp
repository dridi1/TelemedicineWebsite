<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Profile - Telemedicine</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #2563eb;
            --secondary: #3b82f6;
            --background: #f8fafc;
            --text: #1e293b;
            --border: #e2e8f0;
            --shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background: var(--background);
            color: var(--text);
        }

        .doctor-profile {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 1rem;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .back-btn {
            background: #fff;
            border: 1px solid var(--border);
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-btn:hover {
            background: #f1f5f9;
            transform: translateY(-1px);
        }

        .profile-card {
            background: #fff;
            border-radius: 1.5rem;
            padding: 2.5rem;
            box-shadow: var(--shadow);
        }

        .profile-info {
            display: flex;
            gap: 2.5rem;
            align-items: center;
            margin-bottom: 3rem;
        }

        .avatar-lg {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
            flex-shrink: 0;
        }

        .doctor-meta {
            flex-grow: 1;
        }

        .doctor-meta h2 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .specialization {
            color: var(--primary);
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .rating {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .rating .score {
            font-size: 1.25rem;
            color: #f59e0b;
            font-weight: 600;
        }

        .reviews {
            color: #64748b;
            font-size: 0.9rem;
        }

        .profile-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .detail-card {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 1rem;
            border-left: 4px solid var(--primary);
        }

        .detail-card label {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #64748b;
            margin-bottom: 1rem;
        }

        .detail-card p {
            font-size: 1.1rem;
            line-height: 1.6;
            color: var(--text);
        }

        .action-buttons {
            text-align: center;
            margin-top: 2rem;
        }

        .book-btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 1.25rem 2.5rem;
            border-radius: 0.75rem;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
        }

        .book-btn:hover {
            background: var(--secondary);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        @media (max-width: 768px) {
            .profile-info {
                flex-direction: column;
                text-align: center;
            }
            
            .rating {
                justify-content: center;
            }
            
            .doctor-profile {
                padding: 1rem;
            }
            
            .profile-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="doctor-profile">
        <div class="profile-header">
            <button class="back-btn" onclick="window.history.back()">
                <i class="fas fa-arrow-left"></i> Back to List
            </button>
        </div>

        <c:choose>
            <c:when test="${not empty doctor}">
                <div class="profile-card">
                    <div class="profile-info">
                        <div class="avatar-lg">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="doctor-meta">
                            <h2>${doctor.username}</h2>
                            <p class="specialization">${doctor.specialization}</p>
                            <div class="rating">
                                <span class="score">${doctor.rating}</span>
                                <i class="fas fa-star text-yellow-400"></i>
                                <span class="reviews">(${doctor.reviewsCount} reviews)</span>
                            </div>
                        </div>
                    </div>

                    <div class="profile-details">
                        <div class="detail-card">
                            <label><i class="fas fa-certificate"></i> License Number</label>
                            <p>${doctor.licenseNumber}</p>
                        </div>
                        
                        <div class="detail-card">
                            <label><i class="fas fa-briefcase"></i> Experience</label>
                            <p>${doctor.yearsOfExperience} years of experience</p>
                        </div>

                        <div class="detail-card">
                            <label><i class="fas fa-money-bill-wave"></i> Consultation Fee</label>
                            <p>$${doctor.consultationFee}</p>
                        </div>

                        <div class="detail-card">
                            <label><i class="fas fa-sticky-note"></i> Special Notes</label>
                            <p>${not empty doctor.specialNotes ? doctor.specialNotes : 'No special notes provided'}</p>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <button class="book-btn">
                            <i class="fas fa-calendar-check"></i> Book Appointment
                        </button>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="error-message">
                    <h2>Doctor not found</h2>
                    <p>The requested doctor profile could not be located.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>