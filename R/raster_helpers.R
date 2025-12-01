# classes ----
#' A collection of raster helpers to ease work with landscapes
#'
#' Besides those, you could also need
#' [terra::as.factor] or [terra::set.cats] or [terra::classify]
#' to make landscape explicitely qualitative.
#'
#' @param x [terra::SpatRaster]
#' @param NA_value which value, typically an integer (either 0 or 255)
#' should be considered as an NA instead
#'
#' @return various classes, depending on the method
#'
#' @examples
#' library(terra)
#'
#' # let's continue with other raster_helpers
#'
#' # import an example file
#' landscape_quali <- simulate_voronoi(2329)
#' landscape_quant <- simulate_continuous(2329)
#'
#' # minimalist and non absolute deduction based on the number of classes
#' # if <20, likely categorical though
#' raster_likely_categorical(landscape_quali)
#' raster_likely_categorical(landscape_quant)
#'
#' # plot
#' landscape_quali %>% p()
#' landscape_quant %>% p()
#'
#' # show the number of classes (categorical)
#' landscape_quali %>% raster_classes()
#'
#' # count the number of classes (categorical)
#' landscape_quali %>% raster_nclasses()
#'
#' # show raster range (continuous)
#' landscape_quant %>% raster_range()
#'
#' # a packed summary
#' raster_summary(landscape_quant)
#' raster_summary(landscape_quali)
#'
#' # to decrease size
#' # this is a good way to explore fast the big trends,
#' # then run the full map using MHM/CMP
#'
#'\dontrun{
#' # this tends to crash on my (antique) machine
#' # bilinear is likely better for continuous
#' raster_resample(landscape_quant, width=0.1, method="bilinear")
#'
#' # bilinear is likely better for continuous
#' raster_resample(landscape_quali, width=0.1, method="near")
#'}
#'
#' @name raster_helpers
#' @export
raster_classes <- function(x){
  x %>% terra::values() %>% table() %>% names()
}

#' @rdname raster_helpers
#' @export
raster_nclasses <- function(x){
  x %>% terra::values() %>% table() %>% length()
}

#' @rdname raster_helpers
#' @export
# if the number of unique values is <20,
# then the landscape is likely categorical
raster_likely_categorical <- function(x){
  length(unique(terra::values(x))) < 20
}

# #' @rdname raster_helpers
# #' @param df a `data.frame` with `value` (to match) and `label` columns (to name them)
# #' @export
# raster_declare_classes <- function(x, df=NULL){
#
#
#   terra::values(x) <- droplevels(factor(as.character(terra::values(x))))
#
#   # if df is passed
#   if (is.data.frame(df)){
#     if (raster_nclasses(x) != nrow(df))
#       stop("data.frame must match the number of classes")
#     terra::levels(x) <- df
#   }
#   # return this beauty
#   x
# }

# continuous -----
#' @rdname raster_helpers
#' @export
raster_range <- function(x){
  x %>% terra::values() %>% na.omit() %>% range()
}

# pixel number ------
#' @rdname raster_helpers
#' @export
raster_ntot <- function(x){
  prod(dim(x)[1:2])
}

# NA -----
#' @rdname raster_helpers
#' @export
raster_nNA <- function(x){
  sum(is.na(terra::values(x)))
}

#' @rdname raster_helpers
#' @export
raster_anyNA <- function(x){
  any(is.na(terra::values(x)))
}

#' @rdname raster_helpers
#' @export
raster_declareNA <- function(x, NA_value){
  x[x==NA_value] <- NA
  x
}

# chit chat ----

#' @rdname raster_helpers
#' @export
raster_summary <- function(x){
  # categorical flag
  categ <- raster_likely_categorical(x)
  # prepare categ/cont summary
  if (categ){
    msg <- paste0(" with following (", raster_nclasses(x), ") classes: ",
                  paste0(raster_classes(x), collapse = ", ")
    )
  } else {
    msg <- paste0(" with values ranging in: [",
                  paste0(raster_range(x), collapse=", "),
                  "]")
  }
  # prepare NA summary
  nNA <- raster_nNA(x)
  ntot <- raster_ntot(x)
  pcNA <- paste0(signif(100*nNA/ntot, 3), "%")

  # finally spit the full message
  na_msg <- paste0(nNA, " NA (", pcNA, ") among ",  ntot, " values")
    cat(">>> [", ncol(x), "x", nrow(x), "] raster (likely ",
        ifelse(raster_likely_categorical(x), "categorical)", "continous)"),
        "\n>>>", msg,
        "\n>>> ", na_msg,
        sep="")
}

# resample ----
#' @rdname raster_helpers
#' @param width numeric either an integer > 1 (new width) or a proportion to downsize width
#' @param height numeric either an integer > 1 (new height) or a proportion to downsize height
#' @param method default to `near`, passed to [terra::resample]
#' @export
raster_resample <- function(x, width, height, method="near"){
  # sanity checks
  if (missing(width) & missing(height))
    stop("at least one of width/height must be provided")
  if (!missing(width) & !missing(height))
    stop("only one of width/height must be provided")
  # deduce the scaling factor
  if (!missing(width)){ # if width is provided
    k <- ifelse(width>=1, width/ncol(x), width)
  } else { # otherwise this must be that height is provided
    k <- ifelse(height>=1, height/ncol(x), height)
  }
  # calculate new raster nrows and ncols
  new_nr <- round(nrow(x)*k)
  new_nc <- round(ncol(x)*k)
  # create the raster
  r <- terra::rast(nrows=new_nr, ncols=new_nc,
                   xmin=terra::xmin(x), xmax=terra::xmax(x),
                   ymin=terra::ymin(x), ymax=terra::ymax(x))
  terra::crs(r) <- "LOCAL_CS[\"arbitrary\"]"
  # finally use its geometry to resample
  terra::resample(x, r, method=method)
}

# rescale -------
#' @rdname raster_helpers
#' @param new_min new min value after rescaling (default to 0)
#' @param new_max new max value after rescaling (default to 255)
#' @export
raster_rescale <- function(x, new_min = 0, new_max = 255){
  # Get current min and max for each layer
  minmax <- terra::minmax(x)
  old_min <- terra::minmax[1, ]
  old_max <- terra::minmax[2, ]

  # Rescale using linear transformation
  # new_val = (old_val - old_min) / (old_max - old_min) * (new_max - new_min) + new_min
  rescaled <- terra::app(x, function(v) {
    for(i in seq_len(ncol(v))){
      col <- v[, i]
      v[, i] <- (col - old_min[i]) / (old_max[i] - old_min[i]) *
        (new_max - new_min) + new_min
    }
    v
  })

  return(rescaled)
}


