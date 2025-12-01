# Export raster to image format

Exports a `raster` or `SpatRaster` to `.tif` or `.txt` to stick to
original file formats of legacy MHM/CMP softwares.

## Usage

``` r
export_raster(x, filename, ...)
```

## Arguments

- x:

  `raster` or `SpatRaster`

- filename:

  where to write the file

- ...:

  additional arguments to pass to
  [terra::writeRaster](https://rspatial.github.io/terra/reference/writeRaster.html)

## Value

writes a file

## Examples

``` r
# we don't run the export here to not mess CRAN/github
# if you do, this will write a file on your machine
if (FALSE) { # \dontrun{
landscape <- import_example("l1.tif")
landscape %>% export_raster("landscape.tif")
} # }
```
