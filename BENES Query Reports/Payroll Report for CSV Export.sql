-- Payroll Report for CSV Export
-- 10/17/18 Kelly MJ

(SELECT t1.name AS name, t1.employeeId 'Employee ID'
	, t1.chargeDate 'Charge Date'
    , t1.payCode 'Paycode'	-- leave blank if nah
    , t1.hours 'Hours'	-- coalesce to zero
    , t1.employeeType 'Employee Type'
    
FROM (
	-- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , '2018-08-12' AS chargeDate
        , 'Regular' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', SA.subAdminId, ')') AS name
	FROM SubAdmins SA
    LEFT JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '2018-08-06' AND '2018-08-12'
	LEFT JOIN ProfileFieldValues EID ON EID.userId = SA.subAdminId
		AND EID.fieldName = 'EMPLOYEE_ID'
	LEFT JOIN ProfileFieldValues TYPE ON TYPE.userId = SA.subAdminId
		AND TYPE.fieldName = 'EMPLOYEE_TYPE'
	WHERE SA.isActive = 1
    GROUP BY SA.subAdminId)
	-- Teachers
    UNION
    (SELECT T.teacherId AS id
        , SUM(TA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , '2018-08-12' AS chargeDate
        , 'Regular' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', T.teacherId, ') TEACHER') AS name
	FROM Teachers T
    LEFT JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '2018-08-06' AND '2018-08-12'
	LEFT JOIN ProfileFieldValues EID ON EID.userId = T.teacherId
		AND EID.fieldName = 'EMPLOYEE_ID'
	LEFT JOIN ProfileFieldValues TYPE ON TYPE.userId = T.teacherId
		AND TYPE.fieldName = 'EMPLOYEE_TYPE'
	WHERE T.isActive = 1
    GROUP BY T.teacherId)
    ) t1)