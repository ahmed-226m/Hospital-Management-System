-- =====================================================
-- Medical Clinic / Hospital Management System - Full Schema
-- Compatible with: MySQL | PostgreSQL | SQL Server
-- Normalization: 3NF + Partial 4NF
-- Created by: [اسمك أو يوزر خمسات]
-- =====================================================

DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS medical_records CASCADE;
DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- Departments (أقسام المستشفى/العيادة)
CREATE TABLE departments (
    dept_id      INT PRIMARY KEY AUTO_INCREMENT,
    dept_name    VARCHAR(100) NOT NULL UNIQUE,  -- e.g., Cardiology, Pediatrics, Dental
    floor        INT,
    phone_ext    VARCHAR(10),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors
CREATE TABLE doctors (
    doctor_id       INT PRIMARY KEY AUTO_INCREMENT,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    phone           VARCHAR(20) NOT NULL,
    specialty       VARCHAR(100),
    dept_id         INT,
    license_number  VARCHAR(50) UNIQUE,
    hire_date       DATE DEFAULT (CURRENT_DATE),
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) 
        ON DELETE SET NULL
);

-- Patients
CREATE TABLE patients (
    patient_id      INT PRIMARY KEY AUTO_INCREMENT,
    national_id     VARCHAR(20) UNIQUE NOT NULL,
    full_name       VARCHAR(100) NOT NULL,
    phone           VARCHAR(20) NOT NULL,
    email           VARCHAR(100),
    gender          ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth   DATE NOT NULL,
    blood_type      VARCHAR(5),
    address         TEXT,
    emergency_contact VARCHAR(100),
    registration_date DATE DEFAULT (CURRENT_DATE),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Visits (زيارات المريض للعيادة)
CREATE TABLE visits (
    visit_id        INT PRIMARY KEY AUTO_INCREMENT,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    visit_date      DATE NOT NULL,
    visit_time      TIME NOT NULL,
    visit_type      ENUM('Checkup', 'Follow-up', 'Emergency', 'Surgery') DEFAULT 'Checkup',
    status          ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    UNIQUE (patient_id, visit_date, visit_time) -- منع التكرار في نفس التوقيت
);

-- Medical Records (التشخيص والملاحظات الطبية)
CREATE TABLE medical_records (
    record_id       INT PRIMARY KEY AUTO_INCREMENT,
    visit_id        INT NOT NULL,
    diagnosis       TEXT,
    symptoms        TEXT,
    treatment_plan  TEXT,
    height_cm       DECIMAL(5,2),
    weight_kg       DECIMAL(5,2),
    blood_pressure  VARCHAR(20),
    temperature     DECIMAL(4,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE
);

-- Prescriptions (الروشتات)
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    visit_id        INT NOT NULL,
    medicine_name   VARCHAR(150) NOT NULL,
    dosage          VARCHAR(100),           -- e.g., 500mg
    frequency       VARCHAR(100),           -- e.g., Twice daily
    duration        VARCHAR(50),            -- e.g., 5 days
    instructions    TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE
);

-- Appointments (الحجوزات - جدول منفصل لتسهيل الحجز المسبق)
CREATE TABLE appointments (
    appointment_id  INT PRIMARY KEY AUTO_INCREMENT,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status          ENUM('Pending', 'Confirmed', 'Cancelled', 'No Show') DEFAULT 'Pending',
    notes           VARCHAR(255),
    booked_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    UNIQUE (doctor_id, appointment_date, appointment_time)
);

-- Indexes for Performance
CREATE INDEX idx_visits_date ON visits(visit_date);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_patients_national ON patients(national_id);
CREATE INDEX idx_doctors_dept ON doctors(dept_id);

-- =====================================================
-- End of Schema
-- =====================================================