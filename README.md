obpg
================

Access OPeNDAP OBPG data from R. Extract point or bounded boxes (as
raster).

## Requirements

-   [R v4.1+](https://www.r-project.org/)

Packages from CRAN.

-   [rlang](https://CRAN.R-project.org/package=rlang)
-   [dplyr](https://CRAN.R-project.org/package=httr)
-   [sf](https://CRAN.R-project.org/package=sf)
-   [stars](https://CRAN.R-project.org/package=stars)
-   [tidyr](https://CRAN.R-project.org/package=tidyr)
-   [ncdf4](https://CRAN.R-project.org/package=ncdf4)

Packages from Github

-   [xyzt](https://github.com/BigelowLab/xyzt)

## Installation

    remotes::install_github("BigelowLab/obpg")

### Usage

``` r
suppressPackageStartupMessages({
  library(dplyr)
  library(sf)
  library(obpg)
  library(xyzt)
  library(stars)
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

    ## Simple feature collection with 5 features and 4 fields
    ## Geometry type: POINT
    ## Dimension:     XY
    ## Bounding box:  xmin: -70.17 ymin: 40.5 xmax: -66.59 ymax: 43.5
    ## Geodetic CRS:  WGS 84
    ## # A tibble: 5 × 5
    ##   id    name                 geometry qual_sst   sst
    ## * <chr> <chr>             <POINT [°]>    <int> <dbl>
    ## 1 44098 Jeffreys Ledge (-70.17 42.81)        0  19.8
    ## 2 44005 Cashes Ledge   (-69.22 43.17)        0  19.9
    ## 3 44037 Jordan Basin    (-67.87 43.5)        0  17.6
    ## 4 44011 Georges Bank   (-66.59 41.09)        1  23.9
    ## 5 44008 Nantucket SE    (-69.24 40.5)        1  17.3

``` r
# cleanup
ncdf4::nc_close(X)
```
