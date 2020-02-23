

library(shiny)
library (yeastCC)

# Load all the Data
x = exprs(yeastCC)[,5:22]
data = replace (x, is.na(x), 0)


# Define UI for application that draws a histogram
ui = fluidPage(
    # Application title
    titlePanel("Principal Component Analysis"),
   

    # Sidebar with a slider input for number of bins 
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
            p("At the Moment the Analysis runs with Cell Cycle Data from the Yeast Cell Cycle.")
        ),
        
        

        # Show a plot of the generated distribution
        mainPanel(
        
           tabsetPanel(
                tabPanel("PCA - The Method",
                    br(),
                    p("Principal Component Analysis is a Method for Dimension Reduction")     
                ),
                tabPanel("ScorePlot", plotOutput("scoreplot")), 
                tabPanel("Screeplot", plotOutput("screeplot"), textOutput("countPCs")), 
                tabPanel("Biplot", plotOutput("biplot"))
            )
            
        )
    )
)

# support functions
recalcPCA = function (input){ # recalc the Analysis with a different amount of genes, as directed by the user
    var = names(sort (apply (data,1, var), decreasing =TRUE)[1:input$genenums]) # selecting the genes with the most variance, number from the user input
    z = data[var,] # all data of the selected Genes
    pca = prcomp(z) 
    return (pca)
}

# Define server logic required to draw a histogram
server = function(input, output) {

    output$scoreplot = renderPlot({
        pca = recalcPCA(input)
        
        first = input$firstPC
        second = input$secondPC
        plot (pca$rotation[,first], pca$rotation[,second], type = "b", xlab=paste (first, "PC"), ylab=paste (second, "PC"))
        
    })
    
    output$screeplot = renderPlot({
        pca = recalcPCA(input)
        plot (pca)
    })
    
    output$biplot = renderPlot({
        pca = recalcPCA(input)
        first = input$firstPC
        second = input$secondPC
        paste (first:second)
        biplot (pca, choices = c(first, second))
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
        

        paste("You should have a look at the first ", i-1, "PCs to cover", limitv *100, "% of the Variance!")
        # i - 1 represents the actual number of principal components to look at 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
