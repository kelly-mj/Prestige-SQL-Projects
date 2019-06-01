SELECT CONCAT(S.lastName, ', ', S.firstName) AS Student
	, ISF.fieldTitle
	, IIV.fieldValue
	, II.*
    
FROM IsirInstance II

INNER JOIN Students S ON S.studentId = II.studentId

INNER JOIN IsirInstanceValue IIV ON IIV.isirInstanceId = II.isirInstanceId

INNER JOIN IsirField ISF ON ISF.isirFieldId = IIV.isirFieldId
	AND ISF.fieldTitle LIKE ('%Verification%')

WHERE S.studentId = 4048295

-- WHERE DATE(II.creationDtTm) BETWEEN '2019-01-01' AND '2019-02-01'
-- AND S.studentId = 4048250
-- WHERE IIV.fieldValue = 'V2'