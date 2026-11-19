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
autocorrelation at lag 0 is 1. It is `NA` at lags where fewer than three
pairs of residuals are left, such as lags as long as the groups.

## Details

The residuals must be in the order of the data, sorted by time within
each group, and `res` and `group` must have the same length: if the
model dropped rows with missing values, drop them from `group` too.

## Examples

``` r
res <- c(1, 2, 3, 4, 1, 2, 3, 4)
resid_acf(res, rep(c("a", "b"), each = 4), max_lag = 2)
#> # A tibble: 3 × 2
#>     lag   acf
#>   <int> <dbl>
#> 1     0     1
#> 2     1     1
#> 3     2     1

m <- lm(f2 ~ time, data = simling::price_f2)
resid_acf(residuals(m), simling::price_f2$traj)
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
