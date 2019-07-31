-- [BENES] Sample Funnel Report
-- Kelly MJ  |  06/26/2018

(SELECT NULL AS 'State'
	, NULL AS 'Campus Code'
    , NULL AS 'Campus Name'
	, 'Leads' AS 'Monday'
    , 'Int' AS '.'
    , 'Enr' AS '.'
    , 'Leads' AS 'tuesday'
    , 'Int' AS '.'
    , 'Enr' AS '.'
    , 'Leads' AS 'wednesday'
    , 'Int' AS '.'
    , 'Enr' AS '.'
    , 'Leads' AS 'thursday'
    , 'Int' AS '.'
    , 'Enr' AS '.'
    , 'Leads' AS 'friday'
    , 'Int' AS '.'
    , 'Enr' AS '.'
    , 'Leads' AS 'saturday'
    , 'Int' AS '.'
    , 'Enr' AS '.'
	, 'Leads' AS 'Weekly Total'
    , 'Int' AS '.'
    , 'Enr' AS '.'
	, 'Lead to Int' AS '.'
	, 'Lead to Enrol' AS '.'
FROM Campuses CMP LIMIT 1)

UNION (
SELECT CMP.physicalState AS 'State'
	, CMP.campusCode AS 'Campus #'
    , CMP.campusName AS 'Campus Name'
    , COALESCE(t1.mon_l, 0)
    , COALESCE(t1.mon_i, 0)
    , COALESCE(t1.mon_e, 0)
    , COALESCE(t1.tues_l, 0)
    , COALESCE(t1.tues_i, 0)
    , COALESCE(t1.tues_e, 0)
    , COALESCE(t1.wed_l, 0)
    , COALESCE(t1.wed_i, 0)
    , COALESCE(t1.wed_e, 0)
    , COALESCE(t1.thur_l, 0)
    , COALESCE(t1.thur_i, 0)
    , COALESCE(t1.thur_e, 0)
    , COALESCE(t1.fri_l, 0)
    , COALESCE(t1.fri_i, 0)
    , COALESCE(t1.fri_e, 0)
    , COALESCE(t1.sat_l, 0)
    , COALESCE(t1.sat_i, 0)
    , COALESCE(t1.sat_e, 0)
	, COALESCE(t1.mon_l+t1.tues_l+t1.wed_l+t1.thur_l+t1.fri_l+t1.sat_l, 0)
    , COALESCE(t1.mon_i+t1.tues_i+t1.wed_i+t1.thur_i+t1.fri_i+t1.sat_i, 0)
    , COALESCE(t1.mon_e+t1.tues_e+t1.wed_e+t1.thur_e+t1.fri_e+t1.sat_e, 0)
	, CONCAT(FORMAT(COALESCE(100*(t1.mon_i+t1.tues_i+t1.wed_i+t1.thur_i+t1.fri_i+t1.sat_i)/(t1.mon_l+t1.tues_l+t1.wed_l+t1.thur_l+t1.fri_l+t1.sat_l), 0), 2), '%')
    , CONCAT(FORMAT(COALESCE(100*(t1.mon_e+t1.tues_e+t1.wed_e+t1.thur_e+t1.fri_e+t1.sat_e)/(t1.mon_l+t1.tues_l+t1.wed_l+t1.thur_l+t1.fri_l+t1.sat_l), 0), 2), '%')

FROM Campuses CMP
LEFT JOIN (
	SELECT C.campusCode
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY), C.contactId, NULL)) AS mon_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
					, C.contactId, NULL)) AS mon_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
					, C.contactId, NULL)) AS mon_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY), C.contactId, NULL)) AS tues_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
					, C.contactId, NULL)) AS tues_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
					, C.contactId, NULL)) AS tues_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY), C.contactId, NULL)) AS wed_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY)
					, C.contactId, NULL)) AS wed_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY)
					, C.contactId, NULL)) AS wed_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY), C.contactId, NULL)) AS thur_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY)
					, C.contactId, NULL)) AS thur_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY)
					, C.contactId, NULL)) AS thur_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY), C.contactId, NULL)) AS fri_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY)
					, C.contactId, NULL)) AS fri_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY)
					, C.contactId, NULL)) AS fri_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY), C.contactId, NULL)) AS sat_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
					, C.contactId, NULL)) AS sat_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
					, C.contactId, NULL)) AS sat_e
	FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
	LEFT JOIN (SELECT toUserId, DATE(U.updateDtTm) AS updateDt
		FROM UserStatusRecords U
		WHERE DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 1) DAY)
		  AND U.status = (SELECT contactTypeId FROM ContactTypes WHERE typeName = '6. Interviewed')
		GROUP BY U.toUserId, U.updateDtTm) I
		ON I.toUserId = C.contactId
	LEFT JOIN (SELECT toUserId, DATE(U.updateDtTm) AS updateDt
		FROM UserStatusRecords U
		WHERE DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 1) DAY)
		  AND U.status = (SELECT contactTypeId FROM ContactTypes WHERE typeName = '8. Enrolled')
		GROUP BY U.toUserId) E
		ON E.toUserId = C.contactId
	WHERE C.isActive = 1
    GROUP BY C.campusCode) t1
    ON t1.campusCode = CMP.campusCode  /* <ADMINID */

