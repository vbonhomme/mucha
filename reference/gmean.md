# Geometric mean

Brings a geometric mean function (`prod(x)^(1/length(x)`)

## Usage

``` r
gmean(x)
```

## Arguments

- x:

  numeric

## Value

numeric

## Details

Geometric mean is possibly a better alternative than a bare `prod` when
calculating composite maps from monoscale maps.

## Examples

``` r
x <- c(1, 2, 3, 4, 6)
mean(x)  # arithmetic mean
#> [1] 3.2
gmean(x) # geometric mean
#> [1] 2.70192
```
