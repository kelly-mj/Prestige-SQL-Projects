-- USE TEST CODE TO CHECK STUDENT STATUSES

SELECT S.studentCampus
, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name -- student name
, S.isActive
, R.regStatus
, R.startDate
, R.endDate
, R.graduationDate

FROM Students S
INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate AND R.isActive = 1

WHERE S.<ADMINID>
