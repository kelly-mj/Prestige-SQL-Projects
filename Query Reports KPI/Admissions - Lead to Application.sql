-- [HWD] KPI - Admissions - Interview to Application
-- Kelly MJ  |  7/19/2019
-- 7/19/19 TODO: Change lead types to '6. Interviewed' and '7. Applied' for use in Hollywood/Cortiva sites

SELECT CONCAT(CAST(t1.interview AS CHAR), ' : ', CAST(t2.application AS CHAR)) AS '# Interviews : # Applications'
	, CONCAT(FORMAT(COALESCE(100*(t2.application)/(t1.interview), 0), 2), ' %') AS 'I to APP %'

	FROM (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS interview, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '3. Mailed Catalog'
						AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '3. Mailed Catalog' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
					OR USR.include = 1)
			AND IF('[?Campus]' <> ''
					, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
					, C.<ADMINID> /* dummy condition */ )
	) t1
	INNER JOIN (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS application, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '2. Left Message'
						AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '2. Left Message' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
					OR USR.include = 1)
			AND IF('[?Campus]' <> ''
					, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
					, C.<ADMINID> /* dummy condition */ )
	) t2 ON t2.joinCode = t1.joinCode
