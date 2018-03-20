library(plumber)
r <- plumb("Hello.R")
r$run(port=8000)


