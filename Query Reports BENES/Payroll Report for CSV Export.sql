-- Payroll Report for CSV Export
-- 10/17/18 Kelly MJ

/*
 *  paycode 0: REG (Regular)
 */
(SELECT t1.name     -- DELETE 'name'
    , t1.employeeId AS employeeId
    , NULL AS 'Charge Date'
    , t1.payCode 'Paycode'  -- leave blank if nah
    , FORMAT(COALESCE(IF((t1.hours >= 40 OR t1.employeeType LIKE '%Salary%'), 40, t1.hours), 0), 2) 'Hours' -- coalesce to zero

FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , 'REG' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    LEFT JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND SAA.reasonType = 0
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
        , 'REG' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    LEFT JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND TA.reasonType = 0
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

/*
 *  paycode 0: O/T (Over Time)
 */
UNION
(SELECT t1.name     -- DELETE 'name'
    , t1.employeeId AS employeeId
    , NULL AS chargeDate
    , t1.payCode 'Paycode'  -- leave blank if nah
    , FORMAT(t1.hours-40, 2) 'Hours'
    
FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , 'O/T' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    LEFT JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND SAA.reasonType = 0
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
        , 'O/T' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    LEFT JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND TA.reasonType = 0
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = T.teacherId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = TA.teacherId
    WHERE T.isActive = 1
        AND T.<ADMINID>
    GROUP BY T.teacherId)
    ) t1
    WHERE t1.employeeId > '0'
        AND t1.hours > 40
        AND t1.employeeType <> 'Full Time - Salary')

/*
 *  paycode 1 : PTO (Paid Time Off)
 */
UNION
(SELECT t1.name     -- DELETE 'name'
    , t1.employeeId AS employeeId
    , NULL AS chargeDate
    , t1.payCode 'Paycode'  -- leave blank if nah
    , t1.hours 'Hours'
    
FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , 'PTO' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    INNER JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND SAA.reasonType = 1
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
        , 'PTO' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    INNER JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND TA.reasonType = 1
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = T.teacherId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = TA.teacherId
    WHERE T.isActive = 1
        AND T.<ADMINID>
    GROUP BY T.teacherId)
    ) t1
    WHERE t1.employeeId > '0')

/*
 *  paycode 2: HOLS (Holiday)
 */
UNION
(SELECT t1.name     -- DELETE 'name'
    , t1.employeeId AS employeeId
    , NULL AS chargeDate
    , t1.payCode 'Paycode'  -- leave blank if nah
    , t1.hours 'Hours'
    
FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , 'HOLS' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    INNER JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND SAA.reasonType = 2
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
        , 'HOLS' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    INNER JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND TA.reasonType = 2
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = T.teacherId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = TA.teacherId
    WHERE T.isActive = 1
        AND T.<ADMINID>
    GROUP BY T.teacherId)
    ) t1
    WHERE t1.employeeId > '0')

/*
 *  paycode 3: DEATH (Bereavement)
 */
UNION
(SELECT t1.name     -- DELETE 'name'
    , t1.employeeId AS employeeId
    , NULL AS chargeDate
    , t1.payCode 'Paycode'  -- leave blank if nah
    , t1.hours 'Hours'
    
FROM (
    -- Subadmins
    (SELECT SA.subAdminId AS id
        , SUM(SAA.duration) hours
        , EID.fieldValue AS employeeId
        , TYPE.fieldValue AS employeeType
        , 'DEATH' AS payCode
        , CONCAT(SA.firstName, ' ' , SA.lastName, ' (', CAST(SA.subAdminId AS CHAR), ')') AS name
    FROM SubAdmins SA
    INNER JOIN SubAdminAttendance SAA ON SAA.subAdminId = SA.subAdminId
        AND SAA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND SAA.reasonType = 3
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
        , 'DEATH' AS payCode
        , CONCAT(T.firstName, ' ' , T.lastName, ' (', CAST(T.teacherId AS CHAR), ') TEACHER') AS name
    FROM Teachers T
    INNER JOIN TeacherAttendance TA ON TA.teacherId = T.teacherId
        AND TA.attendanceDate BETWEEN '[?Start Date]' AND '[?End Date]'
        AND TA.reasonType = 3
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_ID' AND isActive = 1 GROUP BY userId
        ) EID ON EID.userId = T.teacherId
    LEFT JOIN (
        SELECT MAX(profileFieldValueId), fieldValue, userId FROM ProfileFieldValues WHERE fieldName = 'EMPLOYEE_TYPE' AND isActive = 1 GROUP BY userId
        ) TYPE ON TYPE.userId = TA.teacherId
    WHERE T.isActive = 1
        AND T.<ADMINID>
    GROUP BY T.teacherId)
    ) t1
    WHERE t1.employeeId > '0')

ORDER BY employeeId