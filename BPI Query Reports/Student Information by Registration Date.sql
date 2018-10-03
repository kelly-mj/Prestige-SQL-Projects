-- Student Information by Registration Date
-- Author: Kelly MJ  |  08/24/2018
-- Displays contact/payment/course information for students who enrolled during the user-entered date range

SELECT
	DISTINCT S.idNumber AS 'Student ID'
	, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', UPPER(SUBSTRING(S.lastName, 1, 1)), LOWER(SUBSTRING(S.lastName, 2, 100)), ', ', UPPER(SUBSTRING(S.firstName, 1, 1)), LOWER(SUBSTRING(S.firstName, 2, 100)), '</a>') AS 'Student Name'
	, S.email AS 'Email'
	, CONCAT(S.address, ', ', S.city, ', ', S.state, ', ', S.zip) AS 'Mailing Address'
	, CONCAT(S.address, ', ', S.city, ', ', S.state, ', ', S.zip) AS 'Address at Time of Enrollment'
	, CONCAT(S.address, ', ', S.city, ', ', S.state, ', ', S.zip) AS 'Home Address'
	, DATE_FORMAT(R.registrationDate, '%m/%d/%Y') AS 'Registration Date'
	, P.programmeName AS 'Course'
	, CONCAT('$', PTR.rate) AS 'Course Cost'
	, NULL AS 'Amount of STRF Assessment'
	, NULL AS 'Qtr Remitted to BPPE'
	, NULL AS 'Third Party Payer Identifying Info'
	, CONCAT('$', FORMAT(COALESCE(CH.total, 0), 2)) AS 'Total Inst. Charges Charged'
	, CONCAT('$', FORMAT(COALESCE(PAID.total, 0), 2)) AS 'Total  Inst. Charges Paid'

FROM Students S

INNER JOIN Registrations R
ON R.studentId = S.studentId
AND R.registrationDate >= '[?Start Date]'
AND R.registrationDate <= '[?End Date]'

INNER JOIN Programmes P
ON P.programmeId = R.programmeId
AND P.isActive = 1

INNER JOIN ProgrammeLevelTuitionRates PTR
ON PTR.programmeId = P.programmeId
AND PTR.levelId = P.levelId

-- sum of charges per student in date range
LEFT JOIN (
	SELECT studentId, SUM(amountPayable) AS total
    FROM OutstandingPayments
    WHERE dueDate >= '[?Start Date]' AND dueDate <= '[?End Date]'
    GROUP BY studentId) CH
ON CH.studentId = S.studentId

-- sum of payments made by students
LEFT JOIN (
	SELECT studentId, SUM(paymentAmount) AS total
	FROM Payments
	WHERE paymentDate >= '[?Start Date]' AND paymentDate <= '[?End Date]'
	AND isActive = 1
	GROUP BY studentId) PAID
ON PAID.studentId = S.studentId

-- OLD PAYMENT/CHARGE INFORMATION
/*
LEFT JOIN (
	SELECT studentId, SUM(amount) AS totalCharges
	FROM BillingJournal
	WHERE programmeId <> 11
	AND billDate >= '[?Start Date]' AND billDate <= '[?End Date]'
	GROUP BY studentId) BJ
	ON BJ.studentId = S.studentId

LEFT JOIN (
	SELECT studentId, SUM(paymentAmount) AS totalPayments
	FROM Payments
	WHERE isActive = 1
	AND paymentDate >= '[?Start Date]' AND paymentDate <= '[?End Date]'
	GROUP BY studentId) PM
	ON PM.studentId = S.studentId
*/
WHERE S.<ADMINID>
-- AND S.isActive = 1
GROUP BY S.studentId
ORDER BY S.lastName