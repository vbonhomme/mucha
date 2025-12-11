#' Monoscale plot after an MHM/CMP
#'
#' For what we have to represent, this is a better plot for `SpatRaster`
#' than base [terra]'s plot. The main benefit being
#' sharing the legend across monoscale maps.
#'
#' @param x a `SpatRaster` typically obtained after [MHM]/[CMP]
#' @param palette one of [grDevices::hcl.colors] palette description (default to `viridis`)
#' @param asp target aspect for the layout (default to 1 that is a square)
#' @param ncol integer number of columns for the layout, if provided `asp` is ignored
#' @param title for each plot, if missing use `names(x)`
#' @param multi_title for the general plot (eg when more than one layer)
#' @param global_range logical, default to `TRUE`, whether to use a global range for all layers
#' @param ... additional parameters to single `plot` call
#'
#' @examples
#' # first calculate a small and simple MHM
#' l <- import_example("l1.tif") %>%
#' raster_resample(0.1) %>%
#' MHM(window=c(3, 13, 23, 33), fun=shannon)
#'
#' # global range or not
#' p(l) # by default global_range is TRUE
#' p(l, global_range=FALSE) # each mono map has its scale
#' # change palette
#' p(l, palette = "RdYlBu", ncol=1) # change the color palette for one of hcl.pals()
#'
#' # manage title(s)
#' p(l, multi_title="monoscale maps")
#' p(l, title=paste0("window size ", names(l)), multi_title="monoscale maps")
#'
#' # change aspect
#' p(l, ncol=4)
#' p(l, ncol=1)
#' @export
p <- function(x, palette = "Viridis", asp=1, ncol = NULL,
               title, multi_title, global_range=TRUE, ...) {
  # save par restore later
  op <- graphics::par(oma=c(0, 0, 2, 0))

  # calculate colors
  if(is.character(palette) && length(palette)==1) {
    cols <- grDevices::hcl.colors(100, palette)
  } else {
    cols <- palette
  }

  # simple heuristic for layout-ing
  # aim for asp is ncol is not provided
  n_layers <- terra::nlyr(x)

  # handles title
  if (missing(title)){
    main <- names(x)
  } else {
    main <- title
  }

  # to handle single plot case
  if (n_layers==1){
    # first layer will have a legend
    terra::plot(x, legend = TRUE,
                col = cols, main = main,  ...)
  } else {

    if(is.null(ncol)) {
      ncol <- ceiling(sqrt(n_layers * asp))
    }

    # now we have an ncol either through asp or if provided
    nrow <- ceiling(n_layers / ncol)

    # build and pass the layout
    layout_mat <- matrix(1:(nrow * ncol), nrow = nrow, ncol = ncol, byrow = TRUE)
    layout(layout_mat,
           widths = rep(1, ncol),
           heights = rep(1, nrow))

    if (global_range){
      # calculate a global range accross all layers
      global_range <- range(terra::values(x), na.rm = TRUE)

      # if global_range is TRUE, calculate this range and use it
      # for all plots
      for(i in 1:n_layers) {
        terra::plot(x[[i]], range = global_range, legend = TRUE,
                    col = cols, main = main[i],  ...)
      }
      # otherwise, delegate range to terra:plot
    } else {

      for(i in 1:n_layers) {
        terra::plot(x[[i]],  legend = TRUE,
                    col = cols, main = main[i],  ...)
      }

    }

    # reset layout to stay friend with evryone
    graphics::layout(1)

    # if a multi_title is provided, then add it
    if (!missing(multi_title))
      graphics::mtext(multi_title, line=1, outer=TRUE)

  }

  # restore par
  suppressWarnings(graphics::par(op))
}

