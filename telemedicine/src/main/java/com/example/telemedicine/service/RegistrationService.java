package com.example.telemedicine.service;

import java.sql.SQLException;
import java.time.LocalDate;

import com.example.telemedicine.model.Doctor;
import com.example.telemedicine.model.Patient;

public class RegistrationService {

	public void registerPatient(String username, String email, String hashedPassword, String role, LocalDate dob,
			String gender) throws SQLException {
		// Instantiate Patient subclass
		Patient patient = new Patient();
		patient.setUsername(username);
		patient.setEmail(email);
		patient.setPasswordHash(hashedPassword);
		patient.setRole(role);
		patient.setDateOfBirth(dob);
		patient.setGender(gender);

		patient.create();

	}

	public void registerDoctor(String username, String email, String hashedPassword, String role, String license,
			String specialization, double consultationFee, int yearsOfExperience, String specialNotes)
			throws SQLException {
		// Instantiate Doctor subclass
		Doctor doctor = new Doctor();
		doctor.setUsername(username);
		doctor.setEmail(email);
		doctor.setPasswordHash(hashedPassword);
		doctor.setRole(role);
		doctor.setLicenseNumber(license);
		doctor.setSpecialization(specialization);
		doctor.setConsultationFee(consultationFee);
		doctor.setYearsOfExperience(yearsOfExperience);
		doctor.setSpecialNotes(specialNotes);

		// Persist both user & doctor in one transaction
		doctor.create();

	}

}
