-- Front Desk Call Report
-- Author: Kelly MJ  |  8/25/2018
-- Lists "At Risk," "Under 60% Attendance" and "Pending Drop" students in a printable report for front desk staff


-- **** At Risk Widget list ****
SELECT '<div style="padding-top: 3px;"><font size="2"><strong>At Risk Students</strong></font></div>' AS 'Name'
	, NULL AS 'Home Phone/<br>Cell Phone'
	, NULL AS 'Call Date/Time'
	, '<font color="#fff">Write down what the outcome of the call to each student was</font>' AS 'Call Outcome'  -- white text makes space on the physical print for handwritten notes

UNION

(  SELECT Name AS 'Student'
	, Phone
	, NULL
	, NULL
FROM
(
SELECT Name, Phone, Classname, lda, ((DATEDIFF(CURRENT_DATE, lda)) -
            ((WEEK(CURRENT_DATE) - WEEK(lda)) * 2) -
            (case when weekday(CURRENT_DATE) = 6 then 1 else 0 end) -
            (case when weekday(lda) = 5 then 1 else 0 end)) as DifD
FROM(
SELECT Distinct A.studentID,C.ClassName, CONCAT(S.firstName, ' ', S.lastName) AS Name, CONCAT('<div>H: ', S.homePhone, '<br>C: ', S.cellPhone, '</div>') as Phone, MAX(A.attendanceDate) as lda
FROM Attendance A
INNER JOIN Classes C 
               ON A.classId = C.classId
INNER JOIN ClassStudentReltn R 
               ON  C.classId = R.classId 
               AND A.studentId = R.studentId 
INNER JOIN 
                  (SELECT RR.registrationId, RR.studentID  
                   FROM Registrations RR 
                    WHERE RR.isActive=1 
                    AND RR.regstatus = 1) AS REG ON REG.RegistrationID = R.registrationId 
INNER JOIN Students S 
                ON S.studentID = REG.studentID 
                AND S.<ADMINID>

WHERE C.isActive=1 AND R.isActive=1 AND A.isActive=1 AND A.present > 0 AND A.AttendanceDate  BETWEEN (CURRENT_DATE - INTERVAL 60 DAY) AND CURRENT_DATE
AND S.studentID NOT IN (SELECT LOA.StudentID FROM LeavesOfAbsence LOA WHERE LOA.isactive = 1 AND LOA.returnDate IS NULL OR LOA.returndate = '') 
GROUP BY A.studentID) as t1) as t2
WHERE DifD > 7
ORDER BY S.lastName ASC  )

UNION

-- **** Under 60% Attendance list ****
SELECT '<div style="padding-top: 3px;"><font size="2"><strong>Under 60% Attendance</strong></font></div>' AS 'Name'
	, NULL AS 'Home Phone/<br>Cell Phone'
	, NULL AS 'Call Date/Time'
	, '<font color="#fff">Write down what the outcome of the call to each student was</font>' AS 'Call Outcome'  -- white text makes space on the physical print for handwritten notes

UNION

-- Author: Kelly MJ  |  7/26/2018  |  Code from: "Under 60% Attendance" Admin widget
(  SELECT t1.name
      , t1.phone
      , NULL
      , NULL

FROM (
SELECT CONCAT(UCASE(SUBSTRING(S.firstname, 1, 1)),LCASE(SUBSTRING(S.firstname, 2))," ",CONCAT(UCASE(SUBSTRING(S.lastName, 1, 1)),LCASE(SUBSTRING(S.lastName, 2)))) 'Name'  -- Name (used to be a link)
     , CONCAT('<div>H: ', S.homePhone, '<br>C: ', S.cellPhone, '</div>') as phone
     , P.programmeName 'Program' -- Program name
     , ROUND( 100*(SUM(A.duration)/PFV.fieldValue), 0 ) 'percent'    -- Percentage (numerical)
     , R.startDate
     , PFV.fieldValue AS ih

FROM Registrations R
   
INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate FROM Registrations R
                                                        INNER JOIN Programmes P
                                                        ON P.programmeId = R.programmeId
                                                        AND P.programmeName NOT LIKE '%career%pathway%'
            GROUP BY studentId) R2
ON R2.studentId = R.studentId
AND R2.maxDate = R.startDate

INNER JOIN Attendance A
ON R.studentId = A.studentId
AND A.isActive = 1
AND A.attendanceDate >= R.startDate

INNER JOIN Classes C
ON C.classId = A.classId
AND C.startDate <= CURDATE() and C.endDate >= CURDATE()
AND C.isActive = 1
AND C.subjectId IN (SELECT subjectId FROM GroupSubjectReltn GSR, CourseGroups CG
          WHERE CG.programmeId=R.programmeId AND CG.isActive=1
                    AND CG.courseGroupId=GSR.courseGroupId AND GSR.isActive=1)

INNER JOIN ProfileFieldValues PFV
        ON PFV.userId = R.studentId
       AND PFV.fieldName LIKE 'HOURS_SCHEDULED_FOR_CURRENT_PROGRAM'

INNER JOIN ClassStudentReltn CSR
ON CSR.classId = C.classId
AND CSR.isActive = 1
AND R.studentId = CSR.studentId

INNER JOIN Programmes P
ON P.programmeId = R.programmeId

INNER JOIN Students S
ON R.studentId = S.studentId
AND S.isActive = 1

WHERE R.isActive = 1
AND R.<ADMINID>
AND S.firstName NOT IN ('Test', 'TEST', 'test')
AND S.lastName NOT IN ('Test', 'TEST', 'test')

GROUP BY R.registrationId
) t1
WHERE t1.percent <= 60
ORDER BY S.lastName ASC  )

UNION

-- **** Pending Drop list ****
SELECT '<div style="padding-top: 3px;"><font size="2"><strong>Pending Drop Status</strong></font></div>' AS 'Name'
	, NULL AS 'Home Phone/<br>Cell Phone'
	, NULL AS 'Call Date/Time'
	, '<font color="#fff">Write down what the outcome of the call to each student was</font>' AS 'Call Outcome'  -- white text makes space on the physical print for handwritten notes

UNION

(  SELECT CONCAT(S.firstName, ' ', S.lastName)
	, CONCAT('<div>H: ', S.homePhone, '<br>C: ', S.cellPhone, '</div>')
	, NULL
	, NULL

FROM Students S

INNER JOIN Registrations R
ON R.studentId = S.studentId

WHERE S.isActive = 16
  AND S.<ADMINID>

ORDER BY S.lastName ASC  )