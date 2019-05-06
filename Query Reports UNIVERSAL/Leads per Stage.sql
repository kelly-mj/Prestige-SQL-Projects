-- [SHELL] Leads per Stage
-- Kelly MJ  |  04/26/2019
-- NOTE: Each school has its own description of contact types; for this report to be accurate, the contactTypes list in each part of the query must be updated

SELECT t1.type AS Stage
	, COUNT(t1.contactId) AS 'Count'

FROM (
	SELECT CT.typeName AS type
		, C.contactId

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
				, '86. Lost - Not Interested'
				, '9. Future Attend Date'
		)

	LEFT JOIN (
		SELECT userId, fieldValue AS PFVCampus
		FROM ProfileFieldValues
		WHERE fieldName = 'CAMPUS' AND isActive = 1) CMP
		ON CMP.userId = C.contactId

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND IF('[?Campus Select (leave blank to select all)]' = ''
		    , C.campusCode LIKE '%'
		    , ((CMP.PFVCampus = (SELECT MAX(campusName) FROM Campuses WHERE campusCode = '[?Campus Select (leave blank to select all)]')) OR
			   (LOWER(CMP.PFVCampus) = LOWER('[?Campus Select (leave blank to select all)]'))  /*end condition 2*/)  /*end IF*/)
) t1

GROUP BY Stage

ORDER BY Stage
