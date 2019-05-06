-- [SHELL] ALL Admissions Widget
-- Kelly MJ  |  5/3/2019
-- NOTE: Each school has its own description of contact types; for this widget to be accurate, the contactTypes list in each part of the query must be updated

/*
 *  Active Leads
 */
 SELECT CONCAT('<strong>Active Leads in '
	 			, IF((NOT EXISTS (SELECT subAdminId
			    					FROM SubAdmins
			    					WHERE subAdminId = [USERID]
			    					AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0) )
					 AND [USERID] <> 48)
						, CMP.fieldValue
						, 'All Campuses')
				, '</strong>') AS 'Type'
 	, COUNT(C.contactId) AS 'Count'

 FROM Contacts C
 INNER JOIN ContactTypes CT
 		ON CT.contactTypeId = C.contactTypeId
 		AND CT.contactTypeId IN (
 			SELECT contactTypeId FROM ContactTypes WHERE typeName IN (
 				  '1. New Leads'
 				, '2. Left Message'
 				, '3. Mailed Catalog'
 				, '4. Appointment Scheduled'
 				, '5. Working'
 				, '6. Nuturing'
 				, '7. In-Financial'
 				, '8. GAIN'
 				, '9. Future Attend Date'
 			)
 		)

 LEFT JOIN ProfileFieldValues CMP
 	ON CMP.userId = C.contactId
 	AND CMP.fieldName = 'CAMPUS'

 WHERE IF ((NOT EXISTS (SELECT subAdminId
 					FROM SubAdmins
 					WHERE subAdminId = [USERID]
 					AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
	 		AND [USERID] <> 48)
 		, CMP.fieldValue = ( SELECT CP.campusName
 							 FROM Campuses CP
 							 WHERE CP.campusName = CMP.fieldValue
 							 AND EXISTS (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = CP.campusCode) )
     	, CMP.fieldValue <> 'delicious_kielbasa_sausage' )

 AND C.<ADMINID>


/*
 *  Leads from current month
 */
UNION
SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
				, (SELECT CAST(Q.queryId AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Leads from Current Month')
				,'">Leads added in ', DATE_FORMAT(CURDATE(), '%M'), ' (link):</a>')
	, COUNT(C.contactId)
FROM Contacts C
INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.typeName IN (
			  '1. New Leads'
			, '2. Left Message'
			, '3. Mailed Catalog'
			, '4. Appointment Scheduled'
			, '5. Working'
			, '6. Nuturing'
			, '7. In-Financial'
			, '8. GAIN'
			, '9. Future Attend Date' )
LEFT JOIN ProfileFieldValues CMP
	ON CMP.userId = C.contactId
	AND CMP.fieldName = 'CAMPUS'
WHERE DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
	AND IF (NOT EXISTS (SELECT subAdminId
    					FROM SubAdmins
    					WHERE subAdminId = [USERID]
    					AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
			AND [USERID] <> 48
    		, CMP.fieldValue = ( SELECT CP.campusName
    							 FROM Campuses CP
    							 WHERE CP.campusName = CMP.fieldValue
    							 AND EXISTS (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = CP.campusCode) )
        	, CMP.fieldValue <> 'delicious_kielbasa_sausage' )
	AND C.<ADMINID>


/*
 *  Leads won/lost in current month
 */
UNION
SELECT CONCAT('Leads <strong><span style="color: green;">won</span>/<span style="color: red;">lost</span></strong> in ', DATE_FORMAT(CURDATE(), '%M'), ': ')
	, CONCAT('<strong><span style="color: green;">Won: ', COALESCE(SUM(t1.wonLost = 'WON'), 0), '  </span>/  <span style="color: red;">Lost: ', COALESCE(SUM(t1.wonLost = 'LOST'), 0), '</span></strong>')
FROM (
	SELECT (contactId), 'WON' AS wonLost
	FROM Contacts C
	WHERE C.contactTypeId IN ( SELECT contactTypeId
							   FROM ContactTypes
							   WHERE typeName IN ('Enrolled Student') )
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
		AND C.isActive = 1
		AND C.<ADMINID>
	UNION
	SELECT (contactId), 'LOST' AS wonLost
	FROM Contacts C
	WHERE C.contactTypeId IN ( SELECT contactTypeId
							   FROM ContactTypes
							   WHERE typeName IN ('86. Lost - Not Interested') )
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
		AND C.isActive = 1
		AND C.<ADMINID>
		  ) t1
LEFT JOIN ProfileFieldValues CMP
	ON CMP.userId = t1.contactId
	AND CMP.fieldName = 'CAMPUS'
WHERE IF (NOT EXISTS (SELECT subAdminId
					FROM SubAdmins
					WHERE subAdminId = [USERID]
					AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
		  AND [USERID] <> 48
		, CMP.fieldValue = ( SELECT CP.campusName
							 FROM Campuses CP
							 WHERE CP.campusName = CMP.fieldValue
							 AND EXISTS (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = CP.campusCode) )
		, CMP.fieldValue <> 'delicious_kielbasa_sausage' )



/*
 *  Leads from Previous Month
 */
UNION
SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
				, (SELECT CAST(Q.queryId AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Leads from Previous Month')
				,'">Leads added in ', DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%M'), ' (link):</a>')
	, COUNT(C.contactId)
FROM Contacts C
INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.typeName IN (
			  '1. New Leads'
			, '2. Left Message'
			, '3. Mailed Catalog'
			, '4. Appointment Scheduled'
			, '5. Working'
			, '6. Nuturing'
			, '7. In-Financial'
			, '8. GAIN'
			, '9. Future Attend Date' )
LEFT JOIN ProfileFieldValues CMP
	ON CMP.userId = C.contactId
	AND CMP.fieldName = 'CAMPUS'
WHERE DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
	AND DATE(C.creationDtTm) < LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))      AND C.<ADMINID>
	AND IF (NOT EXISTS (SELECT subAdminId
						FROM SubAdmins
						WHERE subAdminId = [USERID]
						AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
			AND [USERID] <> 48
			, CMP.fieldValue = ( SELECT CP.campusName
								 FROM Campuses CP
								 WHERE CP.campusName = CMP.fieldValue
								 AND EXISTS (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = CP.campusCode) )
			, CMP.fieldValue <> 'delicious_kielbasa_sausage' )
	AND C.<ADMINID>


/*
 *  Leads from Two Months Ago
 */
UNION
SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
				, (SELECT CAST(Q.queryId AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Leads from Two Months Ago')
				,'">Leads added in ', DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%M'), ' (link):</a>')
	, COUNT(C.contactId)
FROM Contacts C
INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.typeName IN (
			  '1. New Leads'
			, '2. Left Message'
			, '3. Mailed Catalog'
			, '4. Appointment Scheduled'
			, '5. Working'
			, '6. Nuturing'
			, '7. In-Financial'
			, '8. GAIN'
			, '9. Future Attend Date' )
LEFT JOIN ProfileFieldValues CMP
	ON CMP.userId = C.contactId
	AND CMP.fieldName = 'CAMPUS'
WHERE DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH))
	AND DATE(C.creationDtTm) < LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
	AND IF (NOT EXISTS (SELECT subAdminId
						FROM SubAdmins
						WHERE subAdminId = [USERID]
						AND (subAdminTypeId IN (32, 35, 34) OR campusCode = 0))
			AND [USERID] <> 48
			, CMP.fieldValue = ( SELECT CP.campusName
								 FROM Campuses CP
								 WHERE CP.campusName = CMP.fieldValue
								 AND EXISTS (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] AND campusCode = CP.campusCode) )
			, CMP.fieldValue <> 'delicious_kielbasa_sausage' )
	AND C.<ADMINID>


UNION	-- Link to leads per stage
SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
				, (SELECT CAST(Q.queryId AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Leads per Stage')
				,'">Leads per Stage (link)</a>')
	, NULL
