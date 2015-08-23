library(shiny)
library(ISLR)
library(ggplot2)
library(caret)
library(kernlab)

# split data
set.seed(12345)
in.train <- createDataPartition(y=Wage$wage, p=0.6, list=FALSE)
tr.set <- Wage[in.train,]
te.set <- Wage[-in.train,]

r1 <- data.frame(y=te.set$wage)

# fit model for lm
fit.lm <- train(wage ~ age, data=tr.set, method="lm")
fit.pred.lm <- predict(fit.lm, te.set)
r2.lm <- data.frame(y=fit.pred.lm)
result.lm <- rbind(r1, r2.lm)
result.lm$label <- c(rep("test", length(te.set$wage)), rep("pred", length(te.set$wage)))

# svmLinear
fit.svmLinear <- train(wage ~ age, data=tr.set, method="svmLinear")
fit.pred.svmLinear <- predict(fit.svmLinear, te.set)
r2.svmLinear <- data.frame(y=fit.pred.svmLinear)
result.svmLinear <- rbind(r1, r2.svmLinear)
result.svmLinear$label <- c(rep("test", length(te.set$wage)), rep("pred", length(te.set$wage)))

# rpart
fit.rpart <- train(wage ~ age, data=tr.set, method="rpart")
fit.pred.rpart <- predict(fit.rpart, te.set)
r2.rpart <- data.frame(y=fit.pred.rpart)
result.rpart <- rbind(r1, r2.rpart)
result.rpart$label <- c(rep("test", length(te.set$wage)), rep("pred", length(te.set$wage)))


shinyServer(function(input, output){
        
    # show model summary
    output$summary.table <- renderTable({
        # set model
        if (input$sel.model=="svmLinear") {
            fit <- fit.svmLinear
        }else if(input$sel.model=="rpart") {
            fit <- fit.rpart
        }else {
            fit <- fit.lm
        }
        getTrainPerf(fit)
    })
    
    # show validation mettric
    output$error.text <- renderText({
        # set model
        if (input$sel.model=="svmLinear") {
            r2 <- r2.svmLinear
        }else if(input$sel.model=="rpart") {
            r2 <- r2.rpart
        }else {
            r2 <- r2.lm
        }
        val.rmse <- sqrt(mean((r1$y - r2$y)^2))
        paste("Root Mean Square Error:", val.rmse)
    })
    
    # comparing density
    output$value.plot <- renderPlot({
        # set model
        if (input$sel.model=="svmLinear") {
            result <- result.svmLinear
        }else if(input$sel.model=="rpart") {
            result <- result.rpart
        }else {
            result <- result.lm
        }
        qplot(y, data=result, geom="freqpoly", ylab="wage", group=label, colour=label, position="identity")
    })
    
    # comparing value
    output$hist1.plot <- renderPlot({
        # set model
        if (input$sel.model=="svmLinear") {
            result <- result.svmLinear
        }else if(input$sel.model=="rpart") {
            result <- result.rpart
        }else {
            result <- result.lm
        }
        qplot(y, data=result, fill=label, geom="bar", ylab="wage")
    })
    
    # comparing value
    output$hist2.plot <- renderPlot({
        # set model
        if (input$sel.model=="svmLinear") {
            result <- result.svmLinear
        }else if(input$sel.model=="rpart") {
            result <- result.rpart
        }else {
            result <- result.lm
        }
        ord.r1 <- data.frame(y=r1[order(r1$y),], index=seq(dim(r1)[1]))
        qplot(index, y, data=ord.r1, geom=c("point", "smooth"), ylab="wage", xlab="ordered index", main="Test Set")
    })
    
    # comparing value
    output$hist3.plot <- renderPlot({
        # set model
        if (input$sel.model=="svmLinear") {
            result <- result.svmLinear
        }else if(input$sel.model=="rpart") {
            result <- result.rpart
        }else {
            result <- result.lm
        }
        ord.r2 <- data.frame(y=r2[order(r2$y),], index=seq(dim(r2)[1]))
        qplot(index, y, data=ord.r2, geom=c("point", "smooth"), ylab="wage", xlab="ordered index", main="Prediction")
    }) 
})