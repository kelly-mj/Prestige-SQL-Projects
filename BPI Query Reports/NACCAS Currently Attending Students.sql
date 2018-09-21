-- Report: All Currently Attending (Active) Students - BPI
-- Kelly MJ  |  9/6/2018

-- Report Run Date
SELECT NULL 'ID Number'
	, CONCAT('<div style="font-size: 120%; padding: 3px;"><strong>Report Run Date: ', DATE_FORMAT(CURDATE(), '%m/%d/%y'), '</strong></div>') 'Student Name'
	, NULL 'Course Enrolled', NULL 'Contract Start Date', NULL 'Hours Scheduled', NULL 'Hours Attended'

UNION	-- Count of students
SELECT NULL
	, CONCAT('<div style="font-size: 120%; padding: 3px;"><strong>Number of active students: ',COUNT(DISTINCT t1.idNumber), '</strong></div>')
	, NULL, NULL, NULL, NULL
FROM (
	SELECT S.idNumber

	FROM Students S

	INNER JOIN Registrations R
	ON R.studentId = S.studentId
	AND R.enrollmentSemesterId = 4000441
	AND R.isActive = 1

	WHERE S.<ADMINID>
	AND S.isActive IN (1, 12)  ) t1

UNION	-- List of students
SELECT t1.idNumber AS 'ID Number'
	, t1.Name AS 'Student Name'
	, t1.programmeName AS 'Course Enrolled'
	, DATE_FORMAT(t1.startDate, '%m/%d/%y') AS 'Contract Start Date'
	, FORMAT(t1.minClockHours, 2) AS 'Hours Scheduled'
	, FORMAT(COALESCE(ROUND(SUM(A.duration), 2), 0.00), 2) AS 'Hours Attended'

FROM (
	SELECT S.idNumber
		, S.studentId
		, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>') AS Name
		, R.startDate AS startDate
		, P.programmeId
		, P.programmeName
		, P.minClockHours

	FROM Students S

	INNER JOIN Registrations R
	ON R.studentId = S.studentId
	AND R.enrollmentSemesterId = 4000441
	AND R.isActive = 1

	INNER JOIN Programmes P
	ON P.programmeId = R.programmeId

	WHERE S.<ADMINID>
	AND S.isActive IN (1, 12)  ) t1

LEFT JOIN (
	SELECT studentId
		, duration
		, attendanceDate
	FROM Attendance AA
		    WHERE subjectId IN (SELECT GSR.subjectId FROM CourseGroups CG
								INNER JOIN GroupSubjectReltn GSR ON GSR.courseGroupId = CG.courseGroupId
		                        WHERE GSR.isActive = 1 AND CG.isActive = 1)
			AND classId IN (SELECT CSR.classId FROM ClassStudentReltn CSR
							  WHERE CSR.studentId = AA.studentId AND CSR.isActive = 1)
	GROUP BY attendanceId  ) A
	ON A.studentId = t1.studentId
	AND A.attendanceDate >= t1.startDate

GROUP BY t1.studentId