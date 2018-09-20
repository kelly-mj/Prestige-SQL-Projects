-- 1. Current Enrolled Students in School
-- Author: Kelly MJ    |    Creation date: 7/20/18
-- Allows user to select date range, then displays students who were enrolled during that date range.
-- 8//22/2018 Update:
    -- Now only considers "S.isActive = 1" students as "Currently Enrolled"
    -- Added sections underneath main list to display LOA/Graduated/Withdrawn students who were enrolled for the chosen period

-- Displays counts of total enrolled students
SELECT NULL AS 'Student ID'  -- student ID
     , 'Student Count: '     AS 'Name' -- student name    
     , COUNT(S.idNumber) AS 'Program Name'             -- program name
     , NULL AS 'Contract Start Date - End Date'             -- start to graduation dates    
     , NULL AS 'Grad/LOA/Withdraw Date'
     
FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
      
WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                  -- student ID criteria
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
						  WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]')) AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive = 1
  AND R.startDate <= '[?End Date]'                         -- start date
  AND RA.endDate > '[?Start Date]'                         -- end date

UNION

-- Displays count of student in each program
SELECT NULL
     , CONCAT('Student Count in ', UPPER(P.programmeName))
     , COUNT(S.idNumber)
     , NULL
     , NULL
     
FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
      
WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                  -- student ID criteria
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]')) AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive = 1
  AND R.startDate <= '[?End Date]'                         -- start date
  AND RA.endDate > '[?Start Date]'                         -- end date
GROUP BY P.programmeId

UNION

-- Displays list of students: Name, Program Name and Contract Start and End Dates
(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(RA.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     , NULL
     
FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
      
WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                  -- student ID criteria
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
						  WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive = 1
  AND R.startDate <= '[?End Date]'
  AND RA.endDate > '[?Start Date]'
       
ORDER BY R.startDate ASC)

UNION
-- Count of LOA students
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

UNION

-- LOA Student List
(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(RA.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     , DATE_FORMAT(LOA.leaveDate, "%m/%d/%Y")
     
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
       
ORDER BY R.startDate ASC)

UNION
-- Count of LOA students
(SELECT '<div><strong>Graduated/Withdrawn Students</strong></div>'
    , CONCAT('<div><strong>Number of graduated/withdrawn students from this period: ', COUNT(S.studentId), '</strong></div>')
    , null
    , null
    , '<div><strong>Date of Graduation or Withdrawal</strong></div>'

FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
      
WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                 -- student ID criteria
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive IN (0, 3)
  AND R.startDate <= '[?End Date]'
  AND RA.endDate > '[?Start Date]')

UNION

-- Grad/Withdrawn student list
(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(RA.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     , CASE WHEN S.isActive = 3 THEN CONCAT(DATE_FORMAT(DATE(S.lastUpdateDtTm), "%m/%d/%Y"), '  -  Grad')
          ELSE DATE_FORMAT(DATE(S.lastUpdateDtTm), "%m/%d/%Y")
          END
     
FROM Students S
   , (SELECT REG.studentId, MAX(REG.startDate) AS startDate, REG.programmeId FROM Registrations REG
      GROUP BY REG.studentId) R
   , Programmes P
   , (SELECT MAX(R.endDate) AS endDate, R.studentId FROM Registrations_Audit R
      GROUP BY R.studentId) RA
      
WHERE S.studentId = R.studentId AND S.studentId = RA.studentId                 -- student ID criteria
  AND P.programmeId = R.programmeId                                            -- programme matching
  AND S.studentId NOT IN (SELECT DISTINCT L.studentId FROM LeavesOfAbsence L   -- exclude LOA students
              WHERE L.isActive = 1 AND (leaveDate < '[?Start Date]'
                          AND (L.returnDate IS NULL OR L.returnDate > '[?End Date]'))  AND L.<ADMINID>)
  AND S.<ADMINID>
  AND S.isActive IN (0, 3)
  AND R.startDate <= '[?End Date]'
  AND RA.endDate > '[?Start Date]'
       
ORDER BY R.startDate ASC)