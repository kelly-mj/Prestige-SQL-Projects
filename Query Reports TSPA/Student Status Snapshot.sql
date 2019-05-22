-- [TSPA] Query Report: Student Status Snapshot
-- Kelly MJ  |  5/22/2019
-- Displays a snapshot of every enrolled student's status in a window of time (provided by the user)

/********************************* Active Student Count by Program ***********************************/
( SELECT NULL AS 'Student'
     , CONCAT('Active students in ', UPPER(P.programmeName), ': ') AS 'Program'
     , COUNT(S.studentId) AS 'Contract Start Date'
     , NULL AS 'Graduation/Withdrawal Date'
     , NULL AS 'LOA Leave'
     , NULL AS 'LOA Return'

FROM Students S
INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg
            FROM Registrations
            WHERE isActive = 1
            GROUP BY studentId) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')
INNER JOIN Programmes P ON P.programmeId = R.programmeId
WHERE R.isActive = 1
  AND NOT EXISTS ( SELECT LOA.studentId
                FROM LeavesOfAbsence LOA
                WHERE LOA.studentId = S.studentId
                  AND ((LOA.returnDate >  '[?From Date]' AND LOA.returnDate < '[?To Date]') OR LOA.returnDate IS NULL)
                  AND   LOA.leaveDate  <= '[?To Date]'
                  AND LOA.isActive = 1 )
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND ( R.graduationDate > '[?To Date]' OR R.graduationDate IS NULL )
  AND R.<ADMINID>
GROUP BY P.programmeId
ORDER BY P.programmeName ASC )

/************************************** Active Students ***************************************/
UNION   -- Header row + Active student count
( SELECT '<strong>Active Students</strong>'
    , CONCAT('<strong>Number of active students: ', COUNT(S.studentId), '</strong>')
    , '<strong>Contract Start Date</strong>'
    , '<strong>Graduation/Withdrawal Date</strong>'
    , '<strong>LOA Leave Date</strong>'
    , '<strong>LOA Return Date</strong>'

FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
             FROM Registrations
             WHERE isActive = 1
             GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')
WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND ( R.graduationDate > '[?To Date]'
        OR R.graduationDate IS NULL )
  AND NOT EXISTS ( SELECT LOA.studentId
                   FROM LeavesOfAbsence LOA
                   WHERE LOA.studentId = S.studentId
                     AND   LOA.leaveDate  <= '[?To Date]'
                     AND ((LOA.returnDate >  '[?From Date]' AND LOA.returnDate < '[?To Date]') OR LOA.returnDate IS NULL)
                     AND LOA.isActive = 1 )
  AND R.<ADMINID> )

UNION   -- Active student list
( SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>')
    , ( SELECT programmeName FROM Programmes WHERE programmeId = R.programmeId )
    , DATE_FORMAT(R.startDate, '%m/%d/%Y')
    , CONCAT(DATE_FORMAT(R.graduationDate, '%m/%d/%Y')
             , CASE R.regStatus WHEN 3 THEN ' - Graduated'
                                WHEN 0 THEN ' - Withdrawn'
                                ELSE '' END )
    , NULL
    , NULL

FROM (SELECT * FROM Students ORDER BY lastName ASC) S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
             FROM Registrations
             WHERE isActive = 1
             GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND ( R.graduationDate > '[?To Date]'
        OR R.graduationDate IS NULL )
  AND NOT EXISTS ( SELECT LOA.studentId
                   FROM LeavesOfAbsence LOA
                   WHERE LOA.studentId = S.studentId
                     AND   LOA.leaveDate  <= '[?To Date]'
                     AND ((LOA.returnDate >  '[?From Date]' AND LOA.returnDate < '[?To Date]')
                         OR LOA.returnDate IS NULL)
                     AND LOA.isActive = 1 )
  AND R.<ADMINID> )

/**************************************** LOA Students ****************************************/
UNION   -- Header row + LOA student count
( SELECT '<strong>LOA Students</strong>'
    , CONCAT('<strong>Number of LOA students: ', COUNT(DISTINCT S.studentId), '</strong>')
    , '<strong>Contract Start Date</strong>'
    , '<strong>Graduation/Withdrawal Date</strong>'
    , '<strong>LOA Leave Date</strong>'
    , '<strong>LOA Return Date</strong>'

FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
           FROM Registrations WHERE isActive = 1 GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN LeavesOfAbsence LOA ON LOA.studentId = S.studentId
    AND   LOA.leaveDate  <= '[?To Date]'
    AND ((LOA.returnDate >  '[?From Date]' AND LOA.returnDate < '[?To Date]')
      OR LOA.returnDate IS NULL)
      AND LOA.isActive = 1
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
  AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01' AND R.startDate <= '[?To Date]'
  AND ( (R.graduationDate > '[?From Date]' AND R.graduationDate <= '[?To Date]')OR R.graduationDate IS NULL )
  AND R.<ADMINID> )

