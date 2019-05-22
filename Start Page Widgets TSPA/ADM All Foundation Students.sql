-- TSPANY All Active Foundation Students
-- 5/13/19 Kelly MJ: Removed TeamLeader join, added requirement for team name like Cos PT/FT Foundations

SELECT DISTINCT
  CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(STD.studentId AS CHAR), '">', STD.lastName, ', ', STD.firstName, '</a>') AS 'Student Name',
  PVF.fieldValue AS Team,
  CLS.className
FROM ProfileFieldValues PVF
  INNER JOIN Students STD ON PVF.userId = STD.studentId
  INNER JOIN Registrations REG ON REG.studentId = STD.studentId
  /*
  INNER JOIN (SELECT
      PVF.userType AS UT,
      PVF.userId,
      PVF.fieldValue AS FV
    FROM ProfileFieldValues PVF
    WHERE PVF.userType = 3) TeamLeader ON TeamLeader.FV = PVF.fieldValue
    */
  INNER JOIN ClassStudentReltn ON STD.studentId = ClassStudentReltn.studentId
  INNER JOIN Classes CLS ON ClassStudentReltn.classId = CLS.classId
WHERE PVF.fieldName = 'TEAM_NAME'
AND PVF.fieldValue LIKE '%Cos%Foundations%'
AND PVF.userType <> 3
AND REG.isActive = 1
AND STD.isActive = 1
AND CLS.className LIKE '%found%'
AND ClassStudentReltn.isActive = 1
AND PVF.<ADMINID>
GROUP BY STD.lastName,
         STD.firstName,
         CLS.className
ORDER BY CLS.className
