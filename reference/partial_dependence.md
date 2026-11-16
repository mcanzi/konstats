# Partial dependence of a model on one predictor

Sets one predictor to the same value in every row of the data, predicts,
averages the predictions, and repeats for each value (Friedman, 2001).
Plotted against the values, the result shows how the predictions change
with the predictor, averaged over the other predictors. Used in Advanced
Statistics for random forests from ranger, but it works with any model
that has a [`predict()`](https://rdrr.io/r/stats/predict.html) method.

## Usage

``` r
partial_dependence(model, data, var, values, class = NULL, ...)
```

## Arguments

- model:

  A fitted model. For a classification forest from ranger, fit it with
  `probability = TRUE`.

- data:

  The data to predict for, usually the data the model was fitted to.

- var:

  Name of the predictor, as a string.

- values:

  Values of the predictor to set, such as `seq(18, 80, by = 2)`. For a
  factor, levels of the factor.

- class:

  For models that predict a probability for each class: the class whose
  probability to average, such as `"deleted"`.

- ...:

  Passed on to [`predict()`](https://rdrr.io/r/stats/predict.html). For
  a logistic regression from
  [`glm()`](https://rdrr.io/r/stats/glm.html), use `type = "response"`
  to average probabilities instead of log-odds.

## Value

A tibble with one row per value and the columns `value` and
`prediction`, the mean prediction (or probability of `class`).

## References

Friedman, J. H. (2001). Greedy function approximation: A gradient
boosting machine. *Annals of Statistics, 29*(5), 1189–1232.

## Examples

``` r
library(simling)
m <- lm(rt ~ log_freq * length, data = megastudy)
partial_dependence(m, megastudy, "length", 3:12)
#> # A tibble: 10 × 2
#>    value prediction
#>    <int>      <dbl>
#>  1     3       724.
#>  2     4       736.
#>  3     5       749.
#>  4     6       762.
#>  5     7       775.
#>  6     8       787.
#>  7     9       800.
#>  8    10       813.
#>  9    11       826.
#> 10    12       838.

if (requireNamespace("ranger", quietly = TRUE)) {
  rf <- ranger::ranger(deleted ~ following + morph + rate + age, data = td_deletion,
                       num.trees = 200, probability = TRUE, seed = 1)
  partial_dependence(rf, td_deletion, "age", seq(20, 80, by = 10), class = "deleted")
}
#> # A tibble: 7 × 2
#>   value prediction
#>   <dbl>      <dbl>
#> 1    20      0.671
#> 2    30      0.644
#> 3    40      0.680
#> 4    50      0.600
#> 5    60      0.514
#> 6    70      0.497
#> 7    80      0.410

# a logistic regression: average the probabilities, not the log-odds
m <- glm(deleted ~ age + rate, data = td_deletion, family = binomial)
partial_dependence(m, td_deletion, "age", c(20, 50, 80), type = "response")
#> # A tibble: 3 × 2
#>   value prediction
#>   <dbl>      <dbl>
#> 1    20      0.749
#> 2    50      0.579
#> 3    80      0.389
```
