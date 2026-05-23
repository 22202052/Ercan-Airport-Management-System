1. Introduction and Assumptions: This project is a Relational Database Management System (RDBMS) designed to automate the management of aircraft, hangars, periodic technical tests, and personnel in various roles (Technician, Air Traffic Controller, etc.) at Ercan Airport.

Design Assumptions:

Each employee has a unique SSN number and is a union member. Technicians and Air Traffic Controllers are also employees (IS-A relationship, linked in the database with a foreign key).

An aircraft is tracked in the hangar with entry and exit dates. If the aircraft is currently in the hangar, the exit date can remain NULL.

A technician can be an expert in more than one aircraft model, and multiple technicians can be experts in a single model (an Expertise table has been established for many-to-many relationships).


2. Relational Data Model

Employees (SSN, Name, UnionMembershipNo)

Technicians (SSN, Salary)

TrafficControllers (SSN, LastMedicalExamDate)

Airplanes (PlaneNo, ModelNo, Capacity)

Hangars (HangarNo, Location)

HangarLogs (LogID, PlaneNo, HangarNo, InDate, OutDate)

Tests (TestNo, TestName, MaxScore)

TestingEvents (EventID, PlaneNo, TechnicianSSN, TestNo, TestDate, HoursSpent, Score)

Expertise (TechnicianSSN, ModelNo)
