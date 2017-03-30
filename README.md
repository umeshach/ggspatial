ggspatial: Spatial data framework for ggplot2
================
Dewey Dunnington
March 30, 2017

Spatial data plus the power of the `ggplot2` framework means easier mapping when input data are already in the form of `Spatial*` objects (most spatial data in R).

Installation
------------

The package isn't available on CRAN (yet), but you can install it using `devtools::install_github()`.

``` r
install.packages("devtools") # if devtools isn't installed
devtools::install_github("paleolimbot/ggspatial")
```

Introduction
------------

The `ggspatial` package provides several functions to convert spatial objects to `ggplot2` layers. There are three cases: vector data (`geom_spatial()` or `ggspatial()`), raster data (`geom_spraster()`), and tiled basemap (`geom_osm()` or `ggosm()`). Their usage is *almost* identical to normal ggplot `geom_*` functions, except that the mapping and the data arguments are switched (usually `mapping` comes before `data`, but in this context, where the type of the object determines the method that gets called, it makes more sense for `data` to come first). Almost every call you make within this package will be:

``` r
library(ggspatial)
ggplot(...) + [ geom_osm() + ] # geom_osm is optional
  geom_spatial(spatial_object, ...) +
  ... +
  coord_map()
```

To save on typing, there are a few shortcuts. The first is where a `geom_spatial` is the first layer: for this, you can use `ggspatial(spatial_object, ...)`, which is short for `ggplot() + geom_spatial(spatial_object, ...) + coord_map()`.

``` r
library(ggspatial)
```

    ## Warning: package 'ggplot2' was built under R version 3.2.5

    ## Warning: package 'sp' was built under R version 3.2.5

``` r
ggspatial(longlake_waterdf, fill = "lightblue")
```

![](README_files/figure-markdown_github/unnamed-chunk-3-1.png)

The second is where a `geom_osm()` is your first layer. For this, you can use `ggosm()`, which is short for `ggplot() + geom_osm() + coord_map()`. In fact, `geom_osm()` *only* works using `coord_map()`, since tiles are projected and not in lat/lon coordinates.

``` r
ggosm() + 
  geom_spatial(longlake_waterdf, fill = "red", alpha = 0.25)
```

![](README_files/figure-markdown_github/unnamed-chunk-4-1.png)

Notice that `geom_osm()` doesn't need any arguments! Cool, right!? For more information, see `?geom_spatial` and `?geom_osm`. Now on to more mundane details...

Spatial objects
---------------

Many (but not all) objects of type `Spatial*` can be used with `ggplot`, but syntax is inconsistent and results vary. This package introduces a single `geom_` for use with `Spatial*` objects (e.g. `SpatialPointsDataFrame`, `SpatialLinesDataFrame`, `SpatialPolygonsDataFrame`...essentially what you get when you use `rgdal::readOGR()` or `maptools::readShapeSpatial()` to read any kind of spatial data). A few spatial objects are included in the package as examples, namely the `longlake_*` series of layers that I used to create my honours thesis figures (a distressingly long time ago, I may add).

``` r
library(ggspatial)
data(longlake_waterdf)
ggplot() + 
  geom_spatial(longlake_waterdf, fill="lightblue") + 
  coord_map()
```

![](README_files/figure-markdown_github/unnamed-chunk-5-1.png)

If we examine `longlake_waterdf`, we can use the columns as aesthetics just as we would for a normal `data.frame`.

``` r
ggplot() + 
  geom_spatial(longlake_waterdf, aes(fill=label)) + 
  coord_map()
```

![](README_files/figure-markdown_github/unnamed-chunk-6-1.png)

A more useful use of this may be to examine a depth survey from Long Lake I took on for my honours thesis.

``` r
data(longlake_depthdf)
ggplot() + geom_spatial(longlake_waterdf[2,], fill="lightblue") +
  geom_spatial(longlake_depthdf, aes(col=DEPTH.M), size=2) + 
  scale_color_gradient(low = "red", high = "blue") +
  coord_map()
```

![](README_files/figure-markdown_github/unnamed-chunk-7-1.png)

Projections
-----------

If you've been trying this at home, you may have noticed that you get a little message for every non-lat/lon dataset you try to plot. `geom_spatial()` is spatially aware, and if you don't tell it otherwise, it will convert all of your input data to lat/lon. I made this the default because `ggplot` has the nice `coord_map()` function that helpfully projects things that happen to be in lat/lon format (and communicates your intent clearly). If you're working in the polar regions or near the international date line, it's unlikely that this what you want. To get around the default projection, you can specify your own using `toepsg` or `toprojection`. For example, the previous plot could be rendered to the Google Mercator projection by passing `toepsg=3857` (note that you'll have to do this for all the layers).

``` r
data(longlake_depthdf)
ggplot() + 
  geom_spatial(longlake_waterdf[2,], fill="lightblue", 
               toepsg=3857) +
  geom_spatial(longlake_depthdf, aes(col=DEPTH.M), size=2,
               toepsg=3857) +
  scale_color_gradient(low = "red", high = "blue")
```

![](README_files/figure-markdown_github/unnamed-chunk-8-1.png)

Open Street Map Basemaps
------------------------

Using the [rosm package](https://github.com/paleolimbot/rosm), `ggspatial` can load Open Street Map tiles (among other tile sources) automatically as a backdrop for your other data (provided your data are in lat/lon, or are converted to such using `geom_spatial()`). Note that here we use `ggosm(...)` instead of `ggplot(...) + geom_osm() + coord_map()`, since `geom_osm()` only works when using `coord_map()` anyway.

``` r
ggosm(type = "stamenwatercolor") + 
  geom_spatial(longlake_waterdf, fill = "red", alpha = 0.25) +
  geom_spatial(longlake_roadsdf, lty = 2) +
  coord_map()
```

![](README_files/figure-markdown_github/unnamed-chunk-9-1.png)

So far we've only used `ggosm()` with no arguments, where it provides an auotmatic backdrop for all of the other layers. The first argument of `ggosm()` (and `geom_osm()`) is actually a bounding box (or an object from which one can be extracted, such as a `Spatial*` object, a `Raster*` object, a set of lon/lat coordinates, or a string of the location name, geocoded using `prettymapr::geocode`). When used with `ggosm()`, the most useful usage is a location name. It's worth noting that passing a vector of location names results in a bounding box containing all of them, so custom bounding boxes can be constructed a little more easily.

``` r
ggosm("nova scotia")
```

![](README_files/figure-markdown_github/unnamed-chunk-10-1.png)

Rasters
-------

Rasters are still a work in progress, but the idea is that you use a similar function to plot a raster layer.

``` r
ggplot() + geom_spatial(longlake_osm, aes(fill = band1, alpha = band3))
```

    ## Warning: no function found corresponding to methods exports from 'raster'
    ## for: 'overlay'

![](README_files/figure-markdown_github/unnamed-chunk-11-1.png)

Ongoing development
-------------------

This package is currently undergoing a major overhaul in preparation for release in April 2017, so keep an eye on the version number before you go crazy using it! In the works are:

-   Better raster plotting

That's it! Enjoy!
