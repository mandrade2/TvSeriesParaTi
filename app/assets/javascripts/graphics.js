

// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart']});

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChart);

// Callback that creates and populates a data table,
// instantiates the pie chart, passes in the data and
// draws it.
function drawChart() {

  // Create the data table.
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Topping');
  data.addColumn('number', 'Slices');
  data.addColumn({type: 'string', role: 'style'});
  data.addRows([
    ['Mushrooms', 3, 'color : blue'],
    ['Onions', 1, 'color : red'],
    ['Olives', 1, 'color : green'],
    ['Zucchini', 1, 'color : pink'],
    ['Pepperoni', 2, 'color : yellow']
  ]);

  // Set chart options
  var options = {'title':'How Much Pizza I Ate Last Night',
                 'width':400,
                 'height':300
};
var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
chart.draw(data, options);
}
