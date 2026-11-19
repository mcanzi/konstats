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
boosting machine. *Annals of Statistics, 29*(5), 1189-1232.
[doi:10.1214/aos/1013203451](https://doi.org/10.1214/aos/1013203451)

## Examples

``` r
m <- lm(mpg ~ wt + hp, data = mtcars)
partial_dependence(m, mtcars, "wt", c(2, 3, 4))
#> # A tibble: 3 × 2
#>   value prediction
#>   <dbl>      <dbl>
#> 1     2       24.8
#> 2     3       20.9
#> 3     4       17.1

td <- simling::td_deletion
m <- glm(deleted ~ age + rate, data = td, family = binomial)
partial_dependence(m, td, "age", c(20, 50, 80), type = "response")
#> # A tibble: 3 × 2
#>   value prediction
#>   <dbl>      <dbl>
#> 1    20      0.749
#> 2    50      0.579
#> 3    80      0.389
rf <- ranger::ranger(deleted ~ following + morph + rate + age, data = td,
  num.trees = 200, probability = TRUE, seed = 1)
partial_dependence(rf, td, "age", seq(20, 80, by = 10), class = "deleted")
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
```
