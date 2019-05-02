-- [SHELL] Timepunch Errors - Missing Clock Outs
-- Kelly MJ  |  2/22/2019

SELECT DATE_FORMAT(CP.punchDate, '%m/%d/%Y') 'Attendance Date'
	, CONCAT('<a target="_blank" href="view_attendance.jsp?semesterid=', CAST(R.enrollmentSemesterId AS CHAR), '&classid=', CAST(CSR.classId AS CHAR), '&subjectid=', CAST(A.subjectId AS CHAR), '&studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ' ', S.firstName, '</a>') AS 'Student Name'
	, C.className 'Class'
	, CP.punchTimes

FROM Students S

INNER JOIN ( SELECT studentId, MAX(registrationId) maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
	ON RR.studentId = S.studentId

INNER JOIN Registrations R
	ON R.studentId = S.studentId AND R.registrationId = RR.maxReg

LEFT JOIN (
	SELECT C.userId, C.punchDate
		, COUNT(C.clockPunchId) AS punchCount
		, MAX(C.clockPunchId) AS clockPunchId
		, GROUP_CONCAT(C.punchTime ORDER BY C.clockPunchId SEPARATOR '; ') AS punchTimes
	FROM (SELECT userId, DATE(punchTime) as punchDate, clockPunchId
		  	, CONCAT(DATE_FORMAT(punchTime, '%l:%i %p')) AS punchTime
	      FROM ClockPunches
		  WHERE isActive > 0 ) C
		  GROUP BY C.userId, C.punchDate
	  ) CP ON CP.userId = S.studentId

INNER JOIN Attendance A
	ON A.studentId = S.studentId AND A.attendanceDate = CP.punchDate

INNER JOIN ClassStudentReltn CSR
	ON CSR.studentId = S.studentId AND CSR.classId = A.classId

INNER JOIN Classes C
	ON C.classId = CSR.classId

WHERE S.<ADMINID>
	AND S.isActive IN (1, 12)
	AND CP.punchCount % 2 = 1
	AND CP.punchDate < CURDATE()
	AND CP.punchDate >= DATE_FORMAT(CURDATE(), '%Y-01-01')
	AND A.isActive = 1
	AND CSR.isActive = 1
	AND C.isActive = 1
	AND (LENGTH(A.attendanceClockPunch) < (10*CP.punchCount + 5))
	AND IF('[?Campus Select (leave blank to select all)]' = ''
	    , S.<ADMINID>
	    , ((S.studentCampus = '[?Campus Select (leave blank to select all)]') OR
	       (S.studentCampus = (SELECT MAX(campusCode) FROM Campuses WHERE LOWER(campusName) = LOWER('[?Campus Select (leave blank to select all)]')) )) )

ORDER BY CP.punchDate, S.lastName
LIMIT 1000
