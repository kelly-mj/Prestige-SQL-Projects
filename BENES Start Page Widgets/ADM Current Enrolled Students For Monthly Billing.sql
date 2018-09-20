-- Current Enrolled Students for Monthly Billing
-- Author: ??  | ??/??/????
-- 9/10/18 Kelly Update: Added rows for Active Lead, Current LOA, Leads per month for past 3 months

SELECT '<strong>Total Enrolled Students (for monthly billing):</strong>' AS 'Type', CONCAT('<strong>', COUNT(Distinct S.studentId), '</strong>') 'Count'
FROM Students S
,Registrations R, Programmes P
WHERE S.isActive = 1
AND S.<ADMINID>
AND R.studentId=S.studentId
AND R.regStatus = 1
AND R.isActive = 1
AND P.isActive = 1
AND P.programmeId = R.programmeId
AND S.studentId Not In (Select Distinct L.studentId From LeavesOfAbsence L WHERE L.isActive = 1 AND (leaveDate < Now() AND (L.returnDate IS NULL OR L.returnDate > NOW())) AND L.<ADMINID>)
AND S.firstName NOT LIKE '%test%'

UNION	-- LOA Students
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=108&type=spquery">Current LOA Students (link to list): </a>' AS 'Type'
	, COUNT(t1.studentId)
FROM (
	SELECT DISTINCT CurrentLOA.studentId AS studentId
	  FROM
      (SELECT STD.StudentID
			, DATEDIFF(CURDATE(), LeaveDate) AS CurrentDiff
		FROM Students STD
		INNER JOIN LeavesOfAbsence LOA 
				ON LOA.studentId = STD.studentId AND LOA.isActive = 1
		INNER JOIN Registrations REG 
				ON REG.StudentID = LOA.studentID 
				AND REG.isactive = 1 
				AND (REG.regstatus = 1 or REG.regstatus = 12)
		INNER JOIN Programmes PRG 
				ON PRG.ProgrammeID = REG.programmeID
		WHERE ReturnDate IS NULL AND STD.<ADMINID>
        GROUP BY STD.StudentID, LastName) AS CurrentLOA
	GROUP BY CurrentLOA.studentId) t1

UNION	-- Active Leads
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=231&type=spquery">Active Leads (link to counts by category):</a>'
	, COUNT(DISTINCT C.contactId)
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
-- using types #1-9 (NOT Lost contacts)

UNION	-- Leads from the previous month
SELECT CONCAT('Leads from ', DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), "%M"), ': ')
	, COUNT(C.contactId)
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), "%Y-%m-01")
	AND DATE(C.creationDtTm) < DATE_FORMAT(CURDATE(), "%Y-%m-01")
	AND C.<ADMINID>

-- UNION	-- Leads from 2 months ago
UNION	-- Leads from the previous month
SELECT CONCAT('Leads from ', DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), "%M"), ': ')
	, COUNT(C.contactId)
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), "%Y-%m-01")
	AND DATE(C.creationDtTm) < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), "%Y-%m-01")
	AND C.<ADMINID>

-- UNION	-- Leads from 3 months ago
UNION	-- Leads from the previous month
SELECT CONCAT('Leads from ', DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 MONTH), "%M"), ': ')
	, COUNT(C.contactId)
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 MONTH), "%Y-%m-01")
	AND DATE(C.creationDtTm) < DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), "%Y-%m-01")
	AND C.<ADMINID>