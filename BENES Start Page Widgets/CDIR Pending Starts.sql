-- BENE CDIR Pending Starte
-- Kelly MJ  |  12/17/2018

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
	, IF(R.startDate > CURDATE(), CONCAT('<span style="color: #cc0000;">', R.startDate, '</span>'), R.startDate) AS startdate
	, SS.statusName 'Status'
	, P.programmeName 'Program'
	, CASE S.studentCampus
		WHEN 34601 THEN 'Brookesville'
		WHEN 34606 THEN 'Spring Hill'
		ELSE 'New Port Richey'
	 END AS Campus

FROM Students S

INNER JOIN StatusSequences SS
 	ON SS.statusId = S.isActive
 	AND SS.statusType = 1 AND SS.isActive = 1 AND SS.<ADMINID>

INNER JOIN (
	SELECT studentId, MAX(startDate) AS maxDate FROM Registrations
	GROUP BY studentId) RR
	ON RR.studentId = S.studentId

INNER JOIN Registrations R
	ON R.studentId = S.studentId
	AND R.startDate = RR.maxDate

INNER JOIN Programmes P
	ON P.programmeId = R.programmeId

WHERE S.isActive = 1
AND S.<ADMINID>
AND R.regStatus = 1
AND R.startDate >= CURDATE()
AND R.isActive = 1
AND P.isActive = 1
AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
AND S.studentCampus IN (SELECT campusCode from SubAdmins WHERE subAdminId = [USERID])
AND S.firstName NOT LIKE '%test%'

ORDER BY Campus, R.startDate