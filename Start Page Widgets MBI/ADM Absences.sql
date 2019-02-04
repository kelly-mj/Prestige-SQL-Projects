-- MBI ADM Absences
-- Kelly MJ  |  1/9/2019

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
	, DATE_FORMAT(A.attendanceDate, '%m/%d/%Y') AS Date
	, C.className AS Class
	, A.reasonText AS Reason

FROM Students S

INNER JOIN Registrations R
	ON R.studentId = S.studentId

INNER JOIN Attendance A
	ON A.studentId = S.studentId
	AND A.isActive = 1
	AND A.absent = 1
	AND A.reasonType <> 7

INNER JOIN Classes C
	ON C.classId = A.classId

WHERE A.<ADMINID>
	AND S.isActive = 1
	AND R.isActive = 1
	AND R.regStatus = 1

ORDER BY Date DESC