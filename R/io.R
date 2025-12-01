# import ------

#' Import text file into raster
#'
#' Imports a text file into a raster.
#'
#' A thin wrapper around [utils::read.table] that creates `SpatRaster` objects.
#' For less exotic file formats, you can use the regular [terra::rast()] methods.
#'
#' @param x character path to file
#' @param header logical (default to `FALSE`) passed to [read.table()]
#' @param sep character (default to `" "`) passed to [read.table()]
#' @param na.strings character (default to `-9999`) passed to [read.table()]
#' @param ... more params to be passed to [read.table()]
#'
#' @return `SpatRaster`
#'
#' @examples
#' # use a system.file to make it work here,
#' # otherwise just point to your file
#' # these two are smaller (resampled 0.5) versions of their tif counterpart
#' # because of data volume limitations
#'
#' system.file("extdata/l1.txt", package = "mucha") %>%
#' import_txt() %>% p()
#'
#' system.file("extdata/l2.txt", package = "mucha") %>%
#' import_txt() %>% p()
#'
#' @name import_txt
#' @export
import_txt <- function(x, header=FALSE, na.strings="NA", sep=" ", ...){
  # read the beast
  x %>%
    utils::read.table(header=header, na.strings=na.strings, sep=sep) %>%
    as.matrix() %>%
    import_raster()
}

#' @rdname import_txt
#' @export
import_txt_grid <- function(x){
  # Read file as text
  lines <- readLines(x)

  # Identify layer separators (lines starting with ###)
  sep_idx <- grep("^###", lines)

  if(length(sep_idx) == 0){
    # Single layer: no headers
    mat <- as.matrix(utils::read.table(x))
    layer_names <- "layer"
    mats <- list(mat)
  } else {
    # Multiple layers: extract names and data
    layer_names <- sub("^### ", "", lines[sep_idx])
    mats <- list()

    for(i in seq_along(sep_idx)){
      # Get start and end row indices for each layer
      start_row <- sep_idx[i] + 1
      end_row <- ifelse(i < length(sep_idx), sep_idx[i+1] - 2, length(lines))

      # Read layer data
      layer_lines <- lines[start_row:end_row]
      layer_lines <- layer_lines[layer_lines != ""]  # remove blank lines

      # Convert to matrix
      con <- textConnection(paste(layer_lines, collapse = "\n"))
      mat <- as.matrix(utils::read.table(con))
      close(con)

      mats[[i]] <- mat
    }
  }

  # Stack all layers into a single array
  stacked <- do.call(c,
                     lapply(mats, function(m) terra::rast(m)))

  # Set layer names
  names(stacked) <- layer_names

  return(stacked)
}


#' Import image files to raster
#'
#' Imports raster files using a thin wrapper around [terra::rast]
#'
#' An arbitrary crs is explicitely declared and warnings
#' about missing extent are supressed but declared anyway.
#'
#' @param x path to the raster in a format accepted by [terra::rast] will work.
#'
#' @return `SpatRaster` ready to use with [MHM]/[CMP]
#'
#' @examples
#' # use a system.file to make it work here,
#' # otherwise just point to your file
#' # these two are smaller (resampled 0.5) versions of their tif counterpart
#' # because of data volume limitations
#'
#' system.file("extdata/l1.tif", package = "mucha") %>%
#' import_raster() %>% p()
#'
#' system.file("extdata/l2.tif", package = "mucha") %>%
#' import_raster() %>% p()
#'
#' @export
import_raster <- function(x){
  # read the image using terra::rast
  # we suppress extent warning defined anyway
   z <- suppressWarnings(terra::rast(x))
   # define an extent
   terra::crs(z) <- "LOCAL_CS[\"arbitrary\"]"
   # return this beauty
   z
}

#' Import example files
#'
#' Imports one of the example files bundled with CMP
#'
#' Thin wrappers around `system.file("extdata", "name_of_file", package="mucha")`.
#' Intended to ease working on example files and make them less verbose in the examples/vignette.
#'
#' @param name of the example file. If empty a list of available examples is returned.
#'
#' @return `SpatRaster` ready to use with [MHM]/[CMP]
#'
#' @examples
#'
#' # when called with no name, returns a list of available examples
#' import_example()
#'
#' # then you can
#' landscape <- import_example("l1.tif")
#' p(landscape)
#' @export
import_example <- function(name){
  # if empty list available ones and cat on the console
  if (missing(name)){
    cat("Available example files to call with import_example('one_of_those_below'):\n")
    cat(list.files(system.file("extdata", package="mucha")), sep="\n")
  } else {
    # if provided, try to import
    system.file(paste0("extdata/", name), package = "mucha") %>%
      import_raster()
  }
}

# export -----

#' Export raster to image format
#'
#' Exports a `raster` or `SpatRaster` to `.tif` or `.txt`
#' to stick to original file formats of legacy MHM/CMP softwares.
#'
#' @param x `raster` or `SpatRaster`
#' @param filename where to write the file
#' @param ... additional arguments to pass to [terra::writeRaster]
#'
#' @return writes a file
#'
#' @examples
#' # we don't run the export here to not mess CRAN/github
#' # if you do, this will write a file on your machine
#' \dontrun{
#' landscape <- import_example("l1.tif")
#' landscape %>% export_raster("landscape.tif")
#' }
#' @export
export_raster <- function(x, filename, ...){
  terra::writeRaster(x, filename=filename, ...)
}

#' Export raster to txt format
#'
#' Exports a `raster` or `SpatRaster` to text format such as `.txt`
#' to stick to original file formats of legacy MHM/CMP softwares.
#'
#' @param x `raster` or `SpatRaster`
#' @param filename where to write the file
#' @param signif how many significant numbers to retain (default to `NULL`, no rounding)
#' @param ... additional arguments to pass to [utils::write.table]
#'
#' @return writes a file
#'
#' @examples
#' # we don't run the export here to not mess CRAN/github
#' # if you do, this will write a file on your machine
#' \dontrun{
#' landscape <- import_example("l1.tif")
#' landscape %>% export_txt("landscape.txt")
#' }
#'
#' @name export_txt
#' @export
export_txt <- function(x, filename, ...){
  x %>%
    terra::as.matrix(wide=TRUE) %>%
    write.table(file = filename,
                row.names = FALSE, col.names=FALSE,
                sep= " ", ...)
}

#' @rdname export_txt
#' @export
export_txt_grid <- function(x, filename, signif = NULL, ...){
  # Get number of layers
  nlayers <- terra::nlyr(x)

  # Open file connection
  con <- file(filename, "w")

  for(i in 1:nlayers){
    layer <- x[[i]]
    layer_name <- names(x)[i]

    # Write layer name separator (only for multiple layers)
    if(nlayers > 1){
      if(i > 1) writeLines("", con)  # blank line before layer
      writeLines(paste("###", layer_name), con)
    }

    # Convert layer to matrix and write
    mat <- terra::as.matrix(layer, wide = TRUE)

    # Round to significant digits if specified
    if(!is.null(signif)) mat <- signif(mat, digits = signif)

    write.table(mat,
                file = con,
                row.names = FALSE, col.names = FALSE,
                sep = " ", ...)
  }

  close(con)
}

