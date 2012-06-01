# Purpose        : Get EXIF info from Wikimedia 
# Maintainer     : Tomislav Hengl (tom.hengl@wur.nl);
# Contributions  : Dylan Beaudette (debeaudette@ucdavis.edu); Pierre Roudier (pierre.roudier@landcare.nz); 
# Dev Status     : Pre-Alpha
# Note           : The URLs might change in the near future;


getWikiMedia.ImageInfo <- function(imagename, APIsource = "http://commons.wikimedia.org/w/api.php", module = "imageinfo", details = c("url", "metadata", "size", "extlinks"), testURL = TRUE){ 
  
  if(testURL == TRUE){
    require(RCurl)
    z <- getURI(paste("http://commons.wikimedia.org/wiki/File:", imagename, sep=""), .opts=curlOptions(header=TRUE, nobody=TRUE, transfertext=TRUE, failonerror=FALSE))
      if(!length(x <- grep(z, pattern="404 Not Found"))==0){
      stop(paste("File", imagename, "could not be located at http://commons.wikimedia.org"))
      }
  }
  
  options(warn = -1)
  # Get the image URL:
  xml.lst <- NULL
  for(j in 1:length(details)){
    if(details[j]=="url"|details[j]=="metadata"|details[j]=="size"){
    xml.api = xmlParse(readLines(paste(APIsource, "?action=query&titles=File:", imagename, "&prop=", module, "&iiprop=", details[j], "&format=xml", sep="")))
    x <- xmlToList(xml.api[["//ii"]], addAttributes=TRUE)
    if(names(x)=="metadata"){
      exif.info <- sapply(xml.api["//metadata[@value]"], xmlGetAttr, "value")
      names(exif.info) <- sapply(xml.api["//metadata[@name]"], xmlGetAttr, "name")
      xml.lst[[j]] <- as.list(data.frame(as.list(exif.info), stringsAsFactors=FALSE))
      }
      else {
      xml.lst[[j]] <- as.list(x)
      }
    }
    else {
    if(details[j]=="extlinks"){
    xml.api = xmlParse(readLines(paste(APIsource, "?action=query&titles=File:", imagename, "&prop=", details[j], "&format=xml", sep="")))    
    geo.tag <- sapply(xml.api["//extlinks/el"], xmlValue)
    geo.tag <- geo.tag[c(grep(geo.tag, pattern="http://toolserver.org/~geohack/"), grep(geo.tag, pattern="maps.google"))]
    if(!length(geo.tag)==0){
      x <- strsplit(strsplit(geo.tag[2], "ll=")[[1]][2], "&")[[1]][1]
      names(geo.tag) <- c("toolserver.org", "maps.google.com")
      xml.lst[[j]] <- as.list(geo.tag)
      # manually enterred metadata:
      Longitude <- strsplit(x, ",")[[1]][2]
      Latitude <- strsplit(x, ",")[[1]][1]
      }
    }
    else {
    stop("Currently reads only 'url', 'metadata' and 'extlinks' information.")
    }
    }

    names(xml.lst)[j] <- details[j] 
  }

  xml.lst[["metadata"]]$GPSLongitude <- Longitude
  xml.lst[["metadata"]]$GPSLatitude <- Latitude
  # rewrite metadata with the Wikimedia specs (more reliable):
  xml.lst[["metadata"]]$ImageWidth <- xml.lst[["size"]]$width
  xml.lst[["metadata"]]$ImageHeight <- xml.lst[["size"]]$height    
  
  return(xml.lst)
}  

# end of script;