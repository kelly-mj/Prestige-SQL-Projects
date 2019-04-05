-- BENES ADM Current SAP Report
-- Kelly MJ  |  3/27/19
  -- Looks for students who have 20 hours remaining until their next SAP date, or are 50 hours past their last SAP date.
  -- Displays whether there is a SAP report for that period or not.

SELECT t2.Name
	, t2.Program
	, t2.hoursScheduled AS 'Hours Scheduled'
	, t2.SAPPeriod AS 'SAP Period'
/*	, COALESCE(IF(t2.dueDate >= CURDATE()
				, DATE_FORMAT(t2.dueDate, '%m/%d/%y')
				, DATE_FORMAT(t2.dueDate, '<span style="color: red;">%m/%d/%y</span>'))
		, 'No due date')  'Due Date'  */
	, COALESCE(IF(t2.SAPReports > 0
					, DATE_FORMAT(t2.dueDate, '<div style="background-color: #bdefaa; color: black;">%m/%d/%y</div>')
					, IF(t2.dueDate >= CURDATE()
							, DATE_FORMAT(t2.dueDate, '%m/%d/%y')
							, DATE_FORMAT(t2.dueDate, '<div style="background-color: #ffb7af; color: black;">%m/%d/%y</div>')))
			, 'No due date') 'Due Date'
	, IF(t2.SAPReports > 0
		, CONCAT(t2.SAPurl, 'Yes</a>')
        , CONCAT(t2.SAPurl, 'No', IF(t2.dueDate < CURDATE(), '; Past due', ''),'</a>')) 'SAP Documents'

