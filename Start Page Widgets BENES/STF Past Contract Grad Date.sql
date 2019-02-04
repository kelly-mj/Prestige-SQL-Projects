-- Widget (Campus Director View): Students Past Contract Grad Date
-- Author: Kelly MJ  |  8/15/2018
-- Displays students who have not fulfilled their program hours by their contracted graduation date. List is filtered by user's (campus director's) campus code.

(SELECT
    'Campus: ' AS 'Name'
    , CASE
        WHEN SA.campusCode = 34601 THEN 'Brooksville'
        WHEN SA.campusCode = 34606 THEN 'Spring Hill'
        WHEN SA.campusCode = 34652 THEN 'New Port Richey'
        END AS 'Program Name'
    , NULL AS 'Contract Grad Date'
    , NULL AS 'Last Date Attended'
    , NULL AS 'Hours Attended up to Contract Grad Date'

FROM SubAdmins SA

WHERE
    SA.<ADMINID>
    AND SA.subAdminId = [USERID])

UNION

(SELECT t1.Name 'Name'
	, t1.programmeName 'Program Name'
	, t1.endDate 'Contract Grad Date'
	, t1.lastPunch 'Last Date Attended'
	, ROUND(t1.HoursAttended, 1) 'Hours Attended up to Contract Grad Date'

FROM (

    SELECT S.idNumber, CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.firstName, ' ', S.lastName, '</a>') AS Name
        , P.programmeName
    	, R.endDate
        , SUM(A.duration) AS HoursAttended  -- sum of hours before contracted grad date
        , CP.lastPunch
    	, P.minClockHours
        , R.transferUnits
        , P.minClockHours - SUM(A.duration) - R.transferUnits AS Hours_Remaining
        , S.studentCampus AS Campus
        
    FROM Students S

    INNER JOIN Registrations R
    	ON R.studentId = S.studentId

    -- Finds greatest contract grad date for each student
    INNER JOIN (
    	SELECT RR.studentId
    		, MAX(RR.endDate) endDate
    	FROM Registrations RR
    	WHERE RR.programmeId IN (SELECT PP.programmeId FROM Programmes PP WHERE PP.programmeName NOT LIKE '%areer%' AND PP.programmeName NOT LIKE '%nstructor%raining%')
        GROUP BY RR.studentId) MAXREG
        ON MAXREG.studentId = R.studentId
        AND MAXREG.endDate = R.endDate
        
    INNER JOIN Programmes P
    	ON P.programmeId = R.programmeId
        AND P.isActive = 1

    INNER JOIN Attendance A
    	ON A.studentId = S.studentId
        AND A.attendanceDate <= R.endDate
        AND A.attendanceDate >= R.startDate
        AND A.subjectId IN (SELECT GSR.subjectId FROM CourseGroups CG
    						INNER JOIN GroupSubjectReltn GSR ON GSR.courseGroupId = CG.courseGroupId
                            WHERE GSR.isActive = 1 AND CG.isActive = 1 AND R.programmeId = CG.programmeId)
    	AND A.classId IN (SELECT CSR.classId FROM ClassStudentReltn CSR
    					  WHERE CSR.studentId = A.studentId AND CSR.isActive = 1)

    INNER JOIN (
    	SELECT DATE(MAX(CPS.punchTime)) AS lastPunch, CPS.userId
        FROM ClockPunches CPS
        GROUP BY CPS.userId) CP
    	ON CP.userId = R.studentId

    WHERE
    	S.isActive = 1
        AND R.isActive = 1
        AND R.regStatus NOT IN (0, 3)
        AND R.endDate <= CURDATE()
        AND R.enrollmentSemesterId = 4000441
        AND S.firstName NOT LIKE 'test'
        AND R.<ADMINID>
        
    GROUP BY S.studentId
    ORDER BY R.endDate DESC
) t1

WHERE
    t1.Hours_Remaining > 0
    AND t1.Campus = (SELECT SA.campusCode FROM SubAdmins SA WHERE SA.subAdminId = [USERID]))