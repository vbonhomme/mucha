# Monoscale plot after an MHM/CMP

For what we have to represent, this is a better plot for `SpatRaster`
than base
[terra](https://rspatial.github.io/terra/reference/terra-package.html)'s
plot. The main benefit being sharing the legend across monoscale maps.

## Usage

``` r
p(x, palette = "viridis", asp = 1, ncol = NULL, title, ...)
```

## Arguments

- x:

  a `SpatRaster` typically obtained after
  [MHM](https://vbonhomme.github.io/mucha/reference/MHM.md)/[CMP](https://vbonhomme.github.io/mucha/reference/CMP.md)

- palette:

  one of grDevices::hcl.colors palette description (default to
  `viridis`)

- asp:

  target aspect for the layout (default to 1 that is a square)

- ncol:

  integer number of columns for the layout, if provided `asp` is ignored

- title:

  for the plot, if missing use `names(x)`

- ...:

  additional parameters to single `plot` call

## Examples

``` r
# first calculate a small and simple MHM
l <- import_example("l1.tif") %>%
raster_resample(0.1) %>%
MHM(window=c(3, 13, 23, 33), fun=richness)

# then let the fun begins
p(l) # compare with plot(l)

p(l, palette = "RdYlBu", ncol=1)
```
