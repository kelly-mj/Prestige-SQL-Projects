SELECT DATE_FORMAT(R.startDate, '%m/%d/%Y') AS 'Start Date'
    , C.className AS 'Class'
    , CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS 'Student'

FROM Registrations R
INNER JOIN Students S ON S.studentId = R.studentId
INNER JOIN ClassStudentReltn CSR ON R.registrationId = CSR.registrationId
INNER JOIN Classes C ON C.classId = CSR.classId
INNER JOIN ClassTeacherReltn CTR ON CTR.classId = CSR.classId

WHERE R.startDate <= DATE_ADD(CURDATE(), INTERVAL 14 DAY)
  AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)
  AND R.isActive = 1
  AND S.isActive = 1
  AND CSR.status = 0
  AND CSR.isActive = 1
  AND CTR.isActive = 1
  AND CTR.teacherId = [RECIPIENT_ID]
  AND R.<ADMINID>

ORDER BY C.className, S.lastName
