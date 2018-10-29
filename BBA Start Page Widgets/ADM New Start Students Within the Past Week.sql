-- BBA ADMIN (widget #230) New Start Students in the Current Month
-- Kelly MJ  |  10/28/2018

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
    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.<ADMINID>