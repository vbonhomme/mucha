# Package index

## Multiscale operations

- [`MHM()`](https://vbonhomme.github.io/mucha/reference/MHM.md) :
  Multiscale Heterogenity Map
- [`CMP()`](https://vbonhomme.github.io/mucha/reference/CMP.md) :
  Comparison Map Profile

## Helper functions

- [`kernel_square()`](https://vbonhomme.github.io/mucha/reference/kernel.md)
  [`kernel_circle()`](https://vbonhomme.github.io/mucha/reference/kernel.md)
  [`kernel_gaussian()`](https://vbonhomme.github.io/mucha/reference/kernel.md)
  [`kernel_plot()`](https://vbonhomme.github.io/mucha/reference/kernel.md)
  : Kernel helper functions
- [`window_quick()`](https://vbonhomme.github.io/mucha/reference/window.md)
  [`window_broad()`](https://vbonhomme.github.io/mucha/reference/window.md)
  [`window_linearpixels()`](https://vbonhomme.github.io/mucha/reference/window.md)
  : Window helper functions
- [`odd_floor()`](https://vbonhomme.github.io/mucha/reference/odd_floor.md)
  : Flooring to the closest odd number

## MHM statistics for single landscapes

- [`richness()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`simpson()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`shannon()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`shannon_evenness()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`kappa_index()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`contagion()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`contagion_cppr()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`shannon_evenness_cppr()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`kappa_index_cppr()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`simpson_cppr()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  [`shannon_cpp()`](https://vbonhomme.github.io/mucha/reference/mhm_funs.md)
  : Summary metrics on a single raster

## CMP statistics for pairs of landscapes

- [`dist_euclidean()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`dist_manhattan()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`dist_chebyshev()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`dist_bhat()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`cor_pearson()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`diff_rmse()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`diff_mean()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`diff_median()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`diff_var()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`diff_cv()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`p_student()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`p_wilcoxon()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`dist_euclidean_cppr()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`dist_manhattan_cppr()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`dist_chebyshev_cppr()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  [`diff_rmse_cppr()`](https://vbonhomme.github.io/mucha/reference/cmp_funs.md)
  : Summary metrics on a pair of rasters

## Summarize and visualize MHM/CMP Results

- [`p()`](https://vbonhomme.github.io/mucha/reference/p.md) : Monoscale
  plot after an MHM/CMP
- [`ms_profile_df()`](https://vbonhomme.github.io/mucha/reference/ms_profile.md)
  [`ms_profile()`](https://vbonhomme.github.io/mucha/reference/ms_profile.md)
  : Profile method for MHM and CMP

## Import/Export landscapes

- [`import_example()`](https://vbonhomme.github.io/mucha/reference/import_example.md)
  : Import example files
- [`import_raster()`](https://vbonhomme.github.io/mucha/reference/import_raster.md)
  : Import image files to raster
- [`import_txt()`](https://vbonhomme.github.io/mucha/reference/import_txt.md)
  [`import_txt_grid()`](https://vbonhomme.github.io/mucha/reference/import_txt.md)
  : Import text file into raster
- [`export_raster()`](https://vbonhomme.github.io/mucha/reference/export_raster.md)
  : Export raster to image format
- [`export_txt()`](https://vbonhomme.github.io/mucha/reference/export_txt.md)
  [`export_txt_grid()`](https://vbonhomme.github.io/mucha/reference/export_txt.md)
  : Export raster to txt format

## Simulate landscapes

- [`simulate_continuous()`](https://vbonhomme.github.io/mucha/reference/simulate.md)
  [`simulate_voronoi()`](https://vbonhomme.github.io/mucha/reference/simulate.md)
  : Simulate categorical and contious landscapes

## Raster and other helpers

- [`raster_classes()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_nclasses()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_likely_categorical()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_range()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_ntot()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_nNA()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_anyNA()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_declareNA()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_summary()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_resample()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  [`raster_rescale()`](https://vbonhomme.github.io/mucha/reference/raster_helpers.md)
  : A collection of raster helpers to ease work with landscapes
- [`se()`](https://vbonhomme.github.io/mucha/reference/se.md) : Standard
  error
- [`gmean()`](https://vbonhomme.github.io/mucha/reference/gmean.md) :
  Geometric mean
