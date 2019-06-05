SELECT NULL AS 'studentId', NULL AS 'lastupdated'
	, 'Report Date Range: ' AS 'First Name'
	, CONCAT(DATE_FORMAT(IF('[?Run Date]' = '', CURDATE(), '[?Run Date]'), '%m/%d/%Y'), ' - ',DATE_FORMAT(DATE_SUB(IF('[?Run Date]' = '', CURDATE(), '[?Run Date]'), INTERVAL 3 MONTH), '%m/01/%Y')) AS 'Last Name'
    , NULL 'M'
    , NULL 'DOB'
    , NULL 'SSN'
    , NULL 'Street Address'
    , NULL 'City'
    , NULL 'State'
    , NULL 'Zip Code'
    , NULL 'Enrollment Status'
    , NULL 'Student Campus'
    , NULL 'Course'
    , NULL 'Program Weeks'
    , NULL 'Start Date'
    , NULL 'Contract Grad Date'
    , NULL 'LDA'
    , NULL 'LOA Start'
    , NULL 'LOA Expected Return'
    , NULL 'LOA Date of Return'
    , NULL 'LOA Comment Box'
    , NULL 'Re-Enroll Date'

UNION

SELECT t1.studentId, t1.graduationDate, CONCAT(UPPER(SUBSTRING(t1.firstName, 1, 1)), LOWER(SUBSTRING(t1.firstName, 2))) AS 'First Name'
	, CONCAT(UPPER(SUBSTRING(t1.lastName, 1, 1)), LOWER(SUBSTRING(t1.lastName, 2))) AS 'Last Name'
    , UPPER(SUBSTRING(t1.middleName, 1, 1)) AS 'M'
    , DATE_FORMAT(t1.dateOfBirth, '%m/%d/%Y') AS 'DOB'
    , t1.ssn AS 'SSN'
    , t1.address AS 'Street Address'
    , t1.city AS 'City'
    , t1.state AS 'State'
    , t1.zip AS 'Zip Code'
    , t1.statusName AS 'Enrollment Status'
    , t1.Campus AS 'Student Campus'
    , t1.Program AS 'Course'
    , t1.programWeeks AS 'Program Weeks'
    , DATE_FORMAT(t1.startDate, '%m/%d/%Y') AS 'Start Date'
    , DATE_FORMAT(t1.endDate, '%m/%d/%Y') AS 'Contract Grad Date'
    , DATE_FORMAT(t1.lda, '%m/%d/%Y') AS 'LDA'
    , DATE_FORMAT(t1.leaveDate, '%m/%d/%Y') AS 'LOA Start'
    , IF(t1.returnDate IS NULL, DATE_FORMAT(t1.expectedReturnDate, '%m/%d/%Y'), NULL) AS 'LOA Expected Return'
    , DATE_FORMAT(t1.returnDate, '%m/%d/%Y') AS 'LOA Date of Return'
    , t1.comments AS 'LOA Comment Box'
    , DATE_FORMAT(t1.reenrollDate, '%m/%d/%Y') AS 'Reenroll Date'

FROM (
	SELECT S.studentId, R.registrationId
		, S.firstName
		, S.lastName
        , S.middleName
        , S.dateOfBirth
        , S.ssn
        , S.address
        , S.city
		, S.state
        , S.zip
        , S.isActive
        , SS.statusName
        , R.startDate
        , R.endDate
        , R.graduationDate
        , LOA.leaveDate
        , LOA.expectedReturnDate
        , LOA.returnDate
        , LOA.comments
        , LDA.lda
        , (SELECT campusName FROM Campuses WHERE campusCode = R.studentCampus) AS Campus
        , (SELECT programmeName FROM Programmes WHERE programmeId = R.programmeId) AS Program
        , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'PROGRAM_WEEKS') AS programWeeks
        , (SELECT fieldValue FROM ProfileFieldValues WHERE userId = S.studentId AND fieldName = 'RE-ENROLL_DATE') AS reenrollDate
        
	FROM Students S
	INNER JOIN StatusSequences SS ON SS.statusId = S.isActive
	INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
		ON RR.studentId = S.studentId
	INNER JOIN Registrations R ON R.studentId = S.studentId
		AND R.registrationId = RR.maxReg
	LEFT JOIN (SELECT L1.*
				FROM LeavesOfAbsence L1
                INNER JOIN (SELECT studentId, MAX(leavesOfAbsenceId) AS maxLOA
							FROM LeavesOfAbsence
							WHERE isActive = 1
								AND leaveDate <= IF('[?Run Date]' = '', CURDATE(), '[?Run Date]')
								AND (returnDate IS NULL OR (returnDate >= DATE_FORMAT(DATE_SUB(IF('[?Run Date]' = '', CURDATE(), '[?Run Date]'), INTERVAL 3 MONTH), '%Y-%m-01')))
							GROUP BY studentId) L2
					ON L2.studentId = L1.studentId
                    AND L2.maxLOA = L1.leavesOfAbsenceId
                WHERE isActive = 1
		) LOA ON LOA.studentId = S.studentId
	LEFT JOIN (SELECT studentId, MAX(attendanceDate) AS lda
				FROM Attendance A
                WHERE isActive = 1
                GROUP BY studentId) LDA
		ON LDA.studentId = S.studentId
    WHERE R.startDate <= IF('[?Run Date]' = '', CURDATE(), '[?Run Date]')
		AND (R.graduationDate IS NULL OR R.graduationDate >= DATE_FORMAT(DATE_SUB(IF('[?Run Date]' = '', CURDATE(), '[?Run Date]'), INTERVAL 3 MONTH), '%Y-%m-01'))
        AND SS.statusName IN ('Active', 'Graduated/Completed', 'Inactive/Past student/Withdrawn', 'Inactive/Past Student/Dropped', 'Leave of Absence')
        AND S.<ADMINID>
) t1
    