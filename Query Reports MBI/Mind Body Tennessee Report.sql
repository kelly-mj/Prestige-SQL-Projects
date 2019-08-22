SELECT DISTINCT
CONVERT(CONCAT("<a target=_blank href='admin_view_student.jsp?studentid=", S.studentId, "'>", S.firstName, "</a>"), CHAR CHARACTER SET utf8) 'FIRST NAME'
,LEFT(S.middleName,1) 'MIDDLE INITIAL'
,S.lastName 'LAST NAME'
,REPLACE(S.SSN,'-','') 'STUDENT SSN'
,S.idNumber 'STUDENT ID NUMBER'
,IF(S.race=1,'C',IF(S.race=2,'A',IF(S.race=4,'U',IF(S.race=6,'H','O')))) 'RACE'
,S.sex 'GENDER'
,DATE_FORMAT(S.dateOfBirth,'%m/%d/%Y') 'DOB'
,(SELECT P.programmeName FROM Programmes P Where P.programmeId = R.programmeId AND P.<ADMINID>) 'PROGRAM NAME'
,IFNULL(P1.fieldValue, '') 'PROGRAM CODE'
,IFNULL(P2.fieldValue, '') 'CIP CODE'
,IF(R.methodOfDelivery=1,'R',IF(R.methodOfDelivery=2,'B','F')) 'DELIVERY MODE'
,IFNULL(P3.fieldValue, '') 'PROGRAM LENGTH'
,IFNULL(P4.fieldValue, '') 'CREDENTIAL (#)'
,DATE_FORMAT(R.startDate,'%m/%d/%Y') 'DATE STARTED'
,IF(R.regStatus = 3, DATE_FORMAT(R.graduationDate,'%m/%d/%Y'), " " ) 'DATE COMPLETED'
,IF(R.regStatus = 0, DATE_FORMAT(R.graduationDate,'%m/%d/%Y'), " " ) 'DATE WITHDREW'
,IFNULL(P5.fieldValue, '') 'SPECIAL CIRCUMSTANCE WITHDREW (#)'
,IF(CP.placementStatus='PLACED' OR CP.placementStatus='Employed in the Field' OR CP.placementStatus='Employed in Unrelated Field' OR CP.placementStatus='Employed by the Institution','Y','N') 'PLACED (Y/N)'
,IF(CP.placementStatus='Employed in the Field','Y','N') 'PLACED IN-FIELD (Y/N)'
,(CASE CP.waiverReason
WHEN "0" THEN "No Special Circumstance"
WHEN "1" THEN "Health related situation"
WHEN "2" THEN "Family Emergency"
WHEN "3" THEN "Death"
WHEN "4" THEN "Incarceration"
WHEN "5" THEN "Full Time Military Service"
WHEN "6" THEN "Job Relocated Transferred"
WHEN "7" THEN "Continuing education at Your Institution"
WHEN "8" THEN "Continuing education at Another Institution"
WHEN "9" THEN "Pending fulfillment of license requirements"
WHEN "10" THEN "International Students - unable to work"
WHEN "11" THEN "Could not be Contacted - Refused Work"
WHEN "12" THEN "Unknown"
WHEN "13" THEN "Volunteering"
WHEN "14" THEN IFNULL(CP.otherWaiverReason, 'Other')
END) 'SPECIAL CIRCUMSTANCE NON-PLACEMENT (#)'
,IFNULL(CP.companyName, '') 'NAME OF EMPLOYER'
,CONVERT(CONCAT(CP.companyAddress, " ", CP.companyCity, " ", CP.companyState, " ", CP.companyZip, " ", CP.companyCountry), CHAR CHARACTER SET utf8) 'FULL ADDRESS OF EMPLOYER'
,IFNULL(CP.salaryAmount, '0') 'TELEPHONE NUMBER OF EMPLOYER'
,IFNULL(CP.salaryAmount, '0') 'ANNUAL SALARY OR HOURLY WAGE'

FROM Students S
INNER JOIN Registrations R ON (R.studentId = S.studentId)
LEFT JOIN ProfileFieldValues P1 ON P1.userId = S.studentId AND P1.userType = 1 AND P1.isActive = 1 AND P1.fieldValue<>'' AND P1.<ADMINID> AND P1.fieldName ='PROGRAM_CODE'
LEFT JOIN ProfileFieldValues P2 ON P2.userId = S.studentId AND P2.userType = 1 AND P2.isActive = 1 AND P2.fieldValue<>'' AND P2.<ADMINID> AND P2.fieldName ='CIP_CODE'
LEFT JOIN ProfileFieldValues P3 ON P3.userId = S.studentId AND P3.userType = 1 AND P3.isActive = 1 AND P3.fieldValue<>'' AND P3.<ADMINID> AND P3.fieldName ='PROGRAM_LENGTH'
LEFT JOIN ProfileFieldValues P4 ON P4.userId = S.studentId AND P4.userType = 1 AND P4.isActive = 1 AND P4.fieldValue<>'' AND P4.<ADMINID> AND P4.fieldName ='CREDENTIALS'
LEFT JOIN ProfileFieldValues P5 ON P5.userId = S.studentId AND P5.userType = 1 AND P5.isActive = 1 AND P5.fieldValue<>'' AND P5.<ADMINID> AND P5.fieldName ='SCW'

LEFT JOIN CareerPlacements CP ON (CP.studentId = S.studentId AND CP.registrationId = R.registrationId AND CP.isActive = 1 AND CP.<ADMINID>)

WHERE R.isActive = 1
AND ((R.graduationDate IS NULL OR R.graduationDate  BETWEEN '[?From Date]' AND '[?To Date]')
OR (R.startDate  BETWEEN '[?From Date]' AND '[?To Date]'))
AND R.startDate <= '[?To Date]'
AND R.<ADMINID>
AND R.studentId = S.studentId AND S.<ADMINID>
AND S.isActive<>14 AND R.regstatus<>14
ORDER BY S.firstName,S.middleName,S.lastName
