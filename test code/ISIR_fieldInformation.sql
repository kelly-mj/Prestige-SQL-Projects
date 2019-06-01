SELECT CONCAT(S.lastName, ', ', S.firstName) AS Name
	, ISF.fieldName
    , IIV.fieldValue
	, DATE(II.creationDtTm) AS 'Date Created' 

FROM IsirInstanceValue IIV
INNER JOIN IsirField ISF ON ISF.isirFieldId = IIV.isirFieldId
INNER JOIN IsirInstance II ON II.isirInstanceId = IIV.isirInstanceId
INNER JOIN Students S ON S.studentId = II.studentId

WHERE ISF.fieldTitle LIKE 'Primary EFC'

LIMIT 100