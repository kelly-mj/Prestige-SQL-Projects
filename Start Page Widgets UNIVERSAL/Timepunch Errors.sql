-- [SHELL] ALL Timepunch Errors
-- Kelly MJ  |  2/22/2019

/* Header row: Displays Campus Name */
SELECT CONCAT('<strong>Showing Results For '
			   , IF((NOT EXISTS (SELECT subAdminId
								   FROM SubAdmins
								   WHERE subAdminId = [USERID]
								   AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0) )
					AND [USERID] <> 48)
					   , CMP.campusName
					   , 'All Campuses')
			   , '</strong>') AS 'Report Type'
	, NULL AS Count
FROM Campuses CMP
WHERE CMP.campusCode = (SELECT MAX(campusCode)
					   FROM SubAdmins
					   WHERE IF ([USERID] = 48, subAdminId <> 48, subAdminId = [USERID]))
AND CMP.<ADMINID>

/* Count of students with an uncorrected, odd number of clock punches for a particular date */
	-- students who have an odd number of clock punches AND their clock punches were not corrected in post attendance
UNION
(SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
			, (SELECT CAST(MAX(Q.queryId) AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Timepunch Errors - Missing Clock Outs')
			,'">Timepunch Errors - Missing Clock Outs</a>') AS 'Report Type'
	, COUNT(CP.clockPunchId) AS Count

FROM Students S

INNER JOIN ( SELECT studentId, MAX(registrationId) maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
	ON RR.studentId = S.studentId

INNER JOIN Registrations R ON R.studentId = S.studentId
	AND R.registrationId = RR.maxReg

LEFT JOIN (
	SELECT C.userId, C.punchDate
		, COUNT(C.clockPunchId) AS punchCount
		, MAX(C.clockPunchId) AS clockPunchId
	FROM (SELECT userId, DATE(punchTime) as punchDate, clockPunchId
	      FROM ClockPunches
		  WHERE isActive > 0 ) C
		  GROUP BY C.userId, C.punchDate
	  ) CP ON CP.userId = S.studentId

INNER JOIN Attendance A ON A.studentId = S.studentId AND A.attendanceDate = CP.punchDate

INNER JOIN ClassStudentReltn CSR ON CSR.studentId = S.studentId AND CSR.classId = A.classId

WHERE S.<ADMINID>
	AND CP.punchDate >= DATE_FORMAT(CURDATE(), '%Y-01-01')
	AND CP.punchDate < CURDATE()
	AND (CP.punchCount % 2 = 1)
	AND CSR.isActive = 1
	AND A.isActive = 1
	AND (LENGTH(A.attendanceClockPunch) < (10*CP.punchCount + 5))		-- error hasn't been corrected in attendanceClockPunch
	AND S.isActive IN (1, 12)
	AND IF (NOT EXISTS (SELECT subAdminId
						FROM SubAdmins
						WHERE subAdminId = [USERID]
						AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
			AND [USERID] <> 48
			, EXISTS ( SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = S.studentCampus)
			, S.studentCampus <> 'delicious_kielbasa_sausage' )
)

/* Count of students with inconsistencies in their attendance record */
	-- students who were not marked as present, but have a nonzero duration
	-- students who were not marked as present, but have at least 1 clock punch
UNION (
SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
				, (SELECT CAST(MAX(Q.queryId) AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Timepunch Errors - Attendance Record Errors')
				,'">Timepunch Errors - Attendance Record Errors</a>') AS 'Report Type'
	, COUNT(A.attendanceId) AS Count

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
	AND IF (NOT EXISTS (SELECT subAdminId
						FROM SubAdmins
						WHERE subAdminId = [USERID]
						AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
			AND [USERID] <> 48
			, EXISTS ( SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = S.studentCampus)
			, S.studentCampus <> 'delicious_kielbasa_sausage' )

ORDER BY A.attendanceDate, S.lastName
LIMIT 1000
)
