-- BPI Student Information Fact Sheet
-- 10/15/18 Kelly MJ

SELECT CONCAT(S.lastName, ', ', S.firstName) 'Student Name'
    , CONCAT(S.address, ', ', S.city, ', ', S.state, ', ', S.zip)'Address'
    , COALESCE(S.homePhone, 'N/A') 'Home Phone' -- coalesce home/cell number
    , COALESCE(S.cellPhone, 'N/A') 'Cell Phone'
    , S.email 'Email Address'
    , P.programmeName 'Program Completed'
    , DATE_FORMAT(R.startDate, '%m/%d/%y') 'Program Start Date'
    , DATE_FORMAT(R.endDate, '%m/%d/%y') 'Scheduled Completion Date'
    , DATE_FORMAT(R.graduationDate, '%m/%d/%y') 'Actual Completion Date'
    , LIC_EXAM.fieldValue 'License Examination'
    , RESULTS.fieldValue 'Exam Results'
    , UNAVAIL.fieldValue 'Unavailable for graduation or Employment'
    , PL_OF_EMPL.fieldValue 'Place of Employment'
    , EMPL_NAME.fieldValue 'Contact Person at Employment'
    , EMPL_PHONE.fieldValue 'Employer Phone'
    , EMPL_ADDR.fieldValue 'Employer Address'
    , EMPL_EMAIL.fieldValue 'Employer Email Address'
    , START_DATE.fieldValue 'Date Employment Began'
    , END_DATE.fieldValue 'Date Employment Ended'
    , VERIFIED.fieldValue 'Date Employment Verified'
    , CONTACT.fieldValue 'Communication with Employer'
    , SELF.fieldValue 'Self Employed (Y/N)'
    -- , 'Documentation of Self Employment'
    -- , 'Job Classifications for Gainful Employment'
    , SALARY.fieldValue 'Actual Salary'
    , HOURS.fieldValue 'Hours per Week'
    , A1.fieldValue 'Attempt 1 to contact Student or employer'
    , A2.fieldValue 'Attempt 2 to contact Student or employer'
    , A3.fieldValue 'Attempt 3 to contact Student or employer'
    
FROM Students S

INNER JOIN Registrations R
    ON R.studentId = S.studentId
	AND R.isActive = 1

INNER JOIN (SELECT studentId, MAX(startDate) AS maxDate FROM Registrations GROUP BY studentId) R2
    ON R2.studentId = R.studentId AND R2.maxDate = R.startDate
    
INNER JOIN Programmes P
    ON P.programmeId = R.programmeId
    
LEFT JOIN ProfileFieldValues LIC_EXAM
    ON LIC_EXAM.userId = S.studentId AND LIC_EXAM.fieldName = 'TOOK_EXAM'

LEFT JOIN ProfileFieldValues RESULTS
    ON RESULTS.userId = S.studentId AND RESULTS.fieldName = 'PASS_ALL_PARTS'

LEFT JOIN ProfileFieldValues UNAVAIL
    ON UNAVAIL.userId = S.studentId AND UNAVAIL.fieldName = 'UNAVAILABLE_FOR_GRADUATION_OR_PLACEMENT'
    
LEFT JOIN ProfileFieldValues PL_OF_EMPL
    ON PL_OF_EMPL.userId = S.studentId AND PL_OF_EMPL.fieldName = 'PLACE_OF_EMPLOYMENT'
    
LEFT JOIN ProfileFieldValues EMPL_NAME
	ON EMPL_NAME.userId = S.studentId AND EMPL_NAME.fieldName = 'EMPLOYER_NAME'

LEFT JOIN ProfileFieldValues EMPL_PHONE
    ON EMPL_PHONE.userId = S.studentId AND EMPL_PHONE.fieldName = 'EMPLOYER_PHONE'

LEFT JOIN ProfileFieldValues EMPL_ADDR
    ON EMPL_ADDR.userId = S.studentId AND EMPL_ADDR.fieldName = 'EMPLOYER_ADDRESS'
    
LEFT JOIN ProfileFieldValues EMPL_EMAIL
    ON EMPL_EMAIL.userId = S.studentId AND EMPL_EMAIL.fieldName = 'EMPLOYER_CONTACT_EMAIL'
    
LEFT JOIN ProfileFieldValues START_DATE
    ON START_DATE.userId = S.studentId AND START_DATE.fieldName = 'EMPLOYMENT_START_DATE'
    
LEFT JOIN ProfileFieldValues END_DATE
    ON END_DATE.userId = S.studentId AND END_DATE.fieldName = 'EMPLOYMENT_END_DATE_IF_APPLICABLE'
    
LEFT JOIN ProfileFieldValues VERIFIED
    ON VERIFIED.userId = S.studentId AND VERIFIED.fieldName = 'VERIFICATION_DATE'
    
LEFT JOIN ProfileFieldValues CONTACT
    ON CONTACT.userId = S.studentId AND CONTACT.fieldName = 'EMPLOYER_CONTACT'
    
LEFT JOIN ProfileFieldValues SELF
    ON SELF.userId = S.studentId AND SELF.fieldName = 'SELF_EMPLOYED_'
    
LEFT JOIN ProfileFieldValues SALARY
    ON SALARY.userId = S.studentId AND SALARY.fieldName = 'SALARY_RANGE'

LEFT JOIN ProfileFieldValues HOURS
    ON HOURS.userId = S.studentId AND HOURS.fieldName = 'HOURS_PER_WEEK'

LEFT JOIN ProfileFieldValues A1
    ON A1.userId = S.studentId AND A1.fieldName = 'ATTEMPT_1'

LEFT JOIN ProfileFieldValues A2
    ON A2.userId = S.studentId AND A2.fieldName = 'ATTEMPT_2'
    
LEFT JOIN ProfileFieldValues A3
    ON A3.userId = S.studentId AND A3.fieldName = 'ATTEMPT_3'

WHERE S.<ADMINID>
GROUP BY S.studentId

-- ORDER BY S.studentId
-- LIMIT 50