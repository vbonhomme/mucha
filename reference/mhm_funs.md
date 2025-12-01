# Summary metrics on a single raster

Summary functions that return a scalar when passed with a portion of
raster. Typically passed to
[MHM](https://vbonhomme.github.io/mucha/reference/MHM.md).

## Usage

``` r
richness(x, ...)

simpson(x, ...)

shannon(x, ...)

shannon_evenness(x, ...)

kappa_index(x, ...)

contagion(x, ...)

contagion_cppr(x, ...)

shannon_evenness_cppr(x, ...)

kappa_index_cppr(x, ...)

simpson_cppr(x, ...)

shannon_cppr(x, ...)
```

## Arguments

- x:

  a fraction of a `SpatRaster` raster

- ...:

  additional parameters, used to collect
  [terra::focal](https://rspatial.github.io/terra/reference/focal.html)
  own passing through `...`

## Value

numeric the index of interest

## Details

For now on, some function have a cpp counterpart. The R implementation
will likely be removed soon. So far we maintain both for the sake of
testing. When a `_cppr` version exists, use it!

- `richness` simply returns the total number of unique classes (only
  makes sense on categorical landscapes)

- `simpson/simpson_cppr` is the Simpson's diversity index

- `shannon`/`shannon_cppr` is the Shannon's diversity index

- `shannon/shannon_cppr` optimized version in cpp

- `shannon_evenness/shannon_evenness_cppr` is the Shannon's evenness
  index

- `kappa_index/kappa_index_cppr` is Kappa index

- `student_p` is the p value from a Student's test

- `contagion/contagion_cppr` is the contagion index (Riitters, 1996) and
  also from MHM paper (only makes sense on categorical landscapes)

## Examples

``` r
set.seed(2329) # for reproducibility
x <- sample(1:3, size=49, replace=TRUE, prob=c(0.1, 0.1, 1))  # unbalanced vector
table(x)
#> x
#>  1  2  3 
#>  3  7 39 
x %>% richness()
#> [1] 3
x %>% simpson()
#> [1] 0.3423574
x %>% simpson_cppr()
#> [1] 0.3423574
x %>% shannon()
#> [1] 0.6306752
x %>% shannon_cppr()
#> [1] 0.6306752
x %>% shannon_evenness()
#> [1] 0.5740653
x %>% shannon_evenness_cppr()
#> [1] 0.5740653
x %>% kappa_index()
#>          1 
#> 0.01044568 
x %>% kappa_index_cppr()
#> [1] 0.01044568
x %>% contagion()
#> [1] 42.00754
x %>% contagion_cppr()
#> [1] 42.00754
```
