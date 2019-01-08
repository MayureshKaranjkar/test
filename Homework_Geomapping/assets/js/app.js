// The code for the chart is wrapped inside a function that
// automatically resizes the chart
function makeResponsive() {

  // if the SVG area isn't empty when the browser loads,
  // remove it and replace it with a resized version of the chart
  var svgArea = d3.select("#scatter").select("svg");

  // clear svg is not empty
  if (!svgArea.empty()) {
    svgArea.remove();
  }

  // SVG wrapper dimensions are determined by the current width and
  // height of the browser window.
  var svgWidth = 900;
  var svgHeight = 600;

  var margin = {
    top: 30,
    bottom: 125,
    right: 50,
    left: 100
  };

  var width = svgWidth - margin.left - margin.right;
  var height = svgHeight - margin.top - margin.bottom;

  // Create an SVG wrapper, append an SVG group that will hold our chart, and shift the latter by left and top margins.
  var svg = d3.select("#scatter")
    .append("svg")
    .attr("width", svgWidth)
    .attr("height", svgHeight);

  var chartGroup = svg.append("g")
    .attr("transform", `translate(${margin.left}, ${margin.top})`);

  // Import Data

  d3.csv("./assets/data/data.csv")
    .then(function(populationData) {

      // Step 1: Parse Data/Cast as numbers
      // ==============================
      populationData.forEach(function(data) {
        data.age = +data.age;
        data.income = +data.income;
        data.abbr = data.abbr;
      });
      console.log(populationData)
      // Step 2: Create scale functions
      // ==============================
      var xLinearScale = d3.scaleLinear()
        .domain([30, d3.max(populationData, d => d.age)])
        .range([0, width]);

      var yLinearScale = d3.scaleLinear()
        .domain([30000, d3.max(populationData, d => d.income)])
        .range([height, 0]);

      // Step 3: Create axis functions
      // ==============================
      var bottomAxis = d3.axisBottom(xLinearScale);
      var leftAxis = d3.axisLeft(yLinearScale);

      // Step 4: Append Axes to the chart
      // ==============================
      chartGroup.append("g")
        .attr("transform", `translate(0, ${height})`)
        .call(bottomAxis);

      chartGroup.append("g")
        .call(leftAxis);

      // Step 5: Create Circles
      // ==============================

      var textGroup = chartGroup.selectAll(null)
      .data(populationData)
      .enter()
      .append("text")
      .attr("x", d => xLinearScale(d.age)-12)
      .attr("y", d => yLinearScale(d.income)+5)
      .attr("opacity", ".75")
      .text(d => d.abbr)


      var circlesGroup = chartGroup.selectAll("circle")
      .data(populationData)
      .enter()
      .append("circle")
      .attr("cx", d => xLinearScale(d.age))
      .attr("cy", d => yLinearScale(d.income))
      .attr("r", "15")
      .attr("fill", "#99FF99")
      .attr("opacity", ".5")

   
  

      // Step 6: Initialize tool tip
      // ==============================
      var toolTip = d3.tip()
        .attr("class", "tooltip")
        .offset([90, 90])
        .html(function(d) {
          return (`${d.state}<br>Age: ${d.age}<br>Income: ${d.income}`);
        });

      // Step 7: Create tooltip in the chart
      // ==============================
      chartGroup.call(toolTip);

      // Step 8: Create event listeners to display and hide the tooltip
      // ==============================
      circlesGroup.on("mouseenter", function(data) {
        toolTip.show(data, this);
      })
        // onmouseout event
        .on("mouseleave", function(data, index) {
          toolTip.hide(data);
        });

      // Create axes labels
      chartGroup.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 0 - margin.left)
        .attr("x", 0 - (height / 2))
        .attr("dy", "1em")
        .attr("class", "axisText")
        .text("Age vs. Average Income (By State)");

      chartGroup.append("text")
        .attr("transform", `translate(${width / 2}, ${height + margin.top + 30})`)
        .attr("class", "axisText")
        .text("(Based on 2014 ACS 1-year estimates)");
      
    });
}

// When the browser loads, makeResponsive() is called.
makeResponsive();

// When the browser window is resized, makeResponsive() is called.
d3.select(window).on("resize", makeResponsive);