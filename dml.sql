-- Ercan Airport Management Information System - DML Details (Sample Data)
USE ErcanAirportDB;

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
