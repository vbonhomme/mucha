#' Multiscale Heterogenity Map
#'
#' Description
#'
#' @param window numeric sequence of window sizes (default to `c(3, 13, 23)` via [window_quick]). Passed to `kernel` function
#' @param kernel function among [kernel]s (default to `kernel_circle`)
#' as `mean` (default), `median`, `min`, `max`, terra::modal, [richness], [simpson],
#' [shannon], [shannon_evenness] or even custom functions (see vignette)
#' @param kernel function among [kernel]s (default to `kernel_circle`)
#' @param na.rm logical passed to `fun`. Whether to remove NA in the calculation for each focal cell.
#' Not the NA in the global SpatRaster. See [terra::focal]
#'
#' @inheritParams terra::focal
#'
#' @return `SpatRaster`
#'
#' @references
#' Gaucherel, C. (2007) Multiscale heterogeneity map and associated scaling profile
#'  for landscape analysis, _Landscape and Urban Planning_ 82(3) 95-102.
#'  doi: 10.1016/j.landurbplan.2007.01.022
#'
#' @examples
#' # load terra
#' library(terra)
#'
#' # import an example file
#' # and turn it into a SpatRaster
#' landscape <- import_example("l1.tif")
#'
#' # plot it
#' plot(landscape)
#'
#' # make it smaller for example purpose:
#' l0 <- landscape %>% raster_resample(0.1)
#'
#' # plot the little landscape
#' p(l0)
#'
#' # calculate MHM on it
#' l0_mhm <- MHM(l0,
#'               window=seq(2, 13, by=2)+1,
#'               fun=richness)
#'
#' # display all intermediate maps
#' p(l0_mhm)
#'
#' # the profile plot
#' ms_profile(l0_mhm)
#'
#' # and a synthetic map
#' app(l0_mhm,  median) %>% p()
#' app(l0_mhm,  sd) %>% p()
#'
#' # change the color palette and print side by side
#' l0_sd <- app(l0_mhm,  sd)
#' c(l0, l0_sd) %>% p()
#'
#' @export
MHM <- function(x,
                window=window_quick(),
                kernel=kernel_circle,
                fun=mean,
                na.policy="omit",
                fillvalue=NA,
                expand=FALSE,
                na.rm=TRUE,
                ...){
  # calculate
  res <- purrr::map(window,
                    function(w) terra::focal(x,
                                  w = kernel(w),
                                  fun = fun,
                                  na.policy=na.policy,
                                  fillvalue=fillvalue,
                                  expand=expand,
                                  na.rm=na.rm,
                                  ...), .progress=TRUE
                    )
                    # combine into a multilayer SpatRaster
                    res <- purrr::reduce(res, c)
                    # name layers with window sizes
                    names(res) <- paste0("w=", as.character(window))
                    # return this beauty
                    res
}

# MHM(landscape, w=c(3, 13), na.policy = "only", kernel=kernel_square, fun=sd) -> z
# z %>% plot()
