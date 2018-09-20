-- Student Information by Registration Date
-- Author: Kelly MJ  |  08/24/2018
-- Displays contact/payment/course information for students who enrolled during the user-entered date range

SELECT
	DISTINCT S.idNumber AS 'Student ID'
	, CONCAT(S.firstName, ' ', S.lastName) AS 'Student Name'
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
	, NULL AS 'Total Inst. Charges Charged'
	, NULL AS 'Total  Inst. Charges Paid'

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

WHERE S.<ADMINID>
GROUP BY S.studentId