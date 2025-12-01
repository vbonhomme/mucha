# Simulate categorical and contious landscapes

These functions simulate simple categorical and continuous landscapes
using Voronoi and random noise function built in `terra`.

## Usage

``` r
simulate_continuous(seed = sample(1:1000, 1), nrow = 200, ncol = 200)

simulate_voronoi(
  seed = sample(1:1000, 1),
  n_cat = 6,
  n_points = 42,
  nrow = 200,
  ncol = 200
)
```

## Arguments

- seed:

  a random seed

- nrow:

  for the simulated landscape

- ncol:

  for the simulated landscape

- n_cat:

  number of patches categories

- n_points:

  number of Voronoi cells

## Examples

``` r
# for the sake of replicability we set seeds

# categorical landscapes
simulate_voronoi(seed=2329) %>% p()
#> simulated voronoi landscape with seed 2329

simulate_voronoi(seed=1517, nrow = 400, ncol=600, n_cat = 4, n_points=820) %>% p()
#> simulated voronoi landscape with seed 1517


# continuous landscapes (dem-like)
simulate_continuous(2329) %>% p()
#> continuous landscape with seed 2329

simulate_continuous(1517, nrow = 400, ncol=600) %>% p()
#> continuous landscape with seed 1517
```
