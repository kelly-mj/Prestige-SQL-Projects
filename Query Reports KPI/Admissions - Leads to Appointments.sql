-- [HWD] KPI - Admissions - Lead to Appointment
-- Kelly MJ  | 7/14/2019
-- 7/15/19 TODO: Correct '3. Mailed Catalog' to Hollywood's interview lead type

SELECT CONCAT(CAST(t1.total AS CHAR), ' : ', CAST(t1.current+t1.past AS CHAR)) AS '# Leads : # Appts'
	, CONCAT(FORMAT(100*(t1.current+t1.past)/t1.total, 2), ' %') AS 'L to A %'

FROM (
	SELECT (SELECT COUNT(C.contactId) FROM Contacts C
				WHERE C.isActive = 1
                AND C.<ADMINID>
                /* user inputs */
                AND C.creationDtTm BETWEEN '[?From Date]' AND '[?To Date]'
                AND IF('[?Campus]' <> ''
						, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
						, C.<ADMINID> /* dummy condition */ )) AS 'total'
		, (SELECT COUNT(C.contactId) FROM Contacts C
				INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
				WHERE C.isActive = 1
				AND C.<ADMINID>
				AND CT.typeName = '3. Mailed Catalog'
				/* user inputs */
				AND C.lastUpdateDtTm BETWEEN '[?From Date]' AND '[?To Date]'
				AND IF('[?Campus]' <> ''
						, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
						, C.<ADMINID> /* dummy condition */ )) AS 'current'
		, (SELECT COUNT(DISTINCT USR.toUserId) FROM UserStatusRecords USR
				INNER JOIN ContactTypes CT ON CT.contactTypeId = USR.status
				INNER JOIN Contacts C ON C.contactId = USR.toUserId
				WHERE USR.isActive = 1
				AND USR.<ADMINID>
				AND CT.typeName = '3. Mailed Catalog'
				AND NOT EXISTS (SELECT * FROM Contacts C
								INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
								WHERE C.contactId = USR.toUserId
								AND CT.typeName = '3. Mailed Catalog')
				/* user inputs */
				AND USR.updateDtTm BETWEEN '[?From Date]' AND '[?To Date]'
				AND IF('[?Campus]' <> ''
						, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
						, C.<ADMINID> /* dummy condition */ ) ) AS 'past'
	) t1
