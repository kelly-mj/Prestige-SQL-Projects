SELECT CONCAT('<a target="_blank" href="view_comments.jsp?usertype=99&aboutuserid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS Name
	, PFV.fieldValue
	, DATE_FORMAT(CM.commentDate, '%m/%d/%Y  %h:%i%p') AS Date
	, CMT.typeName 'Comment Type'
    , CM.comments 'Comment'
    , CM.commentBy 'Staff Name'

FROM Contacts C

INNER JOIN ContactTypes CT
	ON CT.contactTypeId = C.contactTypeId
    
INNER JOIN Comments CM
	ON CM.userId = C.contactId
    AND CM.userType = 99
    AND CM.isActive = 1

INNER JOIN CommentTypes CMT
	ON CMT.commentTypeId = CM.commentTypeId

LEFT JOIN ProfileFieldValues PFV
	ON PFV.userId = C.contactId
    AND PFV.userType = 99
    AND PFV.fieldName = 'CAMPUS'
    AND PFV.isActive = 1

WHERE C.isActive = 1
AND C.<ADMINID>
AND CM.commentDate BETWEEN '2018-12-03' AND '2018-12-08'
AND PFV.fieldValue = 'Ipswich'
ORDER BY C.lastName, CM.commentDate