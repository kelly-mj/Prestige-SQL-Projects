-- WIDGET: Report Links (Admin, Front Staff view)
-- Kelly MJ  |  9/5/2018
-- List of links to start page widgets that were slowing the page down
-- Sorry about the horrible formatting; I was just trying to do this quickly

SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=36&type=spquery">New Starts</a>'  AS 'Report Link'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=37&type=spquery">At Risk Students</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=82&type=spquery">Students 100 Hours from Graduation</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=102&type=spquery">Untyped Documents</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=27&type=spquery">Active Student List for Financial Aid Start Pages    <---- MOVED WIDGET HERE</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=110&type=spquery">Students Missing Naccas Information</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=144&type=spquery">Admission Documents Audit</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=163&type=spquery">Tickets Without Stylists</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=185&type=spquery">Prospective Students for your Campus</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=206&type=spquery">Duplicate Students by SSN</a>'
FROM Admins A WHERE A.<ADMINID> UNION
SELECT '<a target="_blank" href="https://benes.orbund.com/einstein-freshair/view_startpage_query_report.jsp?queryid=222&type=spquery">Under 60% Attendance</a>'