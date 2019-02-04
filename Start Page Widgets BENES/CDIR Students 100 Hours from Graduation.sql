-- BENES CDIR Students 100 Hours from Graduation
-- Kelly MJ  |  12/20/2018
-- original made 7/19/2017

SELECT t1.Name
  , t1.Campus
  , t1.Program
  , FORMAT(t1.PH, 0) 'Pgm Hours'
  , FORMAT(t1.HA, 2) 'Actual Hours'
  , FORMAT(t1.PH - t1.HA, 2) 'Remaining' 

FROM (
  SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
    , CASE S.studentCampus
      WHEN 34652 THEN 'NPR'
      WHEN 34601 THEN 'BKS'
      WHEN 34606 THEN 'SH'
      END AS Campus
    , P.programmeName AS Program
    , ROUND(SUM(A.duration), 2) AS HA -- hours attended
    , ROUND(P.minClockHours, 0) AS PH -- program hours

  FROM Students S

  INNER JOIN (
    SELECT studentId, MAX(startDate) AS maxDate FROM Registrations
    WHERE isActive = 1 AND programmeId NOT IN ( SELECT programmeId FROM Programmes WHERE programmeName LIKE '%career%' ) AND regStatus = 1
      GROUP BY studentId) RR
    ON RR.studentId = S.studentId

  INNER JOIN Registrations R
    ON R.studentId = S.studentId
    AND R.startDate = RR.maxDate
    AND R.isActive = 1 AND R.regStatus = 1

  INNER JOIN Programmes P
    ON P.programmeId = R.programmeId

  INNER JOIN Attendance A
    ON R.studentId = A.studentId
    AND A.isActive = 1
    AND A.attendanceDate >= R.startDate

  INNER JOIN Classes C
    ON C.classId = A.classId
    AND C.startDate <= CURDATE() and C.endDate >= CURDATE()
    AND C.isActive = 1
    AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
              WHERE CG.programmeId=R.programmeId AND CG.isActive=1
              AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)

  INNER JOIN ClassStudentReltn CSR
    ON CSR.classId = C.classId
    AND CSR.isActive = 1
    AND R.studentId = CSR.studentId

  WHERE S.<ADMINID>
  AND S.isActive = 1
  AND S.studentCampus IN ( SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID] )

  GROUP BY S.studentId
) t1

WHERE t1.PH - t1.HA <= 100

ORDER BY Campus, (t1.PH - t1.HA)