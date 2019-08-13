-- Flash Report: Attempt 4

/***** numbers per campus, per day *****/
(SELECT CMP.campusName
	, CONCAT('<span style="width: 15px;">', DATE_FORMAT(DATES.auto_date, '%m/%d/%Y'), ' ', SUBSTRING(DATE_FORMAT(DATES.auto_date, '%W'), 1, 3), '</span>') AS 'Date'
	, IF(DATES.auto_date IS NULL, NULL, COALESCE(t1.C_count, IF(DATES.auto_date > CURDATE(), NULL, 0))) AS 'Leads'
    , IF(DATES.auto_date IS NULL, NULL, COALESCE(t2.I_count, IF(DATES.auto_date > CURDATE(), NULL, 0))) AS 'Interviewed'
    , IF(DATES.auto_date IS NULL, NULL, COALESCE(t2.E_count, IF(DATES.auto_date > CURDATE(), NULL, 0))) AS 'Enrolled'
    , IF(DATES.auto_date IS NULL, NULL, COALESCE(t3.A_count, IF(DATES.auto_date > CURDATE(), NULL, 0))) AS 'Appointments Tomorrow'

FROM Campuses CMP

/* expand campuses*each_day of the six days in the flash report */
LEFT JOIN (
	SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AS auto_date, 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY), 1 AS active
    UNION SELECT null, 1 AS active
	) DATES ON DATES.active = CMP.isActive

