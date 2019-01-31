-- FRANKLIN ADMIN: New Start Students in the Current Month
-- Kelly MJ  |  1/31/2019

SELECT S.idNumber
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
	, P.programmeName AS 'Program Name'
	, R.startDate 'Start Date'
    
FROM Students S
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.isActive = 1
INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1

WHERE S.isActive = 1
	AND R.regStatus = 1
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.startDate >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
    AND S.<ADMINID>