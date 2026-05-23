-- Ercan Airport Management Information System - 15 Statistical Queries
USE ErcanAirportDB;

-- Query 1: Find the average score received by each airplane from all testing events
SELECT PlaneNo, AVG(Score) AS AverageScore 
FROM TestingEvents 
GROUP BY PlaneNo;

-- Query 2: Get the name, union number, and salary of the highest-paid technician (Subquery & Join)
SELECT e.Name, e.UnionMembershipNo, t.Salary 
FROM Employees e 
JOIN Technicians t ON e.SSN = t.SSN 
WHERE t.Salary = (SELECT MAX(Salary) FROM Technicians);

-- Query 3: List technicians alongside the airplane models they are expert in (Join)
SELECT e.Name AS TechnicianName, exp.ModelNo 
FROM Employees e 
JOIN Expertise exp ON e.SSN = exp.TechnicianSSN;

-- Query 4: Find all airplanes currently stationed in a hangar (where OutDate is NULL)
SELECT PlaneNo, HangarNo, InDate 
FROM HangarLogs 
WHERE OutDate IS NULL;

-- Query 5: List traffic controllers whose last medical exam was more than 6 months ago
SELECT e.Name, tc.LastMedicalExamDate 
FROM Employees e 
JOIN TrafficControllers tc ON e.SSN = tc.SSN 
WHERE tc.LastMedicalExamDate < DATE_SUB('2026-05-23', INTERVAL 6 MONTH);

-- Query 6: Find the total hours spent on each type of test
SELECT TestNo, SUM(HoursSpent) AS TotalHours 
FROM TestingEvents 
GROUP BY TestNo;

-- Query 7: Identify technicians who are experts in at least 2 different airplane models (Having clause)
SELECT TechnicianSSN, COUNT(ModelNo) AS SpecialtyCount 
FROM Expertise 
GROUP BY TechnicianSSN 
HAVING COUNT(ModelNo) >= 2;

-- Query 8: Display failed or low-scoring testing events (Score < 85) with airplane and technician names
SELECT te.PlaneNo, e.Name AS TechnicianName, te.TestNo, te.Score 
FROM TestingEvents te 
JOIN Employees e ON te.TechnicianSSN = e.SSN 
WHERE te.Score < 85;

-- Query 9: Find technicians who have never performed any testing event yet (Subquery / NOT IN)
SELECT Name FROM Employees WHERE SSN IN (
    SELECT SSN FROM Technicians WHERE SSN NOT IN (SELECT DISTINCT TechnicianSSN FROM TestingEvents)
);

-- Query 10: Count the total number of technicians and traffic controllers in a single view
SELECT 
    (SELECT COUNT(*) FROM Technicians) AS TotalTechnicians, 
    (SELECT COUNT(*) FROM TrafficControllers) AS TotalControllers;

-- Query 11: Find names of technicians who specialize in 'Boeing' models (Pattern Matching / LIKE)
SELECT DISTINCT e.Name 
FROM Employees e 
JOIN Expertise exp ON e.SSN = exp.TechnicianSSN 
WHERE exp.ModelNo LIKE 'Boeing%';

-- Query 12: Calculate the total number of times each hangar has been utilized (Hangar usage frequency)
SELECT HangarNo, COUNT(*) AS TotalVisits 
FROM HangarLogs 
GROUP BY HangarNo;

-- Query 13: Retrieve all testing event logs performed on large aircrafts (Capacity > 200)
SELECT te.EventID, te.PlaneNo, a.Capacity, te.TestNo 
FROM TestingEvents te 
JOIN Airplanes a ON te.PlaneNo = a.PlaneNo 
WHERE a.Capacity > 200;

-- Query 14: List all testing events that occurred during the month of May 2026
SELECT * FROM TestingEvents 
WHERE TestDate BETWEEN '2026-05-01' AND '2026-05-31';

-- Query 15: Find the maximum score given and maximum hours spent per technician
SELECT TechnicianSSN, MAX(Score) AS BestScore, MAX(HoursSpent) AS MaxHours 
FROM TestingEvents 
GROUP BY TechnicianSSN;
