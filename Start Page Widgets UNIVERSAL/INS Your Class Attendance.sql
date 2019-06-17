-- [SHELL] INS Your Class Attendance
-- Kelly MJ 06/12/2019 - whole lot of changes, refer to github.com/tinytacooo/Prestige-SQL-Projects for full history

SELECT C.className AS 'Class'
    , CONCAT('<a target="_blank" href="view_attendance.jsp?semesterid=', CAST(C.semesterId AS CHAR), '&classid=', CAST(C.classId AS CHAR), '&subjectid=', CAST(C.subjectId AS CHAR), '&studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
    , CASE WHEN S.isActive = 12
			  THEN 'on LOA'
         WHEN CP.punchCount%2 = 0
              THEN 'Clocked Out'
         WHEN CP.punchCount%2 = 1
              THEN 'Clocked In'
         ELSE 'Clocked Out'
       END AS 'Status'
    , COALESCE(DATE_FORMAT(CP.lastPunch, '%h:%i %p'), ' -- ') AS 'Last Punch Today'
    -- , COALESCE(CP.punches, '--') AS 'Punches Today'

FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN ClassStudentReltn CSR ON S.studentId = CSR.studentId
INNER JOIN Classes C ON CSR.classId = C.classId
LEFT JOIN (SELECT userId
                , GROUP_CONCAT(DATE_FORMAT(punchTime, '%h:%i %p') SEPARATOR '; ') AS punches
                , MAX(punchTime) AS lastPunch
                , COUNT(clockPunchId) AS punchCount
			FROM ClockPunches
            WHERE isActive IN (1, 2)
            AND DATE(punchTime) = CURDATE()
            GROUP BY userId) CP
	ON CP.userId = S.studentId

WHERE R.isActive = 1
AND R.startDate <= CURDATE()
AND C.classId IN (SELECT classId FROM ClassTeacherReltn WHERE isActive = 1 AND teacherId = [USERID])
AND S.isActive IN (1, 12)
AND CSR.isActive = 1
AND CSR.status < 2
AND C.isActive = 1
AND C.<ADMINID>

GROUP BY CSR.ClassStudentReltnId

ORDER BY C.className, S.lastName
