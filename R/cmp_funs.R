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
#' * `cor_pearson` is pearson correlation coefficient. Note than for uniform window(s) this will return 1, not NA. See below.
#' * `cor_pearson_uniform_equals_NA` is same as above but return NA when `sd=0` for one or two windows having uniform values,
#' which is likely to happen for small sample sizes.
#' * `kappa_index/kappa_index_cppr` is Cohen's Kappa
#' * `dist_identical` proportion of identical value, pixel wise
#' * `dist_different` proportion of different value, pixel wise
#' * `dist_diff` (signed) difference, pixel wise
#' * `dist_euclidean/dist_euclidean_cppr` euclidean distance (sqrt of sums of squared diff pixel-wise, divided by the number of valid pixels)
#' * `dist_manhattan/dist_manhattan_cppr` manhattan distance (sum of absolute distances pixel-wise, , divided by the number of valid pixels)
#' * `dist_chebyshev/dist_chebyshev_cppr` Chebyshev's distance (max of absolute distances pixel-wise)
#' * `dist_bhat` Bhattacharyya's distance based on distribution distances calculated using nbins
#' * `diff_rmse/diff_rmse_cppr` root-mean square error pixel-wise
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
#' x <- sample(1:3, size=49, replace=TRUE, prob=c(0.1, 0.1, 1))  # unbalanced vector
#' y <- sample(1:3, size=49, replace=TRUE, prob=c(0.1, 0.1, 1))  # another one
#'
#' # examples runs mostly to test and exemplify
#' # but in CMP they will run on each pair of focal windows
#'
#' # built in functions
#' cor(x, y)
#' cov(x, y)
#'
#' # kappa agreement
#' kappa_index(x, y)
#' kappa_index_cppr(x, y)
#'
#' # distance indices
#' dist_euclidean(x, y)
#' dist_euclidean_cppr(x, y)
#'
#' dist_manhattan(x, y)
#' dist_manhattan_cppr(x, y)
#'
#' dist_chebyshev(x, y)
#' dist_chebyshev_cppr(x, y)
#'
#' dist_bhat(x, y)
#'
#' # difference indices
#' diff_rmse(x, y)
#' diff_rmse_cppr(x, y)
#'
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

#' @rdname cmp_funs
#' @export
dist_identical <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  sum(x[valid] == y[valid])/sum(valid)
}

#' @rdname cmp_funs
#' @export
dist_different <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  sum(x[valid] != y[valid])/sum(valid)
}

# bare difference
#' @rdname cmp_funs
#' @export
dist_diff <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) == 0) return(NA)
  sum(x[valid] - y[valid])/sum(valid)
}

# cor and agreement ------

#' @name cmp_funs
#' @export
cor_pearson <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) < 2) return(NA_real_)

  x <- x[valid]
  y <- y[valid]

  # case when both x and y are uniform
  # AND have diff values
  # if (unif_equals_1){
  if ((stats::sd(x)==0 | stats::sd(y)==0)){
    return(1)
  }
  # }

  # suppress warning "the standard deviation is zero"
  suppressWarnings(
    stats::cor(x, y,
               method="pearson", use = "complete")
  )
}

#' @name cmp_funs
#' @export
cor_pearson_uniform_equals_NA <- function(x, y, ...) {
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid) < 2) return(NA_real_)

  x <- x[valid]
  y <- y[valid]

  # suppress warning "the standard deviation is zero"
  suppressWarnings(
    stats::cor(x, y,
               method="pearson", use = "complete")
  )
}


#' @rdname cmp_funs
#' @export
kappa_index <- function(x, y, ...) {
  # x and y are vectors from two different maps/focal windows
  #w e need to claculate agreement but first we have to reconstruct
  # a confusion matrix (two)

  # we assume square windows
  window_size <- sqrt(length(x))
  if (window_size != as.integer(window_size)) {
    stop("Vector length must be a perfect square for square windows")
  }

  # rebuild the matrices
  mat_x <- matrix(x, nrow = window_size, ncol = window_size, byrow = TRUE)
  mat_y <- matrix(y, nrow = window_size, ncol = window_size, byrow = TRUE)

  # handle na as we do everywehere
  valid_idx <- !is.na(x) & !is.na(y)
  x_valid <- x[valid_idx]
  y_valid <- y[valid_idx]

  # only calc when 2 valid pairs
  if (length(x_valid) < 2) {
    return(NA_real_)
  }

  # unique levels
  classes <- sort(unique(c(x_valid, y_valid)))
  n_classes <- length(classes)

  # single class, kappa=0
  if (n_classes == 1) {
    return(0)
  }

  # we finally rebuild confusion
  # rows = map x, columns = map on y
  confusion_matrix <- matrix(0, nrow = n_classes, ncol = n_classes)
  rownames(confusion_matrix) <- colnames(confusion_matrix) <- as.character(classes)

  # and we fill
  for (i in 1:length(x_valid)) {
    class_x <- as.character(x_valid[i])
    class_y <- as.character(y_valid[i])
    confusion_matrix[class_x, class_y] <- confusion_matrix[class_x, class_y] + 1
  }

  # nb of valid pairs
  n_total <- sum(confusion_matrix)

  # observed agreement (Po)
  # proportion of diagonal elements (where both maps agree)
  Po <- 0
  for (i in 1:n_classes) {
    class_name <- as.character(classes[i])
    Po <- Po + confusion_matrix[class_name, class_name]
  }
  Po <- Po / n_total

  # expected agreement by chance (Pe)
  # for each class: (marginal_x / n) * (marginal_y / n)
  Pe <- 0
  for (i in 1:n_classes) {
    class_name <- as.character(classes[i])
    # Marginal probabilities
    p_x <- sum(confusion_matrix[class_name, ]) / n_total
    p_y <- sum(confusion_matrix[, class_name]) / n_total
    Pe <- Pe + (p_x * p_y)
  }

  # finally cohen kappa
  # kappa = (Po - Pe) / (1 - Pe)
  if (Pe >= 1) {
    # division by zero case
    return(0)
  }

  kappa <- (Po - Pe) / (1 - Pe)

  return(as.numeric(kappa))
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
    suppressWarnings(stats::t.test(x[valid], y[valid])$p.value)
}

#' @rdname cmp_funs
#' @export
p_wilcoxon <- function(x, y, min_nb=5, ...){
  valid <- !is.na(x) & !is.na(y)
  if (sum(valid)<min_nb)
    NA_real_
  else
    suppressWarnings(stats::wilcox.test(x[valid], y[valid])$p.value)
}

# cpp ----

#' @rdname cmp_funs
#' @export
kappa_index_cppr <- function(x,y,  ...) {
  kappa_index_cpp(x, y)
}

#' @rdname cmp_funs
#' @export
dist_euclidean_cppr <- function(x, y, ...) {
  dist_euclidean_cpp(x, y)
}

#' @rdname cmp_funs
#' @export
dist_manhattan_cppr <- function(x,y,  ...) {
  dist_manhattan_cpp(x, y)
}

#' @rdname cmp_funs
#' @export
dist_chebyshev_cppr <- function(x, y, ...) {
  dist_chebyshev_cpp(x, y)
}

#' @rdname cmp_funs
#' @export
diff_rmse_cppr <- function(x, y,...) {
  diff_rmse_cpp(x, y)
}

