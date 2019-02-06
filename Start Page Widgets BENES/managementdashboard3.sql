-- USE TEST CODE TO CHECK STUDENT STATUSES

/****************************************************************************************
 *	List of all enrolled students, including LOA. Lists registration and LOA details.	*
 *	No date restriction.																*
 ****************************************************************************************/

( SELECT 'All enrolled students at the moment' AS 'Report Type'
	, COUNT(S.studentId) AS Count

FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
LEFT JOIN ( 
	SELECT L.studentId, L.leaveDate, L.returnDate
	FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
	INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
	) LOA ON LOA.studentId = S.studentId

WHERE S.<ADMINID>
	AND S.isActive IN (1, 12)
	AND R.regStatus IN (1, 12)
	AND R.startDate <= CURDATE()
	AND S.firstName NOT LIKE '%test%'
	AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' ) )


/****************************************************************************************
 *	List of all enrolled students, including LOA. Lists registration and LOA details.	*
 *	Date range restricted to the current month.											*
 ****************************************************************************************/
UNION (
SELECT t1.*

FROM (
	-- Currently enrolled students (NO LOA)
	( SELECT 'Enrolled students at the start of the month - no LOA', COUNT(S.studentId)
	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
	ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
	INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
	WHERE S.<ADMINID>
		AND S.isActive NOT IN (7, 11, 13, 14, 16, 17, 91)
		AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
		AND (R.graduationDate IS NULL OR R.graduationDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE()))
		AND S.firstName NOT LIKE '%test%'
		AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' ) 
		AND S.studentId NOT IN ( SELECT L.studentId
			FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
			INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
			WHERE L.leaveDate < DATE_FORMAT(CURDATE(), '%Y-%m-01') AND L.returnDate IS NULL ) )

	-- Currently LOA students (NO just enrolled)
	UNION (
	SELECT 'LOA students at the start of the month', COUNT(S.studentId)
	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
	ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
	INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
	INNER JOIN ( 
		SELECT L.studentId, L.leaveDate, L.returnDate
		FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
		INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
		WHERE L.leaveDate < DATE_FORMAT(CURDATE(), '%Y-%m-01') AND L.returnDate IS NULL
		) LOA ON LOA.studentId = S.studentId
	WHERE S.<ADMINID>
		AND S.isActive NOT IN (7, 11, 13, 14, 16, 17, 91)
		AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
		AND (R.graduationDate IS NULL OR R.graduationDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE()))
		AND S.firstName NOT LIKE '%test%'
		AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' ) )
	) t1
)


/********************************************************************
 *	List of new starts. Date range restricted to the current month.	*
 ********************************************************************/
UNION
SELECT 'New starts this month', COUNT(S.studentId)

FROM Students S
INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate AND R.isActive = 1
LEFT JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1

WHERE S.<ADMINID>
	AND S.firstName NOT LIKE '%test%'
    AND R.startDate <= CURDATE() AND R.startDate > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
    AND S.isActive = 1
    AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' )


/********************************************************************
 *	List of graduates. Date range restricted to the current month.	*
 ********************************************************************/
UNION
SELECT 'Graduated this month', COUNT(S.studentId)
FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
WHERE S.<ADMINID>
	AND S.isActive = 3								-- graduated status code
	AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
	AND R.graduationDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
	AND S.firstName NOT LIKE '%test%'				-- exclude test students in the system
	AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' ) 
	AND S.studentId NOT IN ( SELECT L.studentId		-- Make sure student isn't on LOA
		FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
		INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
		WHERE L.leaveDate < DATE_FORMAT(CURDATE(), '%Y-%m-01') AND L.returnDate IS NULL )


/********************************************************
 *	List of withdrawn students in the current month.	*
 ********************************************************/
UNION
SELECT 'Withdrew this month', COUNT(S.studentId)
FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
WHERE S.<ADMINID>
	AND S.isActive = 0								-- withdrawn status code
	AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
	AND R.graduationDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
	AND S.firstName NOT LIKE '%test%'				-- exclude test students in the system
	AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' ) 
	AND S.studentId NOT IN ( SELECT L.studentId		-- Make sure student isn't on LOA
		FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
		INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
		WHERE L.leaveDate < DATE_FORMAT(CURDATE(), '%Y-%m-01') AND L.returnDate IS NULL )


/************************************************************
 *	List of students who left on LOA in the current month.	*
 ************************************************************/
UNION
SELECT 'Left on LOA this month',  COUNT(S.studentId)
	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
	ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
	INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
	INNER JOIN ( 
		SELECT L.studentId, L.leaveDate, L.returnDate
		FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
		INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
		WHERE L.leaveDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
			AND L.returnDate IS NULL
		) LOA ON LOA.studentId = S.studentId
	WHERE S.<ADMINID>
		AND S.isActive NOT IN (7, 11, 13, 14, 16, 17, 91)
		AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
		AND (R.graduationDate IS NULL OR R.graduationDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE()))
		AND S.firstName NOT LIKE '%test%'
		AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' )


/********************************************************************
 *	List of students who returned from LOA in the current month.	*
 ********************************************************************/
UNION
SELECT 'Returned from LOA this month', COUNT(S.studentId)
	FROM Students S
	INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId AND R.registrationId = RR.maxReg AND R.isActive = 1
	INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
	INNER JOIN ( 
		SELECT L.studentId, L.leaveDate, L.returnDate
		FROM ( SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA FROM LeavesOfAbsence WHERE isActive = 1 GROUP BY studentId ) LL
		INNER JOIN LeavesOfAbsence L ON L.studentId = LL.studentId AND L.leavesOfAbsenceId = LL.maxLOA
		WHERE L.returnDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
		) LOA ON LOA.studentId = S.studentId
	WHERE S.<ADMINID>
		AND S.isActive NOT IN (0, 3, 7, 11, 13, 14, 16, 17, 91)
		AND R.startDate < DATE_FORMAT(CURDATE(), '%Y-%m-01')
		AND (R.graduationDate IS NULL OR R.graduationDate BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE()))
		AND S.firstName NOT LIKE '%test%'
		AND R.programmeId IN ( SELECT programmeId FROM Programmes WHERE programmeName NOT LIKE '%Career%' )