#' Summary metrics on a single raster
#'
#' Summary functions that return a scalar when passed with a portion of raster.
#' Typically passed to [MHM].
#'
#' @param x a fraction of a `SpatRaster` raster
#' @param ... additional parameters,
#' used to collect [terra::focal] own passing through `...`
#'
#' @return numeric the index of interest
#'
#' @details
#'
#' For now on, some function have a cpp counterpart. The R implementation
#' will likely be removed soon. So far we maintain both for the sake of testing.
#' When a `_cppr` version exists, use it!
#'
#' * `richness` simply returns the total number of unique classes
#'  (only makes sense on categorical landscapes)
#' * `simpson/simpson_cppr` is the Simpson's diversity index
#' * `shannon`/`shannon_cppr` is the Shannon's diversity index
#' * `shannon/shannon_cppr` optimized version in cpp
#' * `shannon_evenness/shannon_evenness_cppr` is the Shannon's evenness index
#' * `kappa_index/kappa_index_cppr` is Kappa index
#' * `student_p` is the p value from a Student's test
#' * `contagion/contagion_cppr` is the contagion index (Riitters, 1996) and
#' also from MHM paper (only makes sense on categorical landscapes)
#'
#' @examples
#' set.seed(2329) # for reproducibility
#' x <- sample(1:3, size=49, replace=TRUE, prob=c(0.1, 0.1, 1))  # unbalanced vector
#' table(x)
#' x %>% richness()
#' x %>% simpson()
#' x %>% simpson_cppr()
#' x %>% shannon()
#' x %>% shannon_cppr()
#' x %>% shannon_evenness()
#' x %>% shannon_evenness_cppr()
#' x %>% contagion()
#' x %>% contagion_cppr()
#' @name mhm_funs
#' @export
richness <- function(x, ...){
  length(unique(na.omit(x)))
}

#' @rdname mhm_funs
#' @export
simpson <- function(x, ...) {
  tab <- table(na.omit(x))
  if (length(tab)==0) return(NA_real_)
  p <- tab / sum(tab)
  return(1 - sum(p^2))
}

#' @rdname mhm_funs
#' @export
shannon <- function(x, ...) {
  tab <- table(na.omit(x))
  p <- tab / sum(tab)
  return(-sum(p * log(p)))
}

#' @rdname mhm_funs
#' @export
shannon_evenness <- function(x, ...){
  x <- na.omit(x)  # Remove NAs
  if (length(x) == 0) return(NA)
  counts <- table(x)
  p <- counts / sum(counts)
  H <- -sum(p * log(p))
  S <- length(p)
  if (S <= 1) return(NA)  # No evenness if only one class
  E <- H / log(S)
  return(E)
}

#' @rdname mhm_funs
#' @export
contagion <- function(x, ...) {

  # Reconstruct the matrix from the vector FIRST (preserving NAs in position)
  # Assuming square window (most common case)
  window_size <- sqrt(length(x))
  mat <- matrix(x, nrow = window_size, ncol = window_size, byrow = TRUE)


  # Now get non-NA values for class calculations
  x_valid <- x[!is.na(x)]

  # Need at least 2 valid pixels to calculate contagion
  if (length(x_valid) < 2) {
    return(NA_real_)
  }

  # Get unique classes (excluding NA)
  classes <- unique(x_valid)
  n_classes <- length(classes)

  # If only one class, contagion is maximum (100)
  if (n_classes == 1) {
    return(100)
  }

  # Calculate proportions of each class (from valid pixels only)
  n_total <- length(x_valid)
  props <- table(x_valid) / n_total

  # Calculate adjacency matrix
  adj_matrix <- matrix(0, nrow = n_classes, ncol = n_classes)
  rownames(adj_matrix) <- colnames(adj_matrix) <- sort(classes)

  n_adjacencies <- 0

  # Count horizontal adjacencies
  for (i in 1:nrow(mat)) {
    for (j in 1:(ncol(mat) - 1)) {
      if (!is.na(mat[i, j]) && !is.na(mat[i, j + 1])) {
        class1 <- as.character(mat[i, j])
        class2 <- as.character(mat[i, j + 1])
        adj_matrix[class1, class2] <- adj_matrix[class1, class2] + 1
        n_adjacencies <- n_adjacencies + 1
      }
    }
  }

  # Count vertical adjacencies
  for (i in 1:(nrow(mat) - 1)) {
    for (j in 1:ncol(mat)) {
      if (!is.na(mat[i, j]) && !is.na(mat[i + 1, j])) {
        class1 <- as.character(mat[i, j])
        class2 <- as.character(mat[i + 1, j])
        adj_matrix[class1, class2] <- adj_matrix[class1, class2] + 1
        n_adjacencies <- n_adjacencies + 1
      }
    }
  }

  # If no adjacencies found, return NA
  if (n_adjacencies == 0) {
    return(NA_real_)
  }

  # Calculate proportion of adjacencies
  p_ij <- adj_matrix / n_adjacencies

  # Calculate contagion index
  # CONTAG = [1 + sum(p_ij * ln(p_ij)) / (2 * ln(n_classes))] * 100

  sum_term <- 0
  for (i in 1:n_classes) {
    for (j in 1:n_classes) {
      if (p_ij[i, j] > 0) {
        sum_term <- sum_term + (p_ij[i, j] * log(p_ij[i, j]))
      }
    }
  }

  contagion <- (1 + sum_term / (2 * log(n_classes))) * 100

  return(contagion)
}

# cpp ------
#' @rdname mhm_funs
#' @export
contagion_cppr <- function(x, ...) {
  contagion_cpp(x)
}

#' @rdname mhm_funs
#' @export
shannon_evenness_cppr <- function(x, ...) {
  shannon_evenness_cpp(x)
}

#' @rdname mhm_funs
#' @export
simpson_cppr <- function(x, ...) {
  simpson_cpp(x)
}

#' @rdname mhm_funs
#' @export
shannon_cppr <- function(x, ...) {
  shannon_cpp(x)
}


