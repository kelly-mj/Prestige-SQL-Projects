-- [HWD] KPI - Admissions - Cancel-Show Rates
-- Kelly MJ  |  7/22/2019

SELECT CMP.campusName
    , CONCAT(COALESCE(APP.num, 0), ' : ', COALESCE(C.num, 0)) 'Applications : Cancels'
    , CONCAT(ROUND(COALESCE(100*COALESCE(C.num, 0)/COALESCE(APP.num, 0), 0), 1), '%') 'Cancel Rate'
    , CONCAT(COALESCE(APP.num, 0), ' : ', COALESCE(S.num, 0)) 'Applications : Starts'
    , CONCAT(ROUND(COALESCE(100*COALESCE(S.num, 0)/COALESCE(APP.num, 0), 0), 1), '%') 'Show Rate'

FROM Campuses CMP
LEFT JOIN (
    SELECT C.campusCode
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
        AND IF('[?Campus]' <> ''
                , ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
                , C.<ADMINID> /* dummy condition */ )
        GROUP BY C.campusCode ) APP
    ON APP.campusCode = CMP.campusCode
LEFT JOIN (
    SELECT C.campusCode
        , COALESCE(COUNT(DISTINCT C.contactId), 0) AS num
        FROM Contacts C
        LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
        LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                    INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                    WHERE T.typeName = '86. Lost - Not Interested - Cancel'
                    AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
            ON USR.toUserId = C.contactId
        WHERE C.isActive = 1
        AND C.<ADMINID>
        AND ((CT.typeName = '86. Lost - Not Interested - Cancel' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL)
        AND IF('[?Campus]' <> ''
                , ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
                , C.<ADMINID> /* dummy condition */ )
        GROUP BY C.campusCode ) C
    ON C.campusCode = CMP.campusCode
LEFT JOIN (
    SELECT C.campusCode
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
        AND IF('[?Campus]' <> ''
                , ( EXISTS (SELECT * FROM Campuses WHERE INSTR(REPLACE(LOWER(campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) AND campusCode = C.campusCode) OR C.campusCode = '[?Campus]')
                , C.<ADMINID> /* dummy condition */ )
        GROUP BY C.campusCode ) S
    ON S.campusCode = CMP.campusCode

WHERE IF('[?Campus]' <> ''
			, INSTR(REPLACE(LOWER(CMP.campusName), ' ', ''), REPLACE(LOWER('[?Campus]'), ' ', '')) OR CMP.campusCode = '[?Campus]'
			, CMP.isActive = 1 /* dummy condition */ )
AND CMP.isActive = 1
