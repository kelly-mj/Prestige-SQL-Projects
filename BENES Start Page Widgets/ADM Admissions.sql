-- Current Enrolled Students for Monthly Billing
-- Author: ??  | ??/??/????
-- 9/10/18 Kelly Update: Added rows for Active Lead, Current LOA, Leads per month for past 3 months

-- Active Leads
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=231&type=spquery">Active Leads (link to leads per stage):</a>'
	, COUNT(DISTINCT C.contactId) 'Count'
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
-- using types #1-9 (NOT Lost contacts)


UNION	-- Leads existing before start of the month
SELECT CONCAT('Leads at beginning of ', DATE_FORMAT(CURDATE(), '%M'), ': ')
	, COUNT(C.contactId)
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) <= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
	AND C.<ADMINID>


UNION	-- Leads added since first day of month
SELECT CONCAT('Leads added in ', DATE_FORMAT(CURDATE(), '%M'), ': ')
	, COUNT(C.contactId)
FROM Contacts C
WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
	AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
	AND C.<ADMINID>


UNION	-- Leads won/lost in current month
SELECT CONCAT('Leads <strong><span style="color: green;">won</span>/<span style="color: red;">lost</span></strong> ', DATE_FORMAT(CURDATE(), '%M'), ': ')
	, CONCAT('<strong><span style="color: green;">Won: ', t1.won, '  </span>/  <span style="color: red;">Lost: ', t2.lost, '</span></strong>')
FROM (
	SELECT COUNT(contactId) AS won
	FROM Contacts C
	WHERE C.contactTypeId IN (4000040, 4000043, 4000044, 4000051, 4000045, 4000042, 4000048, 4000047, 4000049)
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
		AND C.<ADMINID>  ) t1
INNER JOIN (
	SELECT COUNT(contactId) AS lost
	FROM Contacts C
	WHERE C.contactTypeId = 4000050
		AND DATE(C.creationDtTm) > LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
		AND C.<ADMINID>  ) t2


/*
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
*/