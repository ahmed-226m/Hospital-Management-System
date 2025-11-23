# Medical Clinic / Hospital Management System - ERD & Database Schema


## Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    DEPARTMENTS ||--o{ DOCTORS : "contains"
    DOCTORS ||--o{ VISITS : "conducts"
    DOCTORS ||--o{ APPOINTMENTS : "has scheduled"
    PATIENTS ||--o{ VISITS : "has"
    PATIENTS ||--o{ APPOINTMENTS : "books"
    PATIENTS ||--o{ MEDICAL_RECORDS : "has via visit"
    VISITS ||--|| MEDICAL_RECORDS : "generates"
    VISITS ||--o{ PRESCRIPTIONS : "includes"
    APPOINTMENTS }o--|| VISITS : "may become"

    DEPARTMENTS {
        int dept_id PK
        string dept_name UK
        int floor
        string phone_ext
    }

    DOCTORS {
        int doctor_id PK
        string full_name
        string email UK
        string phone
        string specialty
        int dept_id FK
        string license_number UK
        boolean is_active
    }

    PATIENTS {
        int patient_id PK
        string national_id UK
        string full_name
        string phone
        string gender
        date date_of_birth
        string blood_type
        text address
    }

    VISITS {
        int visit_id PK
        int patient_id FK
        int doctor_id FK
        date visit_date
        time visit_time
        enum visit_type
        enum status
        text notes
    }

    MEDICAL_RECORDS {
        int record_id PK
        int visit_id FK
        text diagnosis
        text symptoms
        text treatment_plan
        decimal height_cm
        decimal weight_kg
        string blood_pressure
    }

    PRESCRIPTIONS {
        int prescription_id PK
        int visit_id FK
        string medicine_name
        string dosage
        string frequency
        string duration
        text instructions
    }

    APPOINTMENTS {
        int appointment_id PK
        int patient_id FK
        int doctor_id FK
        date appointment_date
        time appointment_time
        enum status
    }