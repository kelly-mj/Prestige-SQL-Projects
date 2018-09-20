-- ADMIN Widget: Lead Type Counts
-- Kelly MJ  |  09/10/2018 WITH HEADERS

-- New Port Richey
SELECT NULL AS 'Lead Type'
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">New Port Richey</td><td></td></tr>' AS 'Count'

UNION
SELECT t1.Type, t1.Count
FROM (
	SELECT SA.campusCode AS Campus
		, CT.typeName AS Type
		, COUNT(C.contactId) AS Count

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN SubAdmins SA
		ON SA.subAdminId = C.subAdminId

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND C.subAdminId NOT IN (SELECT subAdminId FROM SubAdmins WHERE campusCode IN (34601, 34606))

	GROUP BY CT.typeName) t1

UNION	-- Spring Hill
SELECT NULL AS 'Lead Type'
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Spring Hill</td><td></td></tr>' AS 'Count'

UNION 
SELECT t2.Type, t2.Count
FROM (
	SELECT SA.campusCode AS Campus
		, CT.typeName AS Type
		, COUNT(C.contactId) AS Count

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN SubAdmins SA
		ON SA.subAdminId = C.subAdminId

	WHERE C.isActive = 1
		AND C.<ADMINID>

	GROUP BY Campus, CT.typeName) t2
WHERE t2.Campus = 34606

UNION	-- Brookesville
SELECT NULL AS 'Lead Type'
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Brookesville</td><td></td></tr>' AS 'Count'

UNION
SELECT t3.Type, t3.Count
FROM (
	SELECT SA.campusCode AS Campus
		, CT.typeName AS Type
		, COUNT(C.contactId) AS Count

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN SubAdmins SA
		ON SA.subAdminId = C.subAdminId

	WHERE C.isActive = 1
		AND C.<ADMINID>

	GROUP BY Campus, CT.typeName) t3
WHERE t3.Campus = 34601