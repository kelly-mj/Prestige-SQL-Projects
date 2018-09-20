-- Written by: ??
-- 6/8/2018 Update (Kelly)
   -- Now accounts for 'Daily' or 'Hourly' surcharges
   -- Logic: code calculates average of lesson durations for each student, then divides overall excess hours by the average to find the number of 
        -- 'days' the student has missed.
-- 8/10/2018 Update (Kelly)
   -- Removed Career Pathways students from the list
   -- Uses absolute max grad date for each students (in case of students with multiple registrations)
   -- Moved 'End Date' to second column position
   -- Rolled surcharge type and rate columns into one column

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS Name
,  P.programmeName AS 'Program'
,  R.Enddate AS 'End Date'
,  ROUND(SUM(A.duration)) AS 'Total Hours At End Date'
,  P.MinClockHours AS 'Program Total'
-- ,  P.overContactAmount AS 'Hours Surcharge'
,  CASE WHEN P.overContactType LIKE 'Hourly'
          THEN CONCAT(ROUND((P.MinClockHours)-(SUM(A.duration)), 1), ' hours<br>Rate:   $', P.overContactAmount, '/hr')
        WHEN P.overContactType LIKE 'Daily'
          THEN CONCAT(ROUND((ROUND((P.MinClockHours)-(SUM(A.duration))) / CS.lessonDur), 1), ' days<br>Rate:   $', P.overContactAmount, '/day')
   END AS 'Surcharge Time/Rate' 
   
,  CASE WHEN P.overContactType LIKE 'Hourly' 
          THEN CONCAT('$',ROUND((ROUND((P.MinClockHours)-(SUM(A.duration))) * P.overContactAmount), 2))
        WHEN P.overContactType LIKE 'Daily'
          THEN CONCAT('$', ROUND(((ROUND((P.MinClockHours)-(SUM(A.duration))) * P.overContactAmount)/CS.lessonDur), 2))
   END AS 'Total'

FROM Attendance A

INNER JOIN Registrations    R 
ON A.studentId = R.studentId AND  R.isActive = 1

INNER JOIN (
    SELECT R.studentId
        , MAX(R.endDate) AS endDate
    FROM Registrations R
    GROUP BY R.studentId) MAXREG
ON MAXREG.studentId = A.studentId
AND MAXREG.endDate = R.endDate

INNER JOIN Programmes       P 
ON R.programmeId = P.programmeId AND  P.isActive = 1

INNER JOIN Students         S 
ON R.studentId = S.studentId AND S.isactive = 1

INNER JOIN (
  SELECT CSR.studentId
    , C.classId
    , SUM(C.lessonDuration)/COUNT(C.lessonDuration) AS lessonDur
  FROM ClassStudentReltn CSR
  INNER JOIN Classes C
  ON C.classId = CSR.classId
  GROUP BY CSR.studentId
  ) CS
ON CS.studentId = S.studentId

INNER JOIN (SELECT S.StudentID AS Student 
            FROM Attendance A 
            INNER JOIN  Registrations R 
              ON A.studentId = R.studentId 
      INNER JOIN (
        SELECT R.studentId
          , MAX(R.endDate) AS endDate
        FROM Registrations R
        GROUP BY R.studentId) MAXREG
      ON MAXREG.studentId = A.studentId AND MAXREG.endDate = R.endDate
            INNER JOIN Students        S 
              ON R.studentId = S.studentId 
              AND S.isactive = 1
            INNER JOIN Programmes       P 
              ON R.programmeId = P.programmeId
              AND  P.isActive = 1
              AND  R.isActive = 1
            WHERE A.attendanceDate >= R.enddate 
              AND R.regStatus not like '3' 
              AND R.regStatus not like '0'   
              AND P.programmename Not like ('Care%%') 
              AND P.programmename Not like ('Instructor Training')
            Group BY S.studentID
        ) as late 
ON R.studentId = late.Student
 
WHERE
    R.enrollmentSemesterId = 4000441
    AND R.regStatus not like '3' 
    AND R.regStatus not like '0'
    AND A.attendancedate <= R.enddate
    AND A.subjectId IN (SELECT GSR.subjectId
            FROM CourseGroups CGP
            INNER JOIN GroupSubjectReltn GSR
              ON CGP.courseGroupId=GSR.courseGroupId
              AND GSR.isActive=1
            WHERE R.programmeId = CGP.programmeId 
              AND CGP.isActive=1)
                                        
    AND A.classId IN (SELECT DISTINCT CRS.classId
            From ClassStudentReltn CRS
            Where CRS.studentId = A.studentId AND CRS.isActive=1)
  AND A.<ADMINID>

GROUP BY late.Student
ORDER BY S.firstName
