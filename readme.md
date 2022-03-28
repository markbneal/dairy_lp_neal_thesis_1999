# Grazing dairy linear programming model from Honour's Thesis

This model was for a Honour's level thesis, Neal (1999), at the University of Sydney. The model was originally structured as rows (equations) and columns (variables) in an Excel workbook, with the matrix stretching across 17 spreadsheets. At the time it was solved with Lindo's Whatsbest. Here it has been rewritten as equations in gams, and solves with conopt, which is faster, and much easier to modify. 

Thesis available here:
https://www.researchgate.net/publication/272418932_Modelling_seasonal_production_of_a_NSW_Dairy_Farm_A_linear_programming_approach

## Abstract
This thesis aims to provide management tools to deal with the problem of deciding on the seasonal production pattern and the interrelated decision of a stocking rate. These issues are modelled with linear programming to provide an answer to a complex problem where an intuitive answer is not obvious. The model is based on the region of NSW known as the Manning Valley on a farm where no irrigation occurs. The results of the model are then discussed and methods of dealing with risk are discussed.

A slightly more complex version of this model, with a wider choice of forages, and different protein model, is presented here:
https://github.com/markbneal/dairy_lp_neal_JDS_2007

A simpler linear programming model of a grazing dairy farm (quarter year time step) that considers choice of forage and stocking rate is available here:




