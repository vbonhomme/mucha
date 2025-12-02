# Summary metrics on a pair of rasters

Summary functions that return a scalar when passed with two portions of
two rasters. Typically passed to
[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md).

## Usage

``` r
dist_euclidean(x, y, ...)

dist_manhattan(x, y, ...)

dist_chebyshev(x, y, ...)

dist_bhat(x, y, bins = 10, ...)

dist_identical(x, y, ...)

dist_different(x, y, ...)

cor_pearson(x, y, ...)

kappa_index(x, y, ...)

diff_rmse(x, y, ...)

diff_mean(x, y, ...)

diff_median(x, y, ...)

diff_var(x, y, ...)

diff_cv(x, y, ...)

p_student(x, y, min_nb = 5, ...)

p_wilcoxon(x, y, min_nb = 5, ...)

kappa_index_cppr(x, y, ...)

dist_euclidean_cppr(x, y, ...)

dist_manhattan_cppr(x, y, ...)

dist_chebyshev_cppr(x, y, ...)

diff_rmse_cppr(x, y, ...)
```

## Arguments

- x:

  a fraction of a `SpatRaster` raster

- y:

  a fraction of a `SpatRaster` raster

- ...:

  additional arguments

- bins:

  number of bins to use

- min_nb:

  minimal number of observation to calculate a value, otherwise a
  `NA_real` is returned

## Value

numeric the index of interest

## Details

First of all, you can use built-in function, as long as they return a
single value such as `cor`.

- `cor_pearson` is pearson correlation coefficient. Prone to NA for
  small window sizes with sd=0.

- `kappa_index/kappa_index_cppr` is Cohen's Kappa

- `dist_identical` proportion of identical value, pixel wise

- `dist_different` proportion of different value, pixel wise

- `dist_euclidean/dist_euclidean_cppr` euclidean distance (sqrt of sums
  of squared diff pixel-wise, divided by the number of valid pixels)

- `dist_manhattan/dist_manhattan_cppr` manhattan distance (sum of
  absolute distances pixel-wise, , divided by the number of valid
  pixels)

- `dist_chebyshev/dist_chebyshev_cppr` Chebyshev's distance (max of
  absolute distances pixel-wise)

- `dist_bhat` Bhattacharyya's distance based on distribution distances
  calculated using nbins

- `diff_rmse/diff_rmse_cppr` root-mean square error pixel-wise

- `diff_mean` difference of mean values

- `diff_mean` difference of mean values

- `diff_var` difference of variance values

- `diff_cv` difference of coefficient of variation values

- `p_student` p value from a Student t test

- `p_wilcoxon` p value from a Wilcoxon rank sum test

Naturally, you can also use built-in function, as long as they return a
single value such as: `cor`,

## See also

[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md),
[mhm_funs](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)

## Examples

``` r
set.seed(2329) # for reproducibility
x <- sample(1:3, size=49, replace=TRUE, prob=c(0.1, 0.1, 1))  # unbalanced vector
y <- sample(1:3, size=49, replace=TRUE, prob=c(0.1, 0.1, 1))  # another one

# examples runs mostly to test and exemplify
# but in CMP they will run on each pair of focal windows

# built in functions
cor(x, y)
#> [1] -0.2023918
cov(x, y)
#> [1] -0.08418367

# kappa agreement
kappa_index(x, y)
#> [1] -0.0864745
kappa_index_cppr(x, y)
#> [1] -0.0864745

# distance indices
dist_euclidean(x, y)
#> [1] 0.1443075
dist_euclidean_cppr(x, y)
#> [1] 0.1443075

dist_manhattan(x, y)
#> [1] 0.6122449
dist_manhattan_cppr(x, y)
#> [1] 0.6122449

dist_chebyshev(x, y)
#> [1] 2
dist_chebyshev_cppr(x, y)
#> [1] 2

dist_bhat(x, y)
#> [1] 0.01055561

# difference indices
diff_rmse(x, y)
#> [1] 1.010153
diff_rmse_cppr(x, y)
#> [1] 1.010153

diff_mean(x, y)
#> [1] 0.122449
diff_median(x, y)
#> [1] 0
diff_var(x, y)
#> [1] -0.210034
diff_cv(x, y)
#> [1] -0.07160757

# p value from Student t test
p_student(x, y)
#> [1] 0.3572371
p_wilcoxon(x, y)
#> [1] 0.5229461
```
