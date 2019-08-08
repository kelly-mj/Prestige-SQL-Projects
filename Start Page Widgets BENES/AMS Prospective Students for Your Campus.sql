-- AMS Prospective Students for Your Campus
-- Kelly MJ  |  7/30/2019

SELECT IFNULL(CMP.campusName, '<div style="">No campus</div>') AS Campus
	, CT.typeName AS Status
	, CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.lastName AS CHAR), ', ', CAST(C.firstName AS CHAR), '</a>') AS Name
	, DATE_FORMAT(C.creationDtTm, '%m-%d-%y') AS 'Date Added'
	, DATE_FORMAT(C.lastUpdateDtTm, '%m-%d %h:%i') AS 'Last Update'

FROM Contacts C
INNER JOIN ContactTypes CT ON C.contactTypeId = CT.contactTypeId
LEFT JOIN Campuses CMP ON CMP.campusCode = C.campusCode

WHERE C.isActive = 1
AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '0')
AND SUBSTRING(CT.typeName, 1, 2) <> '86'
AND CT.isActive = 1
#AND C.<ADMINID>
AND C.campusCode = (SELECT campusCode FROM SubAdmins WHERE subAdminId = [USERID])

ORDER BY C.creationDtTm DESC
