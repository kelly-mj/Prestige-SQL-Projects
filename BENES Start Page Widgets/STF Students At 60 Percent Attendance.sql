-- Scheduled Attendance (Query Report)
-- Author: Kelly MJ   |   7/26/2018
    -- Lists students who are at 60% attendance or lower
-- 7/27/2018: Added start date, ordered by percentage, changed admin filter (super admins can see all students)
-- 8/09/2018: Changed scheduled hours from calculation to PFV value; omitted Career Pathways students


SELECT null 'Campus Name'
  , CONCAT("Campus: ", CASE WHEN SA.campusCode = 34652 THEN 'New Port Richey'
          WHEN SA.campusCode = 34601 THEN 'Brooksville'
            WHEN SA.campusCode = 34606 THEN 'Spring Hill'
            ELSE 'All campuses'
    END) 'Student Name'
   , null 'Program'
   , null 'Percent Attended'
   -- , null 'HRS - ATT/SCH'
   , null 'Start Date'
FROM SubAdmins SA
WHERE SA.subAdminId = [USERID]
AND SA.<ADMINID>

UNION


(SELECT t1.campus
      , t1.name
      , t1.program
      , CONCAT(t1.percent, '%')
      -- , t1.breakdown
      , t1.startDate

FROM (
  SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CONCAT(UCASE(SUBSTRING(S.lastName, 1, 1)),LCASE(SUBSTRING(S.lastName, 2)),", ",CONCAT(UCASE(SUBSTRING(S.firstName, 1, 1)),LCASE(SUBSTRING(S.firstName, 2)))), '</a>') 'Name'  -- Name (link)
       , P.programmeName 'Program' -- Program name
       , ROUND( 100*(SUM(A.duration)/PFV.fieldValue), 0 ) 'percent'                                             -- Percentage (numerical)
       , CONCAT(FORMAT(SUM(A.duration), 0), ' / ', FORMAT(PFV.fieldValue, 0)) AS breakdown
       , DATE_FORMAT(R.startDate, '%m/%d/%Y') AS startDate
       , PFV.fieldValue AS ih
       , CASE WHEN S.studentCampus = 34652 THEN 'New Port Richey'
              WHEN S.studentCampus = 34601 THEN 'Brooksville'
              WHEN S.studentCampus = 34606 THEN 'Spring Hill'
         END AS campus

  FROM Registrations R
     
  INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate
              FROM Registrations
              GROUP BY studentId) R2
    ON R2.studentId = R.studentId
    AND R2.maxDate = R.startDate

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

  INNER JOIN ProfileFieldValues PFV
          ON PFV.userId = R.studentId
         AND PFV.fieldName = 'PROGRAM_HOURS_SCHEDULED'

  INNER JOIN ClassStudentReltn CSR
  ON CSR.classId = C.classId
  AND CSR.isActive = 1
  AND R.studentId = CSR.studentId

  INNER JOIN Programmes P
  ON P.programmeId = R.programmeId

  INNER JOIN Students S
  ON R.studentId = S.studentId
  AND S.isActive = 1

  WHERE R.isActive = 1
  AND CASE WHEN (SELECT campusCode from SubAdmins WHERE subAdminId = [USERID]) != 0     -- when user has a specific campus, only display students from that campus
           THEN R.studentCampus = (SELECT campusCode from SubAdmins WHERE subAdminId = [USERID])
           ELSE R.studentCampus != -1        -- for super admins without a campus, display all students in the school
      END
  AND R.<ADMINID>
  AND S.firstName NOT IN ('Test', 'TEST', 'test')
  AND S.lastName NOT IN ('Test', 'TEST', 'test')

  GROUP BY R.registrationId
  ORDER BY campus, R.programmeId, percent ASC
) t1
WHERE t1.percent <= 60)