UNION   -- List of LOA students
( SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>')
  , ( SELECT programmeName FROM Programmes WHERE programmeId = R.programmeId )
  , DATE_FORMAT(R.startDate, '%m/%d/%Y')
  , CONCAT(DATE_FORMAT(R.graduationDate, '%m/%d/%Y')
           , CASE R.regStatus WHEN 3 THEN ' - Graduated'
                              WHEN 0 THEN ' - Withdrawn'
                              ELSE '' END )
  ,  DATE_FORMAT(MAX(LOA.leaveDate), '%m/%d/%Y')
  ,  DATE_FORMAT(MAX(LOA.returnDate), '%m/%d/%Y')

FROM (SELECT * FROM Students ORDER BY lastName ASC) S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
           FROM Registrations
           WHERE isActive = 1
           GROUP BY studentId ) RR
  ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
  AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

INNER JOIN LeavesOfAbsence LOA ON LOA.studentId = S.studentId
  AND   LOA.leaveDate  <= '[?To Date]'
  AND ((LOA.returnDate >  '[?From Date]' AND LOA.returnDate < '[?To Date]')
      OR LOA.returnDate IS NULL)
  AND LOA.isActive = 1

WHERE R.isActive = 1
AND R.startDate >  '1900-01-01'
AND R.startDate <= '[?To Date]'
AND ( (R.graduationDate > '[?From Date]' AND R.graduationDate <= '[?To Date]')
      OR R.graduationDate IS NULL )
AND R.<ADMINID>

GROUP BY S.studentId
ORDER BY S.lastName ASC )

/************************************* Graduated Students *************************************/
UNION   -- Header row + Grad student count
( SELECT '<strong>Graduated Students</strong>'
    , CONCAT('<strong>Number of Graduated students: ', COUNT(S.studentId), '</strong>')
    , '<strong>Contract Start Date</strong>'
    , '<strong>Graduation Date</strong>'
    , '<strong>LOA Leave Date</strong>'
    , '<strong>LOA Return Date</strong>'

FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
         FROM Registrations
         WHERE isActive = 1
         GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND R.graduationDate >= '[?From Date]'
  AND R.graduationDate <= '[?To Date]'
  AND R.regStatus = 3
  AND R.<ADMINID> )

UNION   -- List  of Graduated students
( SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>')
    , ( SELECT programmeName FROM Programmes WHERE programmeId = R.programmeId )
    , DATE_FORMAT(R.startDate, '%m/%d/%Y')
    , DATE_FORMAT(R.graduationDate, '%m/%d/%Y')
    , NULL
    , NULL

FROM (SELECT * FROM Students ORDER BY lastName ASC) S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
         FROM Registrations
         WHERE isActive = 1
         GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND R.graduationDate >= '[?From Date]'
  AND R.graduationDate <= '[?To Date]'
  AND R.regStatus = 3
  AND R.<ADMINID>
ORDER BY S.lastName ASC )

/************************************* Withdrawn Students *************************************/
UNION   -- Header row + Withdrawn student count
( SELECT '<strong>Withdrawn Students</strong>'
    , CONCAT('<strong>Number of Withdrawn students: ', COUNT(S.studentId), '</strong>')
    , '<strong>Contract Start Date</strong>'
    , '<strong>Withdrawal Date</strong>'
    , '<strong>LOA Leave Date</strong>'
    , '<strong>LOA Return Date</strong>'

FROM Students S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
       FROM Registrations
       WHERE isActive = 1
       GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND R.graduationDate >= '[?From Date]'
  AND R.graduationDate <= '[?To Date]'
  AND R.regStatus = 0
  AND R.<ADMINID> )

UNION   -- List of Withdrawn students
( SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>')
    , ( SELECT programmeName FROM Programmes WHERE programmeId = R.programmeId )
    , DATE_FORMAT(R.startDate, '%m/%d/%Y')
    , DATE_FORMAT(R.graduationDate, '%m/%d/%Y')
    , NULL
    , NULL

FROM (SELECT * FROM Students ORDER BY lastName ASC) S
INNER JOIN ( SELECT studentId, MAX(registrationId) AS maxReg
       FROM Registrations
       WHERE isActive = 1
       GROUP BY studentId ) RR
    ON RR.studentId = S.studentId
INNER JOIN Registrations R ON R.studentId = S.studentId
    AND R.registrationId = RR.maxReg
INNER JOIN StatusSequences SS ON SS.statusId = R.regStatus
    AND SS.statusName NOT IN ('Pending-Enrolled', 'No Start', 'Application in Progress')

WHERE R.isActive = 1
  AND R.startDate >  '1900-01-01'
  AND R.startDate <= '[?To Date]'
  AND R.graduationDate >= '[?From Date]'
  AND R.graduationDate <= '[?To Date]'
  AND R.regStatus = 0
  AND R.<ADMINID>
ORDER BY S.lastName ASC )
