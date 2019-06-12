-- [TSPA] INS At Risk Students
-- Kelly MJ  |  5/22/2019
-- Displays students who have missed over 65% of their allowed missed hours (program-specific)

SELECT t1.name
	, t1.Program
    , FORMAT(t1.hoursAtt, 2) AS 'Actual Hours'
    , t1.hoursSch AS 'Scheduled Hours'
	, CASE
		WHEN t1.hoursMissed/t1.hoursCutoff >= 0.90
			THEN CONCAT('<span style="color: red;"><strong>', CAST(FORMAT(t1.hoursMissed, 2) AS CHAR), '</strong></span>')
		WHEN t1.hoursMissed/t1.hoursCutoff > 0.75 AND t1.hoursMissed/t1.hoursCutoff < 0.90
			THEN CONCAT('<span style="color: red;">', CAST(FORMAT(t1.hoursMissed, 2) AS CHAR), '</span>')
		ELSE FORMAT(t1.hoursMissed, 2)
		END AS 'Hours Missed'
    , t1.hoursCutoff AS 'Max Allowed Missed Hours'

FROM (

    SELECT CONCAT('<a target="_blank" href="view_class_roster.jsp?classid=', CAST(CS.classId AS CHAR), '&semesterid=4000441">', S.lastName, ', ', S.firstName, '</a>') AS Name
		, CONCAT(S.lastname, ', ', S.firstName) AS names
		, P.programmeName AS Program
        , SUM(A.duration) AS hoursAtt
        , SCH.fieldValue AS hoursSch
        , SCH.fieldValue - SUM(A.duration) AS hoursMissed
        , CS.maxStartTime
        , P.minClockHours
        , CASE
			WHEN P.programmeCode LIKE 'COS1000FT'
				THEN 55
            WHEN P.programmeCode LIKE 'COS1000PT' AND CS.maxStartTime < 1200
				THEN 70
            WHEN P.programmeCode LIKE 'COS1000PT' AND CS.maxStartTime > 1200
				THEN 80
			WHEN P.programmeCode LIKE 'COS1500FT'
				THEN 77
			WHEN P.programmeCode LIKE 'COS1500PT'
				THEN 92
			WHEN P.programmeCode LIKE 'ESTY'
				THEN 28
			WHEN P.programmeCode LIKE 'ESTPT'
                THEN 50
			WHEN P.programmeCode LIKE 'NTECHPT'
                THEN 20
			END AS hoursCutoff
	, S.studentId as a, R.registrationId as b, P.programmeId as c, CS.maxStartTime AS f

	FROM Students S

	INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
		ON RR.studentId = S.studentId

	INNER JOIN Registrations R
		ON R.studentId = S.studentId
		AND R.registrationId = RR.maxReg

	INNER JOIN Programmes P
		ON P.programmeId = R.programmeId

	LEFT JOIN ( SELECT studentId, classId
				FROM ClassStudentReltn
                WHERE isActive = 1 AND status =  0 ) CSR
		ON CSR.studentId = S.studentId

	LEFT JOIN (SELECT classId, teacherId, MAX(startTime) AS maxStartTime FROM ClassSchedules GROUP BY classId) CS
		ON CS.classId = CSR.classId

	LEFT JOIN Attendance A ON A.studentId = S.studentId

	LEFT JOIN ProfileFieldValues SCH
		ON SCH.userId = S.studentId
		AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'

	WHERE S.isActive IN (1, 12)
    AND S.<ADMINID>
	AND A.isActive = 1
	AND A.attendanceDate >= R.startDate
	AND CS.teacherId = [USERID]

	GROUP BY R.registrationId
) t1


WHERE t1.hoursCutoff IS NOT NULL
AND t1.hoursMissed/t1.hoursCutoff >= 0.65

ORDER BY t1.hoursMissed/t1.hoursCutoff DESC
