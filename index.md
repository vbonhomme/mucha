# mucha

## In brief

The primary goal of CMP package is to port the MHM and CMP softwares by
Gaucherel and colleagues to R. They were originally written in Java and
are no longer maintained.

Both MHM and CMP approaches propose a methodology to capture the local
and scaling variations of landscapes, or anything that can be turned
into rasters.

MHM works on a single raster, while CMP works on a pair of rasters. Both
use moving windows and summary functions to end up with several rasters
(aka the monoscale maps) one per window size, that are eventually
combined, using a custom function, and summarized using a profile plot.

A graphical user interface (in shiny) will probably be released soon, so
that people not proficient in R still could do some MHM and CMP
analyses, just as for original softwares.

## Installation

You can install the last release on CRAN with:

``` r
install.packages("mucha")
```

You can install the development version of mucha from
[GitHub](https://github.com/) with:

``` r
pak::pak("vbonhomme/mucha")
```

## MHM Example

Below, we will use an example raster on which we will apply an MHM
approach with default parameters (see \[MHM\]). Then we will plot all
successive layers and the aggregated version of them using an arithmetic
mean. Finally, we display a vanilla boxplot of the resulting profile
plot.

``` r
library(mucha)
library(terra)
#> terra 1.7.29

# load an example raster and downsize it
# to make things a little faster
l <- import_example("l1.tif") %>% raster_resample(0.2)

# chitchat
raster_summary(l)
#> >>> [160x120] raster (likely categorical)
#> >>> with following (9) classes: 1, 4, 9, 11, 12, 13, 14, 15, 16
#> >>> 13987 NA (72.8%) among 19200 values

# plot it (mplot is more appropriate than vanilla plot)
p(l)
```

![](reference/figures/README-example-1.png)

Now calculate richness at three different scales.

``` r
l_mhm <- MHM(l, window=c(3, 13, 23, 33), fun=richness)
#>  ■■■■■■■■■■■■■■■■ 50% | ETA: 1s ■■■■■■■■■■■■■■■■■■■■■■■ 75% | ETA: 2s 
```

Let’s plot all monoscale maps:

``` r
p(l_mhm)
```

![](reference/figures/README-unnamed-chunk-3-1.png)

Finally, we calculate a composite map and a profile plot:

``` r
app(l_mhm, mean) %>% p()
```

![](reference/figures/README-unnamed-chunk-4-1.png)

``` r
ms_profile(l_mhm)
```

![](reference/figures/README-unnamed-chunk-4-2.png)

CMP works pretty much the same but with two landscapes.

The vignette proposes a much detailed deep into MHM and CMP. You can
have a look to it with:

``` r
vignette("intro", "mucha")
```

An html version of this vignette and of the doc lives
<https://vbonhomme.github.io/mucha/> Feel free to report bugs and
suggest features on the github repo <https://github.com/vbonhomme/mucha>
