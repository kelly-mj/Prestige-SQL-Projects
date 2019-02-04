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

SELECT
    S.idNumber
    , CONCAT(S.firstName, ' ', S.lastName) AS Name
    , C.className AS 'Class Name'
    , CASE WHEN CP.clockedStatus % 2 = 1
              THEN 'Clocked In'
         WHEN LOA.leaveDate IS NOT NULL AND LOA.returnDate IS NULL
              THEN 'Leave of Absence'
         WHEN CP.clockedStatus % 2 = 0
              THEN IF(CURTIME() BETWEEN CS.cutoff AND CS.endTime, 'Absent', 'Clocked Out')
         ELSE 'Clocked Out'
      END AS 'Last Time Clocked'

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

INNER JOIN Students S
ON REG.studentId = S.studentId
AND S.isActive IN (1, 12)

JOIN ClassStudentReltn CSR
ON S.studentId = CSR.studentId
AND CSR.isActive = 1 -- Changed from AND NOT CSR.isActive = 0
AND CSR.status < 2

JOIN Classes C
ON CSR.classId = C.classId
AND C.isActive = 1 -- Changed from AND NOT C.isActive = 0

JOIN (
    SELECT CL.classId
         , TIME(CL.startTime * 100) AS startTime
         , ADDTIME(TIME(CL.startTime * 100), '01:00:00') AS cutoff
         , TIME(CL.endTime * 100) AS endTime
    FROM ClassSchedules CL
    ) CS
ON CS.classId = C.classId

INNER JOIN ClassTeacherReltn CTR
ON CTR.classId = C.classId

LEFT OUTER JOIN LeavesOfAbsence LOA
ON S.studentId = LOA.studentId
AND LOA.isActive = 1 -- Changed from AND NOT LOA.isActive = 0

LEFT OUTER JOIN
        (SELECT CKP.userId
            , DATE_FORMAT(MAX(punchTime), '%m-%d @ %l:%i') AS Last_Punch
            , CKP.clockedStatus
        FROM ClockPunches CKP
        WHERE CURDATE() = DATE(CKP.punchTime)
              AND CKP.isActive = 1 -- Changed from != 0
        GROUP BY CKP.userId
        ) AS CP
ON S.studentId = CP.userId

WHERE CTR.teacherId = [USERID]

GROUP BY S.idNumber

ORDER BY CS.startTime ASC, CTR.classId
