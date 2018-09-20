-- LOA Start Page Query
-- Update: Kelly MJ  |  07/30/2018
    -- Added 'Actual Hours' column
    
SELECT CASE WHEN t1.studentCampus = 34652 THEN 'New Port Richey'
			WHEN t1.studentCampus = 34601 THEN 'Spring Hill'
			WHEN t1.studentCampus = 34606 THEN 'Brookesville'
		END AS Campus

, Name
	
,  CASE WHEN (CurrentDiff +  PAST) >= 170 THEN CONCAT('<font color="white">','<div style="background-color:#ff0000; width: 100%; height:100%; margin:-3px -3px -3px -5px; padding:4px 4px 2px 4px"> ' ,LeaveDate,'</div>','</font>')
       ELSE LeaveDate
       END AS 'Leave Date'

,   CASE WHEN (CurrentDiff +  PAST) >= 170 THEN CONCAT('<font color="white">','<div style="background-color:#ff0000; width: 100%; height:100%; margin:-3px -3px -3px -5px; padding:4px 4px 2px 4px">',expectedReturnDate,'</div>','</font>') 
	   WHEN expectedReturnDate < CURDATE() THEN CONCAT('<font color="black">','<div style="background-color:#ff0000; width: 100%; height:100%; margin:-3px -3px -3px -5px; padding:4px 4px 2px 4px">' , expectedReturnDate,'</div>','</font>')  
	   ELSE expectedReturnDate
       END AS 'Exp. Return'

    ,  CASE WHEN (CurrentDiff +  PAST) >= 170 THEN CONCAT('<font color="white">','<div style="background-color:#ff0000; width: 100%; height:100%; margin:-3px -3px -3px -5px; padding:4px 4px 2px 4px">', (CurrentDiff +  PAST),'</div>','</font>')
       ELSE (CurrentDiff +  PAST)
	   END AS 'Total Accumulated'

	,  CASE WHEN (CurrentDiff +  PAST) >= 170 THEN CONCAT('<font color="white">','<div style="background-color:#ff0000; width: 100%; height:100%; margin:-3px -3px -3px -5px; padding:4px 4px 2px 4px">',t1.ProgrammeName,'</div>','</font>')
       ELSE t1.ProgrammeName
	   END AS 'Program'
	 
	,  TRUNCATE(SUM(ATT.duration), 0) AS 'Actual Hours'


FROM 

	  (SELECT DISTINCT CONCAT('<a href="admin_view_student.jsp?studentid=',CAST(CurrentLOA.StudentID AS CHAR), '">',firstName, ' ', lastName, '</a>') AS Name
	  	   , CurrentLOA.StudentID
	  	   , studentCampus
           , Lastname
	       , LeaveDate
		   , expectedReturnDate
           , CurrentDiff
           , CurrentLOA.ProgrammeName
           ,  CASE WHEN SUM(PastSum) IS NULL THEN 0 ELSE SUM(PastSum) END AS Past
	  FROM
      (SELECT STD.StudentID
			, CONCAT(UCASE(SUBSTRING(Firstname, 1, 1)),LCASE(SUBSTRING(Firstname, 2))) AS FirstName
			, CONCAT(UCASE(SUBSTRING(LastName, 1, 1)),LCASE(SUBSTRING(LastName, 2))) AS Lastname
			, STD.studentCampus
			, LeaveDate
			, expectedReturnDate
			, ReturnDate
			, LOA.isActive
			, DATEDIFF(CURDATE(), LeaveDate) AS CurrentDiff
			, ProgrammeName
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

LEFT JOIN 
	   (SELECT STD.StudentID
             , DATEDIFF(ReturnDate, LeaveDate) AS PastSum
	         , ProgrammeName
		FROM Students STD
		INNER JOIN LeavesOfAbsence LOA 
				ON STD.studentId = LOA.studentId 
		INNER JOIN Registrations REG 
				ON LOA.studentID = REG.studentID
		INNER JOIN Programmes PRG 
				ON PRG.ProgrammeID = REG.ProgrammeId
		GROUP BY LOA.leavesOfAbsenceId) AS PastLOA ON CurrentLOA.StudentID = PastLOA.StudentID 
										AND CurrentLOA.ProgrammeName = PastLOA.ProgrammeName
GROUP BY CurrentLOA.StudentID) AS t1

LEFT JOIN
		(SELECT S.studentId
			  , MAX(R.startDate) AS startDate
			  , A.duration
			  , A.attendanceDate
		 FROM Students S
		 INNER JOIN Registrations R
		 		 ON R.studentId = S.studentId
		 		AND R.isActive = 1
		 INNER JOIN Attendance A
		 		 ON A.studentId = R.studentId
		 		AND A.isActive = 1
		 INNER JOIN ClassStudentReltn CSR
		 		 ON CSR.studentId = R.studentId
		 INNER JOIN Classes C
		 		 ON C.classId = CSR.classId
		 		AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG WHERE CG.programmeId=R.programmeId and CG.isActive=1 and CG.courseGroupId=GSR.courseGroupId and GSR.isActive=1)
		 GROUP BY S.studentId, A.attendanceDate) AS ATT
ON ATT.studentId = t1.StudentID
AND ATT.attendanceDate >= ATT.startDate

GROUP BY ATT.studentId

ORDER BY Campus, expectedReturnDate
