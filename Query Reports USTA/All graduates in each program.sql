-- Report: All graduates in each program in a specified date range
-- Kelly MJ  |  9/6/2018

SELECT '<strong>Date Range: </strong>' AS 'Student ID'
	, CONCAT('<strong>', DATE_FORMAT('[?Start Date]', "%m/%d/%Y"), ' - ', DATE_FORMAT(CURDATE(), "%m/%d/%Y"), '</strong>') 'Student Name'
    , NULL AS 'Course Enrolled'
    , NULL AS 'Contract Start Date'
    , NULL AS '<div style="text-align: left">Scheduled Graduation Date</div>'
    , NULL AS 'Actual Graduation Date'

UNION

SELECT '<strong>Student Count: </strong>' 
	, COUNT(t2.Name)
	, NULL, NULL, NULL, NULL
FROM (
	SELECT S.idNumber
		, CONCAT(UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100))) AS Name -- student name w/ capitalization
		, P.programmeName 'Course Enrolled'
		, DATE_FORMAT(R.startDate, "%m/%d/%Y") 'Contract Start Date'
		, DATE_FORMAT(R.endDate, "%m/%d/%Y") 'Scheduled Graduation Date'
		, DATE_FORMAT(R.graduationDate, "%m/%d/%Y") 'Actual Graduation Date'

	FROM Students S

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.enrollmentSemesterId = 4000441
		AND R.graduationDate >= '[?Start Date]'
		AND R.graduationDate <= CURDATE()

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	WHERE S.isActive = 3
			AND S.<ADMINID>
			AND S.firstName NOT LIKE '%test%'

	ORDER BY S.lastName ASC) t2

UNION
SELECT null, null, null, null, null, null
UNION

SELECT t1.* FROM (
	SELECT S.idNumber
		, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>') AS Name
		, P.programmeName 'Course Enrolled'
		, DATE_FORMAT(R.startDate, "%m/%d/%Y") 'Contract Start Date'
		, DATE_FORMAT(R.endDate, "%m/%d/%Y") 'Scheduled Graduation Date'
		, DATE_FORMAT(R.graduationDate, "%m/%d/%Y") 'Actual Graduation Date'

	FROM Students S

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.enrollmentSemesterId = 4000441
		AND R.graduationDate >= '[?Start Date]'
		AND R.graduationDate <= CURDATE()

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	WHERE S.isActive = 3
			AND S.<ADMINID>
			AND S.firstName NOT LIKE '%test%'

	ORDER BY S.lastName ASC) t1