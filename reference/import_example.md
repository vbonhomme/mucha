# Import example files

Imports one of the example files bundled with CMP

## Usage

``` r
import_example(name)
```

## Arguments

- name:

  of the example file. If empty a list of available examples is
  returned.

## Value

`SpatRaster` ready to use with
[MHM](https://vbonhomme.github.io/mucha/reference/MHM.md)/[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md)

## Details

Thin wrappers around
`system.file("extdata", "name_of_file", package="mucha")`. Intended to
ease working on example files and make them less verbose in the
examples/vignette.

## Examples

``` r
# when called with no name, returns a list of available examples
import_example()
#> Available example files to call with import_example('one_of_those_below'):
#> l1.tif
#> l1.txt
#> l2.tif
#> l2.txt

# then you can
landscape <- import_example("l1.tif")
p(landscape)
```
