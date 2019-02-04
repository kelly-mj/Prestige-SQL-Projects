-- 1. Currently Enrolled Students in School
-- Edited by Kelly MJ
-- Update: 6/27/2018
    -- Added 'start date' to query
-- Update: 6/8/2018
    -- Turned query into a list of students instead of a single number counting the students
    -- Added count of students to the top of the table

SELECT 'Number of students: ' AS 'ID Number'
   , COUNT(S.idNumber) AS 'Student Name' -- CONCAT('<div style="background-color:#66cc00;', CAST(COUNT(S.idNumber) AS CHAR), '</div>')
   , NULL AS 'Programme Name'
   , NULL AS 'Start Date'

FROM Students S

INNER JOIN (
    SELECT REG.studentId
       , MAX(REG.startDate) AS startDate
       , REG.programmeId
    FROM Registrations REG
    WHERE REG.isActive = 1
    AND REG.regStatus = 1
    GROUP BY REG.studentId
  ) R
ON R.studentId = S.studentId

INNER JOIN Programmes P
ON P.programmeId = R.programmeId
AND P.isActive = 1

WHERE S.isActive = 1
AND S.<ADMINID>
AND R.startDate >= ('[?Start date]')
AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)

UNION

SELECT DISTINCT S.idNumber 'ID Number'
   , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS 'Student Name'
   , P.programmeName AS 'Programme Name'
   , R.startDate AS 'Start Date'

FROM Students S

INNER JOIN (
    SELECT REG.studentId
       , MAX(REG.startDate) AS startDate
       , REG.programmeId
    FROM Registrations REG
    WHERE REG.isActive = 1
    AND REG.regStatus = 1
    GROUP BY REG.studentId
  ) R
ON R.studentId = S.studentId

INNER JOIN Programmes P
ON P.programmeId = R.programmeId
AND P.isActive = 1

WHERE S.isActive = 1
AND S.<ADMINID>
AND R.startDate >= ('[?Start date]')
AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
