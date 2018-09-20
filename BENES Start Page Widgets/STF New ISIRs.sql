-- New ISIR (Start Page Query)

-- Created by: ??
-- Edited by Kelly MJ 
-- Updated: 06/29/2018
   -- Omitted any students whose applications have already been processed (identified by 'Enrolled Students' whose records haven't been updated)

SELECT CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(ST.studentId AS CHAR), '">', ST.firstName, ' ', ST.lastName, '</a>') AS 'Student Name', idNumber AS 'Student ID', 
               ST.creationDtTm AS 'Creation Date' 
FROM Students ST
     LEFT OUTER JOIN Registrations REG ON REG.studentId  =  ST.studentId 
     LEFT OUTER JOIN IsirInstance INS  ON REG.studentId = INS.studentId
WHERE ST.<ADMINID> AND REG.programmeId IS NULL 
      AND firstName = BINARY UPPER(firstName) 
      AND lastName = BINARY UPPER(lastName)
      AND DATE(ST.creationDtTm) BETWEEN (CURDATE() - INTERVAL 7 DAY) AND CURDATE()
      AND ST.creationDtTm = ST.lastUpdateDtTm      -- only includes records which haven't been updated
ORDER BY lastName
