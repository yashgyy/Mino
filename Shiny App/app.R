load("Final_Model.rda")
library(gridExtra)
library(ggplot2)
df <- read.csv("Predictions.csv",stringsAsFactors = F)
Output <- read.csv("Predictions.csv",stringsAsFactors = F)
MonthsData<- read.csv("HomeTable.csv")
shinyApp(
  ui = fluidPage(
    titlePanel(h2("Price Prediction")),
    sidebarLayout(
      sidebarPanel(
      textInput("Brand","Brand of the Product"),
      helpText("In case of Local Brand leave the textbox Blank"),
      selectInput("Category","Category the Product Belongs",
                  choices =c("Clothing","Jewellery","Home","Footwear","Mobiles","Automotive","Beauty","Kitchen","
                  Computers","Watches","Tools","Toys","Pens","Bags","Furniture","Sports")),
      
      sliderInput("DemandRate","Maximum Concession",min=0,max=100,value=0),
      
      helpText("The maximum off or discount you can provide to the product over MRP"),
      checkboxInput("CheckInput",strong("Is Your Product Flipkart or Amazon Verified")),
      actionButton("update" ,"Predict", icon("refresh"),
                   class = "btn btn-primary")
      
  ),
  mainPanel(
    br(),
    br(),
    dataTableOutput("value8"),
    br(),
    h3("The Prediction of the Output"),
    verbatimTextOutput("value5"),
    plotOutput("value6")
    
    
  )
  )
),
  
    
  server = function(input, output) {
    output$value <- renderPrint({ 
      input$update
      isolate(input$Brand)
    })
    output$value1 <- renderPrint({ 
      input$update
      isolate(input$Category)
    })
    output$value2 <- renderPrint({ 
      input$update
      isolate(input$DemandRate)
    })
    output$value3 <- renderPrint({ 
      input$update
      isolate(input$CheckInput)
    })
    
    observe({   
      if(input$update > 0) {
       
        
        output$value5 <- renderPrint({
          Demandate <- input$DemandRate/100
          Demandate <- ((1)/(1-Demandate))
          as.factor(Output$Col1) -> Output$Col1
          as.factor(Output$brand) -> Output$brand
          rbind(Output,c(input$Category,0,as.integer(input$CheckInput),input$Brand,Demandate)) -> Output
          as.numeric(Output$retail_price) -> Output$retail_price
          as.numeric(Output$Demand) -> Output$Demand
          as.integer(Output$is_FK_Advantage_product) -> Output$is_FK_Advantage_product
          Output[is.na(Output)] <- ""
          as.factor(Output$Col1) -> Output$Col1
          as.factor(Output$brand) -> Output$brand
          predict(Fit,Output[18293,])
        })
        output$value8 <- renderDataTable({
          Demandate <- input$DemandRate/100
          Demandate <- ((1)/(1-Demandate))
          as.factor(Output$Col1) -> Output$Col1
          as.factor(Output$brand) -> Output$brand
          Output[is.na(Output)] <- ""
          out <- rbind(Output,c(input$Category,0,as.integer(input$CheckInput),input$Brand,Demandate)) 
          return (out[18293,])
        })
        output$value6 <- renderPlot({
          
          YY=subset(MonthsData,Col1==c(input$Category))
          p1<-  ggplot(aes(x=YY$Months,y=YY$Price,group=1),data=YY)+geom_point(shape=8)+geom_line(linetype="dotdash",color="blue")+ylab(paste("Price",input$Category))+xlab("Months")
          p2 <- ggplot(aes(x=YY$Months,y=YY$Demand,group=1),data=YY)+geom_point(shape=8)+geom_line(linetype="dotdash",color="blue")+ylab(paste("Demand",input$Category))+xlab("Months")
          grid.arrange(p1,p2)
          })
      }
    })
  }
)