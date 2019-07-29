-- [HWD] KPI - Admissions Report
-- Kelly MJ  |  7/29/2019

-- adaptions for testing on Benestest:
   -- '5. Appointment Set' --> '5.  Working'
   -- '6. Interviewed'     --> '6.  Nurturing'
   -- '7. Applied'         --> '2.  Left Message'
   -- '8. Enrolled'        --> '3.  Mailed Catalog'

SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', CMP.campusName, 'All Campuses') AS Campus
    , t1.type AS 'Type'
    , CONCAT('<span style="display: inline-block; width: 30px; padding-right: 5px; text-align: right;">', CAST(SUM(t1.l) AS CHAR), '</span>:&nbsp;&nbsp;', CAST(SUM(t1.r) AS CHAR)) AS 'Gross Numbers'
    , CONCAT('<span style="display: inline-block; width: 45px;">', FORMAT(100*COALESCE((SUM(t1.r))/SUM(t1.l), 0), 0), '%</span>', t1.label) AS 'Percentages'

FROM Campuses CMP
INNER JOIN (
    /* Lead to Appointment */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Lead to Appointment' AS type
        , SUM(IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]'
                    , 1, 0)) AS l
        , SUM(IF((CT.typeName = '5. Appointment Set' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'L to A' AS label
        , 1 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '5. Appointment Set'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    GROUP BY C.campusCode)

    UNION /* Appointment to Interview */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Appointment to Interview' AS type
        , SUM(IF((CT.typeName = '5. Appointment Set' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL
                    , 1, 0)) AS l
        , SUM(IF((CT.typeName = '6. Interviewed' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'A to I' AS label
        , 2 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '5. Appointment Set'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '6. Interviewed'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    GROUP BY C.campusCode)

    UNION /* Interview to Application */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Interview to Application' AS type
        , SUM(IF((CT.typeName = '6. Interviewed' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR L.toUserId IS NOT NULL, 1, 0)) AS l
        , SUM(IF((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR R.toUserId IS NOT NULL, 1, 0)) AS r
        , 'I to APP' AS label
        , 3 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '6. Interviewed'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '7. Applied'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    GROUP BY C.campusCode)

    UNION /* Lead to Application */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Lead to Application' AS type
        , SUM(IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]'
                    , 1, 0)) AS l
        , SUM(IF((CT.typeName = '7. Applied' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'L to APP' AS label
        , 4 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '7. Applied'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    GROUP BY C.campusCode)

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
        , 5 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '7. Applied'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') L
        ON L.toUserId = C.contactId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '8. Enrolled'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') R
        ON R.toUserId = C.contactId

    WHERE C.isActive = 1
    GROUP BY C.campusCode)

    UNION /* Lead to Enrollment */
    (SELECT IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', C.campusCode, (SELECT MAX(campusCode) FROM Campuses WHERE isActive = 1)) AS campusCode
        , 'Lead to Enrollment' AS type
        , SUM(IF(DATE(C.creationDtTm) >= '[?From Date]' AND DATE(C.creationDtTm) <= '[?To Date]'
                    , 1, 0)) AS l
        , SUM(IF((CT.typeName = '8. Enrolled' AND DATE(C.lastUpdateDtTm) >= '[?From Date]' AND DATE(C.lastUpdateDtTm) <= '[?To Date]')
                OR USR.toUserId IS NOT NULL
                    , 1, 0)) AS r
        , 'L to E' AS label
        , 6 AS Ord
    FROM Contacts C
    LEFT JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
    LEFT JOIN (SELECT U.toUserId FROM UserStatusRecords U
                INNER JOIN ContactTypes T ON T.contactTypeId = U.status
                WHERE T.typeName = '8. Enrolled'
                AND DATE(U.updateDtTm) >= '[?From Date]' AND DATE(U.updateDtTm) <= '[?To Date]') USR
        ON USR.toUserId = C.contactId

    WHERE C.isActive = 1
    GROUP BY C.campusCode)
) t1
    ON t1.campusCode = CMP.campusCode

WHERE CMP.isActive = 1
GROUP BY CMP.campusCode, t1.Ord

/* <ADMINID> */
