CREATE DATABASE ErcanAirportDB;
USE ErcanAirportDB;

-- 1. Employees Table
CREATE TABLE Employees ( 
SSN VARCHAR(11) PRIMARY KEY, 
Name VARCHAR(100) NOT NULL, 
UnionMembershipNo VARCHAR(20) UNIQUE NOT NULL
);

-- 2. Table of Technicians (derived from Employee)
CREATE TABLE Technicians ( 
SSN VARCHAR(11) PRIMARY KEY, 
Salary DECIMAL(10,2) NOT NULL, 
FOREIGN KEY (SSN) REFERENCES Employees(SSN) ON DELETE CASCADE
);

-- 3. Traffic Controllers Table (derived from Employee)
CREATE TABLE TrafficControllers ( 
SSN VARCHAR(11) PRIMARY KEY, 
LastMedicalExamDate DATE NOT NULL, 
FOREIGN KEY (SSN) REFERENCES Employees(SSN) ON DELETE CASCADE
);

-- 4. Table of Airplanes
CREATE TABLE Airplanes ( 
PlaneNo VARCHAR(20) PRIMARY KEY, 
ModelNo VARCHAR(50) NOT NULL, 
Capacity INT NOT NULL CHECK (Capacity > 0)
);

-- 5. Hangars Table
CREATE TABLE Hangars ( 
HangarNo VARCHAR(10) PRIMARY KEY, 
Location VARCHAR(100) NOT NULL
);

-- 6. Hangar Logs Table (Tracking of aircraft entering and exiting the hangar)
CREATE TABLE HangarLogs ( 
LogID INT AUTO_INCREMENT PRIMARY KEY, 
PlaneNo VARCHAR(20) NOT NULL, 
HangarNo VARCHAR(10) NOT NULL, 
InDate DATETIME NOT NULL, 
OutDate DATETIME, 
FOREIGN KEY (PlaneNo) REFERENCES Airplanes(PlaneNo) ON DELETE CASCADE, 
FOREIGN KEY (HangarNo) REFERENCES Hangars(HangarNo) ON DELETE CASCADE, 
CONSTRAINT CheckDates CHECK (OutDate IS NULL OR OutDate >= InDate)
);

-- 7. Tests Table
CREATE TABLE Tests ( 
TestNo VARCHAR(10) PRIMARY KEY, 
TestName VARCHAR(100) NOT NULL, 
MaxScore INT NOT NULL DEFAULT 100
);

-- 8. Testing Events Table
CREATE TABLE TestingEvents ( 
EventID INT AUTO_INCREMENT PRIMARY KEY, 
PlaneNo VARCHAR(20) NOT NULL, 
TechnicianSSN VARCHAR(11) NOT NULL, 
TestNo VARCHAR(10) NOT NULL, 
TestDate DATE NOT NULL, 
HoursSpent DECIMAL(5,2) NOT NULL CHECK (HoursSpent > 0), 
Score INT NOT NULL CHECK (Score >= 0), 
FOREIGN KEY (PlaneNo) REFERENCES Airplanes(PlaneNo) ON DELETE CASCADE, 
FOREIGN KEY (TechnicianSSN) REFERENCES Technicians(SSN) ON DELETE CASCADE, 
FOREIGN KEY (TestNo) REFERENCES Tests(TestNo) ON DELETE CASCADE
);

-- 9. Expertise Table (Technician <-> Airplane Model Many-to-Many Relationship)
CREATE TABLE Expertise (
TechnicianSSN VARCHAR(11) NOT NULL,
ModelNo VARCHAR(50) NOT NULL,
PRIMARY KEY (TechnicianSSN, ModelNo),
FOREIGN KEY (TechnicianSSN) REFERENCES Technicians(SSN) ON DELETE CASCADE
);

-- Adding Employees
INSERT INTO Employees VALUES ('111', 'Ahmet Yılmaz', 'U-9081');
INSERT INTO Employees VALUES ('222', 'Mehmet Demir', 'U-9082');
INSERT INTO Employees VALUES ('333', 'Ayşe Kaya', 'U-7011');
INSERT INTO Employees VALUES ('444', 'Fatma Şahin', 'U-7012');
INSERT INTO Employees VALUES ('555', 'Ali Can', 'U-9085');

-- Adding a Technician
INSERT INTO Technicians VALUES ('111', 45000.00);
INSERT INTO Technicians VALUES ('222', 48000.00);
INSERT INTO Technicians VALUES ('555', 52000.00);

-- Adding Traffic Controller
INSERT INTO TrafficControllers VALUES ('333', '2025-11-12');
INSERT INTO TrafficControllers VALUES ('444', '2026-02-20');

-- Add Airplane
INSERT INTO Airplanes VALUES ('N-101', 'Boeing 737', 180);
INSERT INTO Airplanes VALUES ('N-102', 'Airbus A320', 150);
INSERT INTO Airplanes VALUES ('N-103', 'Boeing 777', 350);

-- Adding a Hangar
INSERT INTO Hangars VALUES ('H1', 'North Apron Zone A');
INSERT INTO Hangars VALUES ('H2', 'South Apron Zone B');

-- Hangar Logs (Entry-Exit)
INSERT INTO HangarLogs (PlaneNo, HangarNo, InDate, OutDate) VALUES ('N-101', 'H1', '2026-05-01 08:00:00', '2026-05-03 14:00:00');
INSERT INTO HangarLogs (PlaneNo, HangarNo, InDate, OutDate) VALUES ('N-102', 'H2', '2026-05-10 10:00:00', '2026-05-12 18:00:00');
INSERT INTO HangarLogs (PlaneNo, HangarNo, InDate, OutDate) VALUES ('N-103', 'H1', '2026-05-20 06:00:00', NULL); -- Still in the hangar

-- Test Definition
INSERT INTO Tests VALUES ('T_ENG', 'Engine Performance Test', 100);
INSERT INTO Tests VALUES ('T_BRK', 'Brake System Inspection', 100);
INSERT INTO Tests VALUES ('T_AVO', 'Avionics and Radar Test', 100);

-- Test Events
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-101', '111', 'T_ENG', '2026-05-15', 4.5, 92);
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-101', '222', 'T_BRK', '2026-05-16', 2.0, 95);
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-102', '111', 'T_ENG', '2026-05-18', 5.0, 88);
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-103', '555', 'T_AVO', '2026-05-21', 6.0, 78);

-- Areas of Expertise
INSERT INTO Expertise VALUES ('111', 'Boeing 737');
INSERT INTO Expertise VALUES ('111', 'Airbus A320');
INSERT INTO Expertise VALUES ('222', 'Boeing 737');
INSERT INTO Expertise VALUES ('555', 'Boeing 777');

-- 1. List the average scores all aircraft received from the tests.
SELECT Plane
