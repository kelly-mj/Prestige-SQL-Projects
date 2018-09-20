-- Author: Kelly MJ
-- Created 06/25/18
-- Displays totals for any sales registered for customer 'backbar backbar,' which is used to represent any product used by a student doing a service.


-- Lists the product name, sale date, number of units per sale and price of each sale.
SELECT SC.customerName AS 'Customer Name'
             , SC.serviceName AS 'Product'
             , DATE_FORMAT(SC.lastUpdateDtTm, "%b %d, %Y") AS 'Date'
             , COUNT(SC.studentServiceCustomerReltnId) AS 'Units'
             , CONCAT('$', ROUND(SC.ticketTotal, 2)) AS 'Amount'

-- Selects data for 'Backbar Back' sales from StudentServiceCustomerReltn between user-entered dates
FROM (SELECT *
	  FROM StudentServiceCustomerReltn SC 
	  WHERE DATE(SC.creationDtTm) BETWEEN '[?Start Date]' AND '[?End Date]'
	  AND SC.customerName LIKE '%backbar%back%') SC

WHERE SC.<ADMINID>

GROUP BY SC.serviceName, DATE(SC.creationDtTm)


UNION


-- This displays the total number of units sold and the total price for all the sales.
-- The "Grand Total" row is HTML formatted to make the text large and bold against a light blue background.
SELECT CONCAT('<tr style="text-align: left; background-color: #a8c6f7; font-weight: bold;">
                                     <td>
                                     </td>
                                     <td style="font-size: 150%;">
                                             Grand total:
                                     </td>
                                     <td>
                                     </td>
                                     <td style="font-size: 150%;">
                                            ', COUNT(SC2.studentServiceCustomerReltnId), '            <!-- Total units sold -->
                                     </td>
                                     <td style="font-size: 150%;">
                                            $', ROUND(SUM(SC2.ticketTotal), 2), '                              <!-- Total dollar amount of sales -->
                                     </td>
                                 </tr>')
        , '</div>'
        , '</div>'        -- Essentially null values for the empty columns; I wasn't able to get rid of the empty row that appears after the formatted "Grand Total" row.
        , '</div>'
        , '</div>'

FROM (SELECT * 
	     FROM StudentServiceCustomerReltn SC 
	     WHERE DATE(SC.creationDtTm) BETWEEN '[?Start Date]' AND '[?End Date]'
	     AND SC.customerName LIKE '%backbar%back%') SC2

WHERE SC2.<ADMINID>
