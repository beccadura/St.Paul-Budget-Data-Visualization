import org.gicentre.utils.colour.*;      // For colour tables. //<>//
import java.text.NumberFormat;

// Author: Becca Dura
// CSCI 5609 Assignment 1 (Due: January 30, 2022)
// Note: This is built off the support code referenced below.

// Support code for CSci-5609 Assignment on St. Paul Budget Data
// January 2022
// Authors Dan Keefe and Bridger Herman, Univ. of Minnesota
// {dfk, herma582}@umn.edu

// --------------------- Sketch-wide variables ----------------------

PFont titleFont, smallFont;

BudgetData budgetData;
int [] years;
String [] services;
int num_services;
ColourTable colorTable;

// ------------------------ Initialisation --------------------------

// Initialises the data and bar chart.
void setup()
{
  size(1700, 720);
  smooth();

  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  budgetData = new BudgetData();
  budgetData.loadFromFile("operating_budget-2022-01-16.csv");

  // get the years available in the budget data and save in a global variable for easy access
  years = budgetData.getYears();  
  
  // get the services for the most recent year and save in a global variable.  it's smart to
  // use the ordered list of services from just the most recent budget for drawing all of the
  // flowers so that each flower has a consistent ordering of petals and we can compare the
  // same service categories across years.
  services = budgetData.getYearlyData(years[years.length-1]).getServices();  
  
  // get the number of services with data
  num_services = services.length;
  
  //load a pre-made color table for use in the petals of the glyphs
  colorTable = ColourTable.getPresetColourTable(ColourTable.SET2_8,0,6);
}

// ------------------ Processing draw --------------------

// draws a single petal of the flower by drawing an ellipsed scaled in size
// by the data and rotated into position based on the index of the data var
// x = the x position of the center of the flower
// y = the y position of the center of the flower
// index = the index of the petal to draw, 0 for the first, 1 for the second, ...
// nPetals = the total number of petals that will be drawn for the flower
// col = the color to use for this petal
// size = a scaling factor for the petal that should range between 0.0 for the smallest
//        possible petal and 1.0 for the largest possible petal
void drawPetal(float x, float y, int index, int nPetals, color col, float size) {
  float minLen = 10;
  float maxLen = 125;
  float len = minLen + size*(maxLen - minLen);  
  fill(col);
  pushMatrix();
  float angle = (float)index/(float)(nPetals) * TWO_PI;
  translate(x, y);
  rotate(angle);
  ellipse(0, -len/2, len/4, len); 
  popMatrix();
}


// Draws the graph in the sketch.
void draw()
{
  background(255);
  
  // set the title of the visualization
  fill(120);
  textFont(titleFont);
  text("St. Paul Proposed Budgets 2014-2022, by Category",600,30);
  
  // set the initial x value for the center of each glyph
  // set the minimum and maximum possible y values for the center of each glyph
  float x_val = 150;
  float min_y_val = 175;
  float max_y_val = 675;
  
  // get the total proposed budget for each year
  float [] totalProposedBudget = new float[0];
  for (int i=0; i<years.length; i++){
    YearlyData yd = budgetData.getYearlyData(years[i]); 
    float totalProposed = yd.getTotalProposed();
    totalProposedBudget = (float[]) append(totalProposedBudget, totalProposed);
  }
  
  // get the maximum proposed budget among all the years
  float max_total_budget = max(totalProposedBudget);
  
  // draw a glyph for each year
  for (int i=0; i<years.length; i++){
    
    // get the y value for the center of the glyph based on the ratio of the total proposed budget to the maximum total proposed budget (out of all the years)
    float y_val = max_y_val - ((totalProposedBudget[i]/max_total_budget)*(max_y_val-min_y_val));
    
    // get the proposed budget for each service in the current year
    float [] proposedBudget = new float[0];
    YearlyData yd = budgetData.getYearlyData(years[i]);
    for (int j=0; j<num_services; j++) {
      float proposed = yd.getTotalProposedByService(services[j]);
      proposedBudget = (float[]) append(proposedBudget, proposed);
      }
      
    // get the maximum proposed budget among all the services for the current year
    float max_budget = max(proposedBudget);
    
    // draw a petal for each service for the glyph for the current year
    for (int k=0; k<num_services; k++) {
      drawPetal(x_val,y_val,k,num_services,colorTable.findColour(k),(proposedBudget[k]/max_budget));
      } 
      
    // write the year below each glyph
    textSize(16);
    fill(0);
    textAlign(CENTER);
    text(years[i], x_val, (max_y_val+25));
    
    // draw a line connecting each year to its glpyh 
    // the length of the line is based on the ratio of the total proposed budget to the maximum total proposed budget (out of all the years), 
    // which was calculated above
    strokeWeight(3.0);
    line(x_val, y_val, x_val, max_y_val);
    
    // increase the x value for the next glyph
    x_val += 175;
    
  }
  // check which year's glyph the mouse is closest to
  int mouseIndex = int ((mouseX / (float) width) * years.length);
  
  // create the box to display the data for the year's glyph the mouse is closest to
  float x_val_mouse = 400;
  float y_val_mouse = 200;
  fill(color(0, 0, 0, 200));
  rect(mouseX, mouseY, -x_val_mouse, -y_val_mouse);
  x_val_mouse = x_val_mouse - 10;
  y_val_mouse = y_val_mouse - 20;
  fill(255);
  textFont(titleFont);
  text(years[mouseIndex] + " Proposed Budget", mouseX - (x_val_mouse/2), mouseY - y_val_mouse);
  y_val_mouse = y_val_mouse - 25;
  NumberFormat formatter = NumberFormat.getCurrencyInstance();
  text(formatter.format(totalProposedBudget[mouseIndex]), mouseX - (x_val_mouse/2), mouseY - y_val_mouse);
  
  y_val_mouse = y_val_mouse - 5;
  
  YearlyData yd = budgetData.getYearlyData(years[mouseIndex]);
  for (int j=0; j<num_services; j++) {
    y_val_mouse = y_val_mouse - 20;
    float proposed = yd.getTotalProposedByService(services[j]);
    fill(colorTable.findColour(j));
    textAlign(LEFT);
    textSize(16);
    text(services[j] + ": " + formatter.format(proposed), mouseX - x_val_mouse, mouseY - y_val_mouse);
    }
    
    

}
