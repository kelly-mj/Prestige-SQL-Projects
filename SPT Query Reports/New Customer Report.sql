-- SPATECH New Customer Report
-- Kelly MJ  |  12/20/2018

-- Header nonsense
(SELECT NULL AS 'Name'
	, NULL AS 'Phone'
	-- , NULL AS 'Campus'
    , '<br><br>' AS Date
    , NULL AS 'Comment Type'
    , CONCAT('Showing records in date range ', DATE_FORMAT('[?Start Date]', '%m/%d/%Y') ,' - ', DATE_FORMAT('[?End Date]', '%m/%d/%Y'),' for ', '[?Campus{Ipswich|Ipswich|Plymouth|Plymouth|Westbrook|Westbrook|Westborough|Westborough}]', ' campus') AS 'Comment'
    , NULL 'Staff Name'
)
UNION
(SELECT NULL, NULL, NULL, NULL, NULL, NULL)
-- end header


-- Query
UNION (
SELECT t1.Name, IF(t1.cellPhone > '1', CONCAT('Cell: ', t1.cellPhone), CONCAT('Home: ', t1.homePhone)) AS Phone, t1.Date, t1.Type, t1.Comment, t1.Staff

FROM (
	-- Comments
	SELECT CONCAT('<a target="_blank" href="view_comments.jsp?usertype=99&aboutuserid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS Name
		, PFV.fieldValue AS Campus
		, DATE_FORMAT(CM.commentDate, '%m/%d/%Y  %h:%i%p') AS Date
		, CMT.typeName AS Type
	    , CM.comments AS Comment
	    , CM.commentBy AS Staff
	    , C.lastName
	    , C.cellPhone
	    , C.homePhone

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
	AND CM.commentDate BETWEEN '[?Start Date]' AND '[?End Date]'
	AND PFV.fieldValue = '[?Campus{Ipswich|Ipswich|Plymouth|Plymouth|Westbrook|Westbrook|Westborough|Westborough}]'

	-- Correspondences
	UNION
	SELECT CONCAT('<a target="_blank" href="view_correspondences.jsp?usertype=99&aboutuserid=', CAST(C.contactId AS CHAR), '">', C.lastName, ', ', C.firstName, '</a>') AS Name
		, PFV.fieldValue AS Campus
		, DATE_FORMAT(CR.sendingDate, '%m/%d/%Y') AS Date
		, 'Correspondence' AS Type
		, CR.title AS Comment
	    -- , CR.message AS Comment
	    , ST.staffName AS Staff
	    , C.lastName
	    , C.cellPhone
	    , C.homePhone
	    
	FROM Correspondences CR

	INNER JOIN Contacts C
		ON C.contactId = CR.toUserId
	    
	INNER JOIN ProfileFieldValues PFV
		ON PFV.userId = C.contactId
		AND PFV.userType = 99
	    AND PFV.fieldName = 'CAMPUS'
	    AND PFV.isActive = 1

	INNER JOIN (
		SELECT teacherId AS staffId,  CONCAT(firstName, ' ', lastName) AS staffName FROM Teachers
		UNION
		SELECT subAdminId AS staffId, CONCAT(firstName, ' ', lastName) AS staffName FROM SubAdmins) ST	-- staff
		ON ST.staffId = CR.fromId

	WHERE CR.toUserType = 99
	AND C.isActive = 1
	AND C.<ADMINID>
	AND CR.sendingDate BETWEEN '[?Start Date]' AND '[?End Date]'
	AND PFV.fieldValue = '[?Campus{Ipswich|Ipswich|Plymouth|Plymouth|Westbrook|Westbrook|Westborough|Westborough}]'
	) t1

ORDER BY t1.lastName, t1.Date
)	-- end UNION