-- INS Summit Salon Details
-- Written by ??

SELECT Concat(S.FirstName, '  ', S.lastName) AS 'Student ', SC.serviceName, SC.parentCategory, SC.creationDtTm,
                CONCAT('<div align="right">','$',ROUND(SC.lineAmount,2),'</div>') AS 'Service Amount'
   FROM StudentServiceCustomerReltn SC
   INNER JOIN Students S ON S.studentId = SC.studentId
   INNER JOIN ProfileFieldValues PFVS
 		 ON PFVS.UserID = SC.studentID AND
                        PFVS.fieldValue =
 			  (SELECT PFVT.fieldValue 
 				 FROM ProfileFieldValues PFVT
                               WHERE PFVT.usertype = 3 AND
                                             PFVT.userID = [USERID] AND
                                             PFVT.FieldName = 'TEAM_NAME')
  WHERE SC.creationDtTm > DATE('2018-08-01') AND
                SC.ParentCategory IN ('Service','Retail', '1. Service') AND
                SC.<ADMINID>
     Order by Concat(S.FirstName, '  ', S.lastName), SC.creationDtTm