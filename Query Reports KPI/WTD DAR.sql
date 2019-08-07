-- WTD DAR

/***********************
 *      Date Range     *
 ***********************/
(SELECT '<strong>Date Range: </strong>' Campus
    , CONCAT('<strong>', DATE_FORMAT(DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY), '%m/%d/%Y'), ' -</br>', DATE_FORMAT(DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY), '%m/%d/%Y'), '</strong>') AS 'Leads'
    , NULL AS 'Interviewed'
    , NULL AS 'Enrolled'
    , NULL AS 'Referrals'
    , NULL AS 'Lead to Int'
    , NULL AS 'Int to Enroll'
    , NULL AS '% Referrals'
    , NULL AS 'Lead to Enroll')

/***********************
 *  Individual Campus  *
 ***********************/
UNION
(SELECT CMP.campusName AS Campus
	-- , CONCAT('<span style="width: 15px;">', SUBSTRING(DATE_FORMAT(DATES.auto_date, '%W'), 1, 3), DATE_FORMAT(DATES.auto_date, '</span> %m/%d/%Y')) AS 'Date'
	, CONCAT('<div style="text-align: right;">', COALESCE(t1.L_count, 0), '</div>') AS 'Leads'
    , COALESCE(t2.I_count, 0) AS 'Interviewed'
    , COALESCE(t2.E_count, 0) AS 'Enrolled'
    , COALESCE(t1.R_count, 0) AS 'Referrals'
    , CONCAT(IF(t2.I_count/t1.L_count < 0.30 OR t2.I_count/t1.L_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t2.I_count/t1.L_count), 0), 1), '%</span>') AS 'Lead to Int'
    , CONCAT(IF(t2.E_count/t2.I_count < 0.01 OR t2.E_count/t2.I_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t2.E_count/t2.I_count), 0), 1), '%</span>') AS 'Int to Enroll'
    , CONCAT(IF(t1.R_count/t1.L_count < 0.01 OR t1.R_count/t1.L_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t1.R_count/t1.L_count), 0), 1), '%</span>') AS '% Referrals'
    , CONCAT(IF(t2.E_count/t1.L_count < 0.18 OR t2.E_count/t1.L_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t2.E_count/t1.L_count), 0), 1), '%</span>') AS 'Lead to Enroll'

FROM Campuses CMP

/* select newly added leads per campus */
LEFT JOIN (
	SELECT C.campusCode
		, DATE(C.creationDtTm) AS creationDtTm
		, COUNT(DISTINCT C.contactId) AS L_count
        , COUNT(DISTINCT PFV.userId) AS R_count
	FROM Contacts C
	INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT userId
                FROM ProfileFieldValues
                WHERE isActive = 1
                  AND fieldName = 'HOW_DID_YOU_HEAR_ABOUT_US'
                  AND fieldValue = 'Friend Referral'
                GROUP BY userId
            ) PFV ON PFV.userId = C.contactId
	WHERE DATE(C.creationDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	  AND DATE(C.creationDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
	  AND C.isActive = 1
	  AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
	GROUP BY C.campusCode
) t1 ON t1.campusCode = CMP.campusCode

/* select leads who were interviewed/enrolled on each campus */
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

		GROUP BY C.firstName, C.lastName)
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

		GROUP BY C.firstName, C.lastName)
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
		GROUP BY C.firstName, C.lastName)
	) t2_a
	GROUP BY t2_a.campusCode
) t2 ON CMP.campusCode = t2.campusCode

WHERE CMP.isActive = 1
  AND CMP.campusName <> 'Ft Lauderdale Beach')

/***********************
*     Campus Totals    *
***********************/
UNION
(SELECT '~~Totals~~' AS Campus
	-- , CONCAT('<span style="width: 15px;">', SUBSTRING(DATE_FORMAT(DATES.auto_date, '%W'), 1, 3), DATE_FORMAT(DATES.auto_date, '</span> %m/%d/%Y')) AS 'Date'
	, CONCAT('<div style="text-align: right;">', COALESCE(t1.L_count, 0), '</div>') AS 'Leads'
  , COALESCE(t2.I_count, 0) AS 'Interviewed'
  , COALESCE(t2.E_count, 0) AS 'Enrolled'
  , COALESCE(t1.R_count, 0) AS 'Referrals'
  , CONCAT(IF(t2.I_count/t1.L_count < 0.30 OR t2.I_count/t1.L_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t2.I_count/t1.L_count), 0), 1), '%</span>') AS 'Lead to Int'
  , CONCAT(IF(t2.E_count/t2.I_count < 0.01 OR t2.E_count/t2.I_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t2.E_count/t2.I_count), 0), 1), '%</span>') AS 'Int to Enroll'
  , CONCAT(IF(t1.R_count/t1.L_count < 0.01 OR t1.R_count/t1.L_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t1.R_count/t1.L_count), 0), 1), '%</span>') AS '% Referrals'
  , CONCAT(IF(t2.E_count/t1.L_count < 0.18 OR t2.E_count/t1.L_count IS NULL, '<span style="color: red;">', '<span>'), FORMAT(100*COALESCE((t2.E_count/t1.L_count), 0), 1), '%</span>') AS 'Lead to Enroll'

/* select newly added leads per campus */
FROM (
	SELECT C.campusCode
		, DATE(C.creationDtTm) AS creationDtTm
		, COUNT(DISTINCT C.contactId) AS L_count
        , COUNT(DISTINCT PFV.userId) AS R_count
        , 'join' AS joinCode
	FROM Contacts C
	INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
  LEFT JOIN (SELECT userId
              FROM ProfileFieldValues
              WHERE isActive = 1
                AND fieldName = 'HOW_DID_YOU_HEAR_ABOUT_US'
                AND fieldValue = 'Friend Referral'
              GROUP BY userId
          ) PFV ON PFV.userId = C.contactId
	WHERE DATE(C.creationDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	  AND DATE(C.creationDtTm) <= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
	  AND C.isActive = 1
	  AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
) t1

/* select leads who were interviewed/enrolled on each campus */
LEFT JOIN (
	SELECT t2_a.campusCode
		, t2_a.updateDtTm
		, COUNT(DISTINCT t2_a.I) AS I_count
		, COUNT(DISTINCT t2_a.E) AS E_count
        , 'join' AS joinCode
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

		GROUP BY C.firstName, C.lastName)
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

		GROUP BY C.firstName, C.lastName)
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
		GROUP BY C.firstName, C.lastName)
	) t2_a
) t2 ON t1.joinCode = t2.joinCode)
ORDER BY Campus
