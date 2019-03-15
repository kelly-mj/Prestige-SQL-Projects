-- ADM Completion Report
-- Kelly MJ  |  3/15/2019
-- Lists all students who have graduated or dropped within the selected month

SELECT t1.status
    , t1.linkedName 'Name'
    , t1.program
    , DATE_FORMAT(t1.endDate, '%m/%d/%Y') 'End Date'

FROM (
    SELECT CASE S.isActive
            WHEN 0 THEN 'Dropped'
            WHEN 3 THEN 'Graduated'
            ELSE 'Unknown' END AS status
        , S.lastName
        , CONCAT(S.lastName, ', ', S.firstName) AS name
        , CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS linkedName
        , (SELECT P.programmeName FROM Programmes P WHERE P.programmeId = R.programmeId) AS program
        , R.programmeId
        , R.graduationDate AS endDate
        , (SELECT MAX(A.attendanceDate) FROM Attendance A WHERE A.studentId = S.studentId AND A.isActive = 1) AS lda
        , '[?Pick date in desired month]' AS month

    FROM Students S
    INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations GROUP BY studentId) RR   -- get most recent registration record per student
        ON RR.studentId = S.studentId
    INNER JOIN Registrations R
        ON R.studentId = S.studentId AND R.registrationId = RR.maxReg

    WHERE S.<ADMINID>
        AND S.isActive IN (0, 3)    -- either dropped or graduated
) t1

WHERE t1.endDate BETWEEN DATE_FORMAT(month, '%Y-%m-01') AND LAST_DAY(month)

ORDER BY t1.status ASC, t1.programmeId, t1.lastName
