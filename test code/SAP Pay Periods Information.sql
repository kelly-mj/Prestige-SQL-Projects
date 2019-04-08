-- SAP Period Check
-- use this code to find details about payperiods for each student's SAP period

SELECT R.studentId, R.name, PP1.clockHrs
	, PP1.PPno1, PP1.PPh1, PP1.duedate1
	, PP2.PPno2, PP2.PPh2, PP2.duedate2
	, PP3.PPno3, PP3.PPh3, PP3.duedate3
	, PP4.PPno4, PP4.PPh4, PP4.duedate4

FROM (
	SELECT CONCAT(S.lastName, ', ', S.firstName) AS name, RS.*
    FROM Students S
    INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1
		GROUP BY studentId) RR
		ON RR.studentId = S.studentId
	INNER JOIN Registrations RS ON RS.studentId = S.studentId
		AND RS.registrationId = RR.maxReg
	WHERE S.isActive = 1
    LIMIT 100) R
        
LEFT JOIN (SELECT clockHrs, studentId, payPeriodDate AS dueDate1, payPeriodNo AS PPno1, payPeriodHours AS PPh1, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 1) PP1
        ON PP1.studentId = R.studentId AND PP1.registrationId = R.registrationId

LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate2, payPeriodNo AS PPno2, payPeriodHours AS PPh2, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 2) PP2
	ON PP2.studentId = R.studentId AND PP2.registrationId = R.registrationId

LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate3, payPeriodNo AS PPno3, payPeriodHours AS PPh3, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 3) PP3
	ON PP3.studentId = R.studentId AND PP3.registrationId = R.registrationId

LEFT JOIN (SELECT studentId, payPeriodDate AS dueDate4, payPeriodNo AS PPno4, payPeriodHours AS PPh4, registrationId FROM PayPeriodDates WHERE isActive = 1 AND payPeriodNo = 4) PP4
	ON PP4.studentId = R.studentId AND PP4.registrationId = R.registrationId