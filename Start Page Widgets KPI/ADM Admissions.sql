-- [HWD] KPI - ADM Admissions
-- Kelly MJ  |  7/19/2019

SELECT 'Lead to Appointment' AS 'Report Type'
    , CONCAT('<span style="display: inline-block; width: 46px; padding-right: 5px; text-align: right;">', CAST(t1.lead AS CHAR), '</span>:&nbsp;&nbsp;', CAST(t1.appointment AS CHAR)) AS 'Gross Numbers'
	, CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(100*(t1.appointment)/t1.lead, 2), '%</span> L to A') AS 'Percentages'

FROM (
	SELECT (SELECT COUNT(C.contactId) FROM Contacts C
				WHERE C.isActive = 1
                AND C.<ADMINID>
                /* user inputs */
                AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.creationDtTm) <= CURDATE()
				AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])) AS 'lead'
		, (SELECT COUNT(DISTINCT C.contactId) AS count
		    FROM Contacts C
		    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
		    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
		                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
		                WHERE T.typeName = '3. Mailed Catalog'
		                AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
		        ON USR.toUserId = C.contactId
		    WHERE C.isActive = 1
		    AND C.<ADMINID>
		    AND ((CT.typeName = '3. Mailed Catalog' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
		            OR USR.toUserId IS NOT NULL)
		    AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])) AS 'appointment'
	) t1

UNION

(SELECT 'Appointment to Interview'
    , CONCAT('<span style="display: inline-block; width: 46px; padding-right: 5px; text-align: right;">', CAST(t1.appointment AS CHAR), '</span>:&nbsp;&nbsp;', CAST(t2.interview AS CHAR))
	, CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(COALESCE(100*(t2.interview)/(t1.appointment), 0), 2), '%</span> A to I')

	FROM (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS appointment, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '5. Appointment Set'
						AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '5. Appointment Set' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
					OR USR.include = 1)
			AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
	) t1
	INNER JOIN (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS interview, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '6. Interviewed'
						AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '6. Interviewed' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
					OR USR.include = 1)
			AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
	) t2 ON t2.joinCode = t1.joinCode)

UNION

(SELECT 'Interview to Application'
    , CONCAT('<span style="display: inline-block; width: 46px; padding-right: 5px; text-align: right;">', CAST(t1.interview AS CHAR), '</span>:&nbsp;&nbsp;', CAST(t2.application AS CHAR))
	, CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(COALESCE(100*(t2.application)/(t1.interview), 0), 2), '%</span> I to APP')

	FROM (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS interview, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '6. Interviewed'
						AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '6. Interviewed' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
					OR USR.include = 1)
			AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
	) t1
	INNER JOIN (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS application, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '7. Applied'
						AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
					OR USR.include = 1)
		    AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
	) t2 ON t2.joinCode = t1.joinCode)

UNION

(SELECT 'Lead to Application' AS 'Report Type'
    , CONCAT('<span style="display: inline-block; width: 46px; padding-right: 5px; text-align: right;">', CAST(t1.lead AS CHAR), '</span>:&nbsp;&nbsp;', CAST(t1.application AS CHAR))
	, CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(100*(t1.application)/t1.lead, 2), '%</span> L to APP')

FROM (
	SELECT (SELECT COUNT(C.contactId) FROM Contacts C
				WHERE C.isActive = 1
                AND C.<ADMINID>
                /* user inputs */
                AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.creationDtTm) <= CURDATE()
				AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])) AS 'lead'
		, (SELECT COUNT(DISTINCT C.contactId) AS count
		    FROM Contacts C
		    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
		    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
		                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
		                WHERE T.typeName = '7. Applied'
		                AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
		        ON USR.toUserId = C.contactId
		    WHERE C.isActive = 1
		    AND C.<ADMINID>
		    AND ((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
		            OR USR.toUserId IS NOT NULL)
		    AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])) AS 'application') t1)

UNION

(SELECT 'Application to Enrollment'
    , CONCAT('<span style="display: inline-block; width: 46px; padding-right: 5px; text-align: right;">', CAST(t1.application AS CHAR), '</span>:&nbsp;&nbsp;', CAST(t2.enroll AS CHAR))
	, CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(COALESCE(100*(t2.enroll)/(t1.application), 0), 2), '%</span> APP to E')

	FROM (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS application, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '7. Applied'
						AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
					OR USR.include = 1)
			AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
	) t1
	INNER JOIN (
		SELECT COALESCE(COUNT(DISTINCT C.contactId), 0) AS enroll, 'join' as joinCode
			FROM Contacts C
			LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
			LEFT JOIN (SELECT U.toUserId, 1 AS 'include' FROM UserStatusRecords U
						INNER JOIN ContactTypes T ON T.contactTypeId = U.status
						WHERE T.typeName = '8. Enrolled'
						AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
				ON USR.toUserId = C.contactId
			WHERE C.isActive = 1
			AND C.<ADMINID>
			AND ((CT.typeName = '8. Enrolled' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
					OR USR.include = 1)
			AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
	) t2 ON t2.joinCode = t1.joinCode)

UNION

(SELECT 'Lead to Enrollment' AS 'Report Type'
    , CONCAT('<span style="display: inline-block; width: 46px; padding-right: 5px; text-align: right;">', CAST(t1.lead AS CHAR), '</span>:&nbsp;&nbsp;', CAST(t1.enroll AS CHAR))
	, CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(100*(t1.enroll)/t1.lead, 2), '%</span> L to E')

FROM (
	SELECT (SELECT COUNT(C.contactId) FROM Contacts C
				WHERE C.isActive = 1
                AND C.<ADMINID>
                /* user inputs */
                AND DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.creationDtTm) <= CURDATE()
				AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])) AS 'lead'
		, (SELECT COUNT(DISTINCT C.contactId) AS count
		    FROM Contacts C
		    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
		    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
		                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
		                WHERE T.typeName = '8. Enrolled'
		                AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
		        ON USR.toUserId = C.contactId
		    WHERE C.isActive = 1
		    AND C.<ADMINID>
		    AND ((CT.typeName = '8. Enrolled' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
		            OR USR.toUserId IS NOT NULL)
		    AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])
        ) AS 'enroll') t1)
