-- BBA ADMIN Widget: Management Dashboard
-- Kelly MJ  |  9/10/2018
-- 9/24/2018 Kelly MJ: Removed leads, added total enrolled students, changed date range for 'weekly' reports to 'since first day of month' timeframe


-- Total enrolled students (for monthly billing)
SELECT '<strong>Total Enrolled Students (for monthly billing):</strong>' AS 'Type', CONCAT('<strong>', COUNT(Distinct S.studentId), '</strong>') 'Count'
FROM Students S
,Registrations R, Programmes P
WHERE S.isActive = 1
AND S.<ADMINID>
AND R.studentId=S.studentId
AND R.regStatus = 1
AND R.isActive = 1
AND P.isActive = 1
AND P.programmeId = R.programmeId
AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
AND S.firstName NOT LIKE '%test%'


UNION	-- Active students since yesterday
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


UNION	-- New Starts in the current month
SELECT COALESCE(CONCAT('<a target="_blank" href="view_startpage_query_report.jsp?queryid=', CAST(Q.queryId AS CHAR), '&type=spquery">New starts in ', DATE_FORMAT(CURDATE(), '%M'), ' (link to list):</a>'), CONCAT('New starts in ', DATE_FORMAT(CURDATE(), '%M:'))) AS 'Student Type'
	, COALESCE(COUNT(DISTINCT S.idNumber), 0)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
LEFT JOIN CustomStartPageQueries Q
	ON Q.adminid = R.adminid AND Q.userType = 4 AND Q.queryTitle = 'New Start Students In the Current Month'

WHERE S.isActive = 1
	AND R.isActive = 1
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.<ADMINID>

/*
UNION	-- New Leads in the past Week
SELECT CONCAT('<a target="_blank" href="https://bba.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=234&type=spquery">New leads in the past 30 days (link to list):</a>') AS 'Student Type'
	, COUNT(DISTINCT C.contactId)

FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
	AND C.<ADMINID>
*/

UNION	-- Graduates in current month
SELECT CONCAT('Graduated in ', DATE_FORMAT(CURDATE(), '%M'), ': ') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)

FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441

WHERE S.isActive = 3
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.graduationDate <= CURDATE() AND R.graduationDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.<ADMINID>


UNION	-- LOA in the current month
SELECT CONCAT('Went on LOA in ', DATE_FORMAT(CURDATE(), '%M'), ': ') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
INNER JOIN LeavesOfAbsence LOA
	ON LOA.studentId = S.studentId
    AND LOA.leaveDate > DATE_SUB(CURDATE(), INTERVAL 1 WEEK) AND LOA.leaveDate <= CURDATE()

WHERE S.isActive = 12
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.graduationDate <= CURDATE() AND R.graduationDate >= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.<ADMINID>


UNION	-- Drops in the current month
SELECT CONCAT('Dropped/Withdrew in ', DATE_FORMAT(CURDATE(), '%M'), ': ') AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441

WHERE S.isActive = 0
	AND S.firstName NOT LIKE '%test%' AND S.lastName NOT LIKE '%test%'
    AND R.graduationDate <= CURDATE() AND R.graduationDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.<ADMINID>