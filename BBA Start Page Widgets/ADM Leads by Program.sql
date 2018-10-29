-- ADM Leads per Program Widget
-- Kelly MJ  |  10/28/2018

SELECT t1.program 'Program of Interest'
	, t1.count 'Number of Students'
FROM (
	SELECT CT.typeName AS type
		, PFV.fieldValue AS program
		, COUNT(DISTINCT C.contactId) AS count

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.fieldName = 'PROGRAM_OF_INTEREST'

	WHERE C.isActive = 1
		AND C.<ADMINID>

	GROUP BY program
	ORDER BY program ASC) t1