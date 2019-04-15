-- Developer: Zachary Bene
-- Last Update: 2019-03-19
-- All Clock Punches Display for Teachers
-- The purpose of this query is to list all of the instructor clock times for the day.
-- Note: The query does not check for isActive = 1 ClockPunches entries because same day entries can be either 1 or 2
-- 2019-03-14 Bern modified to group each day's punches
-- 2019-03-19 Bern added ORDER BY TIME(CKP.punchtime) to the GROUP_CONCAT to fix the punch times not sorting correctly
-- 2019-04-15 Kelly added custom input fields for Teacher ID and date range - for use in Query Reports


(SELECT CONCAT(TCH.lastName, ', ', TCH.firstName) AS 'Punch Date'
	, NULL AS 'Day of the Week'
	, NULL AS 'Punch Times'
FROM Teachers TCH
WHERE TCH.teacherId = '[?Employee ID]'
AND TCH.<ADMINID>
)

UNION
(SELECT DATE_FORMAT(CKP.punchtime,'%m/%d/%Y') 'Punch_Date'
	, DAYNAME(`CKP`.`punchtime`) as 'Day of the Week'
	, GROUP_CONCAT(
		CASE WHEN CKP.clockedStatus  = 1 THEN CONCAT('Clocked In - ', DATE_FORMAT(`CKP`.`punchtime`, '%h:%i %p'))
			WHEN CKP.clockedStatus  = 2 THEN CONCAT('Clocked Out - ', DATE_FORMAT(`CKP`.`punchtime`, '%h:%i %p'))
			WHEN CKP.clockedStatus  = 0 THEN CONCAT('Manual - ', DATE_FORMAT(`CKP`.`punchtime`, '%h:%i %p'))
			END  ORDER BY TIME(CKP.punchtime) SEPARATOR "<br>" ) AS 'Punch Times'

FROM ClockPunches CKP
INNER JOIN Teachers TCH ON CKP.userId = TCH.teacherId AND NOT TCH.isActive = 0
AND TCH.teacherId = '[?Employee ID]'

WHERE NOT CKP.isActive = 0
AND CKP.<ADMINID>
AND DATE(CKP.Punchtime)  BETWEEN (CURRENT_DATE - INTERVAL [?# of days to look back] DAY) AND CURRENT_DATE

GROUP BY DATE(CKP.punchtime)
)
