#' Comparison Map Profile
#'
#' Description
#'
#' @param x,y rasters as [terra::SpatRaster()]
#' @param window numeric sequence of window sizes (default to `c(3, 13, 23)` via [window_quick]). Passed to `kernel` function
#' @param kernel function among [kernel]s (default to `kernel_circle`)
#' @param fun function that takes multiple numbers and return a single value such
#' as `mean` (default), `median`, `min`, `max`, terra::modal, [richness], [simpson],
#' [shannon], [shannon_evenness] or even custom functions (see vignette)
#' @param ... additional parameters to pass to [terra::focalPairs]
#'
#' @inheritParams terra::focal
#' @return `SpatRaster`
#'
#' @references
#' Gaucherel, C., Alleaume, S. and Hély, C. (2008) The Comparison Map Profile method:
#' a strategy for multiscale comparison of quantitative and qualitative images.
#'  _IEEE Transactions on Geoscience and Remote Sensing_ 46 (9): 2708-2719
#'  doi: 10.1109/TGRS.2008.919379
#' @examples
#' library(terra)
#'
#' # import the first example file
#' l1 <- import_example("l1.tif")
#'
#' # and the second
#' l2 <- import_example("l2.tif")
#'
#' # we can plot them side by side
#' c(l1, l2) %>% p()
#'
#' # make them smaller by a factor 10 for example purpose
#' ls1 <- raster_resample(l1, 0.1)
#' ls2 <- raster_resample(l2, 0.1)
#'
#' ls_cmp <- CMP(ls1, ls2,
#'               window=seq(3, 13, by=2),
#'               fun=cor_pearson)
#'
#' # monoscale maps with customized title/palette
#' p(ls_cmp,
#'   title=paste0("window size ", names(ls_cmp)),
#'   palette="SunsetDark")
#'
#' # correlation is prone to NA when window is small enough
#' # to homogeneous focal values, ie with sd=0 and cor not defined.
#' # this gives us the opportunity to see how to select layers
#' p(ls_cmp[[1]])
#' p(ls_cmp[[-1]])
#'
#'
#' # profile plot
#' ms_profile(ls_cmp, title="a nice title here")
#'
#' app(ls_cmp, mean) %>% p()
#'
#' @export
CMP <- function(x, y,
                window=window_quick(),
                kernel=kernel_circle,
                fun=mean,
                fillvalue=NA,
                ...){
  # concatenate the two rasters
  z <- c(x, y)

  # # calculate
  res <- purrr::map(window,
                    # terra prefers the full version than ~.x
                    function(w) {
                      terra::focalPairs(z,
                                        w = kernel(w),
                                        fun = fun,
                                        fillvalue=fillvalue,
                                        na.rm=TRUE,
                                        ...)
                    }, .progress=TRUE
  )
  # combine into a multilayer SpatRaster
  res <- purrr::reduce(res, c)
  # name layers with window sizes
  names(res) <- paste0("w=", as.character(window))

  # prepare a mask with non NA values from both landscapes
  valid_mask <- !is.na(x) & !is.na(y)
  # use it on mask and return this beauty
  terra::mask(res, valid_mask, maskvalues=0)

}
