# Window helper functions

A collection of helpers to generate window sequences matrices

## Usage

``` r
window_quick()

window_broad(x, steps = 3)

window_linearpixels(x, steps = 3)
```

## Arguments

- x:

  a raster

- steps:

  the number of window sizes to generate

## Value

a sequence on integer to pass to
[MHM](https://vbonhomme.github.io/mucha/reference/MHM.md)/[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md)

## Details

`window_quick` has a function shape but simply returns `c(3, 13, 23)`.
`window_broad` creates a sequence from `3` to `smallest_dim/3`.
`window_linearpixels` tries to have a roughly regular sequence of pixel
numbers which increase with a power two of kernel size otherwise.

## Examples

``` r
kernel_square(3)
#>      [,1] [,2] [,3]
#> [1,]    1    1    1
#> [2,]    1    1    1
#> [3,]    1    1    1
kernel_circle(7)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,]    0    0    0    1    0    0    0
#> [2,]    0    1    1    1    1    1    0
#> [3,]    0    1    1    1    1    1    0
#> [4,]    1    1    1    1    1    1    1
#> [5,]    0    1    1    1    1    1    0
#> [6,]    0    1    1    1    1    1    0
#> [7,]    0    0    0    1    0    0    0
kg <- kernel_gaussian(9, sigma=3)
kg
#>              [,1]        [,2]        [,3]        [,4]        [,5]        [,6]
#>  [1,] 0.003965247 0.005850089 0.007723246 0.009123937 0.009645167 0.009123937
#>  [2,] 0.005850089 0.008630874 0.011394418 0.013460915 0.014229906 0.013460915
#>  [3,] 0.007723246 0.011394418 0.015042829 0.017771002 0.018786220 0.017771002
#>  [4,] 0.009123937 0.013460915 0.017771002 0.020993959 0.022193296 0.020993959
#>  [5,] 0.009645167 0.014229906 0.018786220 0.022193296 0.023461149 0.022193296
#>  [6,] 0.009123937 0.013460915 0.017771002 0.020993959 0.022193296 0.020993959
#>  [7,] 0.007723246 0.011394418 0.015042829 0.017771002 0.018786220 0.017771002
#>  [8,] 0.005850089 0.008630874 0.011394418 0.013460915 0.014229906 0.013460915
#>  [9,] 0.003965247 0.005850089 0.007723246 0.009123937 0.009645167 0.009123937
#>              [,7]        [,8]        [,9]
#>  [1,] 0.007723246 0.005850089 0.003965247
#>  [2,] 0.011394418 0.008630874 0.005850089
#>  [3,] 0.015042829 0.011394418 0.007723246
#>  [4,] 0.017771002 0.013460915 0.009123937
#>  [5,] 0.018786220 0.014229906 0.009645167
#>  [6,] 0.017771002 0.013460915 0.009123937
#>  [7,] 0.015042829 0.011394418 0.007723246
#>  [8,] 0.011394418 0.008630874 0.005850089
#>  [9,] 0.007723246 0.005850089 0.003965247
kg %>% kernel_plot()
```
