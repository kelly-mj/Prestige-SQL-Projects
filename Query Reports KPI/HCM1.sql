-- 2019-07-23 BBR - Per Dave remove   Current Payment Period start date, Current Payment Period- End Date, Current Loan Period End Date if applicable

SELECT DISTINCT
  STD.firstName,
  STD.lastName,
  REPLACE(STD.ssn, '-', '') AS SSN,
  DATE_FORMAT(STD.dateOfBirth, '%m/%d/%Y') AS 'Date of Birth',
  HSN.fieldValue AS 'PriorEducation',
  STD.graduationType,
  DATE_FORMAT(STD.hsGraduationDate, '%m/%d/%Y') AS hsGraduationDate,
  Campuses.federalId AS 'OPEID',
  DATE_FORMAT(REG.registrationDate, '%m/%d/%Y') AS registrationDate,
  P.programmeName,
  DATE_FORMAT(REG.startDate, '%m/%d/%Y') AS startDate,
  DATE_FORMAT(REG.startDate, '%m/%d/%Y') AS startDate,
  'C' AS 'EducationDeliveryMethod',
  IF(REG.enrollmentType=1,'FT','PT') AS 'Current Enrollment Status',
  NULL AS 'Pay Period Start Date',
  NULL AS 'Pay Period End Date',
  NULL AS 'Current Loan Period - Start Date',
  NULL AS 'Current Loan Period - End Date',
 -- StatusSequences.statusName,
--  'TBD' AS 'Current Payment Period start date',
--  'TBD' AS 'Current Payment Period- End Date',
--  'TBD' AS 'Current Loan Period End Date if applicable',
  IF(STD.cellPhone='','', concat('(',substr(replace(replace(replace(STD.cellPhone,'(',''),')',''),'-',''),1,3),') ',substr(replace(replace(replace(STD.cellPhone,'(',''),')',''),'-',''),4,3),'-',substr(replace(replace(replace(STD.cellPhone,'(',''),')',''),'-',''),7))) AS CellNumber,
  IF(STD.homePhone='','', concat('(',substr(replace(replace(replace(STD.homePhone,'(',''),')',''),'-',''),1,3),') ',substr(replace(replace(replace(STD.homePhone,'(',''),')',''),'-',''),4,3),'-',substr(replace(replace(replace(STD.homePhone,'(',''),')',''),'-',''),7))) AS homePhone,
 -- STD.homePhone,
  '' AS 'Alternative Phone',
  STD.email,
  STD.address,
  STD.city,
  STD.state,
  STD.zip,
  DATE_FORMAT(t1.LDA, '%m/%d/%Y') AS 'Last Date Attended'
FROM Students STD
  LEFT OUTER JOIN Registrations REG
    ON REG.studentId = STD.studentId
  LEFT OUTER JOIN Programmes P
    ON P.programmeId = REG.programmeId
  LEFT OUTER JOIN StatusSequences
    ON STD.isActive = StatusSequences.statusId
  LEFT OUTER JOIN (SELECT
      A.studentId,
      MAX(A.attendanceDate) AS LDA
    FROM Attendance A
    WHERE A.isActive = 1
    GROUP BY A.studentId) t1
    ON REG.studentId = t1.studentId
  LEFT OUTER JOIN ProfileFieldValues HSN
    ON HSN.userId = STD.studentId
    AND HSN.fieldName = 'HIGH_SCHOOL_NAME/_OR_EQUIVALENT'
  LEFT OUTER JOIN Campuses
    ON STD.studentCampus = Campuses.campusCode
WHERE REG.isActive = 1
AND P.isActive = 1
AND STD.firstName NOT LIKE '%test%'
AND STD.studentId NOT IN (SELECT DISTINCT
    L.studentId
  FROM LeavesOfAbsence L
  WHERE L.isActive = 1
  AND L.leaveDate < NOW() - INTERVAL 120 DAY
  AND (L.returnDate IS NULL
  OR L.returnDate > NOW() - INTERVAL 120 DAY))
AND REG.startDate <= NOW()
AND (REG.graduationDate = '1900-01-01'
OR REG.graduationDate = ''
OR REG.graduationDate IS NULL)
AND STD.isActive = 1
AND STD.<ADMINID>

ORDER BY 'OPEID', STD.lastName, STD.firstName
