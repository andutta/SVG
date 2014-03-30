<!DOCTYPE html>
<meta charset="utf-8">
<style>

body {
  font: 10px sans-serif;
  shape-rendering: crispEdges;
}

.day {
  fill: #fff;
  stroke: #ccc;
}

.month {
  fill: none;
  stroke: #000;
  stroke-width: 2px;
}

.RdYlGn .q0-11{fill:rgb(165,0,38)}
.RdYlGn .q1-11{fill:rgb(215,48,39)}
.RdYlGn .q2-11{fill:rgb(244,109,67)}
.RdYlGn .q3-11{fill:rgb(253,174,97)}
.RdYlGn .q4-11{fill:rgb(254,224,139)}
.RdYlGn .q5-11{fill:rgb(255,255,191)}
.RdYlGn .q6-11{fill:rgb(217,239,139)}
.RdYlGn .q7-11{fill:rgb(166,217,106)}
.RdYlGn .q8-11{fill:rgb(102,189,99)}
.RdYlGn .q9-11{fill:rgb(26,152,80)}
.RdYlGn .q10-11{fill:rgb(0,104,55)}

</style>
<body>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>

var aspectLegend = 50 / 940;
var parseDate = d3.time.format("%Y-%m-%d").parse;
var price = d3.format(".2f");

var width = 800,
    height = 100,
    cellSize = 10; // cell size

var day = d3.time.format("%w"),
    week = d3.time.format("%U"),
    percent = d3.format(".1%"),
    format = d3.time.format("%Y-%m-%d");

var color = d3.scale.quantize()
    .domain([-.05, .05])
    .range(d3.range(11).map(function(d) { return "q" + d + "-11"; }));
    
var wd = width;  

var datafile = [
	{"checkin": "2012-01-01", "price": "60.24"},
	{"checkin": "2012-02-01", "price": "260.24"},
	{"checkin": "2012-03-01", "price": "160.24"},
	{"checkin": "2012-04-01", "price": "80.24"},
	{"checkin": "2012-05-01", "price": "50.24"},
	{"checkin": "2012-06-01", "price": "90.24"},
	{"checkin": "2013-02-01", "price": "210.24"},
	{"checkin": "2013-03-01", "price": "250.24"}
]

legendSvg = d3.select("body").append("svg")
	.attr("preserveAspectRatio", "xMidYMid")
	.attr("viewBox", "0 0 940 50")
	.attr("width", wd)
	.attr("height", wd * aspectLegend)
	.attr("class", "legd")
	.append("g")
	.attr("transform", "translate(30, 0)");

var legend = legendSvg.selectAll(".legend")
.data(d3.range(0, 11, 1))
.enter().append("g")
.attr("class", "legend RdYlGn")
.attr("transform", function(d, i) { return "translate(" + (i * cellSize + 630) + ", 10)"; });

legend.append("rect")
.attr("x", 0)
.attr("width", this.cellSize)
.attr("height", this.cellSize)
.attr("class", function(d) { return "q" + d + "-11";})
.attr("stroke", "#999")
.attr("stroke-width", "1px")
.attr("shape-rendering", "crispEdges");

legendSvg.selectAll(".months")
.data(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
.enter().append("text")
.attr("x", function(d, i) {
  return (i + 1) * cellSize * 4.35;
})
.attr("y", 48)
.style("text-anchor", "middle")
.text(function(d) { return d; });

var svg = d3.select("body").selectAll(".svg")
    .data(d3.range(2013, 2014))
  .enter().append("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("class", "RdYlGn")
    .style("border", "1px solid black");
    .append("g")
    .attr("transform", "translate(" + ((width - cellSize * 53) / 2) + "," + (height - cellSize * 7 - 1) + ")");

svg.append("text")
    .attr("transform", "translate(-40," + cellSize * 3.5 + ")rotate(-90)")
    .style("text-anchor", "middle")
    .text(function(d) { return d; });

var rect = svg.selectAll(".day")
    .data(function(d) { return d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
  .enter().append("rect")
    .attr("class", "day")
    .attr("width", cellSize)
    .attr("height", cellSize)
    .attr("x", function(d) { return week(d) * cellSize; })
    .attr("y", function(d) { return day(d) * cellSize; })
    .datum(format);

rect.append("title")
    .text(function(d) { return d; });
    
svg.selectAll(".month")
    .data(function(d) { return d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
  .enter().append("path")
    .attr("class", "month")
    .attr("d", monthPath);
    
svg.selectAll(".dowText")
.data(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
.enter().append("text")
.attr("x", -5)
.attr("y", function(d, i) {
  return (i + 1) * cellSize;
})        
.attr("dy", -3)
        .style("text-anchor", "end")
        .text(function(d) { return d; });
    

d3.json("/svg/resources/datafile.json", function(error, csv) {
	csv.forEach(function(d) {

        d.search_date = self.format(self.parseDate(d.checkin));
        d.median = +d.price;
    });

    var minMax = d3.extent(csv, function(d) { return d.median; });
    var color = d3.scale.quantize()
        .domain(minMax)
        .range(d3.range(11).map(function(d) { return "q" + d + "-11"; }));  
    var data = d3.nest()
    .key(function(d) { return d.search_date; })
    .rollup(function(d) { return d[0].median; })
    .map(csv);

	self.rect.filter(function(d) { return d in data; })
	    .attr("class", function(d) { return "day " + color(data[d]); })
	    .select("title")
	    .text(function(d) { return d + ": $" + self.price(data[d]); });
	
	//self.lowPrice.text("$" + self.price2(minMax[0]));
	//self.highPrice.text("$" + self.price2(minMax[1]));

//callback();
});


/*	
d3.csv("/svg/resources/test.csv", function(error, csv) {
  var data = d3.nest()
    .key(function(d) { return d.Date; })
    .rollup(function(d) { return (d[0].Close - d[0].Open) / d[0].Open; })
    .map(csv);

  rect.filter(function(d) { return d in data; })
      .attr("class", function(d) { return "day " + color(data[d]); })
    .select("title")
      .text(function(d) { return d + ": " + percent(data[d]); });
});*/

function monthPath(t0) {
  var t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0),
      d0 = +day(t0), w0 = +week(t0),
      d1 = +day(t1), w1 = +week(t1);
  return "M" + (w0 + 1) * cellSize + "," + d0 * cellSize
      + "H" + w0 * cellSize + "V" + 7 * cellSize
      + "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize
      + "H" + (w1 + 1) * cellSize + "V" + 0
      + "H" + (w0 + 1) * cellSize + "Z";
}

d3.select(self.frameElement).style("height", "2910px");

</script>
</body>