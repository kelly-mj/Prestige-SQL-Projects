-- New All school - Active Enrollment
-- Modified 2019-04-30 Bern Original SQL was not pulling the correct counts, so I took the SQL from "Current Enrolled Students in School for Monthly Billing" widget and modified for this widget by
-- adding count for teachers and calc for ratio
-- removed LOA filtering so this widget will include LOA students
-- left original SQL code for reference (after new code)
-- Kelly MJ 2019-05-31: added requirements CSR.isActive = 1 and CSR.status = 0 (exclude students without active class enrollment)
-- Kelly MJ 2019-06-08: added requirement R.startDate <= CURDATE(); removed original SQL code (prev. commented out)

SELECT
    C.campusName,
  COUNT(DISTINCT S.studentId) AS 'Students',
  COUNT(DISTINCT CTR.teacherId) AS "Teachers",
  FORMAT(COUNT(DISTINCT CSR.studentId) / COUNT(DISTINCT CTR.teacherId), 1) AS "Ratio"
FROM Registrations R
  INNER JOIN Students S ON R.studentId = S.studentId
  INNER JOIN Programmes P ON P.programmeId = R.programmeId
  INNER JOIN ClassStudentReltn CSR ON R.registrationId = CSR.registrationId
  INNER JOIN ClassTeacherReltn CTR ON CSR.classId = CTR.classId
  INNER JOIN Campuses C ON S.studentCampus = C.campusCode
WHERE S.isActive = 1
AND R.regStatus = 1
AND R.startDate <= CURDATE()
AND R.isActive = 1
AND P.isActive = 1
AND S.firstName NOT LIKE '%test%'
AND S.<ADMINID>
AND CSR.isActive = 1
AND CSR.status = 0
GROUP BY C.campusCode
