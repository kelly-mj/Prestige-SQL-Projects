-- [BENES] INS Your Class Attendance
-- Kelly MJ 06/12/2019 - whole lot of changes, refer to github.com/tinytacooo/Prestige-SQL-Projects for full history

SELECT C.className AS 'Class'
    , CONCAT('<a target="_blank" href="view_attendance.jsp?semesterid=4000441&classid=', CAST(C.classId AS CHAR), '&subjectid=', CAST(C.subjectId AS CHAR), '&studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
    , CASE WHEN S.isActive = 12
			  THEN 'on LOA'
         WHEN CP.punchCount%2 = 0
              THEN 'Clocked Out'
         WHEN CP.punchCount%2 = 1
              THEN 'Clocked In'
         ELSE 'Clocked Out'
       END AS 'Status'
    , COALESCE(DATE_FORMAT(CP.lastPunch, '%m/%d @ %h:%i'), ' -- ') AS 'Last Punch Today'

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
LEFT JOIN (SELECT userId, MAX(punchTime) AS lastPunch, COUNT(clockPunchId) AS punchCount
			FROM ClockPunches
            WHERE isActive IN (1, 2)
            AND DATE(punchTime) = CURDATE()
            GROUP BY userId) CP
	ON CP.userId = S.studentId

WHERE C.classId IN (SELECT classId FROM ClassTeacherReltn WHERE isActive = 1 AND teacherId = [USERID])
AND S.isActive IN (1, 12)
AND CSR.isActive = 1
AND CSR.status < 2
AND C.isActive = 1

GROUP BY S.studentId

ORDER BY C.className, S.lastName