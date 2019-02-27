-- Created by ?? on ??
-- Edited by Kelly MJ
-- Kelly MJ 6/27/2018: Reformatted; added comments
-- Kelly MJ 2/27/2019: Re-wrote to use joins instead of subqueries

SELECT CONCAT('<a target="_blank" href="https://usta.orbund.com/einstein-freshair/student_account_ledger.jsp?studentId=', CAST(SL.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Student
   , (SELECT P.programmeName FROM Programmes P WHERE P.programmeId = R.programmeId) AS 'Program'
   , SL.balance
   , DATE_FORMAT(SL.billingDate, '%m/%d/%Y') AS 'Billing Date'
   , DATE_FORMAT(DATE_ADD(SL.billingDate, INTERVAL 14 DAY), '%m/%d/%Y') AS 'Due Date'
FROM StudentLedger SL
INNER JOIN (SELECT studentId, MAX(itemNo) AS maxItem FROM StudentLedger WHERE billingDate <= CURDATE() GROUP BY studentId) SLL
   ON SLL.studentId = SL.studentId AND SLL.maxItem = SL.itemNo
INNER JOIN (SELECT DISTINCT studentId, firstName, lastName FROM Students) S ON S.studentId = SL.studentId
INNER JOIN (SELECT MAX(registrationId) AS maxReg, studentId FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
   ON RR.studentId = SL.studentId
INNER JOIN Registrations R ON R.studentId = SL.studentId
   AND R.registrationId = RR.maxReg

WHERE SL.<ADMINID>
AND SL.balance < -0.01
GROUP BY SL.studentId
LIMIT 1000
