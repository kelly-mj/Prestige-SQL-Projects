-- Developer: Zachary Bene

-- Edited by: Kelly MJ
-- Update: 06/27/2018
    -- Rewrote selection statement from Registration table - included only student records where regStatus = 1, isActive = 1
    -- Added condition CSR.status < 2  --> only shows students who haven't dropped the class

-- Update: 06/04/2018
    -- Now displays students for classes where the teacher is listed as a shared instructor
    -- Changed all AND NOT isActive = 0 to AND isActive = 1
    -- Simplified table/column names
    -- Changed structure of "Last Time Clocked" column from nested IF to CASE statement
       -- Also changed criteria for Absent status to a student who has not clocked in when the class has been in session for an hour
       -- Now using 'clockedStatus' instead of counting daily clockpunches to determine if a student is present
    -- Sorted by class names, ascending start times

-- Update: 03/16/2017 by Zachary Bene
    -- switched studentId with idNumber
-- Attendance Sense for Teacher Start Screens
-- The purpose of this query is to show
    -- Current attendance status of each student
    -- Filtered by teacher for the teacher start page

SELECT S.idNumber
    , CONCAT(S.firstName, ' ', S.lastName) AS Name
    , C.className AS 'Class Name'
    , CASE WHEN LOA.leaveDate IS NOT NULL AND LOA.returnDate IS NULL
            THEN 'Leave of Absence'
         WHEN CP.clockedStatus = 2
              THEN 'Clocked Out'
         WHEN CP.clockedStatus = 1
              THEN 'Clocked In'
         WHEN CP.clockedStatus = 0
              THEN 'Manual'
         ELSE 'Clocked Out'
       END AS 'Status'
     , DATE_FORMAT(CP.punchTime, '%d/%m @ %h:%i')

FROM (SELECT R.studentId
           , R.registrationId
           , MAX(R.startDate)
      FROM Registrations R
      WHERE R.regStatus = 1
        AND R.isActive = 1
        AND R.enrollmentSemesterId = 4000441
        AND R.<ADMINID>
      GROUP BY R.studentId
      ) REG

INNER JOIN Students S ON REG.studentId = S.studentId
INNER JOIN ClassStudentReltn CSR ON S.studentId = CSR.studentId
INNER JOIN Classes C ON CSR.classId = C.classId
LEFT JOIN ( SELECT CPPP.userId, CPPP.punchTime, CPPP.clockedStatus
            FROM ( SELECT userId, MAX(clockPunchId) as maxPunch FROM ClockPunches WHERE isActive = 1 GROUP BY userId ) CPP
            INNER JOIN ClockPunches CPPP ON CPPP.userId = CPP.userId
                AND CPPP.clockPunchId = CPP.maxPunch ) CP
    ON CP.userId = S.studentId
LEFT OUTER JOIN LeavesOfAbsence LOA ON S.studentId = LOA.studentId

WHERE CTR.teacherId = [USERID]
AND S.isActive IN (1, 12)
AND CSR.isActive = 1
AND CSR.status < 2
AND C.isActive = 1
AND LOA.isActive = 1

GROUP BY S.idNumber

ORDER BY CS.startTime ASC, CTR.classId