WHERE CMP.isActive = 1
AND CMP.<ADMINID>)

UNION (
SELECT NULL, NULL, 'School Totals'
	, COALESCE(t1.mon_l, 0)
	, COALESCE(t1.mon_i, 0)
	, COALESCE(t1.mon_e, 0)
	, COALESCE(t1.tues_l, 0)
	, COALESCE(t1.tues_i, 0)
	, COALESCE(t1.tues_e, 0)
	, COALESCE(t1.wed_l, 0)
	, COALESCE(t1.wed_i, 0)
	, COALESCE(t1.wed_e, 0)
	, COALESCE(t1.thur_l, 0)
	, COALESCE(t1.thur_i, 0)
	, COALESCE(t1.thur_e, 0)
	, COALESCE(t1.fri_l, 0)
	, COALESCE(t1.fri_i, 0)
	, COALESCE(t1.fri_e, 0)
	, COALESCE(t1.sat_l, 0)
	, COALESCE(t1.sat_i, 0)
	, COALESCE(t1.sat_e, 0)
	, COALESCE(t1.mon_l+t1.tues_l+t1.wed_l+t1.thur_l+t1.fri_l+t1.sat_l, 0)
	, COALESCE(t1.mon_i+t1.tues_i+t1.wed_i+t1.thur_i+t1.fri_i+t1.sat_i, 0)
	, COALESCE(t1.mon_e+t1.tues_e+t1.wed_e+t1.thur_e+t1.fri_e+t1.sat_e, 0)
	, CONCAT(FORMAT(COALESCE(100*(t1.mon_i+t1.tues_i+t1.wed_i+t1.thur_i+t1.fri_i+t1.sat_i)/(t1.mon_l+t1.tues_l+t1.wed_l+t1.thur_l+t1.fri_l+t1.sat_l), 0), 2), '%')
	, CONCAT(FORMAT(COALESCE(100*(t1.mon_e+t1.tues_e+t1.wed_e+t1.thur_e+t1.fri_e+t1.sat_e)/(t1.mon_l+t1.tues_l+t1.wed_l+t1.thur_l+t1.fri_l+t1.sat_l), 0), 2), '%')

FROM (
	SELECT COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY), C.contactId, NULL)) AS mon_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
					, C.contactId, NULL)) AS mon_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
					, C.contactId, NULL)) AS mon_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY), C.contactId, NULL)) AS tues_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
					, C.contactId, NULL)) AS tues_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 3) DAY)
					, C.contactId, NULL)) AS tues_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY), C.contactId, NULL)) AS wed_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY)
					, C.contactId, NULL)) AS wed_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 4) DAY)
					, C.contactId, NULL)) AS wed_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY), C.contactId, NULL)) AS thur_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY)
					, C.contactId, NULL)) AS thur_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 5) DAY)
					, C.contactId, NULL)) AS thur_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY), C.contactId, NULL)) AS fri_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY)
					, C.contactId, NULL)) AS fri_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 6) DAY)
					, C.contactId, NULL)) AS fri_e
		, COUNT(DISTINCT IF(DATE(C.creationDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY), C.contactId, NULL)) AS sat_l
		, COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY) AND CT.typeName = '6. Interviewed')
					OR I.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
					, C.contactId, NULL)) AS sat_i
        , COUNT(DISTINCT IF((DATE(C.lastUpdateDtTm) = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY) AND CT.typeName = '8. Enrolled')
					OR E.updateDt = DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 7) DAY)
					, C.contactId, NULL)) AS sat_e
	FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
	LEFT JOIN (SELECT toUserId, DATE(U.updateDtTm) AS updateDt
		FROM UserStatusRecords U
		WHERE DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 1) DAY)
		  AND U.status = (SELECT contactTypeId FROM ContactTypes WHERE typeName = '6. Interviewed')
		GROUP BY U.toUserId, U.updateDtTm) I
		ON I.toUserId = C.contactId
	LEFT JOIN (SELECT toUserId, DATE(U.updateDtTm) AS updateDt
		FROM UserStatusRecords U
		WHERE DATE(U.updateDtTm) >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 1) DAY)
		  AND U.status = (SELECT contactTypeId FROM ContactTypes WHERE typeName = '8. Enrolled')
		GROUP BY U.toUserId) E
		ON E.toUserId = C.contactId
	WHERE C.isActive = 1) t1
)
