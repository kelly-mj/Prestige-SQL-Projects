-- ADMIN Widget: Leads per Stage
-- Kelly MJ  |  10/28/2018

SELECT t1.Type, t1.Count
FROM (
	SELECT CT.typeName AS Type
		, COUNT(C.contactId) AS Count

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	WHERE C.isActive = 1
		AND C.<ADMINID>

	GROUP BY CT.typeName) t1