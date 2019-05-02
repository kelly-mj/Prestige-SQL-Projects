-- Query Reportt: Leads from Two Months Ago
-- Kelly MJ  |  09/10/2018
-- 9/24/18 Kelly MJ: Changed from past week to current month timeframe

SELECT COALESCE(t1.PFVCampus, (SELECT campusName FROM Campuses WHERE campusCode = t1.Campus)) AS Campus
	, t1.name 'Contact Name'
	, t1.type 'Stage'
	, t1.program 'Program of Interest'
	, DATE_FORMAT(t1.lastUpdate, '%m/%d/%Y') 'Last Updated'

FROM (
	SELECT CT.typeName AS type
		, PFV.fieldValue AS program
		, CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '"">', C.firstName, ' ', C.lastName, '</a>') AS name
		, DATE(C.lastUpdateDtTm) AS lastUpdate
		, C.campusCode AS Campus
		, CMP.PFVCampus

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
		)   --	(4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)  -- previously used contactTypeIds

	LEFT JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.fieldName = 'PROGRAM_OF_INTEREST'

	LEFT JOIN (
		SELECT userId, fieldValue AS PFVCampus
		FROM ProfileFieldValues
		WHERE fieldName = 'CAMPUS' AND isActive = 1) CMP
		ON CMP.userId = C.contactId

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 3 MONTH))
		AND DATE(C.creationDtTm) < LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
		AND IF('[?Campus Select (leave blank to select all)]' = ''
		    , C.campusCode LIKE '%'
		    , ((C.campusCode = '[?Campus Select (leave blank to select all)]') OR
		       (C.campusCode = (SELECT MAX(campusCode) FROM Campuses WHERE LOWER(campusName) = LOWER('[?Campus Select (leave blank to select all)]')) ) OR
			   (LOWER(CMP.PFVCampus) = LOWER('[?Campus Select (leave blank to select all)]'))  /*end condition 2*/)  /*end IF*/)

	GROUP BY C.contactId
) t1

ORDER BY Campus, type, lastUpdate
