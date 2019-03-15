-- ADM Missing Timepunches - Attendance Record Errors
-- Kelly MJ  |  2/22/2019

SELECT DATE_FORMAT(A.attendanceDate, '%m/%d/%Y') 'Attendance Date'
	, CONCAT('<a target="_blank" href="view_attendance.jsp?semesterid=', CAST(R.enrollmentSemesterId AS CHAR), '&classid=', CAST(A.classId AS CHAR), '&subjectid=', CAST(C.subjectId AS CHAR), '&studentid=', CAST(A.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS 'Name'
	, C.className 'Class'
	, CONCAT(FORMAT(A.duration, 2), ' Hrs') 'Duration'
	, A.attendanceClockPunch 'Clock Punches'
	, IF(A.present = 1, 'Present', 'Absent') 'Marked as'
	, (SELECT
		GROUP_CONCAT((CASE CS.dayNum WHEN 0 THEN 'Sun' WHEN 1 THEN 'Mon' WHEN 2 THEN 'Tues' WHEN 3 THEN 'Wed' WHEN 4 THEN 'Th' WHEN 5 THEN 'Fri' WHEN 6 THEN 'Sat' END)
		ORDER BY dayNum ASC SEPARATOR ', ') FROM ClassSchedules CS WHERE CS.classId = A.classId) AS 'Class Schedule'

FROM Students S

INNER JOIN ( SELECT studentId, MAX(registrationId) maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR

INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg

INNER JOIN Attendance A ON A.studentId = S.studentId
	AND ( (A.present <> 1 AND A.attendanceClockPunch > "1") OR (A.present = 1 AND A.duration = 0) )

INNER JOIN ClassStudentReltn CSR ON CSR.studentId = S.studentId
	AND CSR.classId = A.classId

INNER JOIN Classes C ON C.classId = A.classId

WHERE S.<ADMINID>
	AND S.isActive IN (1, 3, 12)
	AND A.attendanceDate < CURDATE()
	AND A.attendanceDate >= DATE_FORMAT(CURDATE(), '%Y-01-01')
	AND CSR.isActive = 1
	AND C.isActive = 1

ORDER BY A.attendanceDate, S.lastName
LIMIT 1000
