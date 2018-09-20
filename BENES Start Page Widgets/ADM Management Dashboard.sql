-- ADMIN Widget: Management Dashboard
-- Kelly MJ  |  9/10/2018

SELECT CONCAT('Enrolled students who have started since yesterday (', DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY), "%m/%d/%y"), '): ') AS 'Student Type'
    , COUNT(DISTINCT S.idNumber) AS Count
    
FROM Students S
	, Registrations R

WHERE S.isActive = 1
	AND S.<ADMINID>
	AND R.studentId=S.studentId
	AND R.regStatus = 1 AND R.isActive = 1 AND R.startDate < CURDATE()
	AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
	AND S.firstName NOT LIKE '%test%'

UNION	-- New Starts in the past Week
SELECT CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=230&type=spquery">New starts in the past week (link to list):</a>') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441

WHERE S.isActive = 1
	AND R.isActive = 1
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.<ADMINID>

UNION	-- New Leads in the past Week
SELECT CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=234&type=spquery">New leads in the past week (link to list):</a>') AS 'Student Type'
	, COUNT(DISTINCT C.contactId)

FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
	AND C.<ADMINID>
    
UNION

SELECT CONCAT('Graduates in the past week:') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)

FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441

WHERE S.isActive = 3
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.graduationDate <= CURDATE() AND R.graduationDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.<ADMINID>
    
UNION

SELECT CONCAT('Drops in the past week:') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441

WHERE S.isActive = 0
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.graduationDate <= CURDATE() AND R.graduationDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.<ADMINID>

UNION

SELECT CONCAT('LOA in the past week:') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
INNER JOIN LeavesOfAbsence LOA
	ON LOA.studentId = S.studentId
    AND LOA.leaveDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK) AND LOA.leaveDate <= CURDATE()

WHERE S.isActive = 0
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.graduationDate <= CURDATE() AND R.graduationDate >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
    AND S.<ADMINID>