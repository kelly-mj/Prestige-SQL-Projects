-- [U] ADMIN Widget: Management Dashboard
-- Kelly MJ  |  9/10/2018
-- 9/24/2018 Kelly MJ: Removed leads, added total enrolled students, changed date range for 'weekly' reports to 'since first day of month' timeframe

/*
 *	Total enrolled students (for monthly billing)
 */
SELECT CONCAT('<strong>Total Enrolled Students (for monthly billing):</strong>') AS 'Type'
	, CONCAT('<strong>', COUNT(Distinct S.studentId), '</strong>') 'Count'

FROM Students S
INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId ) RR
	ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate AND R.isActive = 1
INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive
WHERE S.<ADMINID>
	AND S.isActive = 1
	AND S.firstName NOT LIKE '%test%'
	AND R.regStatus = 1
	AND R.startDate <= CURDATE()

/*
 *	Active students from before 1st of the current month
 */
UNION
SELECT DATE_FORMAT(CURDATE(), 'Students who were enrolled before %M 1st:') AS 'Student Type'
    , COUNT(DISTINCT t1.idNumber) AS Count
   
FROM ( 
	-- students who are still active/enrolled in the current month
	SELECT S.idNumber
	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId ) RR
		ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate

	WHERE S.<ADMINID>
		AND R.regStatus = 1
		AND R.isActive = 1
		AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
		AND S.isActive = 1
		AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND leaveDate <+ DATE_FORMAT(CURDATE(), '%Y-%m-01') AND (L.returnDate IS NULL OR L.returnDate > NOW()) AND L.<ADMINID>)	-- not currently on LOA
		AND S.firstName NOT LIKE '%test%'

	UNION	-- students who graduated/dropped during the current month
	SELECT S.idNumber
	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId ) RR
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate

	WHERE S.<ADMINID>
		AND S.isActive = 3
		AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')		-- started before the current month
		AND R.isActive = 1
		AND R.graduationDate >= DATE_FORMAT(CURDATE(), '%Y-%m-01')	-- graduated within the current month
		AND R.graduationDate <= LAST_DAY(CURDATE())
	) t1


/*
 *	New Starts in the current month
 */
UNION
SELECT COALESCE(CONCAT('<a target="_blank" href="view_startpage_query_report.jsp?queryid=', CAST(Q.queryId AS CHAR), '&type=spquery">New starts in ', DATE_FORMAT(CURDATE(), '%M'), ' (link to list):</a>'), DATE_FORMAT(CURDATE(), 'New starts in %M:')) AS 'Student Type'
	, COUNT(DISTINCT S.idNumber)
    
FROM Students S
INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.enrollmentSemesterId = 4000441
LEFT JOIN CustomStartPageQueries Q
	ON Q.isActive = S.isActive AND Q.queryTitle = 'New Start Students in the Current Month'

WHERE S.isActive = 1
	AND R.isActive = 1
	AND S.firstName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
    AND S.<ADMINID>

/*
 *	Graduates in current month
 */
UNION
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

/*
 *	LOA in the current month
 */
UNION
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

/*
 *	Drops in the current month
 */
UNION
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