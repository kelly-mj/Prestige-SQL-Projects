-- Missing Licence/Placement Information: Admin View
-- Update: 8/3/2018 by Kelly MJ

select  st.idnumber ID_No,
          CONCAT('<a href="admin_view_student.jsp?studentid=', CAST(st.studentId AS CHAR), '">', st.firstName, ' ', st.lastName, '</a>') AS 
          'Student Name',
          ca.campusName 'Campus',
          prog.programmeName 'Program',
          st.isActive 'ISActive Code',
	  /*DATE_FORMAT(reg.registrationDate,'%m/%d/%Y') "Registration Date", */
          DATE_FORMAT(reg.graduationDate,'%m/%d/%Y') 'Graduation Date',
	  prof.License_No 'License No',
	  prof.Placement_Status 'Placement Status'
From Students st,
          Registrations reg
          LEFT JOIN Campuses ca ON ca.campusCode = reg.studentCampus,
          Programmes prog,
	  (SELECT userId,
            MAX(CASE WHEN fieldName = 'LICENSE_NUMBER'
                      THEN fieldValue END) AS License_No,
            MAX(CASE WHEN fieldName = 'PLACEMENT_STATUS'
                      THEN fieldValue END) AS Placement_Status
	    FROM ProfileFieldValues prof
	    where 1=1
            and      prof.<ADMINID>
            and      isActive = 1
	    and      usertype = 1
	  GROUP BY userId) prof 
where 1=1
and   reg.studentId = st.studentId
and   prog.programmeId = reg.programmeId
and   prof.userId = st.studentId
and   reg.isActive = 1
and   reg.registrationDate >= '2016-01-01'
and   (st.isActive = 3 or reg.graduationDate is not null) 
and  st.isActive <>14
and   st.isactive <> 0
and   ((prof.Placement_Status is null or prof.Placement_Status = ' ') 
				OR (prof.License_No is null or prof.License_No = ' '))
Group by st.studentId
ORDER BY ca.campusName