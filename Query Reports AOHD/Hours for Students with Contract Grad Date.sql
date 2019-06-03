-- [AOHD] Hours for Students with Contract Grad Date
-- Kelly MJ  |  06/03/2019

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS 'Student'
    , DATE_FORMAT(R.endDate, '%m/%d/%Y') AS 'Contract Grad Date'
    , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_SCHEDULED') AS 'Scheduled Hours'
    , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_ATTENDED') AS 'Actual Hours'

FROM Students S
INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = RR.studentId
    AND R.registrationId = RR.maxReg

WHERE R.endDate >= '[?From Date]'
    AND R.endDate <= '[?To Date]'
    AND S.isActive IN (1, 12)
    AND S.<ADMINID>

ORDER BY R.endDate, S.lastName
