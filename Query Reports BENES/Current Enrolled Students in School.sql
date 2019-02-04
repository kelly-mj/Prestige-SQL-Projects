-- 1. Current Enrolled Students in School
-- Author: Kelly MJ    |    Creation date: 7/20/18
-- Allows user to select date range, then displays students who were enrolled during that date range.

SELECT 'Student Count: ' AS 'Student ID'          -- student ID
     , COUNT(S.idNumber) AS 'Name' -- student name
     , NULL AS 'Program Name'              -- program name
     , NULL AS 'Contract Start Date - End Date'                  -- start to graduation dates
     
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
  AND R.startDate <= '[?End Date]'                         -- start date
  AND RA.endDate > '[?Start Date]'                         -- end date

UNION

(SELECT DISTINCT S.studentId 'Student ID'           -- student ID
     , CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.firstName AS CHAR), ' ', CAST(S.lastName AS CHAR), '</a>') AS Name -- student name
     , P.programmeName 'Program Name'              -- program name
     , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(RA.endDate, "%m/%d/%Y")) 'Contract Start Date - End Date'
     
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
  AND R.startDate <= '[?End Date]'
  AND RA.endDate > '[?Start Date]'
       
ORDER BY R.startDate ASC)
