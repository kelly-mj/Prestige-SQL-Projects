-- Query 1: Select RECIPIENT and RECIPIENT_EMAIL
-- Selects students who were clocked in on the current day
SELECT userId AS '[RECIPIENT_ID]', 
	   email AS '[RECIPIENT_EMAIL]'
FROM ClockPunches CP
INNER JOIN Students ST ON CP.userId = ST.studentId 
WHERE ST.<ADMINID> AND 
              ST.isActive = 1 AND 
	      DATE(CP.punchTime) = CURDATE()
GROUP BY userId 


-- Query 2: Produce report, using RECIPIENT and RECIPIENT_EMAIL as arguments
-- Displays a count of the student's services
   SELECT StudentName AS 'Student Name', 
		  Service AS Service, 
		  CONCAT('<DIV align="right">', ROUND(SUM(serviceUnit), 0),'</DIV>') AS 'Count'
   FROM StudentService
   WHERE  ServiceDateTime = CURDATE() AND StudentID = [RECIPIENT_ID] AND <ADMINID> 
   GROUP BY StudentID, Service
UNION
   SELECT '  ',
		  '  ',
		  CONCAT('<b><DIV align="right">','Total Service:', '    ', CAST(t2.cService AS CHAR),'</DIV></b>')
   FROM (SELECT StudentID AS SID, 
                                StudentName AS SName, 
				Service AS service,  
				ROUND(SUM(serviceUnit), 0) AS cService
		 FROM StudentService
		 WHERE  ServiceDateTime = CURDATE() AND StudentID = [RECIPIENT_ID] AND <ADMINID> 
		 GROUP BY StudentName) AS t2