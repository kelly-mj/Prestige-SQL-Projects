-- [MBI] KPI - Admissions Report
-- Kelly MJ  |  7/29/2019

SELECT t1.type AS 'Type'
    , CONCAT('<span style="display: inline-block; width: 30px; padding-right: 5px; text-align: right;">', CAST(SUM(t1.l) AS CHAR), '</span>:  ', CAST(SUM(t1.r) AS CHAR)) AS 'Gross Numbers'
    , IF(SUM(t1.r)/SUM(t1.l) >= t1.threshold
            , CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(100*COALESCE((SUM(t1.r))/SUM(t1.l), 0), 0), '%</span>', t1.label)
            , CONCAT('<span style="display: inline-block; width: 45px; color: red;">', FORMAT(100*COALESCE((SUM(t1.r))/SUM(t1.l), 0), 0), '%</span><span style="color: red;">', t1.label, '</span>')) AS 'Percentages'

FROM (
    /* Lead to Tour */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Lead to Tour' AS type
        , COUNT(DISTINCT IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]', C.contactId, NULL)) AS l
        , COUNT(DISTINCT IF((CT.typeName = '3. Completed Tour' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , C.contactId, NULL)) AS r
        , 'L to A' AS label
        , 0 AS threshold
        , 1 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '3. Completed Tour'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Tour to Interview */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Tour to Interview' AS type
        , COUNT(DISTINCT IF((CT.typeName = '3. Completed Tour' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL
                    , C.contactId, NULL)) AS l
        , SUM(IF((CT.typeName = '6. Interviewed' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'A to I' AS label
        , 0 AS threshold
        , 2 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '3. Completed Tour'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '6. Interviewed'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Interview to Application */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Interview to Application' AS type
        , SUM(IF((CT.typeName = '6. Interviewed' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL, 1, 0)) AS l
        , SUM(IF((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL, 1, 0)) AS r
        , 'I to APP' AS label
        , .6 AS threshold
        , 3 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '6. Interviewed'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '7. Applied'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Lead to Application */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Lead to Application' AS type
        , COUNT(DISTINCT IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]', C.contactId, NULL)) AS l
        , SUM(IF((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'L to APP' AS label
        , 0 AS threshold
        , 4 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '7. Applied'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Application to Enrollment */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Application to Enrollment' AS type
        , SUM(IF((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL
                    , 1, 0)) AS l
        , SUM(IF((CT.typeName = '8. Enrolled' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'APP to E' AS label
        , .8 AS threshold
        , 5 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '7. Applied'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '8. Enrolled'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )

    UNION /* Lead to Enrollment */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Lead to Enrollment' AS type
        , COUNT(DISTINCT IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]', C.contactId, NULL)) AS l
        , SUM(IF((CT.typeName = '8. Enrolled' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'L to E' AS label
        , .22 AS threshold
        , 6 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT DISTINCT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '8. Enrolled'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
    )
) t1

GROUP BY t1.Ord

/* <ADMINID> */
