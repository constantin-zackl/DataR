# Principal Component Web App
>This is a Web App for analysing Gene Expression Data with Principal Component Analysis (PCA) which is a tool for dimension reduction of multi dimensional Data. 

## Installation
For using the Web App you can either use this link ########### (no installation required) or install it locally on your computer. 
For installing the R Package you ########################

These R Packages need to be installed for the package to work: 
<ul>
<li>shiny</li>
<li>yeastCC</li>
<li>Golub</li>
</ul>

To start the app open your R console and change the folder to the downloaded file, then use this code to execute the source code: 

<code> 
library(shiny)  <br>
runApp("##########")
</code>


## What is Principal Component Analysis

The gene expression of organisms is a very complex system. Changes in the conditions result in changes of a variety of genes correlated positive or negative. Therefore, a lot of information gain is made by looking at several Genes at the same time. 
While the Gene Expression of cells depends on thousands Genes (***multidimensional data***) only up to three dimensions of the data could be visualised at the same time. 

In this case we will use the dimension reduction method Principal Component analysis to reduce the amount of dimensions of the data while keeping the maximum amount of information. ##########   

<img src="Images/Expression_Data_3D.png" align="right" />

### A three dimensional approach

For explaining the idea of dimension with PCA we will first focus on visualising three dimensional Data in two dimensions and will increase the amount of dimensions afterwards. For a visual explanation we have a look at the randomly generated expression Data of 3 Genes x, y and z from 100 Patients. We can visualise this Data in three Dimensions. One Point in the plot represents one of the patients. 


But how is the difference in the expression? Can we group the Patients into different Groups? How can we see a difference in the expression? 

To answer these questions we can have a look from different sides on the data, imagine turning the plot in 3D Space and taking pictures from different views. Which picture has the best angle to group the patients or tell about a difference in the gene expression? 
Here the Principal Components Analysis can compute this "view" on the Data for us. 
With the given Data the Method tries to find an axis trough the three dimensional Data with the maximal possible variance, this axis is called "Principal Component 1 (PC1)". 

<img src="Images/Score_Plot.png" align="left"/>



Orthogonal to that axis it constructs another Principal Component maximisign the rest of the Variance an so on. With three dimensional Data we can get a maximum of three new Principal Components who are a new orthogonal Coordinate System to have a look at the data. As defined along PC1 the data shows the biggest Variance, along PC2 the second biggest etc. To have the "best" view on the Data we have to Plot PC1 against PC2. 


In this Score Plot we can se a projection of the original Data on the Plane made up by the two first principal components. Now we can work with a plot with reduced dimension (only 2) and can be shure that the new coordinate System covers the most variance possible. 



<img src="Images/Loading_Plot.png" align="right" />



But how exactly do the Principal Components look like? As said before in this three dimensional case the principal components are a straigth line trough the Data .... .Therefore the Principal components are linear combinations of the original Variables (here: Genes). 

In the result of the PCA the coefficients of the Principal Components are called Loadings and can be visualised in a Loading Plot. In the following Loading Plot the acutal composition of the first two PCs are visualized: 


As we can see PC1 is made up mainly by the original gene x why PC 2 is mainly characterized by Gene z. In the first Prinical components gene y seems not to explain a lot of the found variance. 

<img src="Images/Rotated_Expression_Data.png" align="left"/>



Because we are working with three dimensional Data we can still have a look into the original Data. This time we rotate the Plot to have a look in the x/z direction as directed from the PCA. 


When we take a look back on the Score Plot we can clearly see that this is nearly the view which was calculated by the PCA, however the exact view consists in a small rotation in the y axis which can be seen in the Loading Plot. 

### Multi Dimensional Data
In our three Dimensional example the "best view" can clearly also be found with rotating the original Data, but with multidimensional data this is, due to the impossible visualisation, unpractial. The Principal components can still be computed an visualised. The main Part of the Variance can be explained by more than 2 PCs. But on how many PCs to we have to look at? 



The following Scree Plot contains the Variance for eatch Principal Component. By a look at this Plot we have a visual indicator at how many Principal Components we have to look. 

The greatest power of the PCA is the dimension reduction trough a projection of data on the calculated Principal Components. 

Often the results of a PCA get visualized with a Biplot which is a combination of the shown Score and Loading Plots. 

![](Images/Biplot.png)
![](Images/Screeplot.png)



##  The Web App

## The Golub Data


## Used Functions



## The results

The Principal Component Analysis can reveal how exactly the patients vary in their expression. The Score Plot is a good start to see if there is a significant difference. For understanding this difference the Loading Plot shows the Genes which construct the view seen in the Score Plot. With the Gene names same or different Expression Names can be found. 