FROM (
	SELECT t1.*
		, (SELECT MAX(PPD.payPeriodDate) FROM PayPeriodDates PPD WHERE PPD.studentId = t1.studentId AND PPD.payPeriodNo = t1.SAPPeriod GROUP BY PPD.studentId) AS dueDate
        , CASE t1.SAPPeriod
			WHEN 1 THEN t1.fileCount1
			WHEN 2 THEN t1.fileCount2
			WHEN 3 THEN t1.fileCount3
			WHEN 4 THEN t1.fileCount4 END AS SAPReports
		, '<a target="_blank" href="files_and_documents.jsp?userid=' AS SAPurlStart
		, CASE t1.SAPPeriod
			WHEN 1 THEN CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(t1.studentId AS CHAR)
								, '&usertype=1&folderFolderReltnId='
								, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 1' AND isActive = 1) AS CHAR)
								, '&previousFolderId=0,0">')
			WHEN 2 THEN CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(t1.studentId AS CHAR)
								, '&usertype=1&folderFolderReltnId='
								, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2' AND isActive = 1) AS CHAR)
								, '&previousFolderId=0,0">')
			WHEN 3 THEN CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(t1.studentId AS CHAR)
								, '&usertype=1&folderFolderReltnId='
								, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3' AND isActive = 1) AS CHAR)
								, '&previousFolderId=0,0">')
			WHEN 4 THEN CONCAT('<a target="_blank" href="files_and_documents.jsp?userid=', CAST(t1.studentId AS CHAR)
								, '&usertype=1&folderFolderReltnId='
								, CAST((SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4' AND isActive = 1) AS CHAR)
								, '&previousFolderId=0,0">') END AS SAPurl

	FROM (
		SELECT CONCAT('<a target="_blank" href="admin_view_student.jsp?studentid=', CAST(S.studentId AS CHAR), '">', S.lastName, ', ', S.firstName, '</a>') AS Name
					, S.studentId
					, P.programmeName AS Program
					, P.minClockHours AS programHours
					, SCH.hoursScheduled
					, PP.programmeId	-- Matching program in PayPeriod table
					, PP.ppHours		-- Hours in matching program (1200, 600, 360)
					, PP.disbPercent	-- How the payments are split up (100%, 50%, 25% per pay period)
					, CASE WHEN (SELECT MAX(PP.payPeriodHours) FROM PayPeriod PP WHERE PP.programmeId = P.programmeId) = 1200
							 THEN CASE WHEN 450  - hoursScheduled BETWEEN -50 AND 20 THEN 1
									   WHEN 900  - hoursScheduled BETWEEN -50 AND 20 THEN 2
									   WHEN 1050 - hoursScheduled BETWEEN -50 AND 20 THEN 3
									   WHEN 1200 - hoursScheduled BETWEEN -50 AND 20 THEN 4
									   ELSE 5 END
						WHEN (SELECT MAX(PP.payPeriodHours) FROM PayPeriod PP WHERE PP.programmeId = P.programmeId) = 600 AND PP.disbPercent = 50.0
							 THEN CASE WHEN 301  - hoursScheduled BETWEEN -50 AND 20 THEN 1
									   WHEN 600  - hoursScheduled BETWEEN -50 AND 20 THEN 2
									   ELSE 5 END
						WHEN (SELECT MAX(PP.payPeriodHours) FROM PayPeriod PP WHERE PP.programmeId = P.programmeId) = 600 AND PP.disbPercent = 100.0
							 THEN CASE WHEN 600  - hoursScheduled BETWEEN -50 AND 20 THEN 1
									   ELSE 5 END
						WHEN (SELECT MAX(PP.payPeriodHours) FROM PayPeriod PP WHERE PP.programmeId = P.programmeId) = 360 AND PP.disbPercent = 50.0
							 THEN CASE WHEN 180  - hoursScheduled BETWEEN -50 AND 20 THEN 1
									   WHEN 360  - hoursScheduled BETWEEN -50 AND 20 THEN 2
									   ELSE 5 END
						ELSE 'Something has gone horribly wrong'
				   END AS SAPPeriod
	               , DISB1.fileCount1
	               , DISB2.fileCount2
	               , DISB3.fileCount3
	               , DISB4.fileCount4

				FROM Students S

				INNER JOIN (SELECT studentId, MAX(registrationId) AS maxReg FROM Registrations WHERE isActive = 1 GROUP BY studentId) RR
					ON RR.studentId = S.studentId

				INNER JOIN Registrations R ON R.studentId = S.studentId
					AND R.registrationId = RR.maxReg

				INNER JOIN Programmes P ON P.programmeId = R.programmeId

				INNER JOIN (SELECT programmeId, MAX(payPeriodHours) ppHours, MAX(payPeriodDisbPercent) disbPercent FROM PayPeriod GROUP BY programmeId) PP
					ON PP.programmeId = R.programmeId

				INNER JOIN (SELECT PFV.userId, PFV.fieldValue AS hoursScheduled FROM ProfileFieldValues PFV WHERE PFV.fieldName = 'PROGRAM_HOURS_SCHEDULED') SCH
					ON SCH.userId = S.studentId

				LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount1 FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 1' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 1' AND isActive = 1)
							GROUP BY userId) DISB1
			        ON DISB1.userId = S.studentId

				LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount2 FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 2' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 2' AND isActive = 1)
							GROUP BY userId) DISB2
			        ON DISB2.userId = S.studentId

				LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount3 FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 3' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 3' AND isActive = 1)
							GROUP BY userId) DISB3
			        ON DISB3.userId = S.studentId

			    LEFT JOIN (SELECT userId, COUNT(folderFileReltnId) AS fileCount4 FROM FolderFileReltn
							WHERE folderFolderReltnId = (SELECT folderFolderReltnId FROM FolderFolderReltn WHERE folderName = 'Disbursement 4' AND isActive = 1)
							  AND documentTypeId = (SELECT documentTypeId FROM DocumentType WHERE documentType = 'SAP 4' AND isActive = 1)
							GROUP BY userId) DISB4
			        ON DISB4.userId = S.studentId

				WHERE S.isActive = 1
				   AND S.<ADMINID>
			) t1

		WHERE t1.SAPPeriod < 5
	) t2
WHERE ((t2.SAPReports < 1 OR t2.SAPReports IS NULL) OR (t2.SAPReports > 0 AND t2.dueDate >= CURDATE()))

ORDER BY t2.dueDate ASC
