-- [CORTIVA] KPI - Career Services - MBLEX testing
-- Kelly MJ  |  7/26/2019

SELECT t1.Campus
    , t1.type AS 'Type'
    , CONCAT(CAST(SUM(t1.l) AS CHAR), ' : ', CAST(SUM(t1.r) AS CHAR)) AS 'Gross Numbers'
    , CONCAT(FORMAT(COALESCE(100*SUM(t1.r)/SUM(t1.l), 0), 0), '%') AS 'Percentage'

FROM (
    /* Total Eligible vs. Testing */
    (SELECT '<strong>Total Eligible vs. Testing</strong>' AS type
        , IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', CMP.campusName, 'All Campuses') AS Campus
        , COUNT(DISTINCT R.studentId) AS l
        , COUNT(DISTINCT IF(CP.satForAllPartsOfExam = 1, R.studentId, NULL)) AS r
        , 1 AS Ord

    FROM (
        SELECT MAX(registrationId) AS maxReg
        FROM Registrations
        WHERE isActive = 1
          AND graduationDate BETWEEN '[?From Date]' AND '[?To Date]'
        GROUP BY studentId) RR
    INNER JOIN Registrations R ON R.registrationId = RR.maxReg
    LEFT JOIN CareerPlacements CP ON CP.registrationId = RR.maxReg
    LEFT JOIN Campuses CMP ON CMP.campusCode = R.studentCampus

    WHERE R.regStatus = 3
    GROUP BY CMP.campusCode)
    /* <ADMINID> */

    UNION  /* Total Testing vs. Passing */
    (SELECT '<strong>Total Testing vs. Passing<strong>'
        , IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', CMP.campusName, 'All Campuses') AS Campus
        , COUNT(DISTINCT IF(CP.satForAllPartsOfExam = 1, R.studentId, NULL)) AS l
        , COUNT(DISTINCT IF(CP.passedExam = 1, R.studentId, NULL)) AS r
        , 3 AS Ord

    FROM (
        SELECT MAX(registrationId) AS maxReg
        FROM Registrations
        WHERE isActive = 1
          AND graduationDate BETWEEN '[?From Date]' AND '[?To Date]'
        GROUP BY studentId) RR
    INNER JOIN Registrations R ON R.registrationId = RR.maxReg
    LEFT JOIN CareerPlacements CP ON CP.registrationId = RR.maxReg
    LEFT JOIN Campuses CMP ON CMP.campusCode = R.studentCampus

    WHERE R.regStatus = 3
    GROUP BY CMP.campusCode)

    UNION /* Individual Program Eligible vs. Testing */
    (SELECT CONCAT('&nbsp;&nbsp;&nbsp;&nbsp;', P.programmeName, ' Eligible vs. Testing') AS type
        , IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', CMP.campusName, 'All Campuses') AS Campus
        , COUNT(DISTINCT R.studentId) AS l
        , COUNT(DISTINCT IF(CP.satForAllPartsOfExam = 1, R.studentId, NULL)) AS r
        , 2 AS Ord

    FROM (
        SELECT MAX(registrationId) AS maxReg
        FROM Registrations
        WHERE isActive = 1
          AND graduationDate BETWEEN '[?From Date]' AND '[?To Date]'
        GROUP BY studentId) RR
    INNER JOIN Registrations R ON R.registrationId = RR.maxReg
    INNER JOIN Programmes P ON P.programmeId = R.programmeId
    LEFT JOIN CareerPlacements CP ON CP.registrationId = RR.maxReg
    LEFT JOIN Campuses CMP ON CMP.campusCode = R.studentCampus

    WHERE R.regStatus = 3
    GROUP BY CMP.campusCode)

    UNION  /* Individual Program Testing vs. Passing */
    (SELECT CONCAT('&nbsp;&nbsp;&nbsp;&nbsp;', P.programmeName, ' Testing vs. Passing') AS type
        , IF('[?Aggregate?{No|No|Yes|Yes}]' = 'No', CMP.campusName, 'All Campuses') AS Campus
        , COUNT(DISTINCT IF(CP.satForAllPartsOfExam = 1, R.studentId, NULL)) AS l
        , COUNT(DISTINCT IF(CP.passedExam = 1, R.studentId, NULL)) AS r
        , 4 AS Ord

    FROM (
        SELECT MAX(registrationId) AS maxReg
        FROM Registrations
        WHERE isActive = 1
          AND graduationDate BETWEEN '[?From Date]' AND '[?To Date]'
        GROUP BY studentId) RR
    INNER JOIN Registrations R ON R.registrationId = RR.maxReg
    INNER JOIN Programmes P ON P.programmeId = R.programmeId
    LEFT JOIN CareerPlacements CP ON CP.registrationId = RR.maxReg
    LEFT JOIN Campuses CMP ON CMP.campusCode = R.studentCampus

    WHERE R.regStatus = 3
      AND P.programmeName = 'Cosmetology'
    GROUP BY CMP.campusCode)
) t1

GROUP BY Campus, type
ORDER BY Campus, Ord
