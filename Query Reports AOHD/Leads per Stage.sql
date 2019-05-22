-- [AOHD] Leads per Stage
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
