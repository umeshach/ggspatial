% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-raster.R, R/class-spatial.R, R/spatial-geom.R
\name{spatial_geom.Raster}
\alias{spatial_default_aes}
\alias{spatial_default_aes.Lines}
\alias{spatial_default_aes.Polygons}
\alias{spatial_default_aes.Raster}
\alias{spatial_default_aes.SpatialLines}
\alias{spatial_default_aes.SpatialPolygons}
\alias{spatial_geom}
\alias{spatial_geom.Line}
\alias{spatial_geom.Lines}
\alias{spatial_geom.Polygon}
\alias{spatial_geom.Polygons}
\alias{spatial_geom.Raster}
\alias{spatial_geom.SpatialLines}
\alias{spatial_geom.SpatialPoints}
\alias{spatial_geom.SpatialPolygons}
\alias{spatial_geom.default}
\alias{spatial_stat}
\title{Guess ggplot parameters based on a spatial object}
\usage{
\method{spatial_geom}{Raster}(x)

\method{spatial_default_aes}{Raster}(x)

\method{spatial_geom}{SpatialPoints}(x)

\method{spatial_geom}{Line}(x)

\method{spatial_geom}{Lines}(x)

\method{spatial_geom}{SpatialLines}(x)

\method{spatial_geom}{Polygon}(x)

\method{spatial_geom}{Polygons}(x)

\method{spatial_geom}{SpatialPolygons}(x)

\method{spatial_default_aes}{Lines}(x)

\method{spatial_default_aes}{SpatialLines}(x)

\method{spatial_default_aes}{Polygons}(x)

\method{spatial_default_aes}{SpatialPolygons}(x)

spatial_geom(x)

\method{spatial_geom}{default}(x)

spatial_stat(x)

spatial_default_aes(x)
}
\arguments{
\item{x}{A spatial object}
}
\value{
A ggplot2 \code{Geom}
}
\description{
In most cases, the ggplot geometry that should be used with a
spatial object is suggested based on its type (e.g, SpatialPoints
should use \code{geom = "point"}). S3 implementations of this
method should return a ggplot2 \code{Geom} that will be used in
\link{geom_spatial} when \code{geom = NA}. The default is
\code{geom = "point"}. In almost all cases, the statistic
to be used should be \code{stat = "identity"}, but could
theoretically be a custom stat written for a specific
class of spatial object. Default aesthetics are by default
\code{aes(.long, .lat)}, but some spatial objects require
other aesthetics, for which the defaults are returned by
\code{spatial_default_aes()}.
}
\examples{
spatial_geom(data.frame()) # default is GeomPoint
spatial_geom(longlake_waterdf) # GeomPolypath
spatial_geom(longlake_roadsdf) # GeomPath
spatial_geom(longlake_buildingsdf) # GeomPoint
spatial_geom(longlake_osm) # GeomRaster

}

