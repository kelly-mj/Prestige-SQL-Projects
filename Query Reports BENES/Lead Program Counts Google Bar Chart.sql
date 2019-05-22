SELECT CONCAT('<html>
  <head>
    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript">
    google.charts.load("current", {packages:["corechart"]});
    google.charts.setOnLoadCallback(drawChart);
    function drawChart() {
      var data = google.visualization.arrayToDataTable(['
          , ( SELECT CONCAT('["Program", "Count", { role: \'annotation\' }], '
                            , GROUP_CONCAT(CONCAT('["'
                                    , Q.col1, '", '
                                    , Q.col2, ', '
                                    , CAST(Q.col2 AS CHAR), ']')
                                SEPARATOR ', ')) AS ''
            FROM (
                SELECT PFV.fieldValue col1
                    , COUNT(PFV.profileFieldValueId) AS col2
              FROM ProfileFieldValues PFV
              WHERE PFV.fieldName = 'PROGRAM_OF_INTEREST'
              AND PFV.userType = 99
              AND PFV.<ADMINID>
              AND PFV.fieldValue <> (SELECT defaultValue FROM ProfileFieldNames WHERE fieldName = 'PROGRAM_OF_INTEREST' AND userType = 99)
              AND PFV.fieldValue <> 'Other'
              GROUP BY PFV.fieldValue ) Q
          )
      , ']);

      var view = new google.visualization.DataView(data);
      view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" }]);

      var options = {
        title: "Lead Program Interests",
        width: 1000,
        height: 600,
        bar: {groupWidth: "85%"},
      };
      var chart = new google.visualization.BarChart(document.getElementById("barchart_values"));
      chart.draw(view, options);
  }
  </script>
<div id="barchart_values" style="width: 900px; height: 300px;"></div>
  </body>
</html>') AS 'Table'

FROM Students S
WHERE S.<ADMINID>

LIMIT 1
