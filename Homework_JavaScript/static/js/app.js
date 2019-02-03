// from data.js
var tableData = data;

// YOUR CODE HERE!
// Use D3 to select the table
var table = d3.select("#ufo-table");

// Use D3 to set the table class to `table table-bordered`
table.attr("class", "table table-striped table-bordered");

var tbody = d3.select("tbody");

// Select the submit button
var fiterTable = d3.select("#filter-btn");
// Select the input element date , state ,city etc  from form
var inputElementDate = d3.select("#datetime");
var inputElementState = d3.select("#state");
var inputElementCity = d3.select("#city");
var inputElementCountry = d3.select("#country");



fiterTable.on("click", function() {
  // Prevent the page from refreshing
  d3.event.preventDefault();
  tbody.innerHTML = "";
  //get values from each element
  var inputValueDate = inputElementDate.property("value").trim();
  var inputValueState = inputElementState.property("value").toLowerCase().trim();
  var inputValueCity = inputElementCity.property("value").toLowerCase().trim();
  var inputValueCountry = inputElementCountry.property("value").toLowerCase().trim();

  console.log(inputValueDate);
  console.log(inputValueState);
  console.log(tableData);
  var filteredData =[]
  filteredData = tableData
  if (inputValueDate != ""){
    filteredData = tableData.filter(ufo => ufo.datetime === inputValueDate);
  }
  if (inputValueState != ""){
    filteredData = filteredData.filter(ufo => ufo.state === inputValueState);
  }
  if (inputValueCity != ""){
    filteredData = filteredData.filter(ufo => ufo.city === inputValueCity);
  }
  if (inputValueCountry != ""){
    filteredData = filteredData.filter(ufo => ufo.country === inputValueCountry);
  }

  console.log(filteredData);
  tbody.innerHTML = "";
  table.innerHTML = "";
  filteredData.forEach((ufo) => {
    var row = tbody.append("tr");
    Object.entries(ufo).forEach(([key,value]) => {
      var cell = tbody.append("td");
      cell.text(value);
    });
          
  });
});
