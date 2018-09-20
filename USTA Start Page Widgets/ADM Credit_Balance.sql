SELECT Distinct
CONCAT('<a href="student_account_ledger.jsp?studentId=', CAST(SDT.studentId AS CHAR), '">', CAST(SDT.firstName AS CHAR), ' ', CAST(SDT.lastName AS CHAR), '</a>') AS Name,
(SELECT programmeName FROM Programmes Where programmeId = R.programmeId) as 'PROGRAM',
ROUND((Select balance From StudentLedger  Where studentId =SAL.studentId AND registrationId = SAL.registrationId AND itemNo = ITEM.itemNo ),2) as 'Balance',
DATE_FORMAT((Select billingDate From StudentLedger  Where studentId =SAL.studentId AND registrationId = SAL.registrationId AND itemNo = ITEM.itemNo ), "%m /%d /%Y") as 'BILLING_DATE', 
DATE_FORMAT((Select DATE_ADD(billingDate, INTERVAL 14 DAY) From StudentLedger  Where studentId =SAL.studentId AND registrationId = SAL.registrationId AND itemNo = ITEM.itemNo ), "%m /%d /%Y") as 'DUE DATE'

From StudentLedger SAL 
INNER JOIN  Registrations R ON R.registrationId = SAL.registrationId AND R.studentId = SAL.studentId
INNER JOIN  Students SDT ON SDT.studentId = SAL.studentId
INNER JOIN 
      (
      SELECT registrationId, MAX(itemNo) 'itemNo'
      From StudentLedger
      Where billingDate <= CURDATE() 
      Group By registrationId
      ) ITEM ON SAL.registrationId = ITEM.registrationId
Where SAL.<ADMINID>
HAVING Balance < 0 