-- New Student Alert: Query 1
-- Kelly MJ

SELECT T.teacherId AS '[RECIPIENT_ID]'
    , T.email AS '[RECIPIENT_EMAIL]'

FROM Registrations R
INNER JOIN Students S ON S.studentId = R.studentId
INNER JOIN ClassStudentReltn CSR ON R.registrationId = CSR.registrationId
INNER JOIN Classes C ON C.classId = CSR.classId
INNER JOIN ClassTeacherReltn CTR ON CTR.classId = CSR.classId
INNER JOIN Teachers T ON T.teacherId = CTR.teacherId

WHERE R.startDate <= DATE_ADD(CURDATE(), INTERVAL 14 DAY)
  AND R.startDate >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)
  AND R.isActive = 1
  AND S.isActive = 1
  AND CSR.status = 0
  AND CSR.isActive = 1
  AND CTR.isActive = 1
  AND R.<ADMINID>

GROUP BY CTR.teacherId
