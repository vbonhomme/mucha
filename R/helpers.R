# kernel -------
#' Kernel helper functions
#'
#' A collection of helpers to generate kernel matrices
#'
#' @param size integer size of the kernel matrix to generate. Must be an odd number so that
#' the central pixel is actually central.
#' @param sigma numeric the sigma parameter for the gaussian kernel
#' @param x a kernel to visualize
#'
#' @return a kernel matrix (or a plot for kernel_plot)
#'
#' @examples
#' kernel_square(3)
#' kernel_circle(7)
#' kg <- kernel_gaussian(9, sigma=3)
#' kg
#' kg %>% kernel_plot()
#' @name kernel
#' @export
kernel_square <- function(size=3){
  if (size %% 2 == 0)
    stop(paste0("kernel size must be an odd number not: ", size))
  matrix(rep(1, size^2), nrow=size)
}

#' @rdname kernel
#' @export
kernel_circle <- function(size=3) {
  if (size %% 2 == 0)
    stop(paste0("kernel size must be an odd number not: ", size))

  radius <- (size-1)/2
  center <- radius + 1
  kernel <- matrix(0, nrow = size, ncol = size)

  for (i in 1:size) {
    for (j in 1:size) {
      # euc dist from the center
      dist <- sqrt((i - center)^2 + (j - center)^2)
      if (dist <= radius) {
        kernel[i, j] <- 1
      }
    }
  }
  return(kernel)
}

#' @rdname kernel
#' @export
kernel_gaussian <- function(size = 3, sigma = 1) {
  if (size %% 2 == 0)
    stop(paste0("kernel size must be an odd number not: ", size))

  center <- floor(size / 2)
  kernel <- outer(
    -center:center,
    -center:center,
    function(x, y) exp(-(x^2 + y^2) / (2 * sigma^2))
  )
  # normalize the kenel
  kernel / sum(kernel)
}

#' @rdname kernel
#' @export
kernel_plot <- function(x) {
  if (!is.matrix(x)) stop("input must be a matrix")

  n <- nrow(x)
  m <- ncol(x)

  # flip for image() so origin is bottom-left
  x_flipped <- x[n:1, ]

  # plot the kernel
  graphics::image(1:m, 1:n, t(x_flipped),
                  col =  grDevices::heat.colors(256),
                  axes = FALSE, xlab="", ylab="", asp=1)

  # qdd the values in cells
  for (i in 1:n) {
    for (j in 1:m) {
      val <- round(x[i, j], digits=3)
      graphics::text(j, n - i + 1, labels = val, col = "black", cex = 0.8)
    }
  }
}
# window -----

#' Window helper functions
#'
#' A collection of helpers to generate window sequences matrices
#'
#' @param x a raster
#' @param steps the number of window sizes to generate
#'
#' @return a sequence on integer to pass to [MHM]/[CMP]
#'
#' @details
#' `window_quick` has a function shape but simply returns `c(3, 13, 23)`.
#' `window_broad` creates a sequence from `3` to `smallest_dim/3`.
#' `window_linearpixels` tries to have a roughly regular sequence of pixel numbers
#' which increase with a power two of kernel size otherwise.
#'
#' @examples
#' kernel_square(3)
#' kernel_circle(7)
#' kg <- kernel_gaussian(9, sigma=3)
#' kg
#' kg %>% kernel_plot()
#' @name window
#' @export
window_quick <- function(){
  c(3, 13, 23)
}

#' @name window
#' @export
window_broad <- function(x, steps=3){
  # deduce smallest dim
  min_dim <- min(ncol(x), nrow(x))
  # largest allowed is 1/3 of the smallest
  largest_window <- min_dim/3
  # make a length steps seq
  # and make it round and odd
  seq(3, largest_window, length.out=steps) %>%
    odd_floor() %>%
    unique()
}

#' @name window
#' @export
window_linearpixels <- function(x, steps=3){
  # to mimic largest allowed 1/3 of
  # the smallest dim from window broad
  # we calculate this
  largest_pixel_n <- ncol(x)*nrow(x)*(1/9)
  # largest window will have ^2 pixels
  # smallest is usually w=3 so 9 pixels
  # and we want a number of pixels linear not ^2
  # so we create the sequence of pixel nb
  # then take the sqrt and odd_floor it
  seq(9, largest_pixel_n, length.out=steps) %>%
    sqrt() %>%
    odd_floor()
}

# misc -----


#' Geometric mean
#'
#' Brings a geometric mean function (`prod(x)^(1/length(x)`)
#'
#' @param x numeric
#'
#' @details Geometric mean is possibly a better alternative than a bare `prod` when calculating
#'  composite maps from monoscale maps.
#'
#' @return numeric
#' @examples
#' x <- c(1, 2, 3, 4, 6)
#' mean(x)  # arithmetic mean
#' gmean(x) # geometric mean
#' @export
gmean <- function(x) {
  prod(x)^(1/length(x))
}

#' Standard error
#'
#' Brings a standard error `(var(x)/sqrt(n))` function
#'
#' @param x numeric
#'
#' @details SE is the historical error measurement in C. Gaucherel's papers.
#'
#' @return numeric
#' @examples
#' x <- c(1, 2, 3, 4, 3, 4, 3, 2, 1, 4)
#' sd(x) # standard deviation
#' se(x) # standard error
#' @export
se <- function(x) {
  stats::sd(x)/sqrt(length(x))
}

#' Flooring to the closest odd number
#'
#' To ease the use in `window` size in [MHM]/[CMP]
#'
#' @param x numeric
#'
#' @return an odd integer, the closest from the numeric passed
#'
#' @examples
#' odd_floor(4)
#' odd_floor(99)
#' odd_floor(c(54, 53.99, 54.01))
#' @export
odd_floor <- function(x) {
  # take the floor
  x_floor <- floor(x)
  # if even, minus 1, otherwise we're good to go
  ifelse(x_floor %% 2 == 0,
         x_floor - 1,
         x_floor)
}
