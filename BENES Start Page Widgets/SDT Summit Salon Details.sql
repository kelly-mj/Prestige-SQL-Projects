SELECT SC.parentcategory, SC.serviceName, SC.creationDtTm, SC.customerName, CONCAT('<div align="right">','$',ROUND(SC.TicketTotal,2),'</div>') AS 'Ticket Total'
FROM StudentServiceCustomerReltn SC
WHERE  SC.studentID = [USERID]
AND CASE 
	WHEN MONTH(CURDATE()) = 1 THEN SC.creationDtTm BETWEEN CONCAT(YEAR(CURDATE())-1, '-12-01') AND LAST_DAY(CURDATE())
    WHEN MONTH(CURDATE()) IN (2, 4, 6, 8, 10) THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
    WHEN MONTH(CURDATE()) IN (3, 5, 7, 9, 11) THEN SC.creationDtTm BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AND LAST_DAY(CURDATE())
    WHEN MONTH(CURDATE()) = 12 THEN SC.creationDtTm BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
    ELSE 'error setting daterange'
    END
AND SC.<ADMINID>