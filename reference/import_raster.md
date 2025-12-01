# Import image files to raster

Imports raster files using a thin wrapper around
[terra::rast](https://rspatial.github.io/terra/reference/rast.html)

## Usage

``` r
import_raster(x)
```

## Arguments

- x:

  path to the raster in a format accepted by
  [terra::rast](https://rspatial.github.io/terra/reference/rast.html)
  will work.

## Value

`SpatRaster` ready to use with
[MHM](https://vbonhomme.github.io/mucha/reference/MHM.md)/[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md)

## Details

An arbitrary crs is explicitely declared and warnings about missing
extent are supressed but declared anyway.

## Examples

``` r
# use a system.file to make it work here,
# otherwise just point to your file
# these two are smaller (resampled 0.5) versions of their tif counterpart
# because of data volume limitations

system.file("extdata/l1.tif", package = "mucha") %>%
import_raster() %>% p()


system.file("extdata/l2.tif", package = "mucha") %>%
import_raster() %>% p()

```
