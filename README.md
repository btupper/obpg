obpg
================

Access OPeNDAP OBPG data from R. Extract point or bounded boxes (as
raster).

Find a catalog of the available OBPG data offerings
[here](https://oceandata.sci.gsfc.nasa.gov/opendap/)

## Requirements

- [R v4.1+](https://www.r-project.org/)

Packages from CRAN:

- [rlang](https://CRAN.R-project.org/package=rlang)
- [dplyr](https://CRAN.R-project.org/package=httr)
- [sf](https://CRAN.R-project.org/package=sf)
- [stars](https://CRAN.R-project.org/package=stars)
- [tidyr](https://CRAN.R-project.org/package=tidyr)
- [ncdf4](https://CRAN.R-project.org/package=ncdf4)

Packages from Github:

- [xyzt](https://github.com/BigelowLab/xyzt)

## Installation

    remotes::install_github("BigelowLab/obpg")

### Usage

``` r
suppressPackageStartupMessages({
  library(dplyr)
  library(sf)
  library(stars)
  
  library(xyzt)
  library(obpg)
})
```

#### Working with points.

See the [xyzt](https://github.com/BigelowLab/xyzt) package for more
details on the example Gulf of Maine data.

``` r
# read in example GOM points
x <- xyzt::read_gom() |>
  dplyr::select(-time, -depth) |>
  xyzt::as_POINT()

# generate a MUR url for a given date
url <- obpg_url("2020-07-12")

# open the resource
X <- ncdf4::nc_open(url)

# extract the data 
covars <- obpg::extract(x, X, varname = obpg::obpg_vars(X))

# bind to the input
(y <- dplyr::bind_cols(x, covars))
```

    ## Simple feature collection with 5 features and 3 fields
    ## Geometry type: POINT
    ## Dimension:     XY
    ## Bounding box:  xmin: -70.17 ymin: 40.5 xmax: -66.59 ymax: 43.5
    ## Geodetic CRS:  WGS 84
    ## # A tibble: 5 × 4
    ##   id    name                 geometry   sst
    ## * <chr> <chr>             <POINT [°]> <dbl>
    ## 1 44098 Jeffreys Ledge (-70.17 42.81)  19.8
    ## 2 44005 Cashes Ledge   (-69.22 43.17)  19.9
    ## 3 44037 Jordan Basin    (-67.87 43.5)  17.6
    ## 4 44011 Georges Bank   (-66.59 41.09)  23.9
    ## 5 44008 Nantucket SE    (-69.24 40.5)  17.3

#### Working with bounding boxes

``` r
x <- xyzt::read_gom() |>
  dplyr::select(-time, -depth) |>
  xyzt::as_BBOX()

covars <- obpg::extract(x, X, varname = obpg::obpg_vars(X))

covars
```

    ## stars object with 2 dimensions and 1 attribute
    ## attribute(s):
    ##      Min. 1st Qu. Median     Mean 3rd Qu. Max. NA's
    ## sst  11.1  17.505 18.855 18.72126  19.915 25.1   61
    ## dimension(s):
    ##   from to offset      delta refsys x/y
    ## x    1 45 -70.17  0.0795556 WGS 84 [x]
    ## y    1 38   43.5 -0.0789474 WGS 84 [y]

Plot the bounding box of data with the points we pulled above:

``` r
x <- xyzt::read_gom() |>
  dplyr::select(-time, -depth) |>
  xyzt::as_POINT()
par(mfrow = c(1,2))
plot(covars, attr = 'sst', col = sf.colors(n=16), axes = TRUE, reset = FALSE)
plot(sf::st_geometry(x), add = TRUE, col = "green", pch = 19, cex = 2)
```

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
# cleanup
ncdf4::nc_close(X)
```

## Climatologies

Mission-length climatologies are available (for the entire mission, a
particular season or month.) You can search for these. Here we find the
seasonal (northern) summer.

``` r
uri <- query_obpg_climatology(climatology = "SCSU", res = "9km", param = "SST.sst")
uri
```

    ## [1] "https://oceandata.sci.gsfc.nasa.gov/opendap/MODISA/L3SMI/2002/0621/AQUA_MODIS.20020621_20220920.L3m.SCSU.SST.sst.9km.nc"

``` r
x <- xyzt::read_gom() |>
  dplyr::select(-time, -depth) |>
  xyzt::as_BBOX()

# open the resource
X <- ncdf4::nc_open(uri)

covars <- obpg::extract(x, X, varname = obpg::obpg_vars(X), flip = "none")
covars
```

    ## stars object with 2 dimensions and 1 attribute
    ## attribute(s):
    ##      Min. 1st Qu. Median     Mean 3rd Qu.  Max. NA's
    ## sst  8.78  18.585  24.02 22.66712  26.755 31.91 6988
    ## dimension(s):
    ##   from  to offset      delta refsys x/y
    ## x    1 155 -70.17  0.0230968 WGS 84 [x]
    ## y    1 148   43.5 -0.0202703 WGS 84 [y]

``` r
x <- xyzt::read_gom() |>
  dplyr::select(-time, -depth) |>
  xyzt::as_POINT()
par(mfrow = c(1,2))
plot(covars, attr = 'sst', col = sf.colors(n=16), axes = TRUE, reset = FALSE)
plot(sf::st_geometry(x), add = TRUE, col = "green", pch = 19, cex = 2)
```

![](README_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
# cleanup
ncdf4::nc_close(X)
```
