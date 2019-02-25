-- ADMIN (widget #230) New Start Students Within the Past Week
-- Kelly MJ  |  9/10/2018
-- Update Kelly MJ 9/14/2018: Added sort by campus
-- Update Kelly MJ 9/24/2018: Changed date range from 'weekly' to 'since first day of the month'
-- Update Dave - generic for Buffalo
-- Update Kelly MJ 2/25/2019: Added sections for eacah student campus; DON'T COPY THIS CODE TO ANOTHER SCHOOL'S SITE

/*
 *	No Campus (0)
 */
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program'
	, IF(MAX(C.campusCode) != '14150', '<strong>CHANGE WIDGET CODE TO SUPPORT THIS SCHOOL</strong>', '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">No Campus</td><td></td><td></td><td></td></tr>') AS '<div style="margin-right: 15em;"">Start Date</div>'
FROM Campuses C WHERE C.<ADMINID>

UNION
SELECT S.idNumber
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
	, P.programmeName AS 'Program Name'
	, R.startDate 'Start Date'

FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
LEFT JOIN Programmes P
	ON P.programmeId = R.programmeId
	AND P.isActive = 1

WHERE S.isActive = 1
	AND R.isActive = 1
	AND S.firstName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.studentCampus = 0
    AND S.<ADMINID>

/*
 *	Main Campus (1)
 */
UNION
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program'
	, IF(MAX(C.campusCode) != '14150', '<strong>CHANGE WIDGET CODE TO SUPPORT THIS SCHOOL</strong>', '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Main Campus</td><td></td><td></td><td></td></tr>') AS '<div style="margin-right: 15em;"">Start Date</div>'
FROM Campuses C WHERE C.<ADMINID>

UNION
SELECT S.idNumber
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
	, P.programmeName AS 'Program Name'
	, R.startDate 'Start Date'

FROM Students S
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
LEFT JOIN Programmes P ON P.programmeId = R.programmeId
	AND P.isActive = 1

WHERE S.isActive = 1
	AND R.isActive = 1
	AND S.firstName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.studentCampus = 1
    AND S.<ADMINID>

/*
 *	Buffalo (14150)
 */
UNION
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program'
	, IF(MAX(C.campusCode) != '14150', '<strong>CHANGE WIDGET CODE TO SUPPORT THIS SCHOOL</strong>', '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Buffalo</td><td></td><td></td><td></td></tr>') AS '<div style="margin-right: 15em;"">Start Date</div>'
FROM Campuses C WHERE C.<ADMINID>

UNION
SELECT S.idNumber
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
	, P.programmeName AS 'Program Name'
	, R.startDate 'Start Date'

FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
LEFT JOIN Programmes P
	ON P.programmeId = R.programmeId
	AND P.isActive = 1

WHERE S.isActive = 1
	AND R.isActive = 1
	AND S.firstName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.studentCampus = 14150
    AND S.<ADMINID>
