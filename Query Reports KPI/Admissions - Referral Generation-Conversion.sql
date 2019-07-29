-- [HWD] KPI - Admissions - Referral Generation/Conversion
-- Kelly MJ  |  7/25/2019

SELECT CMP.campusName AS 'Campus'
    , CONCAT(COALESCE(CAST(COUNT(DISTINCT C.contactId) AS CHAR), 0), ': ', CAST(SUM(IF(USR.toUserId IS NOT NULL OR CT.typeName = '7. Applied', 1, 0)) AS CHAR)) AS 'Referrals : Applications'
    , CONCAT(ROUND(COALESCE(SUM(IF(USR.toUserId IS NOT NULL OR CT.typeName = '7. Applied', 1, 0))/COUNT(DISTINCT C.contactId), 0), 2), '%') AS 'Conversion Rate'

FROM Contacts C
INNER JOIN ProfileFieldValues PFV ON PFV.userId = C.contactId
INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
INNER JOIN Campuses CMP ON CMP.campusCode = C.campusCode
LEFT JOIN (SELECT MAX(U.toUserId) AS toUserId FROM UserStatusRecords U
            INNER JOIN ContactTypes T ON T.contactTypeId = U.status
            WHERE T.typeName = '7. Applied'
            -- AND DATE(U.updateDtTm) >= DATE_SUB(CURDATE(), INTERVAL 2 WEEK) AND DATE(U.updateDtTm) <= CURDATE()
            GROUP BY U.toUserId) USR
    ON USR.toUserId = C.contactId

WHERE C.isActive = 1
    AND PFV.fieldName = 'HOW_DID_YOU_HEAR_ABOUT_US'
    AND PFV.fieldValue = 'Friend Referral'
    AND CMP.isActive = 1
    #AND C.<ADMINID>

GROUP BY C.campusCode
