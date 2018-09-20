-- Written by Andrew
-- Edited by Kelly MJ
-- Last Updated: 6/6/2018
-- Changed hours total from hour:minute to decimal format
-- Now only sums up 1 duration value per employee per day to obtain weekly hours - this avoids counting double punches.
-- Added column to display Vacation/Illness reasons

-- NON=BENE'S VERSIONS: Have any campusCode columns/restrictions removed

SELECT t1.TeacherID, t1.Name AS 'Staff Member Name',
         
t1.DOW AS 'Day Of The Week',t1.ATDate AS 'Attendance Date',

CASE WHEN t1.reasonType > 0 
          THEN CASE WHEN t1.reasonType = 1 THEN IF (t1.reasonText > 'a', t1.reasonText, 'Illness')
                    WHEN t1.reasonType = 6 THEN IF (t1.reasonText > 'a', t1.reasonText, 'Vacation')
                    ELSE 'No reason text provided'
               END
     WHEN t1.reasonType < 1 AND t1.reasonText > 'a'
          THEN t1.reasonText
         -- THEN IF (t1.reasonText > 'a', t1.reasonText, '<a href="post_attendance_for_staff.jsp?semesterid=4000441&adate=05.28.2018">REASON MISSING - FILL IN</a>')
     ELSE NULL
     END AS 'Reason for Absence',
 
CONCAT('<div style="text-align: right;">',FLOOR(t1.duration),'.', LPAD(ROUND((t1.duration- FLOOR(t1.duration)) * 100)% 100,2,0),'</div>') AS Duration
 
FROM
      (SELECT T.teacherID AS TeacherID
        , CONCAT('<a href="admin_view_teacher.jsp?teacherid=', CAST(T.teacherId AS CHAR),'"target="_blank">', T.firstName, ' ', T.lastName, '</a>') AS Name
        , TA.attendanceDate AS ATdate
        , MAX(duration) AS duration
        , DAYNAME(TA.attendanceDate) AS DOW
        , MAX(TA.teacherAttendanceId)
        , TA.reasonType
        , TA.reasonText
       FROM TeacherAttendance TA
       INNER JOIN Teachers T 
           ON TA.teacherID = T.teacherID
       WHERE DATE(TA.attendancedate)  BETWEEN '[?Start Date]' AND '[?End Date]'
         AND TA.isactive = 1
         and T.isactive = 1  
         AND (duration > 0 OR TA.reasonType > 0 OR TA.reasonText > 'a')
         AND T.<ADMINID>
       GROUP BY T.teacherID, TA.attendancedate  
UNION
       SELECT SA.SubadminID AS TeacherID
       , CONCAT('<a href="admin_view_subadmin.jsp?subadminid=', CAST(SA.subAdminId AS CHAR),'" target="_blank">', SA.firstName, ' ', SA.lastName, '</a>') AS Name
       , SAA.attendanceDate AS ATdate
       , MAX(duration) AS duration
       , DAYNAME(SAA.attendanceDate) AS DOW
       , MAX(SAA.subAdminAttendanceId)
       , SAA.reasonType
       , SAA.reasonText
       FROM SubAdminAttendance SAA
       INNER JOIN SubAdmins SA 
       ON SA.SubAdminID = SAA.SubAdminID
       WHERE DATE(SAA.attendancedate)  BETWEEN '[?Start Date]' AND '[?End Date]'
         AND SAA.isactive = 1 
         and SA.isactive = 1 
         AND (duration > 0 OR SAA.reasonType > 0 OR SAA.reasonText > 'a') 
         AND SA.<ADMINID> 
         GROUP BY SA.subAdminID, SAA.attendanceDate
             ) AS t1   
UNION  
SELECT t3.TeacherID, NULL, NULL,  t3.n3, t3.n4, 
CONCAT('</td></tr><tr><td></td><td colspan="7" style="text-align: right; font color: white; font-size: 150%; font-weight: bold;">','',
CONCAT('</td></tr><tr><td></td><td colspan="7" style="text-align: right; font color: white; font-size: 150%; background-color: #A8D0E6; font-weight: bold;">','<div align="right">'
,t3.Name,"'s" '  Weekly Hours Are','  ', FLOOR(SUM(t3.duration)),'.', LPAD(ROUND((SUM(t3.duration)- FLOOR(SUM(t3.duration))) * 100)% 100,2,0),
CONCAT('</td></tr><tr><td></td><td colspan="7" style="text-align: right; font color: white; font-size: 150%; font-weight: bold;">','','','</td></tr></font></div>')))

FROM (
    SELECT T.teacherID AS TeacherID
        , CONCAT('<a href="admin_view_teacher.jsp?teacherid=', CAST(T.teacherId AS CHAR),'"target="_blank">', T.firstName, ' ', T.lastName, '</a>') AS Name
        , TA.attendanceDate AS ATdate
        , MAX(duration) AS duration
        , MAX(TA.teacherAttendanceId)
        , NULL AS n3
        , NULL AS n4
       FROM TeacherAttendance TA
       INNER JOIN Teachers T 
           ON TA.teacherID = T.teacherID
       WHERE DATE(TA.attendancedate)  BETWEEN '[?Start Date]' AND '[?End Date]'
         AND TA.isactive = 1
         and T.isactive = 1  
         AND (duration > 0 OR TA.reasonType > 0)
         AND T.<ADMINID>
       GROUP BY T.teacherID, TA.attendancedate  
UNION
       SELECT SA.SubadminID AS TeacherID
       , CONCAT('<a href="admin_view_subadmin.jsp?subadminid=', CAST(SA.subAdminId AS CHAR),'" target="_blank">', SA.firstName, ' ', SA.lastName, '</a>') AS Name
       , SAA.attendanceDate AS ATdate
       , MAX(duration) AS duration
       , MAX(SAA.subAdminAttendanceId)
       , NULL AS n3
       , NULL AS n4
       FROM SubAdminAttendance SAA
       INNER JOIN SubAdmins SA 
       ON SA.SubAdminID = SAA.SubAdminID
       WHERE DATE(SAA.attendancedate)  BETWEEN '[?Start Date]' AND '[?End Date]'
         AND SAA.isactive = 1 
         and SA.isactive = 1 
         AND (duration > 0 OR SAA.reasonType > 0) 
         AND SA.<ADMINID> 
         GROUP BY SA.subADminID, SAA.attendanceDate
             ) AS t3   

GROUP BY TeacherID
ORDER BY TeacherID 