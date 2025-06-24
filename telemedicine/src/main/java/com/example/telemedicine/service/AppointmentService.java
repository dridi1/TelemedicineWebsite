package com.example.telemedicine.service;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import com.example.telemedicine.model.Appointment;
import com.example.telemedicine.model.Appointment.Status;

public class AppointmentService {

    /**
     * Book a new appointment.
     * @return true if creation succeeded
     */
    public boolean bookAppointment(int patientId, int doctorId, LocalDateTime appointmentDate, String symptoms) {
        Appointment appointment = new Appointment(patientId, doctorId, appointmentDate, symptoms);
        return appointment.save();
    }

    /**
     * Cancel an appointment on behalf of a patient.
     * @throws IllegalStateException if unauthorized or not found
     */
    public boolean cancelAppointment(int appointmentId, int patientId) throws SQLException {
        Appointment appointment = Appointment.findById(appointmentId);
        if (appointment == null) {
            throw new IllegalStateException("Appointment not found");
        }
        if (!appointment.isValidForPatient(patientId)) {
            throw new IllegalStateException("Patient not authorized to cancel this appointment");
        }
        return appointment.updateStatus(Status.CANCELLED.name());
    }

    /**
     * List all appointments for a given patient.
     */
    public List<Appointment> getAppointmentsForPatient(int patientId) throws SQLException {
        return Appointment.findByPatient(patientId);
    }

    /**
     * List all appointments for a given doctor.
     */
    public List<Appointment> getAppointmentsForDoctor(int doctorId) throws SQLException {
        return Appointment.findByDoctor(doctorId);
    }

    /**
     * Update the status of an appointment by doctor.
     */
    public boolean updateStatusByDoctor(int appointmentId, int doctorId, Status newStatus) throws SQLException {
        Appointment appointment = Appointment.findById(appointmentId);
        if (appointment == null) {
            throw new IllegalStateException("Appointment not found");
        }
        if (!appointment.isValidForDoctor(doctorId)) {
            throw new IllegalStateException("Doctor not authorized to update this appointment");
        }
        return appointment.updateStatus(newStatus.name());
    }

    /**
     * Fetch a single appointment by ID.
     */
    public Appointment getAppointmentById(int appointmentId) throws SQLException {
        return Appointment.findById(appointmentId);
    }
}
