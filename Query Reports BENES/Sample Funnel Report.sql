-- [BENES] Sample Funnel Report
-- Kelly MJ  |  06/26/2018

SELECT NULL AS 'State'
	, NULL AS 'Campus Code'
    , NULL AS 'Campus Name'
	, '2. Left Message' AS 'Monday'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
    , '2. Left Message' AS 'Tuesday'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
    , '2. Left Message' AS 'Wednesday'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
    , '2. Left Message' AS 'Thursday'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
    , '2. Left Message' AS 'Friday'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
    , '2. Left Message' AS 'Saturday'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
	, '2. Left Message' AS 'Weekly Total'
    , '5. Working' AS '.'
    , '6. Nurturing' AS '.'
	, 'Working to Left Message' AS '.'
	, 'Nurturing to Left Message' AS '.'
FROM Campuses CMP WHERE CMP.<ADMINID> LIMIT 1

UNION
SELECT CMP.physicalState AS 'State'
	, CMP.campusCode AS 'Campus #'
    , CMP.campusName AS 'Campus Name'
    , COALESCE(MON.leads, 0)
    , COALESCE(MON.intr, 0)
    , COALESCE(MON.enr, 0)
    , COALESCE(TUES.leads, 0)
    , COALESCE(TUES.intr, 0)
    , COALESCE(TUES.enr, 0)
    , COALESCE(WED.leads, 0)
    , COALESCE(WED.intr, 0)
    , COALESCE(WED.enr, 0)
    , COALESCE(THUR.leads, 0)
    , COALESCE(THUR.intr, 0)
    , COALESCE(THUR.enr, 0)
    , COALESCE(FRI.leads, 0)
    , COALESCE(FRI.intr, 0)
    , COALESCE(FRI.enr, 0)
    , COALESCE(SAT.leads, 0)
    , COALESCE(SAT.intr, 0)
    , COALESCE(SAT.enr, 0)
	, COALESCE(TOTAL.leads, 0)
    , COALESCE(TOTAL.intr, 0)
    , COALESCE(TOTAL.enr, 0)
	, CONCAT(FORMAT(COALESCE(TOTAL.intr/TOTAL.leads*100, 0), 2), '%')
    , CONCAT(FORMAT(COALESCE(TOTAL.enr /TOTAL.leads*100, 0), 2), '%')

FROM Campuses CMP
LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 2
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) MON
    ON MON.campus = CMP.campusName

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 3
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) TUES
    ON TUES.campus = CMP.campusName

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 4
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) WED
    ON WED.campus = CMP.campusName

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 5
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) THUR
    ON THUR.campus = CMP.campusName

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 6
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) FRI
    ON FRI.campus = CMP.campusName

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 7
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) SAT
    ON SAT.campus = CMP.campusName

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , (SELECT MAX(fieldValue) FROM ProfileFieldValues WHERE userId = contactId AND fieldName = 'CAMPUS') AS campus
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]'
    GROUP BY campus) TOTAL
    ON TOTAL.campus = CMP.campusName

WHERE CMP.campusName NOT IN ('Test Campus')
AND CMP.campusCode IN (34606, 34601, 34652)
GROUP BY CMP.campusId

UNION
SELECT NULL, NULL, 'School Totals'
	, COALESCE(MON.leads, 0)
    , COALESCE(MON.intr, 0)
    , COALESCE(MON.enr, 0)
    , COALESCE(TUES.leads, 0)
    , COALESCE(TUES.intr, 0)
    , COALESCE(TUES.enr, 0)
    , COALESCE(WED.leads, 0)
    , COALESCE(WED.intr, 0)
    , COALESCE(WED.enr, 0)
    , COALESCE(THUR.leads, 0)
    , COALESCE(THUR.intr, 0)
    , COALESCE(THUR.enr, 0)
    , COALESCE(FRI.leads, 0)
    , COALESCE(FRI.intr, 0)
    , COALESCE(FRI.enr, 0)
    , COALESCE(SAT.leads, 0)
    , COALESCE(SAT.intr, 0)
    , COALESCE(SAT.enr, 0)
	, COALESCE(TOTAL.leads, 0)
    , COALESCE(TOTAL.intr, 0)
    , COALESCE(TOTAL.enr, 0)
	, CONCAT(FORMAT(COALESCE(TOTAL.intr/TOTAL.leads*100, 0), 2), '%')
    , CONCAT(FORMAT(COALESCE(TOTAL.enr /TOTAL.leads*100, 0), 2), '%')

FROM (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 2
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]' ) MON

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 3
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]' ) TUES
    ON TUES.joinCode = MON.joinCode

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 4
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]' ) WED
    ON WED.joinCode = MON.joinCode

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 5
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]' ) THUR
    ON THUR.joinCode = MON.joinCode

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 6
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
 	AND C.lastUpdateDtTm <= '[?Run Date]') FRI
    ON FRI.joinCode = MON.joinCode

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE DAYOFWEEK(C.lastUpdateDtTm) = 7
	AND C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]' ) SAT
    ON SAT.joinCode = MON.joinCode

LEFT JOIN (
	SELECT COUNT(CASE WHEN CT.typeName = '2. Left Message' THEN 1 END) AS leads
		, COUNT(CASE WHEN CT.typeName = '5. Working' THEN 1 END) AS intr
        , COUNT(CASE WHEN CT.typeName = '6. Nuturing' THEN 1 END) AS enr
        , 'join' AS joinCode
	FROM Contacts C
    INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    WHERE C.lastUpdateDtTm >= DATE_SUB('[?Run Date]', INTERVAL (DAYOFWEEK('[?Run Date]') - 2) DAY)
	AND C.lastUpdateDtTm <= '[?Run Date]' ) TOTAL
    ON TOTAL.joinCode = MON.joinCode
