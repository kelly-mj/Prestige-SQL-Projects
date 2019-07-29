-- [Cortiva] ADM, STF Leads from Past 7 Days
-- Kelly MJ  |  7/7/2019
-- Shows a list of all leads (expect 86. Lost, 8. Enrolled, 9. Started)

SELECT IFNULL(CMP.campusName, '<div style="">No campus</div>') AS Campus
	, CT.typeName AS Status
	, CONCAT('<a href="admin_view_contact.jsp?contactid=', CAST(C.contactId AS CHAR), '">', CAST(C.lastName AS CHAR), ', ', CAST(C.firstName AS CHAR), '</a>') AS Name
	, DATE_FORMAT(C.creationDtTm, '%m-%d %h:%i') AS 'Date Added'
	, DATE_FORMAT(C.lastUpdateDtTm, '%m-%d %h:%i') AS 'Last Update'

FROM Contacts C
INNER JOIN ContactTypes CT ON C.contactTypeId = CT.contactTypeId
LEFT JOIN Campuses CMP ON CMP.campusCode = C.campusCode

WHERE C.isActive = 1
AND (CT.typeName = '1. New Leads'
   OR DATE(C.creationDtTm) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) )
AND SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
AND CT.typeName NOT IN ('Salon Customer', '86. Lost - Not Interested - Cancel')
AND CT.isActive=1
AND C.<ADMINID>

ORDER BY DATE(C.creationDtTm) DESC, CMP.campusName ASC
