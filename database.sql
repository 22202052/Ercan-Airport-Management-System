DROP DATABASE IF EXISTS ErcanAirportDB;
CREATE DATABASE ErcanAirportDB;
USE ErcanAirportDB;

CREATE TABLE Employees (
    SSN VARCHAR(11) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    UnionMembershipNo VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Technicians (
    SSN VARCHAR(11) PRIMARY KEY,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (SSN) REFERENCES Employees(SSN) ON DELETE CASCADE
);

CREATE TABLE TrafficControllers (
    SSN VARCHAR(11) PRIMARY KEY,
    LastMedicalExamDate DATE NOT NULL,
    FOREIGN KEY (SSN) REFERENCES Employees(SSN) ON DELETE CASCADE
);

CREATE TABLE Airplanes (
    PlaneNo VARCHAR(20) PRIMARY KEY,
    ModelNo VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0)
);

CREATE TABLE Hangars (
    HangarNo VARCHAR(10) PRIMARY KEY,
    Location VARCHAR(100) NOT NULL
);

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

CREATE TABLE Tests (
    TestNo VARCHAR(10) PRIMARY KEY,
    TestName VARCHAR(100) NOT NULL,
    MaxScore INT NOT NULL DEFAULT 100
);

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

CREATE TABLE Expertise (
    TechnicianSSN VARCHAR(11) NOT NULL,
    ModelNo VARCHAR(50) NOT NULL,
    PRIMARY KEY (TechnicianSSN, ModelNo),
    FOREIGN KEY (TechnicianSSN) REFERENCES Technicians(SSN) ON DELETE CASCADE
);

INSERT INTO Employees VALUES ('111', 'John Doe', 'U-9081');
INSERT INTO Employees VALUES ('222', 'Alice Smith', 'U-9082');
INSERT INTO Employees VALUES ('333', 'Robert Johnson', 'U-7011');
INSERT INTO Employees VALUES ('444', 'Emily Davis', 'U-7012');
INSERT INTO Employees VALUES ('555', 'Michael Brown', 'U-9085');

INSERT INTO Technicians VALUES ('111', 45000.00);
INSERT INTO Technicians VALUES ('222', 48000.00);
INSERT INTO Technicians VALUES ('555', 52000.00);

INSERT INTO TrafficControllers VALUES ('333', '2025-11-12');
INSERT INTO TrafficControllers VALUES ('444', '2026-02-20');

INSERT INTO Airplanes VALUES ('N-101', 'Boeing 737', 180);
INSERT INTO Airplanes VALUES ('N-102', 'Airbus A320', 150);
INSERT INTO Airplanes VALUES ('N-103', 'Boeing 777', 350);

INSERT INTO Hangars VALUES ('H1', 'North Apron Zone A');
INSERT INTO Hangars VALUES ('H2', 'South Apron Zone B');

INSERT INTO HangarLogs (PlaneNo, HangarNo, InDate, OutDate) VALUES ('N-101', 'H1', '2026-05-01 08:00:00', '2026-05-03 14:00:00');
INSERT INTO HangarLogs (PlaneNo, HangarNo, InDate, OutDate) VALUES ('N-102', 'H2', '2026-05-10 10:00:00', '2026-05-12 18:00:00');
INSERT INTO HangarLogs (PlaneNo, HangarNo, InDate, OutDate) VALUES ('N-103', 'H1', '2026-05-20 06:00:00', NULL);

INSERT INTO Tests VALUES ('T_ENG', 'Engine Performance Test', 100);
INSERT INTO Tests VALUES ('T_BRK', 'Brake System Inspection', 100);
INSERT INTO Tests VALUES ('T_AVO', 'Avionics and Radar Test', 100);

INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-101', '111', 'T_ENG', '2026-05-15', 4.5, 92);
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-101', '222', 'T_BRK', '2026-05-16', 2.0, 95);
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-102', '111', 'T_ENG', '2026-05-18', 5.0, 88);
INSERT INTO TestingEvents (PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score) VALUES ('N-103', '555', 'T_AVO', '2026-05-21', 6.0, 78);

INSERT INTO Expertise VALUES ('111', 'Boeing 737');
INSERT INTO Expertise VALUES ('111', 'Airbus A320');
INSERT INTO Expertise VALUES ('222', 'Boeing 737');
INSERT INTO Expertise VALUES ('555', 'Boeing 777');

SELECT PlaneNo, AVG(Score) AS AverageScore 
FROM TestingEvents 
GROUP BY PlaneNo;

SELECT e.Name, e.UnionMembershipNo, t.Salary 
FROM Employees e 
JOIN Technicians t ON e.SSN = t.SSN 
WHERE t.Salary = (SELECT MAX(Salary) FROM Technicians);

SELECT e.Name AS TechnicianName, exp.ModelNo 
FROM Employees e 
JOIN Expertise exp ON e.SSN = exp.TechnicianSSN;

SELECT PlaneNo, HangarNo, InDate 
FROM HangarLogs 
WHERE OutDate IS NULL;

SELECT e.Name, tc.LastMedicalExamDate 
FROM Employees e 
JOIN TrafficControllers tc ON e.SSN = tc.SSN 
WHERE tc.LastMedicalExamDate < DATE_SUB('2026-05-23', INTERVAL 6 MONTH);

SELECT TestNo, SUM(HoursSpent) AS TotalHours 
FROM TestingEvents 
GROUP BY TestNo;

SELECT TechnicianSSN, COUNT(ModelNo) AS SpecialtyCount 
FROM Expertise 
GROUP BY TechnicianSSN 
HAVING COUNT(ModelNo) >= 2;

SELECT te.PlaneNo, e.Name AS TechnicianName, te.TestNo, te.Score 
FROM TestingEvents te 
JOIN Employees e ON te.TechnicianSSN = e.SSN 
WHERE te.Score < 85;

SELECT Name FROM Employees WHERE SSN IN (
    SELECT SSN FROM Technicians WHERE SSN NOT IN (SELECT DISTINCT TechnicianSSN FROM TestingEvents)
);

SELECT 
    (SELECT COUNT(*) FROM Technicians) AS TotalTechnicians, 
    (SELECT COUNT(*) FROM TrafficControllers) AS TotalControllers;

SELECT DISTINCT e.Name 
FROM Employees e 
JOIN Expertise exp ON e.SSN = exp.TechnicianSSN 
WHERE exp.ModelNo LIKE 'Boeing%';

SELECT HangarNo, COUNT(*) AS TotalVisits 
FROM HangarLogs 
GROUP BY HangarNo;

SELECT te.EventID, te.PlaneNo, a.Capacity, te.TestNo 
FROM TestingEvents te 
JOIN Airplanes a ON te.PlaneNo = a.PlaneNo 
WHERE a.Capacity > 200;

SELECT * FROM TestingEvents 
WHERE TestDate BETWEEN '2026-05-01' AND '2026-05-31';

SELECT TechnicianSSN, MAX(Score) AS BestScore, MAX(HoursSpent) AS MaxHours 
FROM TestingEvents 
GROUP BY TechnicianSSN;
