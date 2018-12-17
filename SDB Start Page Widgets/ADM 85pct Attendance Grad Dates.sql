-- SDB ADM Grad Date for Students as 85% Attendance
-- Kelly MJ  |  12/17/2018

SELECT CONCAT(S.lastname, ', ', S.firstName) AS name
	, R.startDate 'Start Date'
    , R.endDate 'Contract End Date'
    , DATE_ADD(R.endDate, INTERVAL (ROUND(0.15*DATEDIFF(R.endDate, R.startDate), 0)) DAY) 'Proj. End Date At 85% Att.'
    , P.programmeName 'Program'
    
FROM Students S

INNER JOIN (
	SELECT studentId, MAX(startDate) AS maxDate
    FROM Registrations WHERE regStatus = 1
    GROUP BY studentId ) RR
    ON RR.studentId = S.studentId

INNER JOIN Registrations R
	ON R.studentId = S.studentId
    AND R.startDate = RR.maxDate
    
LEFT JOIN Programmes P
	ON P.programmeId = R.programmeId
    
WHERE S.isActive = 1
AND S.<ADMINID>