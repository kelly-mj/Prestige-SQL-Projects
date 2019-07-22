-- [HWD] KPI - Admissions - Cancel-Show Rates
-- Kelly MJ  |  7/22/2019

SELECT 'Cancel Rate (Applied : Cancel)' AS 'Type'
    , CONCAT(COALESCE(APP.num, 0), ' : ', COALESCE(C.num, 0), '') 'Gross Numbers'
    , CONCAT(ROUND(COALESCE(100*COALESCE(C.num, 0)/COALESCE(APP.num, 0), 0), 1), '%') 'Percentage'

FROM (
    SELECT 'join' as joinCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
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
        AND C.campusCode IN (SELECT campusCode FROM SubAdmins WHERE subAdminId = [?USERID] AND isActive = 1) ) APP
LEFT JOIN (
    SELECT 'join' as joinCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
        FROM Contacts C
        LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
        LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                    INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                    WHERE T.typeName = '86. Lost - Not Interested - Cancel'
                    AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
            ON USR.toUserId = C.contactId
        WHERE C.isActive = 1
        AND C.<ADMINID>
        AND ((CT.typeName = '86. Lost - Not Interested - Cancel' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
                OR USR.toUserId IS NOT NULL)
        AND C.campusCode IN (SELECT campusCode FROM SubAdmins WHERE subAdminId = [?USERID] AND isActive = 1) ) C
    ON C.joinCode = APP.joinCode

UNION
SELECT 'Show Rate (Applied : Start)'
    , CONCAT(COALESCE(APP.num, 0), ' : ', COALESCE(S.num, 0))
    , CONCAT(ROUND(COALESCE(100*COALESCE(S.num, 0)/COALESCE(APP.num, 0), 0), 1), '%')

FROM (
    SELECT 'join' as joinCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
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
        AND C.campusCode IN (SELECT campusCode FROM SubAdmins WHERE subAdminId = [?USERID] AND isActive = 1) ) APP
LEFT JOIN (
    SELECT 'join' as joinCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
        FROM Contacts C
        LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
        LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                    INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                    WHERE T.typeName = '9. Started Student'
                    AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()) USR
            ON USR.toUserId = C.contactId
        WHERE C.isActive = 1
        AND C.<ADMINID>
        AND ((CT.typeName = '9. Started Student' AND DATE(C.lastUpdateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(C.lastUpdateDtTm) <= CURDATE())
                OR USR.toUserId IS NOT NULL)
        AND C.campusCode IN (SELECT campusCode FROM SubAdmins WHERE subAdminId = [?USERID] AND isActive = 1) ) S
    ON S.joinCode = APP.joinCode
