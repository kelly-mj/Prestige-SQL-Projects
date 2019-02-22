-- ADM Missing Timepunches
-- Kelly MJ  |  Sometime before 8/24/18
-- Kelly MJ 8/24/2018 update: use attendanceClockPunch instead of reasonText
-- Kelly MJ 9/13/2018 update: excluded attendance records from the current day

SELECT CONCAT('<a target="_blank" href="admin_view_student_attendance_record.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS 'Student Name'
	-- , A.attendanceDate
	-- , A.present
	-- , A.duration
	-- , A.attendanceClockPunch
	, CP.punchDate
	, CP.punchTimes
	, CP.punchCount
	-- , IF(LENGTH(A.attendanceClockPunch) < (10*CP.punchCount + 5), 'N', 'Y') AS 'Corrected?'

FROM Students S

INNER JOIN ( SELECT studentId, MAX(registrationId) maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR

INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg

/*
INNER JOIN Attendance A ON A.studentId = S.studentId -- AND A.attendanceDate = CP.punchDate
	AND ( (A.present <> 1 AND A.attendanceClockPunch > "1") OR (A.present = 1 AND A.duration = 0) )
	AND A.attendanceDate >= '2019-01-01' AND A.attendanceDate < CURDATE()
*/

LEFT JOIN (
	SELECT C.userId, C.punchDate, COUNT(C.clockPunchId) AS punchCount, GROUP_CONCAT(C.punchTime ORDER BY C.clockPunchId SEPARATOR ' ') AS punchTimes
	FROM (
		  SELECT userId, DATE(punchTime) as punchDate, clockPunchId
		  	, CONCAT(IF(clockedStatus%2 = 1, DATE_FORMAT(punchTime, '%l:%i %p -'), DATE_FORMAT(punchTime, '%l:%i %p; '))) AS punchTime
	      FROM ClockPunches
		  WHERE isActive > 0 ) C
		  GROUP BY C.userId, C.punchDate
	  ) CP ON CP.userId = S.studentId
	AND CP.punchDate >= DATE_FORMAT(CURDATE(), '%Y-01-01')
	AND (CP.punchCount % 2 = 1)

WHERE S.<ADMINID>
	AND S.isActive IN (1, 12)
	AND CP.punchDate < CURDATE()
	AND CP.punchDate >= '2019-01-01'

ORDER BY
	CP.punchDate
	-- A.attendanceDate
	, S.lastName
LIMIT 1000
