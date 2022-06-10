import org.gicentre.utils.stat.*;        // For chart classes. //<>//

// Author: Becca Dura
// CSCI 5609 Assignment 1 (Due: January 30, 2022)
// Note: This is built off the support code referenced below.

// Adapted for CSci-5609 Assignment on St. Paul Budget Data
// January 2022
// Authors Dan Keefe and Bridger Herman, Univ. of Minnesota
// {dfk, herma582}@umn.edu

// Sketch to demonstrate the use of the BarChart class to draw simple bar charts.
// Version 1.3, 6th February, 2016.
// Author Jo Wood, giCentre.

// --------------------- Sketch-wide variables ----------------------

BarChart barChart;
BarChart barChart2;
PFont titleFont,smallFont;

BudgetData budgetData;

// ------------------------ Initialisation --------------------------

// Initialises the data and bar chart.
void setup()
{
  size(1280, 720);
  smooth();

  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  // here's how to load the budget data
  budgetData = new BudgetData();
  budgetData.loadFromFile("operating_budget-2022-01-16.csv");

  // get the years available in the budget data as an array of ints
  int [] years = budgetData.getYears();  


  // request data aggregated by year for each year individually
  // get the total proposed and total approved budget for each year individually
   YearlyData yd = budgetData.getYearlyData(years[0]);
   float proposedIn2014 = yd.getTotalProposed();
   float approvedIn2014 = yd.getTotalApproved();
   
   YearlyData yd2 = budgetData.getYearlyData(years[1]);
   float proposedIn2015 = yd2.getTotalProposed();
   float approvedIn2015 = yd2.getTotalApproved();
   
   YearlyData yd3 = budgetData.getYearlyData(years[2]);
   float proposedIn2016 = yd3.getTotalProposed();
   float approvedIn2016 = yd3.getTotalApproved();
   
   YearlyData yd4 = budgetData.getYearlyData(years[3]);
   float proposedIn2017 = yd4.getTotalProposed();
   float approvedIn2017 = yd4.getTotalApproved();
   
   YearlyData yd5 = budgetData.getYearlyData(years[4]);
   float proposedIn2018 = yd5.getTotalProposed();
   float approvedIn2018 = yd5.getTotalApproved();
   
   YearlyData yd6 = budgetData.getYearlyData(years[5]);
   float proposedIn2019 = yd6.getTotalProposed();
   float approvedIn2019 = yd6.getTotalApproved();
   
   YearlyData yd7 = budgetData.getYearlyData(years[6]);
   float proposedIn2020 = yd7.getTotalProposed();
   float approvedIn2020 = yd7.getTotalApproved();
   
   YearlyData yd8 = budgetData.getYearlyData(years[7]);
   float proposedIn2021 = yd8.getTotalProposed();
   float approvedIn2021 = yd8.getTotalApproved();
   
   YearlyData yd9 = budgetData.getYearlyData(years[8]);
   float proposedIn2022 = yd9.getTotalProposed();
   float approvedIn2022 = yd9.getTotalApproved();


  // store the proposed and approved budget for each year in arrays
  // store the years as strings in an array
  float [] barData = new float[] {proposedIn2014, proposedIn2015, proposedIn2016,
                                  proposedIn2017, proposedIn2018, proposedIn2019,
                                  proposedIn2020, proposedIn2021, proposedIn2022};
  float [] barData2 = new float[] {approvedIn2014, approvedIn2015, approvedIn2016,
                                  approvedIn2017, approvedIn2018, approvedIn2019,
                                  approvedIn2020, approvedIn2021, approvedIn2022};
  String [] barLabels = new String[] {str(years[0]), str(years[1]), str(years[2]), 
                                      str(years[3]), str(years[4]), str(years[5]), 
                                      str(years[6]), str(years[7]), str(years[8])};
  
  // create the bar chart for the proposed budget each year
  barChart = new BarChart(this);
  barChart.setData(barData);
  barChart.setBarLabels(barLabels);
  barChart.setBarColour(color(131,197,255,200));
  barChart.setBarGap(2); 
  barChart.setValueFormat("$###,###");
  barChart.showValueAxis(true); 
  barChart.showCategoryAxis(true); 
  barChart.setMinValue(550000000);
  barChart.setMaxValue(850000000);
  
  // create the bar chart for the approved budget each year
  // Note: The bar color is more transparent for this bar chart since the bar charts are being stacked on top of each other.
  // This allows for easier readability of the data.
  barChart2 = new BarChart(this);
  barChart2.setData(barData2);
  barChart2.setBarLabels(barLabels);
  barChart2.setBarColour(color(131,197,255,100));
  barChart2.setBarGap(2); 
  barChart2.setValueFormat("$###,###");
  barChart2.showValueAxis(true); 
  barChart2.showCategoryAxis(true);
  barChart2.setMinValue(550000000);
  barChart2.setMaxValue(850000000);
}

// ------------------ Processing draw --------------------

// Draws the graph in the sketch.
void draw()
{
  background(255);

  // draw the bar charts for the proposed and approved budgets by year
  barChart.draw(10,10,width-20,height-20);
  barChart2.draw(10,10,width-20,height-20);

  // set the bar chart title
  fill(120);
  textFont(titleFont);
  text("St. Paul Proposed Budget, 2014-2022", 120,30);
  float textHeight = textAscent();
  textFont(smallFont);
  
  // create the legend for the bar chart
  textSize(10);
  float legendX = 120;
  float legendY = 50;
  fill(250);
  rect(legendX, legendY, 110, 80);
  fill(131,197,255,200);
  rect(legendX + 10, legendY + 10, 25, 25);
  fill(0);
  textAlign(LEFT);
  text("Proposed", legendX + 50, legendY + 30);
  fill(131,197,255,100);
  rect(legendX + 10, legendY + 45, 25, 25);
  fill(0);
  text("Approved", legendX + 50, legendY + 65);
}
