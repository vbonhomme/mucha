
#' Simulate categorical and contious landscapes
#'
#' These functions simulate simple categorical and continuous landscapes
#' using Voronoi and random noise function built in `terra`.
#'
#' @param seed a random seed
#' @param nrow for the simulated landscape
#' @param ncol for the simulated landscape
#' @param n_cat number of patches categories
#' @param n_points number of Voronoi cells
#'
#' @examples
#' # for the sake of replicability we set seeds
#'
#' # categorical landscapes
#' simulate_voronoi(seed=2329) %>% p()
#' simulate_voronoi(seed=1517, nrow = 400, ncol=600, n_cat = 4, n_points=820) %>% p()
#'
#' # continuous landscapes (dem-like)
#' simulate_continuous(2329) %>% p()
#' simulate_continuous(1517, nrow = 400, ncol=600) %>% p()

#' @name simulate
#' @export
simulate_continuous <- function(seed=sample(1:1e3, 1),
                                nrow=200, ncol=200){
  # replicability
  set.seed(seed)
  cat("continuous landscape with seed", seed)
  # a raster to host the landscape
  r <- terra::rast(nrows = nrow, ncols = ncol,
            xmin = 0, xmax = ncol, ymin = 0, ymax = nrow)
  # helper to make a smoothed noise layer
  .noise <- function(r, smooth) {
    x <- terra::rast(r)
    terra::values(x) <- stats::rnorm(terra::ncell(r))      # Gaussian noise
    terra::focal(x, w = smooth, fun = "mean")
  }
  # noisify this boring dem-like
  dem <-  .noise(r, 3)  * 1 + .noise(r, 33) * 20
  # smooth
  dem <- dem %>%
    terra::focal(w = 9, fun = "mean") %>%
    terra::focal(w = 9, fun = "mean")
  # return this beauty
  dem
}

#' @rdname simulate
#' @export
simulate_voronoi <- function(seed=sample(1:1e3, 1),
                             n_cat=6, n_points=42,
                             nrow=200, ncol=200){
  # replicability
  set.seed(seed)
  cat("simulated voronoi landscape with seed", seed)
  # a raster to host the landscape
  r <- terra::rast(nrows = nrow, ncols = ncol,
            xmin = 0, xmax = ncol, ymin = 0, ymax = nrow)
  # voronoi generation and vect it before polygonization
  pts <- cbind(stats::runif(n_points, 0, ncol), stats::runif(n_points, 0, nrow))
  v <- terra::vect(pts, type="points")
  vor <- terra::voronoi(v, terra::ext(r))
  # attribute categories to polygons
  vor$cat <- sample(1:n_cat, size = n_points, replace = TRUE)
  # rasterize the vect landscape
  landscape <- terra::rasterize(vor, r, field = "cat")
  # return this beauty
  landscape
}

