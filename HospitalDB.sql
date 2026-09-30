CREATE DATABASE clinic_db;
USE clinic_db;

CREATE TABLE patients (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    birthdate DATE NOT NULL,
    contact   VARCHAR(20)
);

CREATE TABLE appointments (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    patient_id       INT NOT NULL,
    doctor           VARCHAR(100) NOT NULL,
    appointment_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- Table 1: 5 records
INSERT INTO patients (name, birthdate, contact) VALUES
('Cedrick John Loydd',  '1990-03-15', '09171234567'),
('Eric James Reid',    '1985-07-22', '09181234567'),
('Princess Cali',     '2000-11-05', '09191234567'),
('Walter Tubig',       '1995-01-30', '09201234567'),
('Jelaine Maine',   '1978-09-12', '09211234567'),
('Nilo Bot',    '2002-04-18', '09221234567');



-- Table 2: 100 records (generates 120 rows) 

DELIMITER //

CREATE PROCEDURE PopulateAppointments()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 100 DO
        INSERT INTO appointments (patient_id, doctor, appointment_date)
        VALUES (
            FLOOR(1 + (RAND() * 5)),
            CASE FLOOR(1 + (RAND() * 4))
                WHEN 1 THEN 'Dr. House'
                WHEN 2 THEN 'Dr. Strange'
                WHEN 3 THEN 'Dr. Who'
                ELSE 'Dr. Watson'
            END,
            DATE_ADD('2026-01-01 09:00:00', INTERVAL i DAY)
        );
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- Run the procedure to insert records
CALL PopulateAppointments();

-- Clean up the procedure
DROP PROCEDURE PopulateAppointments;

-- Proof of setup
SELECT COUNT(*) AS total_patients     FROM patients;
SELECT COUNT(*) AS total_appointments FROM appointments;


-- =====================================================
-- PHASE 2: ADMINISTRATION (THE TWIST)
-- Limited user that can only see the "name" column
-- =====================================================
CREATE USER 'clinic_user'@'localhost' IDENTIFIED BY 'Clinic@123';

-- Column-level GRANT instead of granting the whole table
GRANT SELECT (name) ON clinic_db.patients TO 'clinic_user'@'localhost';

FLUSH PRIVILEGES;

-- Show what the user is allowed to do
SHOW GRANTS FOR 'clinic_user'@'localhost';



-- PHASE 3 
USE clinic_db;

-- Check record before deletion
SELECT * FROM appointments WHERE id = 10;

-- Delete the record
DELETE FROM appointments WHERE id = 10;

-- Verify deletion
SELECT * FROM appointments WHERE id = 10;

-- VERIFY RESTORATION
USE clinic_db;
SELECT * FROM appointments WHERE id = 10;

-- PHASE 4

EXPLAIN SELECT * FROM appointments WHERE doctor = 'Dr. House';

-- ADD INDEX
CREATE INDEX idx_doctor ON appointments(doctor);

-- INDEX QUERY ANALYSIS
EXPLAIN SELECT * FROM appointments WHERE doctor = 'Dr. House';

