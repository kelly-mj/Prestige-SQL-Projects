-- Kelly MJ  |  9/5/2018
-- Links to admin start page widgets

SELECT CONCAT('<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=', CAST(Q.queryId AS CHAR),'&type=spquery">', CAST(Q.queryTitle AS CHAR),'</a>') 'Widget Links'

FROM CustomStartPageQueries Q

WHERE Q.<ADMINID>
AND Q.userType = 4 
AND Q.queryTitle IN ('New Starts'
					, 'At Risk Students'
					, 'Students 100 Hours From Graduation'
					, 'Untyped Documents'
					, 'Active Student List for Financial Aid Start Pages'
					, 'LOA'
					, 'Students Missing Naccas Information'
					, 'Admission Documents Audit'
					, 'Tickets Without Stylists'
					, 'Prospective Students for your Campus'
					, 'Duplicate Students by SSN'
					, 'Under 60% Attendance')

GROUP BY Q.queryTitle