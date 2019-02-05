-- AOHD ADMIN  New Start Students Within the Past Month
-- Kelly MJ  |  9/10/2018

/*
 *	Austin (78741)
 */
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program' 
	, IF(MAX(C.campusCode) != '78741', '<strong>CHANGE WIDGET CODE TO SUPPORT THIS SCHOOL</strong>', '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Austin</td><td></td><td></td><td></td></tr>') AS '<div style="margin-right: 15em;"">Start Date</div>'
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
    AND S.studentCampus = 78741
    AND S.<ADMINID>

/*
 *	Springfield (65804)
 */
UNION
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program' 
	, IF(MAX(C.campusCode) != '78741', '<strong>CHANGE WIDGET CODE TO SUPPORT THIS SCHOOL</strong>', '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Springfield</td><td></td><td></td><td></td></tr>') AS '<div style="margin-right: 15em;"">Start Date</div>'
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
    AND S.studentCampus = 65804
    AND S.<ADMINID>