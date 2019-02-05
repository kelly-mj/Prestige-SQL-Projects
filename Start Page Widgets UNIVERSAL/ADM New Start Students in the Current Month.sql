-- [U] SINGLE CAMPUS New Start Students in the Current Month
-- Kelly MJ  |  2/5/2019

SELECT t1.idNumber
	, IF(t1.campusNum = 1, t1.Name, '<strong>CHANGE WIDGET CODE TO SUPPORT MULTIPLE CAMPUSES</strong>') AS Name
	, IF(t1.campusNum = 1, t1.Program, NULL) AS Program
	, IF(t1.campusNum = 1, t1.startDate, NULL) 'Start Date'

FROM (
	SELECT S.idNumber
		, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
		, P.programmeName AS Program
		, DATE_FORMAT(R.startDate, '%m/%d/%Y') AS startDate
		, ( SELECT COUNT(C.campusId) FROM Campuses C WHERE C.<ADMINID> AND C.isActive = 1 ) AS campusNum

	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate AND R.isActive = 1
	LEFT JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1

	WHERE S.<ADMINID>
		AND S.firstName NOT LIKE '%test%'
	    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
	    AND S.isActive = 1
    ) t1

GROUP BY CASE t1.campusNum
	WHEN 1 THEN t1.idNumber
	ELSE t1.campusNum
	END