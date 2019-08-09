-- [SHELL] Graduated Students With No Program
-- Kelly MJ  |  8/8/2019

SELECT t1.Name
    , (SELECT statusName FROM StatusSequences WHERE statusId = t1.isActive) AS 'Student Status'
    , t1.registrationId AS 'Reg Record ID'
    , t1.programmeName AS 'Program'
    , DATE_FORMAT(t1.graduationDate, '%m/%d/%Y') AS 'Grad/Drop Date'
    , (SELECT statusName FROM StatusSequences WHERE statusId = t1.regStatus) AS 'Registration Status'
    , t1.employerInfo

FROM (
    SELECT S.studentId
    , CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
    , S.lastName
    , S.isActive
    , S.creationDtTm
    , S.lastUpdateDtTm
    , R.registrationId
    , R.graduationDate
    , R.regStatus
    , P.programmeName
    , CONCAT(IF(P0.fieldValue IS NOT NULL, P0.fieldValue, '')
        , IF(P0.fieldValue IS NOT NULL AND P0.fieldValue <> '' AND P1.fieldValue IS NOT NULL AND P1.fieldValue <> '', ' - ', '')
        , CONCAT('<strong>', P1.fieldValue, '</strong>')
        , IF((P0.fieldValue IS NOT NULL OR P1.fieldValue IS NOT NULL) AND P2.fieldValue IS NOT NULL, '</br>', '')
        , P2.fieldValue
        , IF(P2.fieldValue IS NOT NULL AND P3.fieldValue IS NOT NULL, '</br>', '')
        , P3.fieldValue) AS employerInfo

    FROM Students S
    LEFT JOIN Registrations R ON R.studentId = S.studentId
        AND R.isActive = 1
    LEFT JOIN Programmes P ON P.programmeId = R.programmeId
    LEFT JOIN ProfileFieldValues P0 ON P0.userId = S.studentId
        AND P0.fieldName = 'EMPLOYER_TYPE'
    LEFT JOIN ProfileFieldValues P1 ON P1.userId = S.studentId
        AND P1.fieldName = 'EMPLOYER_NAME'
    LEFT JOIN ProfileFieldValues P2 ON P2.userId = S.studentId
        AND P2.fieldName = 'EMPLOYER_ADDRESS'
    LEFT JOIN ProfileFieldValues P3 ON P3.userId = S.studentId
        AND P3.fieldName = 'EMPLOYER_PHONE'

    WHERE (S.isActive = 3 OR R.regStatus = 3)
      #AND S.<ADMINID>
) t1

WHERE CASE '[?Show{All (No Filters)|All (No Filters)|No Registration Record|No Registration Record|Non-Graduate Registration Record|Non-Graduate Registration Record|Graduate Registration Record|Graduate Registration Record|Active Students with Graduated Record|Active Students with Graduated Record}]'
    WHEN 'No Registration Record' THEN t1.registrationId IS NULL
    WHEN 'Non-Graduate Registration Record' THEN t1.regStatus <> 3
    WHEN 'Graduate Registration Record' THEN t1.regStatus = 3
    WHEN 'Active Students with Graduated Record' THEN t1.isActive <> 3
    ELSE t1.isActive = 3
    END

ORDER BY t1.lastName
