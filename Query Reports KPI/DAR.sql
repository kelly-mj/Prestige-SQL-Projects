-- Flash Report: Attempt 4

SELECT CMP.campusName
	, DATES.auto_date
    , t2.I_count
    , t2.E_count

FROM Campuses CMP
LEFT JOIN (
	SELECT DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 2) DAY) AS auto_date, 1 AS active
	UNION SELECT DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 3) DAY), 1 AS active
	UNION SELECT DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 4) DAY), 1 AS active
	UNION SELECT DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 5) DAY), 1 AS active
	UNION SELECT DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 6) DAY), 1 AS active
	UNION SELECT DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 7) DAY), 1 AS active
    UNION SELECT null, 1 AS active
	) DATES ON DATES.active = CMP.isActive
LEFT JOIN (
	SELECT t1.campusCode
		, t1.updateDtTm
		, COUNT(DISTINCT t1.I) AS I_count
		, COUNT(DISTINCT t1.E) AS E_count
	FROM (
		(SELECT C.campusCode
			, CONCAT(C.firstName, C.lastName) AS 'I'
			, NULL AS 'E'
			, DATE(U.updateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN UserStatusRecords U ON C.contactId = U.toUserId
		INNER JOIN ContactTypes CT ON CT.contactTypeId = U.status

		WHERE CT.typeName = '6. Interviewed'
		  AND DATE(U.updateDtTm) >= DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 7) DAY)
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
		  AND DATE(U.updateDtTm) >= DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 2) DAY)
		  AND DATE(U.updateDtTm) <= DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 7) DAY)
		  #AND U.<ADMINID>

		GROUP BY C.firstName, C.lastName, U.updateDtTm)
		UNION
		(SELECT C.campusCode
			, IF(CT.typeName = '6. Interviewed', CONCAT(C.firstName, C.lastName), NULL) AS 'I'
			, IF(CT.typeName = '8. Enrolled', CONCAT(C.firstName, C.lastName), NULL) AS 'E'
			, DATE(C.lastUpdateDtTm) AS updateDtTm

		FROM Contacts C
		INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId

		WHERE CT.typeName IN ('6. Interviewed', '8. Enrolled')
		  AND DATE(C.lastUpdateDtTm) >= DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 2) DAY)
		  AND DATE(C.lastUpdateDtTm) <= DATE_SUB('2019-07-29', INTERVAL (DAYOFWEEK('2019-07-29') - 7) DAY)
		GROUP BY C.firstName, C.lastName, DATE(C.lastUpdateDtTm)
		)
	) t1
	GROUP BY t1.campusCode, t1.updateDtTm
) t2 ON CMP.campusCode = t2.campusCode
	AND t2.updateDtTm = DATES.auto_date

WHERE CMP.isActive = 1
ORDER BY CMP.campusName, DATES.auto_date
