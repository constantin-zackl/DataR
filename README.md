# Principal Component Web App
>This is a Web App for analysing Gene Expression Data with Principal Component Analysis (PCA) which is a tool for dimension reduction of multi dimensional Data. 

## Installation
For using the Web App you can either use this link ########### (no installation required) or install it locally on your computer. 
For installing the R Package you just download the file app.R and save in on your computer. A full Zip Download of all resources is possible by using the green *Clone or Downlaod* Button on the top right corner. 

These R Packages ***need to be installed*** for the package to work:
* [BiocManager](https://www.bioconductor.org/install/)
* [GolubEsets](https://bioconductor.org/packages/release/data/experiment/html/golubEsets.html)
* [shiny](https://shiny.rstudio.com/)
* For recalculationg the explaining Plots: [plot3D](http://www.sthda.com/english/wiki/impressive-package-for-3d-and-4d-graph-r-software-and-data-visualization)

To start the app open your R console and change the folder to the downloaded file, then use this code to execute the source code: 

<code> 
library(shiny)  <br>
runApp("app.R")
</code>

The testing has been done with R 3.6.1 with R Studio 1.2.5001 on Windows 10. 

##  The Web App

The Web app performs a Principal Component Analysis on the Golub Data Set of leukemia Patients. In the input Panel on the left side the number of genes in the analysis and the wanted Principal Components can be selected. It is also possible to change the maximum amount of Gene Names displayed in the Loading Plot. In the main Panel on the right side the user can select the plot type and can get some basic information about the analysis. Fore more information about the plot types please review the explanation below. 

## The Golub Data

The Golub Data by Todd Golub cover the Gene Expression of 27 Patients with acute lymphoblastic leukemia (ALL) and 11 patients with acute myeloid leukemia (AML). In total there were 7129 Genes measured. 
The App performs a PCA to find difference in the gene expression between these two group of patients. 

## What is Principal Component Analysis

The gene expression of organisms is a very complex system. Changes in the conditions result in changes of a variety of genes correlated positive or negative. Therefore, a lot of information gain is made by looking at several Genes at the same time. 
While the Gene Expression of cells depends on thousands Genes (***multidimensional data***) only up to three dimensions of the data could be visualised at the same time. 

In this case we will use the dimension reduction method Principal Component analysis to reduce the amount of dimensions of the data while keeping the maximum amount of information. ##########   

<img src="Images/Expression_Data_3D.png" align="right" />

### A three dimensional approach

For explaining the idea of dimension with PCA we will first focus on visualising three dimensional Data in two dimensions and will increase the amount of dimensions afterwards. For a visual explanation we have a look at the randomly generated expression Data of 3 Genes x, y and z from 100 Patients. We can visualise this Data in three Dimensions. One Point in the plot represents one of the patients. 

But how is the difference in the expression? Can we group the Patients into different Groups? How can we see a difference in the expression? 
<img src="Images/Score_Plot.png" align="left"/>
To answer these questions we can have a look from different sides on the data, imagine turning the plot in 3D Space and taking pictures from different views. Which picture has the best angle to group the patients or tell about a difference in the gene expression? 
Here the Principal Components Analysis can compute this "view" on the Data for us. 
With the given Data the Method tries to find an axis trough the three dimensional Data with the maximal possible variance, this axis is called "Principal Component 1 (PC1)". 

Orthogonal to that axis it constructs another Principal Component maximisign the rest of the Variance an so on. With three dimensional Data we can get a maximum of three new Principal Components who are a new orthogonal Coordinate System to have a look at the data. As defined along PC1 the data shows the biggest Variance, along PC2 the second biggest etc. To have the "best" view on the Data we have to Plot PC1 against PC2. 

In this ***Score Plot*** we can se a projection of the original Data on the Plane made up by the two first principal components. Now we can work with a plot with reduced dimension (only 2) and can be shure that the new coordinate System covers the most variance possible. 

<img src="Images/Loading_Plot.png" align="right" />

But how exactly do the Principal Components look like? As said before in this three dimensional case the principal components are a straigth line trough the Data .... .Therefore the Principal components are linear combinations of the original Variables (here: Genes). 

In the result of the PCA the coefficients of the Principal Components are called Loadings and can be visualised in a ***Loading Plot***. In the following Loading Plot the acutal composition of the first two PCs are visualized: 

As we can see PC1 is made up mainly by the original gene x why PC 2 is mainly characterized by Gene z. In the first Prinical components gene y seems not to explain a lot of the found variance. 

<img src="Images/Rotated_Expression_Data.png" align="left"/>

Because we are working with three dimensional Data we can still have a look into the original Data. This time we rotate the Plot to have a look in the x/z direction as directed from the PCA. 

When we take a look back on the Score Plot we can clearly see that this is nearly the view which was calculated by the PCA, however the exact view consists in a small rotation in the y axis which can be seen in the Loading Plot. 

### Multi Dimensional Data
In our three Dimensional example the "best view" can clearly also be found with rotating the original Data, but with multidimensional data this is, due to the impossible visualisation, unpractial. The Principal components can still be computed an visualised. The main Part of the Variance can be explained by more than 2 PCs. But on how many PCs to we have to look at? 

<img src="Images/Screeplot.png" align="right"/>

The following ***Scree Plot*** contains the Variance for eatch Principal Component. By a look at this Plot we have a visual indicator at how many Principal Components we have to look. 

The greatest power of the PCA is the dimension reduction trough a projection of data on the calculated Principal Components. 

Often the results of a PCA get visualized with a ***Biplot*** which is a combination of the shown Score and Loading Plots. 

<p align="center">
<img src="Images/Biplot.png"/> 
</p>

The source code which was used for generating the explaining plots is available in the file PCA_example.R . The randomly generated three Dimensional Data is also available for recalculations in the file PCA_test_data.txt.

## Used Functions

* data("Golub_Train""), exprs(Golub_Train): Loading the Data from the Dataset
* replace (): Removing unwanted Data
* log2(): 
* rownames(): changing the rownames to the leukemia type of the patient
* fluidPage(): UI definition
* titlePanel(): title setup of the App
* sidebarLayout(): sidebar UI
* sidbarPanel(): initialising the Input Panel on the left side
* manPanel(): initialising the main Panel with the plots
* sliderInput(), numericInput(): getting User intput
* tabsetpanel(), tabPanel(): initializing the Panel setup of the plots
* recalcPCA(): recalculation of the PCA when the number of Genes is changed
* sort(): sorting the data
* prcomp(): the Principal Component Analysis
* server (), renderPlot(), renderText(): rendering dynamic Outputs
* plot(), points(), arrows(), text(): Functions for Creating the PCA Plots


## The results

The Principal Component Analysis can reveal how exactly the patients vary in their expression. The Score Plot is a good start to see if there is a significant difference. For understanding this difference the Loading Plot shows the Genes which construct the view seen in the Score Plot. Strongly correlated Genes are expressed with very close arrows. The displayed Gene names can be used to get more information about the genes in the internet or databases. 


## Further Information
For further information about Principal Component Analysis please have a look at these resouces: 
* [Youtube: PCA - main ideas in 5 Minutes](https://youtu.be/HMOI_lkzW08)
* [Youtube: PCA - step by step](https://youtu.be/FgakZw6K1QQ)
* [Wikipedia_ Principal Component Analysis](https://en.wikipedia.org/wiki/Principal_component_analysis)