# old p just in case
# p <- function(x, palette = "Viridis", asp=1, ncol = NULL,
#               title, multi_title, ...) {
#   # save par restore later
#   op <- graphics::par()
#
#   # calculate colors
#   if(is.character(palette) && length(palette)==1) {
#     cols <- grDevices::hcl.colors(100, palette)
#   } else {
#     cols <- palette
#   }
#
#   # simple heuristic for layout-ing
#   # aim for asp is ncol is not provided
#   n_layers <- terra::nlyr(x)
#
#   # handles title
#   if (missing(title)){
#     main <- names(x)
#   } else {
#     main <- title
#   }
#
#   # to handle single plot case
#   if (n_layers==1){
#     # first layer will have a legend
#     terra::plot(x, legend = TRUE,
#                 col = cols, main = main,  ...)
#   } else {
#     # calculate a global range accross all layers
#     global_range <- range(terra::values(x), na.rm = TRUE)
#
#     if(is.null(ncol)) {
#       ncol <- ceiling(sqrt(n_layers * asp))
#     }
#
#     # now we have an ncol either through asp or if provided
#     nrow <- ceiling(n_layers / ncol)
#
#     # build and pass the layout
#     layout_mat <- matrix(1:(nrow * ncol), nrow = nrow, ncol = ncol, byrow = TRUE)
#     layout(layout_mat,
#            widths = rep(1, ncol),
#            heights = rep(1, nrow))
#
#     # first layer will have a legend
#     terra::plot(x[[1]], range = global_range, legend = TRUE,
#                 col = cols, main = main[1],  ...)
#
#     # others nope
#     for(i in 2:n_layers) {
#       terra::plot(x[[i]], range = global_range, legend = FALSE,
#                   col = cols, main = main[i],  ...)
#     }
#
#     # reset layout to stay friend with evryone
#     graphics::layout(1)
#
#     # if a multi_title is provided, then add it
#     if (!missing(multi_title))
#       graphics::mtext(multi_title, outer=FALSE)
#
#   }
#
#   # restore par
#   suppressWarnings(graphics::par(op))
# }

#' Profile method for MHM and CMP
#'
#' Profile the result of [MHM]/[CMP], ie obtain, summarize and visualize
#' results for each window size.
#'
#' @param x SpatRast typically obtained from [MHM]/[CMP]
#' @param summary_fun a function to calculate a
#' summary statistic for each window (default to `mean`)
#' @param error_fun a function to calculate an
#' error statistic for each window (default to standard error)
#' @param title for the plot
#' @param ylab for the y axis
#'
#' @return a plot or a `data.frame`
#'
#' @examples
#' landscape <- import_example("l1.tif") %>%
#'    raster_resample(0.2)
#'
#' # vanilla MHM
#' res <- MHM(landscape, window=c(3, 5, 7, 9, 13, 17, 33))
#'
#' # plot the ms_profile plot directly
#' res %>% ms_profile()
#'
#' # you can tweak summary_fun, error_fun and title
#' res %>% ms_profile(summary_fun=max, error_fun=var, ylab="max +/- var", title="ms")
#'
#' # you can also get the raw data.frame
#' # to make your own (eg ggplot2) graph
#' res %>% ms_profile_df() %>% head()
#'
#' @name ms_profile
#' @export
ms_profile_df <- function(x){
  # extract values to a list
  l <- purrr::map(seq_len(terra::nlyr(x)),
                  ~terra::values(x[[.x]], dataframe=FALSE) %>%
                    as.numeric() %>% stats::na.omit())
  # rename with window size
  names(l) <- names(x) %>% substring(3)
  # bind to single df
  df <- purrr::imap_dfr(l, ~data.frame(window=.y, value=.x))
  df$window <- factor(as.numeric(df$window))
  # return this beauty
  df
}

#' @rdname ms_profile
#' @export
ms_profile <- function(x,
                       summary_fun=mean,
                       error_fun=se,
                       title="multiscale profile",
                       ylab="mean +/- SE"){
  x <- ms_profile_df(x)
  # filter NAs rows
  x <- x[!is.na(x$value), ]
  # splits on window
  xs <- x %>% split(.$window)

  # calculate mean (or other) single points
  single_y <- purrr::map_dbl(xs, function(w) summary_fun(w$value))
  # calculate error
  error_y  <- purrr::map_dbl(xs, function(w) error_fun(w$value))
  # also extracts windows
  xs <- as.numeric(as.character(unique(x$window)))
  # now prepare an empty plot
  plot(NA,
       xlim=range(xs),
       ylim=c(min(single_y-error_y), max(single_y+error_y)),
       xlab="window size (pixels)", ylab=ylab, axes=FALSE,
       main=title)
  # draw segments for error
  segments(x0=xs, y0=single_y-error_y,
           x1=xs, y1=single_y+error_y,
           col="gray70")
  # points statistics
  points(xs, single_y, pch=20)
  # finally add axes and bob's your uncle
  axis(1, at=xs, labels=xs)
  axis(2)
}
