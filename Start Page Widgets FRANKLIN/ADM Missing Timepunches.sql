-- Kelly MJ 8/24/2018 update: use attendanceClockPunch instead of reasonText
-- Kelly MJ 9/13/2018 update: excluded attendance records from the current day
-- Kelly MJ 11/27/18 update: exclude records from before 2018

SELECT CONCAT('<a href="view_attendance.jsp?semesterid=', CAST(REG.enrollmentSemesterId AS CHAR), '&classid=', CAST(ATD.classId AS CHAR), '&subjectid=', CAST(ATD.subjectId AS CHAR), '&studentid=', CAST(ATD.studentId AS CHAR), '"target="_blank">', CAST(SDT.firstName AS CHAR), ' ', CAST(SDT.lastName AS CHAR), '</a>') AS Name
	, MAX(ATD.duration) AS Duration
	, ATD.attendanceDate AS Attendance_Date
    , ATD.attendanceClockPunch

FROM (
	SELECT A.studentId
		, A.attendanceDate
		, MAX(A.duration) AS duration
	FROM Attendance A
	WHERE A.attendanceType = 0
	GROUP BY A.studentId, A.attendanceDate ) AA

INNER JOIN Attendance ATD
	ON ATD.studentId = AA.studentId
	AND ATD.attendanceDate = AA.attendanceDate
	AND ATD.duration = AA.duration

INNER JOIN ( 
	SELECT MAX(attendanceId) AS attendanceId
	FROM Attendance
	GROUP BY studentId, attendanceDate ) AAA
	ON AAA.attendanceId = ATD.attendanceId

INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId ) RR

INNER JOIN Registrations REG
	ON ATD.studentId = REG.studentId
	AND REG.startDate = RR.maxDate

INNER JOIN Students SDT
	ON ATD.studentId = SDT.studentId

WHERE ATD.<ADMINID>
	AND ATD.isActive = 1
	AND ATD.attendanceDate >= REG.startDate
	AND ATD.attendanceDate < CURDATE()
	AND ATD.duration = 0
	AND ATD.present = 1
	-- AND ATD.attendanceId IN ( SELECT MAX(attendanceId) FROM Attendance GROUP BY studentId, attendanceDate WHERE attendanceDate >= '2018-06-01')
	AND SDT.isActive IN (1, 3, 12)

GROUP BY Attendance_Date, ATD.studentId
ORDER BY Attendance_Date DESC, SDT.lastName 
LIMIT 10000