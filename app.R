

library(shiny)
library(golubEsets)
data("Golub_Train")
data = t(exprs(Golub_Train))
data = replace(data, data<1, 1)
data = log2(data)
rownames(data)= c(replicate(27, "ALL"), replicate(11, "AML"))


# Define UI for application
ui = fluidPage(
    # Application title
    titlePanel("Principal Component Analysis"),

    # Sidebar with all the inputs
    sidebarLayout(
        
        sidebarPanel(
            sliderInput("genenums",
                        "Number of Genes in the Analysis:",
                        min = 25,
                        max = 250,
                        value = 100),
            numericInput("firstPC", "First PC: ", value = 1),
            numericInput("secondPC", "Second PC: ", value = 2),
            br(),
            p("At the Moment the Analysis runs with Gene Expression Data from the Golub Dataset."),
            numericInput("geneNameNumber", "Number Of Gene Names displayed in the Loading Plot:", value = 15 ),
            p("The selected Number of Gene Names has to be lower than the number of Genes in the analysis (slider)")
        ),

        # Filling the main panel with all the plots with a panel menu
        mainPanel(

           tabsetPanel(
                #main Panel with explanation
                tabPanel("PCA - The Method",
                    br(),
                    p("Principal Component Analysis is a Method for Dimension Reduction which is used for analysis multidimensional Data. For this reduction the data gets projected on constructed 
                      Principal Components (PC) while keeping the maximum amount of Information possible. For an explanation of the Method and the used functions please have a look in the documentation
                        . This example analysisi the Golub Data which consists of Expression Data of 38 Patients with Leukemia. Information on the Dataset are also accesible in the documentation.
                      "),
                    br(),
                    p("Useful links:"),
                ),
                # Score Plot
                tabPanel("Score plot", plotOutput("scoreplot"), textOutput("scoreplottext")),#
                # Scree Plot with Calculation of the PCs to use
                tabPanel("Scree plot", plotOutput("screeplot"), textOutput("countPCs")), 
                # Loading Plot
                tabPanel("Loading plot", plotOutput("loadingplot"),
                    br(),
                    p("The Loading plot shows the impact of each gene in the Principal Components (coefficients of the linear combination). Genes which are strongly correlated are
                      displayed close to each other. The Plot uses a Arrow / Vector design similar to the biplot. For a better visualisation the number of displayed Gene names is
                      limited and can be changed on the left side. More information about Loading Plots can be found in the documentation.")     
                         
                ),
                # Biplot
                tabPanel("Biplot", plotOutput("biplot"), 
                    p("The Biplot is a combination of the Loading and Score Plot and is a great way for a fast acces to the PCA results. In case this Plot is too complex and chaotic a second 
                      view into the single Plots can show a more detailed view. It is also possible to reduce the amount of Genes in the Analysis with the slider on the left side.")
                              
                )
            )
        )
    )
)

# support functions

recalcPCA = function (input){ # recalc the Analysis with a different amount of genes, as directed by the user
    var = names (sort(apply(data, 2, var), decreasing =TRUE)[1:input$genenums]) # selecting the genes with the most variance, number from the user input
    z = data[,var] # all data of the selected Genes
    pca = prcomp(z, scale. = TRUE) 
    return (pca)
}

# The server logic, rendering the plots and different text outputs. 
server = function(input, output) {

    output$scoreplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        plot (pca$x[,first], pca$x[,second], xlab=paste (first, "PC"), ylab=paste (second, "PC"))
        
        # adding colors
        points(x = pca$x[1:27,first], y = pca$x[1:27, second], col = "blue", pch=19) # all in blue
        points(x = pca$x[28:38,first], y = pca$x[28:38, second], col = "red", pch=19) # aml in red
        
    })
    
    output$screeplot = renderPlot({
        pca = recalcPCA(input)
        plot (pca, main = "")
    })
    
    output$biplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        biplot (pca, choices = c(first, second))
    })
    
    output$loadingplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        
        plot (pca$rotation[,first], pca$rotation[,second], xlab = "PC1", ylab= "PC2", type = "n")
        
        # adding the Arrows of the Genes
        arrows(x0 = 0, y0= 0, x1=pca$rotation[,first], y1 = pca$rotation[,second], col = "blue", length = "0.1")
        
        # adding the Gene Names, the count is selected by the User
        for (i in 1:input$geneNameNumber){
            text (pca$rotation[i,first], pca$rotation[i,second], label = rownames(pca$rotation)[i], col = "blue")
        }
        
    })
    
    output$countPCs = renderText({ # calculates the number of PCs which explain a specific amount of the total variance
        pca = recalcPCA(input)
        eig = pca$sdev^2
        count = 0
        i = 1
        sumeigs = sum (eig)
        limitv = 0.9
        while (count < limitv){ # sum the relative variances up to the treshhold
            count = count + eig[i] / sumeigs # add the relative variance
            i = i + 1
        }
        
        paste("The Scree Plot displays the variance of each Principal Component. As definied the first principal component has the biggest Variance and 
              therefore explains the most most difference in the Data.For example you should have a look at the first ", i-1, "PCs to cover", limitv *100, "% of the Variance!")
        # i - 1 represents the actual number of principal components to look at because the counter i  starts at one
    })
    
    output$scoreplottext = renderText({
        br()
        paste("The Score Plot displays a Projection of the Patients on the Principal Components. ALL Patients are displayed blue, AML patients are displayed red. For more information about this plot type please refer to the documentation. ")
    })
    
    output$loadinplottext = renderText({
        br()
        paste("The Loading Plot shows the impact of each Gene into the Principal Components (coefficients of the linear combination). For more information please refer to the documentation.")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
