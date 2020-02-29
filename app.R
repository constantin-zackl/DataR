
# importing the packages
library(shiny)
library(golubEsets)

# importing the data
data("Golub_Train")
data = t(exprs(Golub_Train))
data = replace(data, data<1, 1) # removing unusable Data
data = log2(data)
rownames(data)= c(replicate(27, "ALL"), replicate(11, "AML"))

# Define UI for application
ui = fluidPage(
    
    # Application title
    titlePanel("Principal Component Analysis"),

    # Sidebar with all the inputs
    sidebarLayout(
        
        #defining the input panel
        sidebarPanel(
            sliderInput("genenums",
                        "Number of genes in the analysis:",
                        min = 15,
                        max = 250,
                        value = 50),
            numericInput("firstPC", "First PC: ", value = 1),
            numericInput("secondPC", "Second PC: ", value = 2),
            br(),
            p("At the moment the analysis runs with gene expression data from the Golub dataset."),
            numericInput("geneNameNumber", "Number Of gene names displayed in the Loading Plot:", value = 15 ),
            p("The selected number of gene names has to be lower than the number of genes in the analysis.")
        ),

        # Filling the main panel with all the plots with a panel menu
        mainPanel(

           tabsetPanel(
                #main Panel with explanation
                tabPanel("PCA - The method",
                    br(),
                    p("Principal Component Analysis is a method for dimension reduction which is used for analysis multidimensional data. For this reduction the data gets projected on constructed 
                      Principal Components (PC) while keeping the maximum amount of information possible. For an explanation of the method and the used functions please have a look in the documentation
                        . This example analyses the Golub data which consists of expression data of 38 patients with leukemia. Information on the dataset are also accesible in the documentation.
                      "),
                ),
                # Score Plot
                tabPanel("Score plot", plotOutput("scoreplot"), textOutput("scoreplottext")),#
                # Scree Plot with Calculation of the PCs to use
                tabPanel("Scree plot", plotOutput("screeplot"), textOutput("countPCs")), 
                # Loading Plot
                tabPanel("Loading plot", plotOutput("loadingplot"),
                    br(),
                    p("The Loading plot shows the impact of each gene in the Principal Components (coefficients of the linear combination). Genes which are strongly correlated are
                      displayed close to each other. The Plot uses a Arrow / Vector design similar to the biplot. For a better visualisation the number of displayed gene names is
                      limited and can be changed on the left side. More information about Loading plots can be found in the documentation.")     
                         
                ),
                # Biplot
                tabPanel("Biplot", plotOutput("biplot"), 
                    p("The Biplot is a combination of the Loading and Score plot and is a great way for a fast acces to the PCA results. In case this plot is too complex and chaotic a second 
                      view into the single plots can show a more detailed view. It is also possible to reduce the amount of genes in the analysis with the slider on the left side.")
                              
                )
            )
        )
    )
)

# support functions
recalcPCA = function (input){ # recalc the Analysis with a different amount of genes, as directed by the user
    var = names (sort(apply(data, 2, var), decreasing =TRUE)[1:input$genenums]) # selecting the genes with the most variance, number from the user input
    z = data[,var] # all data of the selected Genes
    pca = prcomp(z, scale. = TRUE) # the acutual PCA
    return (pca)
}

# The server logic, rendering the plots and different text outputs. 
server = function(input, output) {
    
    # renderin the score plot
    output$scoreplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        plot (pca$x[,first], pca$x[,second], xlab=paste (first, "PC"), ylab=paste (second, "PC"))
        
        # adding colors
        points(x = pca$x[1:27,first], y = pca$x[1:27, second], col = "blue", pch=19) # all in blue
        points(x = pca$x[28:38,first], y = pca$x[28:38, second], col = "red", pch=19) # aml in red
        
    })
    
    # rendering the Scree plot
    output$screeplot = renderPlot({
        pca = recalcPCA(input)
        plot (pca, main = "")
    })
    
    # rendering the biplot
    output$biplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        biplot (pca, choices = c(first, second))
    })
    
    # rendering the loading Plot
    output$loadingplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        
        # initializing the plot
        plot (pca$rotation[,first], pca$rotation[,second], xlab = "PC1", ylab= "PC2", type = "n")
        
        # adding the Arrows of the Genes
        arrows(x0 = 0, y0= 0, x1=pca$rotation[,first], y1 = pca$rotation[,second], col = "blue", length = "0.1")
        
        # adding the Gene Names, the count is selected by the User
        for (i in 1:input$geneNameNumber){
            text (pca$rotation[i,first], pca$rotation[i,second], label = rownames(pca$rotation)[i], col = "blue")
        }
        
    })
    
    # render the number of PCs to look at to explain a specific amount of the variance
    output$countPCs = renderText({ 
        pca = recalcPCA(input)
        eig = pca$sdev^2 # variance (eigenvector) of the PCs
        count = 0
        i = 1
        sumeigs = sum (eig)
        limitv = 0.9
        while (count < limitv){ # sum the relative variances up to the treshhold
            count = count + eig[i] / sumeigs # add the relative variance
            i = i + 1
        }
        
        paste("The Scree plot displays the variance of each Principal Component. As definied the first Principal Component has the biggest Variance and 
              therefore explains the most most difference in the Data. You should have a look at the first ", i-1, "PCs to cover", limitv *100, "% of the Variance!")
        # i - 1 represents the actual number of principal components to look at because the counter i  starts at one
    })
    
    # additional text output for the score plot
    output$scoreplottext = renderText({
        br()
        paste("The Score Plot displays a projection of the paatients on the Principal Components. ALL patients are displayed blue, AML patients are displayed red. For more information about this plot type please refer to the documentation. ")
    })
    
    # additional text output for the loading plot
    output$loadinplottext = renderText({
        br()
        paste("The Loading Plot shows the impact of each Gene into the Principal Components (coefficients of the linear combination). For more information please refer to the documentation.")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
