
# myfile.R

library(httr)
r <- GET("",  query = list(key1 = "value 1", "key 2" = "value2", key2 = NULL))
http_status(r)

#' @get /mean
normalMean <- function(samples=10){
  
}

pr <- plumber$new()
pr$handle("GET", "/", function(req, res){
  # ...
})

pr$handle("POST", "/submit", function(req, res){
  # ...
})


#' @post /user
function(category_name,brand,concession){
  list(
    
    name = req$category_name,
    brand=req$brand,
    concession=req$concession,
   
  )
}
  


