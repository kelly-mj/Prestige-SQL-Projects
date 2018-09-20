-- Total Attendance Hours Graph: Admin-view widget
-- Author: Kelly MJ  |  08/29/2018
-- Shows cumulative hours attended per day for the past 7 days

SELECT t1.dateAtt AS 'Date'
	, t1.total AS 'cumulative hours'

FROM (
	SELECT DATE_FORMAT(A.attendanceDate, '%d') AS dateAtt
	    , DAYOFWEEK(A.attendanceDate) AS day
		, SUM(A.duration) AS total
	    
	FROM Attendance A

	WHERE A.attendanceDate >= DATE_SUB(CURDATE(), INTERVAL 31 DAY) AND A.attendanceDate < CURDATE()
	AND A.<ADMINID>

	GROUP BY A.attendanceDate
) t1

WHERE t1.total > 0