# Import text file into raster

Imports a text file into a raster.

## Usage

``` r
import_txt(x, header = FALSE, na.strings = "NA", sep = " ", ...)

import_txt_grid(x)
```

## Arguments

- x:

  character path to file

- header:

  logical (default to `FALSE`) passed to
  [`read.table()`](https://rdrr.io/r/utils/read.table.html)

- na.strings:

  character (default to `-9999`) passed to
  [`read.table()`](https://rdrr.io/r/utils/read.table.html)

- sep:

  character (default to `" "`) passed to
  [`read.table()`](https://rdrr.io/r/utils/read.table.html)

- ...:

  more params to be passed to
  [`read.table()`](https://rdrr.io/r/utils/read.table.html)

## Value

`SpatRaster`

## Details

A thin wrapper around
[utils::read.table](https://rdrr.io/r/utils/read.table.html) that
creates `SpatRaster` objects. For less exotic file formats, you can use
the regular
[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html)
methods.

## Examples

``` r
# use a system.file to make it work here,
# otherwise just point to your file
# these two are smaller (resampled 0.5) versions of their tif counterpart
# because of data volume limitations

system.file("extdata/l1.txt", package = "mucha") %>%
import_txt() %>% p()


system.file("extdata/l2.txt", package = "mucha") %>%
import_txt() %>% p()

```
