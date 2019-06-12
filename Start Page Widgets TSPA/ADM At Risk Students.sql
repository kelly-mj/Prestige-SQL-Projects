SELECT t1.name
	, t1.Program
    , t1.hoursAtt AS 'Actual Hours'
    , t1.hoursSch AS 'Scheduled Hours'
--     , FORMAT(t1.hoursMissed/t1.hoursCutoff, 2)   -- percent of hours cutoff used up
	, CASE
		WHEN t1.hoursMissed/t1.hoursCutoff >= 0.90
			THEN CONCAT('<span style="color: red;"><strong>', CAST(FORMAT(t1.hoursMissed, 2) AS CHAR), '</strong></span>')
		WHEN t1.hoursMissed/t1.hoursCutoff > 0.75 AND t1.hoursMissed/t1.hoursCutoff < 0.90
			THEN CONCAT('<span style="color: red;">', CAST(FORMAT(t1.hoursMissed, 2) AS CHAR), '</span>')
		ELSE FORMAT(t1.hoursMissed, 2)
		END AS 'Hours Missed'
    , t1.hoursCutoff AS 'Max Allowed Missed Hours'
    
FROM (
    
    SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
		, CONCAT(S.lastname, ', ', S.firstName) AS names
		, P.programmeName AS Program
        , ATT.fieldValue AS hoursAtt
        , SCH.fieldValue AS hoursSch
        , SCH.fieldValue - ATT.fieldValue AS hoursMissed
        , CS.maxStartTime
        , P.minClockHours
        , CASE
			WHEN P.programmeCode LIKE 'COS1000FT'
				THEN 55
            WHEN P.programmeCode LIKE 'COS1000PT' AND CS.maxStartTime < 1200
				THEN 65
            WHEN P.programmeCode LIKE 'COS1000PT' AND CS.maxStartTime > 1200
				THEN 80
			WHEN P.programmeCode LIKE 'COS1500FT'
				THEN 77
			WHEN P.programmeCode LIKE 'COS1500PT'
				THEN 92
			WHEN P.programmeCode LIKE 'ESTFT'
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
    
	LEFT JOIN (SELECT classId, MAX(startTime) AS maxStartTime FROM ClassSchedules GROUP BY classId) CS
		ON CS.classId = CSR.classId
		
	LEFT JOIN ProfileFieldValues ATT
		ON ATT.userId = S.studentId
		AND ATT.fieldName = 'PROGRAM_HOURS_ATTENDED'
		
	LEFT JOIN ProfileFieldValues SCH
		ON SCH.userId = S.studentId
		AND SCH.fieldName = 'PROGRAM_HOURS_SCHEDULED'
    
	WHERE S.isActive IN (1, 12)
    AND SCH.fieldValue - ATT.fieldValue > 0
    AND S.<ADMINID>
) t1


WHERE t1.hoursCutoff IS NOT NULL
AND t1.hoursMissed/t1.hoursCutoff >= 0.65

ORDER BY t1.hoursMissed/t1.hoursCutoff DESC