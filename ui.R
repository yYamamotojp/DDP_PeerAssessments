library(shiny)
library(ISLR)

# set Wage
wage.cols <- colnames(Wage)
var.cols <- wage.cols[-which(wage.cols %in% "wage")]

shinyUI(fluidPage(
    
    titlePanel("Comparing Models for Mid-Atlantic Wage Data"),
    
    sidebarLayout(
        sidebarPanel(            
            # select model
            selectInput("sel.model",
                        label = h3("Model"),
                        choices = list("Liner Regression" = "lm"
                                       , "SVM Liner Regression" = "svmLinear"
                                       , "Regression Tree" = "rpart"),
                        selected = "lm"),
            
            # target variable
            h3("Target"),
            p("wage"),
    
            # select variables
            h3("Variable"),
            p("age")
            ),
            mainPanel(
                h3("Training Result"),
                
                # show model summary
                tableOutput("summary.table"),
                
                h3("Cross Validation Result"),
                
                # show error metrix
                textOutput("error.text"),
                
                # comparing value
                plotOutput("value.plot"),
                
                # comparing test set vs prediction
                plotOutput("hist1.plot"),
                plotOutput("hist2.plot"),
                plotOutput("hist3.plot")
            )
        )
    )
)