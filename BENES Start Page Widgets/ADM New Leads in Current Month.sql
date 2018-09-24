-- ADMIN Widget: New Leads in the Past Week
-- Kelly MJ  |  09/10/2018

-- New Port Richey
SELECT NULL 'Contact Name', NULL 'Stage', NULL 'Program of Interest'
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">New Port Richey</td><td></td><td></td><td></td></tr>' AS 'Last Updated'

UNION
SELECT t1.name 'Contact Name'
	, t1.type 'Stage'
	, t1.program 'Program of Interest'
	, t1.lastUpdate 'Last Updated'
FROM (
	SELECT SA.campusCode AS campus
		, CT.typeName AS type
		, PFV.fieldValue AS program
		, CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '"">', C.firstName, ' ', C.lastName, '</a>') AS name
		, DATE(C.lastUpdateDtTm) AS lastUpdate

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.fieldName = 'PROGRAM_OF_INTEREST'

	LEFT JOIN SubAdmins SA
		ON SA.subAdminId = C.subAdminId

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
		AND C.subAdminId NOT IN (SELECT subAdminId FROM SubAdmins WHERE campusCode IN (34601, 34606))

	GROUP BY C.contactId) t1

UNION	-- Spring Hill
SELECT NULL 'Contact Name', NULL 'Stage', NULL 'Program of Interest'
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Spring Hill</td><td></td><td></td><td></td></tr>' AS 'Last Updated'

UNION
SELECT t2.name 'Contact Name'
	, t2.type 'Stage'
	, t2.program 'Program of Interest'
	, t2.lastUpdate 'Last Updated'
FROM (
	SELECT SA.campusCode AS campus
		, CT.typeName AS type
		, PFV.fieldValue AS program
		, CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '"">', C.firstName, ' ', C.lastName, '</a>') AS name
		, DATE(C.lastUpdateDtTm) AS lastUpdate

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.fieldName = 'PROGRAM_OF_INTEREST'

	LEFT JOIN SubAdmins SA
		ON SA.subAdminId = C.subAdminId

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
		AND C.subAdminId IN (SELECT subAdminId FROM SubAdmins WHERE campusCode = 34606)

	GROUP BY C.contactId) t2
WHERE t2.Campus = 34606

UNION	-- Brookesville
SELECT NULL 'Contact Name', NULL 'Stage', NULL 'Program of Interest'
	, '<tr style="text-align: left; background-color: #ADD8E6;"><td style="font-size: 125%; font-weight: bold;">Brookesville</td><td></td><td></td><td></td></tr>' AS 'Last Updated'

UNION
SELECT t1.name 'Contact Name'
	, t1.type 'Stage'
	, t1.program 'Program of Interest'
	, t1.lastUpdate 'Last Updated'
FROM (
	SELECT SA.campusCode AS campus
		, CT.typeName AS type
		, PFV.fieldValue AS program
		, CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '"">', C.firstName, ' ', C.lastName, '</a>') AS name
		, DATE(C.lastUpdateDtTm) AS lastUpdate

	FROM Contacts C

	INNER JOIN ContactTypes CT
		ON CT.contactTypeId = C.contactTypeId
		AND CT.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000050, 4000049)

	LEFT JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.fieldName = 'PROGRAM_OF_INTEREST'

	LEFT JOIN SubAdmins SA
		ON SA.subAdminId = C.subAdminId

	WHERE C.isActive = 1
		AND C.<ADMINID>
		AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 1 WEEK)
		AND C.subAdminId IN (SELECT subAdminId FROM SubAdmins WHERE campusCode = 34601)

	GROUP BY C.contactId) t1