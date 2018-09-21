-- Report: All withdrawn students in a specified date range
-- Kelly MJ  |  9/6/2018
-- 9/21/2018 Kelly MJ: Reformatted first two rows; corrected column order; uses attendance table to determine LDA

-- Report date range
SELECT '<span style="font-size: 110%; padding: 3px 3px 3px 1px;"><strong>Date Range: </strong></span>' AS 'Student ID'
	, CONCAT('<span style="font-size: 110%; padding: 3px;"><strong>', DATE_FORMAT('[?Start Date]', "%m/%d/%Y"), ' - ', DATE_FORMAT(CURDATE(), "%m/%d/%Y"), '</strong></span>') 'Student Name'
	, NULL AS 'Program Name'
    , NULL AS 'Contract Start Date'
    , NULL AS 'Withdrawal Date'
    , NULL AS 'Last Date of Attendance'
    , NULL AS 'Actual Hours at<br>Time of Withdrawal'
    , NULL AS '<div style="text-align: left">Scheduled<br>Program<br>Hours</div>'

UNION	-- Count of students in list
SELECT '<span style="font-size: 110%; padding: 3px 3px 3px 0px;"><strong>Student Count: </strong></span>' 
	, CONCAT('<span style="font-size: 110%; padding: 3px;"><strong>', COUNT(t2.idNumber), '</strong></span>')
	, NULL, NULL, NULL, NULL, NULL, NULL
FROM (
	SELECT S.idNumber

	FROM Students S

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.graduationDate >= '[?Start Date]'

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	WHERE S.isActive = 0
			AND S.<ADMINID>
			AND S.firstName NOT LIKE '%test%'

	GROUP BY S.idNumber
	ORDER BY S.lastName ASC) t2

UNION	-- spacer
SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL

UNION	-- student list
SELECT t1.* FROM (
	SELECT S.idNumber
		, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>') AS Name
		, P.programmeName
		, DATE_FORMAT(R.startDate, "%m/%d/%Y") 'Contract Start Date'
		, DATE_FORMAT(R.graduationDate, "%m/%d/%Y") 'Withdrawal Date'
		, COALESCE(DATE_FORMAT(DATE(CP.punchTime), "%m/%d/%Y"), DATE_FORMAT(MAX(A.attendanceDate), '%m/%d/%y'), 'N/A') 'LDA'
		, COALESCE(ROUND(SUM(A.duration), 2), 'N/A') 'Actual Hours'
		, CAST(P.minClockHours AS CHAR) 'Scheduled Hours'

	FROM Students S

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.graduationDate >= '[?Start Date]'

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	LEFT JOIN Attendance A
	ON A.studentId = S.studentId
    AND A.attendanceDate <= R.graduationDate
    AND A.attendanceDate >= R.startDate
    AND A.subjectId IN (SELECT GSR.subjectId FROM CourseGroups CG
						INNER JOIN GroupSubjectReltn GSR ON GSR.courseGroupId = CG.courseGroupId
                        WHERE GSR.isActive = 1 AND CG.isActive = 1 AND R.programmeId = CG.programmeId)
	AND A.classId IN (SELECT CSR.classId FROM ClassStudentReltn CSR
					  WHERE CSR.studentId = A.studentId AND CSR.isActive = 1)

	LEFT JOIN (SELECT userId, MAX(punchTime) AS punchTime FROM ClockPunches GROUP BY userId) CP
		ON CP.userId = S.studentId

	WHERE S.isActive = 0
			AND S.<ADMINID>
			AND S.firstName NOT LIKE '%test%'

	GROUP BY S.idNumber
	ORDER BY S.lastName ASC) t1