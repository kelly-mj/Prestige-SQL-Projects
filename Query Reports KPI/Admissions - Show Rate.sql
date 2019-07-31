-- [HWD] KPI - Admissions - Cancel-Show Rates
-- Kelly MJ  |  7/22/2019

SELECT IF('[?Aggregate{No|No|Yes|Yes}]' = 'No', CMP.campusName, 'All Campuses') AS 'Campus'
    , CONCAT(COALESCE(SUM(APP.num), 0), ' : ', COALESCE(SUM(C.num), 0)) 'Applications : Cancels'
    , CONCAT(ROUND(COALESCE(100*COALESCE(SUM(C.num), 0)/COALESCE(SUM(APP.num), 0), 0), 1), '%') 'Cancel Rate'
    , CONCAT(COALESCE(SUM(APP.num), 0), ' : ', COALESCE(SUM(S.num), 0)) 'Applications : Starts'
    , CONCAT(ROUND(COALESCE(100*COALESCE(SUM(S.num), 0)/COALESCE(SUM(APP.num), 0), 0), 1), '%') 'Show Rate'

FROM Campuses CMP
LEFT JOIN (
    SELECT IF('[?Aggregate{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
        FROM Contacts C
        LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
        LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                    INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                    WHERE T.typeName = '7. Applied'
                    AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
            ON USR.toUserId = C.contactId
        WHERE C.isActive = 1
        AND C.<ADMINID>
        AND ((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL)
        GROUP BY C.campusCode ) APP
    ON APP.campusCode = CMP.campusCode
LEFT JOIN (
    SELECT IF('[?Aggregate{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
        FROM Contacts C
        LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
        LEFT JOIN (SELECT U.toUserId, MAX(U.updateDtTm) FROM UserStatusRecords U
                    INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                    WHERE T.typeName = '86. Lost - Not Interested - Cancel'
                    AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]'
                    GROUP BY U.toUserId) USR
            ON USR.toUserId = C.contactId
        WHERE C.isActive = 1
        AND C.<ADMINID>
        AND ((CT.typeName = '86. Lost - Not Interested - Cancel' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL)
        GROUP BY C.campusCode ) C
    ON C.campusCode = CMP.campusCode
LEFT JOIN (
    SELECT IF('[?Aggregate{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
        FROM Contacts C
        LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
        LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                    INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                    WHERE T.typeName = '9. Started Student'
                    AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
            ON USR.toUserId = C.contactId
        WHERE C.isActive = 1
        AND C.<ADMINID>
        AND ((CT.typeName = '9. Started Student' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL)
        GROUP BY C.campusCode ) S
    ON S.campusCode = CMP.campusCode

WHERE IF('[?Aggregate{No|No|Yes|Yes}]' = 'No'
            , CMP.isActive = 1 /* dummy condition */
            , CMP.campusCode = (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1))
AND CMP.isActive = 1

GROUP BY CMP.campusCode
