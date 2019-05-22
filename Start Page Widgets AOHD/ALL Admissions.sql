-- [AOHD] ALL Admissions Widget
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
        AND CT.typeName IN (
                '01. New Leads'
              , '02. Leads from ISIR'
              , '03. Left Message'
              , '04. Working'
              , '05. Made Appointment'
              , '06. Nurturing'
              , '07. In Process'
              , '08. Future Attend Date'
              , '09. Enrolled Student'
              , '09. Lost - Not Interested'
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
     	, CT.typeName <> 'delicious_kielbasa_sausage' )

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
                '01. New Leads'
              , '02. Leads from ISIR'
              , '03. Left Message'
              , '04. Working'
              , '05. Made Appointment'
              , '06. Nurturing'
              , '07. In Process'
              , '08. Future Attend Date'
              , '09. Enrolled Student'
              , '09. Lost - Not Interested'
            )
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
        	, CT.typeName <> 'delicious_kielbasa_sausage' )
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
							   WHERE typeName IN ('09. Enrolled Student') )
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
		AND C.isActive = 1
		AND C.<ADMINID>
	UNION
	SELECT (contactId), 'LOST' AS wonLost
	FROM Contacts C
	WHERE C.contactTypeId IN ( SELECT contactTypeId
							   FROM ContactTypes
							   WHERE typeName IN ('09. Lost - Not Interested') )
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
		, t1.contactId <> 'delicious_kielbasa_sausage' )



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
                '01. New Leads'
              , '02. Leads from ISIR'
              , '03. Left Message'
              , '04. Working'
              , '05. Made Appointment'
              , '06. Nurturing'
              , '07. In Process'
              , '08. Future Attend Date'
              , '09. Enrolled Student'
              , '09. Lost - Not Interested'
            )
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
			, CT.typeName <> 'delicious_kielbasa_sausage' )
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
				'01. New Leads'
			  , '02. Leads from ISIR'
			  , '03. Left Message'
			  , '04. Working'
			  , '05. Made Appointment'
			  , '06. Nurturing'
			  , '07. In Process'
			  , '08. Future Attend Date'
			  , '09. Enrolled Student'
			  , '09. Lost - Not Interested'
			)
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
			, CT.typeName <> 'delicious_kielbasa_sausage' )
	AND C.<ADMINID>


UNION	-- Link to leads per stage
SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid='
				, (SELECT CAST(Q.queryId AS CHAR) FROM Queries Q WHERE Q.queryTitle = 'Leads per Stage')
				,'">Leads per Stage (link)</a>')
	, NULL
