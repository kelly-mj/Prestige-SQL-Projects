-- written by Nilima

Select Distinct 
S.firstName 'FIRST NAME'
,LEFT(S.middleName,1) 'MIDDLE INITIAL'
,S.lastName 'LAST NAME'
,REPLACE(S.SSN,'-','') 'STUDENT SSN'
,S.idNumber 'STUDENT ID NUMBER'
,IF(S.race=1,'C',IF(S.race=2,'A',IF(S.race=4,'U',IF(S.race=6,'H','O')))) 'RACE'
,S.sex 'GENDER'
,DATE_FORMAT(S.dateOfBirth,'%m/%d/%Y') 'DOB'
,(Select P.programmeName From Programmes P Where P.programmeId = R.programmeId AND P.<ADMINID>) 'PROGRAM NAME'
,IFNULL(P1.fieldValue, '') 'PROGRAM CODE'
,IFNULL(P2.fieldValue, '') 'CIP CODE'
,IF(R.methodOfDelivery=1,'R',IF(R.methodOfDelivery=2,'B','F')) 'DELIVERY MODE'
,IFNULL(P3.fieldValue, '') 'PROGRAM LENGTH'
,IFNULL(P4.fieldValue, '') 'CREDENTIAL (#)'
,DATE_FORMAT(R.startDate,'%m/%d/%Y') 'DATE STARTED'
,IF(R.regStatus = 3, DATE_FORMAT(R.graduationDate,'%m/%d/%Y'), " " ) 'DATE COMPLETED'
,IF(R.regStatus = 0, DATE_FORMAT(R.graduationDate,'%m/%d/%Y'), " " ) 'DATE WITHDREW'
,IFNULL(P5.fieldValue, '') 'SPECIAL CIRCUMSTANCE WITHDREW (#)'
,IF(P6.fieldValue='TRUE','Y',IF(P6.fieldValue='FALSE','N','')) 'PLACED (Y/N)'
,IF(P7.fieldValue='TRUE','Y',IF(P7.fieldValue='FALSE','N','')) 'PLACED IN-FIELD (Y/N)'
,IFNULL(P8.fieldValue, '') 'SPECIAL CIRCUMSTANCE NON-PLACEMENT (#)'
,IFNULL(P9.fieldValue, '') 'NAME OF EMPLOYER'
,IFNULL(P10.fieldValue, '') 'FULL ADDRESS OF EMPLOYER'
,IFNULL(P11.fieldValue, '') 'TELEPHONE NUMBER OF EMPLOYER'
,IFNULL(P12.fieldValue, '') 'ANNUAL SALARY OR HOURLY WAGE'

From Registrations R, Students S
LEFT JOIN ProfileFieldValues P1 ON P1.userId = S.studentId AND P1.userType = 1 AND P1.isActive = 1 AND P1.fieldValue<>'' AND P1.<ADMINID> AND P1.fieldName ='PROGRAM_CODE'
LEFT JOIN ProfileFieldValues P2 ON P2.userId = S.studentId AND P2.userType = 1 AND P2.isActive = 1 AND P2.fieldValue<>'' AND P2.<ADMINID> AND P2.fieldName ='CIP_CODE'
LEFT JOIN ProfileFieldValues P3 ON P3.userId = S.studentId AND P3.userType = 1 AND P3.isActive = 1 AND P3.fieldValue<>'' AND P3.<ADMINID> AND P3.fieldName ='PROGRAM_LENGTH'
LEFT JOIN ProfileFieldValues P4 ON P4.userId = S.studentId AND P4.userType = 1 AND P4.isActive = 1 AND P4.fieldValue<>'' AND P4.<ADMINID> AND P4.fieldName ='CREDENTIALS'
LEFT JOIN ProfileFieldValues P5 ON P5.userId = S.studentId AND P5.userType = 1 AND P5.isActive = 1 AND P5.fieldValue<>'' AND P5.<ADMINID> AND P5.fieldName ='SCW'
LEFT JOIN ProfileFieldValues P6 ON P6.userId = S.studentId AND P6.userType = 1 AND P6.isActive = 1 AND P6.fieldValue<>'' AND P6.<ADMINID> AND P6.fieldName ='PLACED'
LEFT JOIN ProfileFieldValues P7 ON P7.userId = S.studentId AND P7.userType = 1 AND P7.isActive = 1 AND P7.fieldValue<>'' AND P7.<ADMINID> AND P7.fieldName ='PLACED_IN_FIELD'
LEFT JOIN ProfileFieldValues P8 ON P8.userId = S.studentId AND P8.userType = 1 AND P8.isActive = 1 AND P8.fieldValue<>'' AND P8.<ADMINID> AND P8.fieldName ='SCNP'
LEFT JOIN ProfileFieldValues P9 ON P9.userId = S.studentId AND P9.userType = 1 AND P9.isActive = 1 AND P9.fieldValue<>'' AND P9.<ADMINID> AND P9.fieldName ='EMPLOYER_NAME'
LEFT JOIN ProfileFieldValues P10 ON P10.userId = S.studentId AND P10.userType = 1 AND P10.isActive = 1 AND P10.fieldValue<>'' AND P10.<ADMINID> AND P10.fieldName ='EMPLOYER_ADDRESS'
LEFT JOIN ProfileFieldValues P11 ON P11.userId = S.studentId AND P11.userType = 1 AND P11.isActive = 1 AND P11.fieldValue<>'' AND P11.<ADMINID> AND P11.fieldName ='EMPLOYER_PHONE'
LEFT JOIN ProfileFieldValues P12 ON P12.userId = S.studentId AND P12.userType = 1 AND P12.isActive = 1 AND P12.fieldValue<>'' AND P12.<ADMINID> AND P12.fieldName ='ANNUAL_SALARY_OR_HOURLY_WAGE'

Where R.isActive = 1 
AND ((R.graduationDate IS NULL OR R.graduationDate  BETWEEN '[?From Date]' AND '[?To Date]')
OR (R.startDate  BETWEEN '[?From Date]' AND '[?To Date]'))
AND R.startDate <= '[?To Date]'
AND R.<ADMINID>
AND R.studentId = S.studentId AND S.<ADMINID>
AND S.isActive<>14 AND R.regstatus<>14
ORDER BY S.firstName,S.middleName,S.lastName
