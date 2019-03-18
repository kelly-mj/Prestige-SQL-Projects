-- 1. Current Enrolled Students in School
-- Author: Kelly MJ    |    Creation date: 7/20/18
-- Allows user to select date range, then displays students who were enrolled during that date range.
-- Kelly MJ 3/18/19 : Major changes to widget
   -- "Enrolled Students" are any students with an active registration which was active during any part of the selected date range
   -- "Active Students" are any enrolled students who were not graduated or who reached the end of the selected period with an LOA status (ie. had no graduation date by the end date and were not on LOA during the end date)
   -- "LOA Students" are any enrolled students who reached the end of the selected period with an LOA status (ie. are not graduated or have not finished their LOA by the selected end date)
   -- "Graduated Students" are any enrolled students who graduated during the selected date range


/* Displays count of enrolled students in each program */
SELECT NULL AS 'Student ID'  -- student ID
     , CONCAT('Student Count in ', UPPER(P.programmeName)) AS 'Name' -- student name
     , COUNT(S.idNumber) AS 'Program Name'                  -- program name
     , NULL AS 'Contract Start Date - End Date'             -- contracted start to end dates
     , NULL AS 'Grad/LOA/Withdraw Date'

FROM Students S
   , Registration R
   , Programmes P

WHERE S.studentId = R.studentId
  AND P.programmeId = R.programmeId
  AND R.registrationId = (SELECT MAX(RR.registrationId) FROM Registrations RR WHERE RR.studentId = S.studentId AND RR.isActive = 1 GROUP BY RR.studentId)
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]')) AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive = 1
  AND R.startDate <= '[?End Date]'
  AND (R.graduationDate > '[?Start Date]' OR R.graduationDate IS NULL)
GROUP BY P.programmeId


-- Displays counts of total enrolled students
UNION
SELECT '<strong>Active Students</strong>'
     , CONCAT('<strong>Active Enrolled Student Count: ', COUNT(S.idNumber), '</strong>')
     , NULL
     , NULL
     , NULL

FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA

FROM Students S
 , Registrations R
 , Programmes P

WHERE S.studentId = R.studentId
  AND R.registrationId = (SELECT MAX(RR.registrationId) FROM Registrations RR WHERE RR.studentId = S.studentId AND RR.isActive = 1 GROUP BY RR.studentId)
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
    						  WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                            AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND R.startDate <= '[?End Date]'           -- Was student enrolled during given date range?
  AND (R.graduationDate > '[?Start Date]' OR R.graduationDate IS NULL)


/* Displays list of students: Name, Program Name and Contract Start and End Dates */
UNION
(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(R.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     , NULL, S.isActive, R.regStatus

FROM Students S
   , Registrations R
   , Programmes P

WHERE S.studentId = R.studentId
  AND R.registrationId = (SELECT MAX(RR.registrationId) FROM Registrations RR WHERE RR.studentId = S.studentId AND RR.isActive = 1 GROUP BY RR.studentId)
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
						  WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND R.startDate <= '[?End Date]'
  AND (R.graduationDate > '[?Start Date]' OR R.graduationDate IS NULL)

ORDER BY S.lastName, R.startDate ASC)    -- end active students


/* Count of LOA students */
UNION
(SELECT '<div><strong>LOA Students</strong></div>'
    , CONCAT('<div><strong>Number of students on LOA during this period: ', COUNT(S.studentId), '</strong></div>')
    , null
    , null
    , '<div><strong>Date of LOA</strong></div>'

FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
   , LeavesOfAbsence LOA

WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                 -- student ID criteria
  AND LOA.studentId = S.studentId                                              -- LOA join
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- include only LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive = 12
  AND R.startDate <= '[?End Date]'
  AND RA.endDate > '[?Start Date]')


/* LOA Student List */
UNION
(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(RA.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     , CONCAT(DATE_FORMAT(LOA.leaveDate, "%m/%d/%Y"), ' - ', COALESCE(DATE_FORMAT(LOA.returnDate, "%m/%d/%Y"), 'Current'))

FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
   , LeavesOfAbsence LOA

WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                 -- student ID criteria
  AND LOA.studentId = S.studentId                                              -- LOA join
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- include only LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive = 12
  AND R.startDate <= '[?End Date]'
  AND RA.endDate > '[?Start Date]'

ORDER BY S.lastName, R.startDate ASC)   -- end LOA

/* Count of graduated/withdrawn students */
UNION
(SELECT '<div><strong>Graduated/Withdrawn Students</strong></div>'
    , CONCAT('<div><strong>Number of graduated/withdrawn students from this period: ', COUNT(S.studentId), '</strong></div>')
    , NULL
    , NULL
    , '<div><strong>Date of Graduation or Withdrawal</strong></div>'

FROM Students S
   , (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations
      GROUP BY studentId) RR
   , Registrations R
   , Programmes P
   , (SELECT MAX(endDate) AS endDate, studentId FROM Registrations_Audit
      GROUP BY studentId) RA

WHERE S.studentId = RR.studentId AND S.studentId = RA.studentId                 -- student ID criteria
  AND R.studentId = S.studentId AND R.registrationId = RR.maxReg                -- registrations join
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive IN (0, 3)
  AND R.startDate <= '[?End Date]'
  AND R.graduationDate > '[?Start Date]')


/* Grad/Withdrawn student list */
UNION
(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(RA.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     , IF(S.isActive = 3, DATE_FORMAT(DATE(S.lastUpdateDtTm), "%m/%d/%Y (Graduated)"), DATE_FORMAT(DATE(S.lastUpdateDtTm), "%m/%d/%Y (Withdrew)"))

FROM Students S
   , (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations
      GROUP BY studentId) RR
   , Registrations R
   , Programmes P
   , (SELECT MAX(endDate) AS endDate, studentId FROM Registrations_Audit
      GROUP BY studentId) RA

WHERE S.studentId = RR.studentId AND S.studentId = RA.studentId                 -- student ID criteria
  AND R.studentId = S.studentId AND R.registrationId = RR.maxReg                -- registrations join
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive IN (0, 3)
  AND R.startDate <= '[?End Date]'
  AND R.graduationDate > '[?Start Date]'

ORDER BY S.lastName, R.startDate ASC)   -- end Grad/Withdraw
