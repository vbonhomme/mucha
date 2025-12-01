# distance indices ----
#' Summary metrics on a pair of rasters
#'
#' Summary functions that return a scalar when passed with two portions of two rasters.
#' Typically passed to [CMP].
#'
#' @param x a fraction of a `SpatRaster` raster
#' @param y a fraction of a `SpatRaster` raster
#' @param bins number of bins to use
#' @param min_nb minimal number of observation to calculate a value,
#' otherwise a `NA_real` is returned
#' @param ... additional arguments
#'
#' @return numeric the index of interest
#'
#' @details
#' First of all, you can use built-in function,
#' as long as they return a single value such as `cor`.
#'
#' * `cor_pearson` is pearson correlation coefficient. Prone to NA for small window sizes with sd=0.
#' * `dist_euclidean` euclidean distance (sqrt of sums of squared diff pixel-wise, divided by the number of valid pixels)
#' * `dist_manhattan` manhattan distance (sum of absolute distances pixel-wise, , divided by the number of valid pixels)
#' * `dist_chebyshev` Chebyshev's distance (max of absolute distances pixel-wise)
#' * `dist_bhat` Bhattacharyya's distance based on distribution distances calculated using nbins
#' * `diff_rmse` root-mean square error pixel-wise
#' * `diff_mean` difference of mean values
#' * `diff_mean` difference of mean values
#' * `diff_var` difference of variance values
#' * `diff_cv` difference of coefficient of variation values
#' * `p_student` p value from a Student t test
#' * `p_wilcoxon` p value from a Wilcoxon rank sum test
#'
#' Naturally, you can also use built-in function, as long as they return a single value such as: `cor`,
#'
#' @seealso [CMP], [mhm_funs]
#'
#' @examples
#' set.seed(2329) # for reproducibility
#' x <- sample(1:3, size=50, replace=TRUE, prob=c(0.1, 0.1, 1))  # unbalanced vector
#' y <- sample(1:3, size=50, replace=TRUE, prob=c(0.1, 0.1, 1))  # another one
#'
#' # examples runs mostly to test and exemplify
#' # but in CMP they will run on each pair of focal windows
#'
#' # built in functions
#' cor(x, y)
#' cov(x, y)
#'
#' # distance indices
#' dist_euclidean(x, y)
#' dist_manhattan(x, y)
#' dist_chebyshev(x, y)
#' dist_bhat(x, y)
#'
#' # difference indices
#' diff_rmse(x, y)
#' diff_mean(x, y)
#' diff_median(x, y)
#' diff_var(x, y)
#' diff_cv(x, y)
#'
#' # p value from Student t test
#' p_student(x, y)
#' p_wilcoxon(x, y)
#'
#' @name cmp_funs
#' @export
dist_euclidean <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  sqrt(sum((x[valid] - y[valid])^2))/sum(valid)
}

# l1 norm
#' @rdname cmp_funs
#' @export
dist_manhattan <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  sum(abs(x[valid] - y[valid]))/sum(valid)
}

# maximum difference
#' @rdname cmp_funs
#' @export
dist_chebyshev <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  max(abs(x[valid] - y[valid]))
}

#' @rdname cmp_funs
#' @export
# Bhattacharya's distance
dist_bhat <- function(x, y, bins = 10, ...) {
  valid_x <- x[!is.na(x)]
  valid_y <- y[!is.na(y)]

  if (length(valid_x) < 2 || length(valid_y) < 2) return(NA)

  # Create common breaks for both distributions
  min_val <- min(c(valid_x, valid_y))
  max_val <- max(c(valid_x, valid_y))
  breaks <- seq(min_val, max_val, length.out = bins + 1)

  # Create histograms
  hist_x <- graphics::hist(valid_x, breaks = breaks, plot = FALSE)$counts
  hist_y <- graphics::hist(valid_y, breaks = breaks, plot = FALSE)$counts

  # Normalize to get probability distributions
  p <- hist_x / sum(hist_x)
  q <- hist_y / sum(hist_y)

  # Avoid log(0) issues
  p[p == 0] <- 1e-10
  q[q == 0] <- 1e-10

  # Calculate Bhattacharyya coefficient
  bc <- sum(sqrt(p * q))

  # Bhattacharyya distance
  -log(bc)
}

# cor ------

#' @name cmp_funs
#' @export
cor_pearson <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA_real_)
  # suppress warning "the standard deviation is zero"
  suppressWarnings(
    stats::cor(x[valid], y[valid],
             method="pearson", use = "complete")
  )
}

# difference indices ----

# root mean square error
#' @rdname cmp_funs
#' @export
diff_rmse <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  sqrt(mean((x[valid] - y[valid])^2))
}

# difference of means
#' @rdname cmp_funs
#' @export
diff_mean <- function(x, y, ...) {
  mean(x, na.rm = TRUE) - mean(y, na.rm = TRUE)
}

# difference of medians
#' @rdname cmp_funs
#' @export
diff_median <- function(x, y, ...) {
  stats::median(x, na.rm = TRUE) - stats::median(y, na.rm = TRUE)
}

# variance difference
#' @rdname cmp_funs
#' @export
diff_var <- function(x, y, ...) {
  stats::var(x, na.rm = TRUE) - stats::var(y, na.rm = TRUE)
}

# coeff of variation difference
#' @rdname cmp_funs
#' @export
diff_cv <- function(x, y, ...) {
  cv_x <- stats::sd(x, na.rm = TRUE) / abs(mean(x, na.rm = TRUE))
  cv_y <- stats::sd(y, na.rm = TRUE) / abs(mean(y, na.rm = TRUE))
  cv_x - cv_y
}

# p indices ----
#' @rdname cmp_funs
#' @export
p_student <- function(x, y, min_nb=5, ...){
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid)<min_nb)
    NA_real_
  else
    stats::t.test(x[valid], y[valid])$p.value
}

#' @rdname cmp_funs
#' @export
p_wilcoxon <- function(x, y, min_nb=5, ...){
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid)<min_nb)
    NA_real_
  else
    stats::wilcox.test(x[valid], y[valid])$p.value
}

# cpp ----

#' @rdname cmp_funs
#' @export
dist_euclidean_cppr <- function(x, ...) {
  dist_euclidean_cpp(x)
}

#' @rdname cmp_funs
#' @export
dist_manhattan_cppr <- function(x, ...) {
  dist_manhattan_cpp(x)
}

#' @rdname cmp_funs
#' @export
dist_chebyshev_cppr <- function(x, ...) {
  dist_chebyshev_cpp(x)
}

#' @rdname cmp_funs
#' @export
diff_rmse_cppr <- function(x, ...) {
  diff_rmse_cpp(x)
}


#' @rdname cmp_funs
#' @export
dist_euclidean_cppr <- function(x, ...) {
  dist_euclidean_cpp(x)
}

#' @rdname cmp_funs
#' @export
dist_euclidean_cppr <- function(x, ...) {
  dist_euclidean_cpp(x)
}


