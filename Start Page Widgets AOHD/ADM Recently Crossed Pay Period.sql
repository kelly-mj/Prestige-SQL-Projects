-- [AOHD] ADM Recently Crossed Pay Period
-- Kelly MJ  |  6/19/2019
-- Displays a list of students who have recently crossed a pay period (determined by attended hours)
-- Students persist on this widget for one week (approx. by his/her weekly program hours requirements)

SELECT t1.Name
	, t1.Campus
	, t1.Program
	, t1.attHours

FROM (
	SELECT S.studentId
		, CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
        , S.lastName
		, CAST(HOURS.fieldValue AS decimal(6, 2)) AS attHours
		, P.programmeName AS Program
		, P.reqClockHour
		, CMP.campusName AS Campus

	FROM Students S

	INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
		ON RR.studentId = S.studentId

	INNER JOIN Registrations R ON R.studentId = S.studentId
		AND R.registrationId = RR.maxReg

	INNER JOIN ProfileFieldValues HOURS ON HOURS.userId = S.studentId
		AND HOURS.fieldName = 'PROGRAM_HOURS_ATTENDED'

	INNER JOIN Programmes P ON P.programmeId = R.programmeId

	INNER JOIN Campuses CMP ON CMP.campusCode = S.studentCampus

	WHERE S.isActive = 1
	-- AND S.<ADMINID>
) t1

WHERE (t1.attHours - t1.reqClockHour - (SELECT MAX(payPeriodHours) FROM PayPeriodDates WHERE studentId = t1.studentId AND payPeriodHours < t1.attHours)) < 5
ORDER BY t1.Campus, t1.lastName
