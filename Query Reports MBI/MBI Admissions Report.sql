-- [MBI] KPI - Admissions Report
-- Kelly MJ  |  7/29/2019

SELECT t1.type AS 'Type'
    , CONCAT('<span style="display: inline-block; width: 30px; padding-right: 5px; text-align: right;">', CAST(SUM(t1.l) AS CHAR), '</span>:  ', CAST(SUM(t1.r) AS CHAR)) AS 'Gross Numbers'
    , IF(SUM(t1.r)/SUM(t1.l) >= t1.threshold
            , CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(100*COALESCE((SUM(t1.r))/SUM(t1.l), 0), 0), '%</span>', t1.label)
            , CONCAT('<span style="display: inline-block; width: 45px; color: red;">', FORMAT(100*COALESCE((SUM(t1.r))/SUM(t1.l), 0), 0), '%</span><span style="color: red;">', t1.label, '</span>')) AS 'Percentages'

FROM (
    /* Lead to Contact */
    (SELECT 'Lead to Contact' AS type
        , COUNT(DISTINCT IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]', C.contactId, NULL)) AS l
        , COUNT(DISTINCT IF((CT.typeName = '2. Set Tour' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , C.contactId, NULL)) AS r
        , 'Lead to Contact' AS label
        , 0 AS threshold
        , 1 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '2. Set Tour'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Contact to Tour */
    (SELECT 'Contact to Tour' AS type
        , COUNT(DISTINCT IF((CT.typeName = '2. Set Tour' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL
                    , C.contactId, NULL)) AS l
        , SUM(IF((CT.typeName = '3. Completed Tour' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'Contact to Tour' AS label
        , 0 AS threshold
        , 2 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '2. Set Tour'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '3. Completed Tour'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Tour to Applied */
    (SELECT 'Tour to Applied' AS type
        , SUM(IF((CT.typeName = '3. Completed Tour' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL, 1, 0)) AS l
        , SUM(IF((CT.typeName = '5. Future Attend Date' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL, 1, 0)) AS r
        , 'Tour to Applied' AS label
        , 0 AS threshold
        , 3 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '3. Completed Tour'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '5. Future Attend Date'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Application to Enrolled */
    (SELECT 'Application to Enrolled' AS type
        , SUM(IF((CT.typeName = '5. Future Attend Date' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL
                    , 1, 0)) AS l
        , SUM(IF((CT.typeName = '6. Enrolled Student' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'Application to Enrolled' AS label
        , 0 AS threshold
        , 4 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '5. Future Attend Date'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '6. Enrolled Student'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

) t1

GROUP BY t1.Ord

/* <ADMINID> */
