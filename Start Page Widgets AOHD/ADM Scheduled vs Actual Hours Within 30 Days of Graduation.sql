-- [AOHD] ADM Scheduled vs Actual Hours Within 30 Days of Graduation
-- Kelly MJ  |  06/03/2019

-- 2nd widget, for the admin for now:
-- Need to show students Scheduled vs actual within 30 days of their Contracted Grade Date, But he also wants to take that widget and turn it into a query report with a date range

SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS 'Student'
    , DATE_FORMAT(R.endDate, '%m/%d/%Y') AS 'Contract Grad Date'
    , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_SCHEDULED') AS 'Scheduled Hours'
    , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_HOURS_ATTENDED') AS 'Actual Hours'

FROM Students S
INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = RR.studentId
    AND R.registrationId = RR.maxReg

WHERE CURDATE() >= DATE_SUB(R.endDate, INTERVAL 1 MONTH)
    AND CURDATE() <= DATE_ADD(R.endDate, INTERVAL 1 MONTH)
    AND S.isActive IN (1, 12)
    AND S.<ADMINID>

ORDER BY R.endDate, S.lastName
