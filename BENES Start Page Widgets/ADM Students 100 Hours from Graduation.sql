/* Students within 100 hours of graduation */

select st.idNumber "Student Id",
           CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(st.studentId AS CHAR), '">', st.firstName, ' ', st.lastName, '</a>') AS 'Student Name',
           COALESCE(ca.campusName,'Invalid Campus') as "Campus Name",
           prog.programmeName "Program",    
	  prog.minClockHours "Required Pgm Hours",  
          Round(hrs.totalhours,2) "Actual Hours",
          Round((prog.minClockHours - hrs.totalhours),2) "Remaining",
          DATE_FORMAT(hrs.lastday,'%m/%d/%Y') "Last Day Of Att"
from   Registrations reg
           LEFT JOIN Campuses ca ON ca.campusCode = reg.studentCampus,
           Students st,
           Programmes prog,
          (Select crel.studentId,
                       crel.registrationId,
                       SUM(att.duration) as "TotalHours",
		       MAX(attendanceDate) as "Lastday"
           from ClassStudentReltn crel,
		    Attendance att
           where 1=1
           and  att.studentid = crel.studentid
           and  att.classid = crel.classid 
           and  crel.isActive = 1
           Group by crel.studentId,
                            crel.registrationId) hrs 
where  1=1
and    reg.<ADMINID>
and    st.studentId = reg.studentId
and    prog.programmeId = reg.programmeId
and    hrs.studentId = st.studentId
and    hrs.registrationId = reg.registrationId
and    reg.graduationdate IS NULL 
and    reg.isActive = 1
and    st.isActive = 1
and 	  prog.programmeId <> 4000999   
and    ((prog.minClockHours - hrs.totalhours) >   0
              and    (prog.minClockHours - hrs.totalhours) <= 100)
AND IFNULL(PV.fieldValue,"") = (Select CMP.campusName From SubAdmins SA 
													LEFT JOIN Campuses CMP  ON SA.campusCode = CMP.campusCode 
													Where SA.<ADMINID> AND SA.subAdminId=[USERID])
ORDER BY ca.campusName,
		      st.lastName,
		      st.firstName