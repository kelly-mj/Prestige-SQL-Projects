-- [HWD] KPI - Admissions - Lead to Appointment
-- Kelly MJ  | 7/14/2019
-- 7/15/19 TODO: Correct '3. Mailed Catalog' to Hollywood's interview lead type

SELECT CONCAT(CAST(t1.lead AS CHAR), ' : ', CAST(t1.appointment AS CHAR)) AS '# Leads : # Appts'
	, CONCAT(FORMAT(100*(t1.appointment)/t1.lead, 2), ' %') AS 'L to A %'

FROM (
	SELECT (SELECT COUNT(C.contactId) FROM Contacts C
				WHERE C.isActive = 1
                AND C.<ADMINID>
                /* user inputs */
                AND DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]'
                AND IF('[?Campus]' <> ''
						, ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
						, C.<ADMINID> /* dummy condition */ )) AS 'lead'
		, (SELECT COUNT(DISTINCT C.contactId) AS count
		    FROM Contacts C
		    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
		    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
		                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
		                WHERE T.typeName = '3. Mailed Catalog'
		                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
		        ON USR.toUserId = C.contactId
		    WHERE C.isActive = 1
		    AND C.<ADMINID>
		    AND ((CT.typeName = '3. Mailed Catalog' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
		            OR USR.toUserId IS NOT NULL)
		    AND IF('[?Campus]' <> ''
		            , ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
		            , C.<ADMINID> /* dummy condition */ )) AS 'appointment'
	) t1