/* select newly added leads per campus and date */
LEFT JOIN (
	SELECT C.campusCode
		, DATE(C.creationDtTm) AS creationDtTm
		, COUNT(DISTINCT C.contactId) AS C_count
	FROM Contacts C
	INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
	WHERE DATE(C.creationDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	  AND DATE(C.creationDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
	  AND C.isActive = 1
	  AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
	GROUP BY C.campusCode, DATE(C.creationDtTm)
) t1 ON t1.campusCode = CMP.campusCode
	AND t1.creationDtTm = DATES.auto_date

/* select leads who were interviewed/enrolled on each campus on each day of the week */
LEFT JOIN (
	SELECT t2_a.campusCode
		, t2_a.updateDtTm
		, COUNT(DISTINCT t2_a.I) AS I_count
		, COUNT(DISTINCT t2_a.E) AS E_count
	FROM (
		(SELECT C.campusCode
			, CONCAT(C.firstName, C.lastName) AS 'I'
			, NULL AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '6. Interviewed'
		  AND DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, DATE(U.updateDtTm))
		UNION
		(SELECT C.campusCode
			, NULL
			, CONCAT(C.firstName, C.lastName) AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '8. Enrolled'
		  AND DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, DATE(U.updateDtTm))
		UNION
		(SELECT C.campusCode
			, IF(CT.typeName = '6. Interviewed', CONCAT(C.firstName, C.lastName), NULL) AS 'I'
			, IF(CT.typeName = '8. Enrolled', CONCAT(C.firstName, C.lastName), NULL) AS 'E'
			, DATE(C.lastUpdateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId

		WHERE CT.typeName IN ('6. Interviewed', '8. Enrolled')
		  AND DATE(C.lastUpdateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(C.lastUpdateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		GROUP BY C.firstName, C.lastName, DATE(C.lastUpdateDtTm)
		)
	) t2_a
	GROUP BY t2_a.campusCode, t2_a.updateDtTm
) t2 ON CMP.campusCode = t2.campusCode
	AND t2.updateDtTm = DATES.auto_date

/* select appointments per campus per day of the week */
LEFT JOIN  (
	SELECT SA.campusCode
		, DATE_SUB(DATE(A.fromDtTm), INTERVAL 1 DAY) AS fromDtTm
		, COUNT(DISTINCT A.appointmentId) AS A_count

	FROM Appointments A
	INNER JOIN AppointmentPeopleReltn APR ON APR.appointmentId = A.appointmentId
	LEFT JOIN SubAdmins SA ON SA.subAdminId = APR.userId

	WHERE APR.userType IN (4, 6)
	  AND A.isActive = 1
	  AND APR.isActive = 1
	  AND DATE(A.fromDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
	  AND DATE(A.fromDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 8) DAY)

	GROUP BY SA.campusCode, DATE(A.fromDtTm)
) t3 ON t3.campusCode = CMP.campusCode
	AND t3.fromDtTm = DATES.auto_date

WHERE CMP.isActive = 1
  AND CMP.campusName <> 'Ft Lauderdale Beach' )

/***** weekly totals per campus *****/
UNION
(SELECT CMP.campusName
	, '<strong>Weekly Total</strong>' AS 'Date'
	, CONCAT('<strong>', COALESCE(SUM(t1.C_count), 0), '</strong>') AS 'Leads'
    , CONCAT('<strong>', COALESCE(SUM(t2.I_count), 0), '</strong>') AS 'Interviewed'
    , CONCAT('<strong>', COALESCE(SUM(t2.E_count), 0), '</strong>') AS 'Enrolled'
    , CONCAT('<strong>', COALESCE(SUM(t3.A_count), 0), '</strong>') AS 'Appointments Tomorrow'

FROM Campuses CMP

/* expand campuses*each_day of the six days in the flash report */
LEFT JOIN (
	SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AS auto_date, 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY), 1 AS active
    UNION SELECT null, 1 AS active
	) DATES ON DATES.active = CMP.isActive

/* select newly added leads per campus and date */
LEFT JOIN (
	SELECT C.campusCode
		, DATE(C.creationDtTm) AS creationDtTm
		, COUNT(DISTINCT C.contactId) AS C_count
	FROM Contacts C
	INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
	WHERE DATE(C.creationDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	  AND DATE(C.creationDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
	  AND C.isActive = 1
	  AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
	GROUP BY C.campusCode, DATE(C.creationDtTm)
) t1 ON t1.campusCode = CMP.campusCode
	AND t1.creationDtTm = DATES.auto_date

/* select leads who were interviewed/enrolled on each campus on each day of the week */
LEFT JOIN (
	SELECT t2_a.campusCode
		, t2_a.updateDtTm
		, COUNT(DISTINCT t2_a.I) AS I_count
		, COUNT(DISTINCT t2_a.E) AS E_count
	FROM (
		(SELECT C.campusCode
			, CONCAT(C.firstName, C.lastName) AS 'I'
			, NULL AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '6. Interviewed'
		  AND DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, DATE(U.updateDtTm))
		UNION
		(SELECT C.campusCode
			, NULL
			, CONCAT(C.firstName, C.lastName) AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '8. Enrolled'
		  AND DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, DATE(U.updateDtTm))
		UNION
		(SELECT C.campusCode
			, IF(CT.typeName = '6. Interviewed', CONCAT(C.firstName, C.lastName), NULL) AS 'I'
			, IF(CT.typeName = '8. Enrolled', CONCAT(C.firstName, C.lastName), NULL) AS 'E'
			, DATE(C.lastUpdateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId

		WHERE CT.typeName IN ('6. Interviewed', '8. Enrolled')
		  AND DATE(C.lastUpdateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(C.lastUpdateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		GROUP BY C.firstName, C.lastName, DATE(C.lastUpdateDtTm)
		)
	) t2_a
	GROUP BY t2_a.campusCode, t2_a.updateDtTm
) t2 ON CMP.campusCode = t2.campusCode
	AND t2.updateDtTm = DATES.auto_date

/* select appointments per campus per day of the week */
LEFT JOIN  (
	SELECT SA.campusCode
		, DATE_SUB(DATE(A.fromDtTm), INTERVAL 1 DAY) AS fromDtTm
		, COUNT(DISTINCT A.appointmentId) AS A_count

	FROM Appointments A
	INNER JOIN AppointmentPeopleReltn APR ON APR.appointmentId = A.appointmentId
	LEFT JOIN SubAdmins SA ON SA.subAdminId = APR.userId

	WHERE APR.userType IN (4, 6)
	  AND A.isActive = 1
	  AND APR.isActive = 1
	  AND DATE(A.fromDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
	  AND DATE(A.fromDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 8) DAY)

	GROUP BY SA.campusCode, DATE(A.fromDtTm)
) t3 ON t3.campusCode = CMP.campusCode
	AND t3.fromDtTm = DATES.auto_date

WHERE CMP.isActive = 1
  AND CMP.campusName <> 'Ft Lauderdale Beach'
GROUP BY CMP.campusName )

/***** weekly totals overall *****/
UNION
(SELECT '~ <strong>All Campuses</strong> ~'
	, '<strong>Weekly Total</strong>' AS 'Date'
	, CONCAT('<strong>', COALESCE(SUM(t1.C_count), 0), '</strong>') AS 'Leads'
    , CONCAT('<strong>', COALESCE(SUM(t2.I_count), 0), '</strong>') AS 'Interviewed'
    , CONCAT('<strong>', COALESCE(SUM(t2.E_count), 0), '</strong>') AS 'Enrolled'
    , CONCAT('<strong>', COALESCE(SUM(t3.A_count), 0), '</strong>') AS 'Appointments Tomorrow'

FROM Campuses CMP

/* expand campuses*each_day of the six days in the flash report */
LEFT JOIN (
	SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AS auto_date, 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY), 1 AS active
	UNION SELECT DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY), 1 AS active
    UNION SELECT null, 1 AS active
	) DATES ON DATES.active = CMP.isActive

/* select newly added leads per campus and date */
LEFT JOIN (
	SELECT C.campusCode
		, DATE(C.creationDtTm) AS creationDtTm
		, COUNT(DISTINCT C.contactId) AS C_count
	FROM Contacts C
	INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
	WHERE DATE(C.creationDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	  AND DATE(C.creationDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
	  AND C.isActive = 1
	  AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
	GROUP BY C.campusCode, DATE(C.creationDtTm)
) t1 ON t1.campusCode = CMP.campusCode
	AND t1.creationDtTm = DATES.auto_date

/* select leads who were interviewed/enrolled on each campus on each day of the week */
LEFT JOIN (
	SELECT t2_a.campusCode
		, t2_a.updateDtTm
		, COUNT(DISTINCT t2_a.I) AS I_count
		, COUNT(DISTINCT t2_a.E) AS E_count
	FROM (
		(SELECT C.campusCode
			, CONCAT(C.firstName, C.lastName) AS 'I'
			, NULL AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '6. Interviewed'
		  AND DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, DATE(U.updateDtTm))
		UNION
		(SELECT C.campusCode
			, NULL
			, CONCAT(C.firstName, C.lastName) AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '8. Enrolled'
		  AND DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, DATE(U.updateDtTm))
		UNION
		(SELECT C.campusCode
			, IF(CT.typeName = '6. Interviewed', CONCAT(C.firstName, C.lastName), NULL) AS 'I'
			, IF(CT.typeName = '8. Enrolled', CONCAT(C.firstName, C.lastName), NULL) AS 'E'
			, DATE(C.lastUpdateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId

		WHERE CT.typeName IN ('6. Interviewed', '8. Enrolled')
		  AND DATE(C.lastUpdateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
		  AND DATE(C.lastUpdateDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
		GROUP BY C.firstName, C.lastName, DATE(C.lastUpdateDtTm)
		)
	) t2_a
	GROUP BY t2_a.campusCode, t2_a.updateDtTm
) t2 ON CMP.campusCode = t2.campusCode
	AND t2.updateDtTm = DATES.auto_date

/* select appointments per campus per day of the week */
LEFT JOIN  (
	SELECT SA.campusCode
		, DATE_SUB(DATE(A.fromDtTm), INTERVAL 1 DAY) AS fromDtTm
		, COUNT(DISTINCT A.appointmentId) AS A_count

	FROM Appointments A
	INNER JOIN AppointmentPeopleReltn APR ON APR.appointmentId = A.appointmentId
	LEFT JOIN SubAdmins SA ON SA.subAdminId = APR.userId

	WHERE APR.userType IN (4, 6)
	  AND A.isActive = 1
	  AND APR.isActive = 1
	  AND DATE(A.fromDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
	  AND DATE(A.fromDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 8) DAY)

	GROUP BY SA.campusCode, DATE(A.fromDtTm)
) t3 ON t3.campusCode = CMP.campusCode
	AND t3.fromDtTm = DATES.auto_date

WHERE CMP.isActive = 1
  AND CMP.campusName <> 'Ft Lauderdale Beach' )

ORDER BY campusName, date
