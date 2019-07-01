-- [BENES] NACCAS 2. All Graduates per Program
-- Kelly MJ  |  9/6/2018
-- 9/21/2018 Kelly MJ: Reformatted first two rows; corrected column order; uses attendance table to determine LDA

-- Report date range
SELECT '<span style="font-size: 110%; padding: 3px 3px 3px 1px;"><strong>Date Range: </strong></span>' AS 'Student ID'
	, CONCAT('<span style="font-size: 110%; padding: 3px;"><strong>', DATE_FORMAT('[?From Date]', "%m/%d/%Y"), ' - ', DATE_FORMAT(CURDATE(), "%m/%d/%Y"), '</strong></span>') 'Student Name'
	, NULL AS 'Program Name'
    , NULL AS 'Contract Start Date'
    , NULL AS 'Graduation Date'
    , NULL AS 'Last Date of Attendance'
    , NULL AS 'Actual Hours at Time of Graduation'
    , NULL AS 'Scheduled Hours'

UNION	-- Count of students in list
SELECT '<span style="font-size: 110%; padding: 3px 3px 3px 0px;"><strong>Student Count: </strong></span>'
	, CONCAT('<span style="font-size: 110%; padding: 3px;"><strong>', COUNT(t2.idNumber), '</strong></span>')
	, NULL, NULL, NULL, NULL, NULL, NULL
FROM (
	SELECT S.idNumber

	FROM Students S
	INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations
				WHERE isActive = 1
				AND programmeId NOT IN (SELECT programmeId FROM Programmes WHERE programmeName LIKE '%Career%') GROUP BY studentId) RR
	INNER JOIN Registrations R ON R.studentId = S.studentId
	INNER JOIN Programmes P ON P.programmeId = R.programmeId

	WHERE S.isActive = 3
			AND S.<ADMINID>
			AND S.firstName NOT LIKE '%test%'
			AND S.studentCampus = '[?Campus{34601|Brooksville|34652|New Port Richey|34606|Spring Hill}]'
			AND R.graduationDate >= '[?From Date]'
			AND R.registrationId = RR.maxReg

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
		, DATE_FORMAT(R.graduationDate, "%m/%d/%Y") 'Graduation Date'
		, (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_LDA' AND isActive = 1) 'LDA'
		, COALESCE(ROUND(PFV.fieldValue, 2), 'N/A') 'Actual Hours'
		, COALESCE((SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_SCHEDULED' AND isActive = 1), 0) 'Scheduled Hours'

	FROM Students S
	INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations
				WHERE isActive = 1
				AND programmeId NOT IN (SELECT programmeId FROM Programmes WHERE programmeName LIKE '%Career%') GROUP BY studentId) RR
	INNER JOIN Registrations R ON R.studentId = S.studentId
	INNER JOIN Programmes P ON P.programmeId = R.programmeId
	LEFT JOIN ProfileFieldValues PFV ON PFV.userId = S.studentId
		AND PFV.fieldName = 'PROGRAM_HOURS_ATTENDED'
	LEFT JOIN (SELECT userId, MAX(punchTime) AS lastPunch FROM ClockPunches GROUP BY userId) CP
		ON CP.userId = S.studentId

	WHERE S.isActive = 3
			AND S.<ADMINID>
			AND S.studentCampus = '[?Campus{34601|Brooksville|34652|New Port Richey|34606|Spring Hill}]'
			AND S.firstName NOT LIKE '%test%'
			AND R.graduationDate >= '[?From Date]'
			AND R.registrationId = RR.maxReg

	GROUP BY S.idNumber
	ORDER BY S.lastName ASC) t1
