# Standard error

Brings a standard error `(var(x)/sqrt(n))` function

## Usage

``` r
se(x)
```

## Arguments

- x:

  numeric

## Value

numeric

## Details

SE is the historical error measurement in C. Gaucherel's papers.

## Examples

``` r
x <- c(1, 2, 3, 4, 3, 4, 3, 2, 1, 4)
sd(x) # standard deviation
#> [1] 1.159502
se(x) # standard error
#> [1] 0.3666667
```
