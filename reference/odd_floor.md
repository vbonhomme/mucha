# Flooring to the closest odd number

To ease the use in `window` size in
[MHM](https://vbonhomme.github.io/mucha/reference/MHM.md)/[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md)

## Usage

``` r
odd_floor(x)
```

## Arguments

- x:

  numeric

## Value

an odd integer, the closest from the numeric passed

## Examples

``` r
odd_floor(4)
#> [1] 3
odd_floor(99)
#> [1] 99
odd_floor(c(54, 53.99, 54.01))
#> [1] 53 53 53
```
