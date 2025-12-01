# Export raster to txt format

Exports a `raster` or `SpatRaster` to text format such as `.txt` to
stick to original file formats of legacy MHM/CMP softwares.

## Usage

``` r
export_txt(x, filename, ...)

export_txt_grid(x, filename, signif = NULL, ...)
```

## Arguments

- x:

  `raster` or `SpatRaster`

- filename:

  where to write the file

- ...:

  additional arguments to pass to
  [utils::write.table](https://rdrr.io/r/utils/write.table.html)

- signif:

  how many significant numbers to retain (default to `NULL`, no
  rounding)

## Value

writes a file

## Examples

``` r
# we don't run the export here to not mess CRAN/github
# if you do, this will write a file on your machine
if (FALSE) { # \dontrun{
landscape <- import_example("l1.tif")
landscape %>% export_txt("landscape.txt")
} # }
```
