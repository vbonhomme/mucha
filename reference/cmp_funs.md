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

cor_pearson(x, y, ...)

diff_rmse(x, y, ...)

diff_mean(x, y, ...)

diff_median(x, y, ...)

diff_var(x, y, ...)

diff_cv(x, y, ...)

p_student(x, y, min_nb = 5, ...)

p_wilcoxon(x, y, min_nb = 5, ...)
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

- `correlation`

- `dist_euclidean` euclidean distance (sqrt of sums of squared diff
  pixel-wise)

- `dist_manhattan` manhattan distance (sum of absolute distances
  pixel-wise

- `dist_chebyshev` Chebyshev's distance (max of absolute distances
  pixel-wise)

- `dist_bhat` Bhattacharyya's distance based on distribution distances
  calculated using nbins

- `diff_rmse` root-mean square error pixel-wise

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
x <- sample(1:3, size=50, replace=TRUE, prob=c(0.1, 0.1, 1))  # unbalanced vector
y <- sample(1:3, size=50, replace=TRUE, prob=c(0.1, 0.1, 1))  # another one

# examples runs mostly to test and exemplify
# but in CMP they will run on each pair of focal windows

# built in functions
cor(x, y)
#> [1] 0.1026562
cov(x, y)
#> [1] 0.04204082

# distance indices
dist_euclidean(x, y)
#> [1] 6.164414
dist_manhattan(x, y)
#> [1] 24
dist_chebyshev(x, y)
#> [1] 2
dist_bhat(x, y)
#> [1] 0.01033658

# difference indices
diff_rmse(x, y)
#> [1] 0.8717798
diff_mean(x, y)
#> [1] 0.12
diff_median(x, y)
#> [1] 0
diff_var(x, y)
#> [1] -0.2073469
diff_cv(x, y)
#> [1] -0.07078931

# p value from Student t test
p_student(x, y)
#> [1] 0.3583415
p_wilcoxon(x, y)
#> [1] 0.5260465
```
