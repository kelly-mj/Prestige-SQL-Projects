-- ADMIN Widget: New Leads in the Current Month
-- Kelly MJ  |  10/28/2018

SELECT t1.name 'Contact Name'
	, t1.type 'Stage'
	, t1.program 'Program of Interest'
	, t1.lastUpdate 'Last Updated'
FROM (
	SELECT CT.typeName AS type
		, PFV.fieldValue AS program
		, CONCAT('<a target="_blank" href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '"">', C.firstName, ' ', C.lastName, '</a>') AS name
		, DATE(C.lastUpdateDtTm) AS lastUpdate

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.fieldName = 'PROGRAM'

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))

	GROUP BY C.contactId
	ORDER BY lastUpdate ASC) t1