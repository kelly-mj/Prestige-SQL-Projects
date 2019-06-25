-- [SHELL] ASM Admissions Dashboard
-- Kelly MJ  |  06/17/2019
-- Displays a list of the numbers of types of leads assigned to each admissions employee; links to Query Report to view detailed list of leads.

SELECT CONCAT('<a target="_blank" href="admin_run_query.jsp?queryid=', CAST((SELECT queryId FROM Queries WHERE queryTitle='Lead List') AS CHAR),'">', CT.typeName,'</a>') AS 'Lead Type'
    , COUNT(C.contactId) AS 'Count'

FROM Contacts C
INNER JOIN ContactTypes CT ON CT.contactTypeId = C.contactTypeId
INNER JOIN ProfileFieldValues CMP ON CMP.userId = C.contactId
    AND CMP.fieldName = 'CAMPUS'

WHERE SUBSTRING(CT.typeName, 1, 1) IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '0')
AND SUBSTRING(CT.typeName, 1, 2) <> '86'
AND CMP.fieldValue = (SELECT fieldValue FROM ProfileFieldValues WHERE userId = [USERID] AND fieldName = 'CAMPUS')
AND C.<ADMINID>
AND C.isActive = 1

GROUP BY C.contactTypeId
ORDER BY CAST(SUBSTRING(CT.typeName, 1, 2) AS SIGNED)
