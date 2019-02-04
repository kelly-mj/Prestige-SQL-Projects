-- Payroll Report for CSV Export
-- 10/17/18 Kelly MJ

(SELECT t1.employeeId AS employeeId     -- DELETE 'name'
    , t1.chargeDate 'Charge Date'
    , t1.payCode 'Paycode'  -- leave blank if nah
    , FORMAT(COALESCE(IF((t1.hours >= 40 OR t1.employeeType LIKE '%Salary%'), 40, t1.hours), 0), 2) 'Hours' -- coalesce to zero

FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , '[?Start Date]' AS dummyDate      -- Included this column to have the Start Date field appear before the End Date field when running the report
        , '[?End Date]' AS chargeDate
        , 'REG' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    LEFT JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = SA.subAdminId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = SA.subAdminId
    WHERE SA.isActive = 1
    AND SA.<ADMINID>
    GROUP BY SA.subAdminId)

    UNION   -- Teachers
    (SELECT T.teacherId AS id
        , SUM(TA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , NULL
        , '[?End Date]' AS chargeDate
        , 'REG' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    LEFT JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = T.teacherId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = T.teacherId
    WHERE T.isActive = 1
    AND T.<ADMINID>
    GROUP BY T.teacherId)
    ) t1
    WHERE t1.employeeId > '0')

UNION   -- OT
(SELECT t1.employeeId AS employeeId     -- DELETE 'name'
    , t1.chargeDate 'Charge Date'
    , t1.payCode 'Paycode'  -- leave blank if nah
    , FORMAT(t1.hours-40, 2) 'Hours'    -- coalesce to zero
    
FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , '[?End Date]' AS chargeDate
        , 'O/T' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    LEFT JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = SA.subAdminId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = SA.subAdminId
    WHERE SA.isActive = 1
    AND SA.<ADMINID>
    GROUP BY SA.subAdminId)

    UNION   -- Teachers
    (SELECT T.teacherId AS id
        , SUM(TA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , '[?End Date]' AS chargeDate
        , 'O/T' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    LEFT JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = T.teacherId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = T.teacherId
    WHERE T.isActive = 1
    AND T.<ADMINID>
    GROUP BY T.teacherId)
    ) t1
    WHERE t1.employeeId > '0'
    AND t1.hours > 40)

ORDER BY employeeId