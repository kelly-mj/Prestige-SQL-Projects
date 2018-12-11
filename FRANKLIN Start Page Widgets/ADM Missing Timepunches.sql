-- Kelly MJ 8/24/2018 update: use attendanceClockPunch instead of reasonText
-- Kelly MJ 9/13/2018 update: excluded attendance records from the current day
-- Kelly MJ 11/27/18 update: exclude records from before 2018

SELECT CONCAT('<a href="view_attendance.jsp?semesterid=', CAST(REG.enrollmentSemesterId AS CHAR), '&classid=', CAST(ATD.classId AS CHAR), '&subjectid=', CAST(ATD.subjectId AS CHAR), '&studentid=', CAST(ATD.studentId AS CHAR), '"target="_blank">', CAST(SDT.firstName AS CHAR), ' ', CAST(SDT.lastName AS CHAR), '</a>') AS Name
	, ATD.duration AS Duration
	, ATD.attendanceDate AS Attendance_Date
    , ATD.attendanceClockPunch

FROM Attendance ATD

INNER JOIN Registrations REG
	ON ATD.studentId = REG.studentId

INNER JOIN Students SDT
	ON ATD.studentId = SDT.studentId

WHERE ATD.<ADMINID>
	AND NOT ATD.isActive = 0
	AND YEAR(ATD.attendanceDate) >= 2018
	AND ATD.attendanceDate < CURDATE()
	AND ATD.duration = 0
	AND ATD.present = 1

GROUP BY Attendance_Date, Name
ORDER BY Attendance_Date DESC, SDT.lastName 
LIMIT 10000