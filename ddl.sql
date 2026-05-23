-- Ercan Airport Management Information System - DDL Details
CREATE DATABASE IF NOT EXISTS ErcanAirportDB;
USE ErcanAirportDB;

-- 1. Employees Table
CREATE TABLE Employees (
    SSN VARCHAR(11) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    UnionMembershipNo VARCHAR(20) UNIQUE NOT NULL
);

-- 2. Technicians Table (Derived from Employees)
CREATE TABLE Technicians (
    SSN VARCHAR(11) PRIMARY KEY,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (SSN) REFERENCES Employees(SSN) ON DELETE CASCADE
);

-- 3. Traffic Controllers Table (Derived from Employees)
CREATE TABLE TrafficControllers (
    SSN VARCHAR(11) PRIMARY KEY,
    LastMedicalExamDate DATE NOT NULL,
    FOREIGN KEY (SSN) REFERENCES Employees(SSN) ON DELETE CASCADE
);

-- 4. Airplanes Table
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

-- 6. Hangar Logs Table (Tracks check-in and check-out dates)
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

-- 9. Expertise Table (Many-to-Many relationship between Technician and Model)
CREATE TABLE Expertise (
    TechnicianSSN VARCHAR(11) NOT NULL,
    ModelNo VARCHAR(50) NOT NULL,
    PRIMARY KEY (TechnicianSSN, ModelNo),
    FOREIGN KEY (TechnicianSSN) REFERENCES Technicians(SSN) ON DELETE CASCADE
);
