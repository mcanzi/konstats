# Autocorrelation of residuals within groups

Computes the autocorrelation of model residuals within each trajectory,
time series or other group, for lags from 0 to `max_lag`. At lag 1 it is
the correlation between each residual and the residual one measurement
earlier in the same group; lag 2 skips one measurement, and so on.
Residuals are never paired across groups. Used in Advanced Statistics to
check GAMMs for autocorrelated residuals;
[`itsadug::acf_resid()`](https://rdrr.io/pkg/itsadug/man/acf_resid.html)
does the same with base R graphics.

## Usage

``` r
resid_acf(res, group, max_lag = 8)
```

## Arguments

- res:

  Residuals of a model, such as `residuals(m)`.

- group:

  The trajectory or series each residual belongs to, such as
  `data$traj`.

- max_lag:

  The largest lag, in measurements.

## Value

A tibble with one row per lag and the columns `lag` and `acf`. The
autocorrelation at lag 0 is always 1. It is `NA` at lags as long as the
groups, where there are too few pairs of residuals left.

## Details

The residuals must be in the order of the data, sorted by time within
each group, and `res` and `group` must have the same length: if the
model dropped rows with missing values, drop them from `group` too.

## Examples

``` r
library(simling)
# a straight line through the PRICE trajectories: the residuals of
# neighbouring measurements are strongly correlated
m <- lm(f2 ~ time, data = price_f2)
resid_acf(residuals(m), price_f2$traj)
#> # A tibble: 9 × 2
#>     lag   acf
#>   <int> <dbl>
#> 1     0 1    
#> 2     1 0.887
#> 3     2 0.647
#> 4     3 0.370
#> 5     4 0.164
#> 6     5 0.108
#> 7     6 0.178
#> 8     7 0.269
#> 9     8 0.307
```
