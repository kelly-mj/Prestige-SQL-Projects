-- Created by ?? on ??
-- Edited by Kelly MJ
-- Update: 6/27/2018
   -- Improved formatting; added comments
   -- Added filter so only active students are displayed

SELECT Distinct
    CONCAT('<a href="student_account_ledger.jsp?studentId=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.firstName AS CHAR), ' ',   CAST(SDT.lastName AS CHAR), '</a>') AS Name
  , (SELECT programmeName
     FROM Programmes 
     WHERE programmeId = R.programmeId) as 'PROGRAM'
  , ROUND((SELECT balance From StudentLedger 
           WHERE studentId =SAL.studentId
           AND registrationId = SAL.registrationId
           AND itemNo = ITEM.itemNo ), 2) as 'Balance'
  , DATE_FORMAT((SELECT billingDate 
                 FROM StudentLedger  
                 WHERE studentId =SAL.studentId 
                 AND registrationId = SAL.registrationId 
                 AND itemNo = ITEM.itemNo ), "%m /%d /%Y") as 'BILLING_DATE'
  , DATE_FORMAT((Select DATE_ADD(billingDate, INTERVAL 14 DAY) From StudentLedger  Where studentId =SAL.studentId AND registrationId = SAL.registrationId AND itemNo = ITEM.itemNo ), "%m /%d /%Y") as 'DUE DATE'

FROM StudentLedger SAL 

INNER JOIN  Registrations R
ON R.registrationId = SAL.registrationId
AND R.studentId = SAL.studentId
AND R.regStatus = 1
And R.isActive = 1

INNER JOIN  Students SDT
ON SDT.studentId = SAL.studentId
AND SDT.isActive = 1

INNER JOIN 
			( SELECT registrationId, MAX(itemNo) 'itemNo'
			  FROM StudentLedger
			  WHERE billingDate <= CURDATE() 
			  GROUP BY registrationId
			) ITEM
ON SAL.registrationId = ITEM.registrationId

WHERE SAL.<ADMINID>
HAVING Balance < 0 
