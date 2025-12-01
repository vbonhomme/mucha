# Multiscale Heterogenity Map

Description

## Usage

``` r
MHM(
  x,
  window = window_quick(),
  kernel = kernel_circle,
  fun = mean,
  na.policy = "omit",
  fillvalue = NA,
  expand = FALSE,
  na.rm = TRUE,
  ...
)
```

## Arguments

- x:

  SpatRaster

- window:

  numeric sequence of window sizes (default to `c(3, 13, 23)` via
  [window_quick](https://vbonhomme.github.io/mucha/reference/window.md)).
  Passed to `kernel` function

- kernel:

  function among
  [kernel](https://vbonhomme.github.io/mucha/reference/kernel.md)s
  (default to `kernel_circle`)

- fun:

  function that takes multiple numbers, and returns a numeric vector
  (one or multiple numbers). For example mean, modal, min or max

- na.policy:

  character. Can be used to determine the cells of `x` for which focal
  values should be computed. Must be one of "all" (compute for all
  cells), "only" (only for cells that are `NA`) or "omit" (skip cells
  that are `NA`). Note that the value of this argument does not affect
  which cells around each focal cell are included in the computations
  (use `na.rm=TRUE` to ignore cells that are `NA` for that)

- fillvalue:

  numeric. The value of the cells in the virtual rows and columns
  outside of the raster

- expand:

  logical. If `TRUE` The value of the cells in the virtual rows and
  columns outside of the raster are set to be the same as the value on
  the border. Only available for "build-in" `fun`s such as mean, sum,
  min and max

- na.rm:

  logical passed to `fun`. Whether to remove NA in the calculation for
  each focal cell. Not the NA in the global SpatRaster. See
  [terra::focal](https://rspatial.github.io/terra/reference/focal.html)

- ...:

  additional arguments passed to `fun` such as `na.rm`

## Value

`SpatRaster`

## References

Gaucherel, C. (2007) Multiscale heterogeneity map and associated scaling
profile for landscape analysis, *Landscape and Urban Planning* 82(3)
95-102. doi: 10.1016/j.landurbplan.2007.01.022

## Examples

``` r
# load terra
library(terra)

# import an example file
# and turn it into a SpatRaster
landscape <- import_example("l1.tif")

# plot it
plot(landscape)


# make it smaller for example purpose:
l0 <- landscape %>% raster_resample(0.1)

# plot the little landscape
p(l0)


# calculate MHM on it
l0_mhm <- MHM(l0,
              window=seq(2, 13, by=2)+1,
              fun=richness)

# display all intermediate maps
p(l0_mhm)


# the profile plot
ms_profile(l0_mhm)


# and a synthetic map
app(l0_mhm,  median) %>% p()

app(l0_mhm,  sd) %>% p()


# change the color palette and print side by side
l0_sd <- app(l0_mhm,  sd)
c(l0, l0_sd) %>% p()

```
