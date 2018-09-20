-- ADMIN (widget #230) New Start Students Within the Past Week
-- Kelly MJ  |  9/10/2018
-- Update Kelly MJ 9/14/2018: Added sort by campus

-- New Port Richey
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program Name' 
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">New Port Richey</td><td></td><td></td><td></td></tr>' AS '<div style="margin-right: 15em;"">Count</div>'

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
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.studentCampus = 34652
    AND S.<ADMINID>

UNION	-- Spring Hill
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program Name' 
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Spring Hill</td><td></td><td></td><td></td></tr>'

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
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.studentCampus = 34606
    AND S.<ADMINID>

UNION	-- Brookesville
SELECT NULL AS 'idNumber', NULL AS 'Name', NULL AS 'Program Name' 
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Brookesville</td><td></td><td></td><td></td></tr>'

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
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.studentCampus = 34601
    AND S.<ADMINID>