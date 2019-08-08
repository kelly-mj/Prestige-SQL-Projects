-- [TSPA] Graduates From 2 Years
-- Kelly MJ  |  8/7/2019

SELECT CMP.campusName AS Campus
    , P.programmeName AS Program
    , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
    , DATE_FORMAT(R.graduationDate, '%m/%d/%Y') AS 'Graduation Date'

FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg
            FROM Registrations
            WHERE isActive = 1
              AND R.regStatus = 3
            GROUP BY studentId) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN Programmes P ON P.programmeId = R.programmeId
LEFT JOIN Campuses CMP ON CMP.campusCode = S.studentCampus

WHERE R.graduationDate <= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
  AND R.graduationDate >= IF('[?Earliest Grad Date]' <> '', '[?Earliest Grad Date]', '1970-01-02')

ORDER BY CMP.campusName, P.programmeName, S.lastName
