-- FOR SCHOOLS WITH A SINGLE CAMPUS - TO ADD CAMPUS COLUMN, COPY CODE FROM A SCHOOL WITH MULTIPLE CAMPUSES
-- 1. Current Enrolled Students in School
-- Author: Kelly MJ    |    Creation date: 7/20/18
-- Allows user to select date range, then displays students who were enrolled during that date range.

SELECT t1.idNumber 'Student ID'                     -- student ID
     , t1.Name                                      -- student name
     , t1.programmeName 'Program Name'              -- program name
     , IF(t1.status = 1, 'Enrolled', t1.statusName) 'Status'
     , t1.dateRange 'Contract Start Date - Actual End Date'
     -- , '[?Start Date]', '[?End Date]'            -- no idea why, but including this line makes the date selection work properly

FROM (
  -- currently active students
  SELECT DISTINCT S.idNumber
       , CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name -- student name
       , P.programmeName
       , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  N/A') AS dateRange
       , S.isActive AS status
       , SS.statusName
       , S.lastName
       
  FROM Students S
  INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
  INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate AND R.isActive = 1 AND R.regStatus = 1 AND R.startDate <= '[?End Date]'
  INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
  INNER JOIN StatusSequences SS ON SS.statusId = S.isActive AND SS.<ADMINID>  -- active status codes have adminid=48

  WHERE S.isActive = 1
    AND S.<ADMINID>
    

  -- students who have graduated/dropped within the current period
  UNION
  SELECT DISTINCT S.idNumber
       , CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', CAST(S.lastName AS CHAR), ', ', CAST(S.firstName AS CHAR), '</a>') AS Name -- student name
       , P.programmeName
       , CONCAT(DATE_FORMAT(R.startDate, "%m/%d/%Y"), '  -  ', DATE_FORMAT(R.graduationDate, "%m/%d/%Y")) dateRange
       , S.isActive AS status
       , SS.statusName
       , S.lastName

  FROM Students S
  INNER JOIN ( SELECT studentId, MAX(startDate) AS maxDate FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
  INNER JOIN Registrations R ON R.studentId = S.studentId AND R.startDate = RR.maxDate AND R.isActive = 1
  INNER JOIN Programmes P ON P.programmeId = R.programmeId AND P.isActive = 1
  INNER JOIN StatusSequences SS ON SS.statusId = S.isActive AND SS.<ADMINID>  -- active status codes have adminid=48

  WHERE S.isActive IN (0, 3)
    AND S.<ADMINID>
    AND R.graduationDate BETWEEN '[?Start Date]' AND '[?End Date]'
    AND R.startDate <= '[?End Date]'
) t1

ORDER BY t1.lastName