\name{kml_layer.Raster}
\alias{kml_layer.Raster}
\alias{kml_layer.SpatialPixels}
\alias{RasterLayer}
\title{Writes raster objects to KML}
\description{Writes rasters to PNG images and makes a KML code (ground overlays). Works with \code{"RasterLayer"}, \code{"SpatialGrid"}, \code{"SpatialPixels"} and \code{"RasterStack"} class objects. Target attributes can be specified using aesthetics arguments (e.g. \code{"colour"}).}
\usage{
kml_layer.Raster(obj, plot.legend = TRUE, metadata = NULL, raster_name, \dots)
}
\arguments{
  \item{obj}{object of class \code{"RasterLayer"}, \code{"SpatialPixelsDataFrame"} or \code{"SpatialGridDataFrame"}}
  \item{plot.legend}{logical; specify whether a map legend should be generated automatically}
  \item{metadata}{(optional) specify the metadata object}
  \item{raster_name}{(optional) specify the output file name (PNG)}
  \item{\dots}{additional \code{\link{aesthetics}} arguments}
}  
\details{Google Earth does not properly handle a 24-bit PNG file which has a single transparent color (read more at \href{http://groups.google.com/group/earth-help/}{Google Earth Help}). To force transparency, plotKML will try to set it using the \code{-matte -transparent "\#FFFFFF"} option in the \href{http://www.imagemagick.org/Usage/masking/}{ImageMagick convert program} (ImageMagick needs to be installed separately and located using \code{plotKML.env()}).
}
\author{Tomislav Hengl, Pierre Roudier and Dylan Beaudette}
\seealso{ \code{\link{kml-methods}}, \code{\link{kml_open}}, \code{\link{kml_layer.RasterBrick}} }
\examples{
data(eberg_grid)
coordinates(eberg_grid) <- ~x+y
gridded(eberg_grid) <- TRUE
proj4string(eberg_grid) <- CRS("+init=epsg:31467")
data(SAGA_pal)
\dontrun{
# KML plot with a single raster:
kml(eberg_grid, colour_scale = SAGA_pal[[1]], colour = TWISRT6) 
}
}
\keyword{spatial}

