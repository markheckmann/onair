#' Extracts the relevant <canvas> sections from the HTML document produced via
#' a call to writeWebGL().
#' 
#' The resultant HTML document will work assuming that canvasMatrix.js is loaded
extractWebGL <- function(size, wwwDir="www", imgDir="img/"){
  #generate a random 10 character sequence to represent this file
  id <- paste(sample(c(letters, LETTERS), 10), collapse="")  
  tempDir <- paste(tempdir(), "/", id, "/", sep="")
  
  writeWebGL(dir=tempDir, template="template_webgl.html", height=size, width=size)

  #read in the file
  lines <- readLines(paste(tempDir, "/index.html", sep=""))
  #remove canvasMatrix load -- we'll load it elsewhere
  lines <- lines[-1]
      
  #sub out the snapshot reference for a file with a unique ID
  lines <- gsub("snapshot.png", paste(imgDir, id, ".png", sep=""), lines)
  
  #create the img dir if it doesn't yet exist.
  dir.create(paste(wwwDir, "/", imgDir, sep=""), showWarnings=FALSE)
  
  #copy the snapshot image to a public WWW dir
  file.copy(paste(tempDir, "snapshot.png", sep=""), paste(wwwDir, "/", imgDir, id, ".png", sep=""))
  
  #remove the temporary directory
  #TODO: Doesn't seem to work in Windows
  unlink(tempDir, recursive=TRUE)
  
  #return the HTML lines generated by RGL
  paste(lines, collapse="\n")
}
