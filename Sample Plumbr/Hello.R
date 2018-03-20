library(jsonlite)

#* @post /predict
function(a){
  return (fromJSON(a))
}

#* @get /mean
function(){
  return ("Hello")
}