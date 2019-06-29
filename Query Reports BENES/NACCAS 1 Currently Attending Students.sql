-- Report: All Currently Attending (Active) Students
-- Kelly MJ  |  9/6/2018

SELECT '<strong>Date Report Run: </strong>' AS 'Student ID'
	, CONCAT('<strong>', CURDATE(), '</strong>') 'Student Name'
    , NULL AS 'Course Enrolled'
    , NULL AS 'Contract Start Date'
    , NULL AS '<div style="text-align: left">Scheduled Hours</div>'
    , NULL AS 'Actual Hours Completed'

UNION

SELECT '<strong>Student Count: </strong>'
	, COUNT(t2.Name)
	, NULL, NULL, NULL, NULL
FROM (
	SELECT DISTINCT S.idNumber 'Student ID'
		, CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>') AS Name

	FROM Students S
	INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations
				WHERE isActive = 1
				AND programmeId NOT IN (SELECT programmeId FROM Programmes WHERE programmeName LIKE '%Career%') GROUP BY studentId) RR
		ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId
	INNER JOIN Programmes P ON P.programmeId = R.programmeId
	LEFT JOIN ProfileFieldValues PFV ON PFV.userId = S.studentId
	    AND PFV.fieldName = 'PROGRAM_HOURS_ATTENDED'

	WHERE S.isActive IN (1, 12)
		AND S.firstName NOT LIKE '%test%'
		AND S.studentCampus = '[?Campus{34601|Brooksville|34652|New Port Richey|34606|Spring Hill}]'
		AND RR.maxReg = R.registrationId
		-- AND R.enrollmentSemesterId = 4000441
		AND S.<ADMINID>

	ORDER BY S.lastName ASC
) t2

UNION
SELECT null, null, null, null, null, null
UNION

SELECT t1.* FROM (
	SELECT DISTINCT S.idNumber 'Student ID'
		, CASE
			WHEN S.isActive = 1 THEN CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>')
			WHEN S.isActive = 12 THEN CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), ' (LOA)</a>')
			END AS Name
	    , P.programmeName 'Course Enrolled'              -- program name
	    , DATE_FORMAT(R.startDate, "%m/%d/%Y") 'Contract Start Date'
	    , FORMAT((SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE fieldName = 'PROGRAM_HOURS_SCHEDULED' AND userId = S.studentId AND isActive = 1), 2) 'Scheduled Hours'		-- scheduled hours
	    , CONCAT('<div style="text-align: left">', COALESCE(ROUND(PFV.fieldValue, 2), 0.00), '</div>') 'Actual Hours Completed'		-- actual hours completed

	FROM Students S
	INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations
				WHERE isActive = 1
				AND programmeId NOT IN (SELECT programmeId FROM Programmes WHERE programmeName LIKE '%Career%') GROUP BY studentId) RR
	INNER JOIN Registrations R ON R.studentId = S.studentId
	INNER JOIN Programmes P ON P.programmeId = R.programmeId
	LEFT JOIN ProfileFieldValues PFV ON PFV.userId = S.studentId
	    AND PFV.fieldName = 'PROGRAM_HOURS_ATTENDED'

	WHERE S.isActive IN (1, 12)
		AND S.firstName NOT LIKE '%test%'
		AND S.studentCampus = '[?Campus{34601|Brooksville|34652|New Port Richey|34606|Spring Hill}]'
		AND RR.maxReg = R.registrationId
		-- AND R.enrollmentSemesterId = 4000441
		AND S.<ADMINID>

	GROUP BY S.studentId
	ORDER BY S.lastName ASC
) t1
