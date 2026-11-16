# Cross-validate a random forest by speaker

Splits the speakers into `k` folds, fits a random forest from ranger on
all folds but one, and predicts the tokens of the speakers left out, so
that every token is predicted by a forest that never saw its speaker.
This estimates the accuracy for new speakers, which the out-of-bag
accuracy overestimates when tokens of the same speaker are alike.

## Usage

``` r
cv_speakers(
  formula,
  data,
  speaker = "speaker",
  k = 5,
  seed = 2,
  num_trees = 500
)
```

## Arguments

- formula:

  Formula of the forest, such as `l1 ~ vot + vowel_ratio + rate`.

- data:

  A data frame with one row per token.

- speaker:

  Name of the column with the speakers, as a string.

- k:

  Number of folds.

- seed:

  Seed for assigning speakers to folds and for breaking ties between the
  votes of the trees. The forest of fold `i` uses seed `i`. Your own
  random seed is left as it was.

- num_trees:

  Number of trees in each forest.

## Value

A tibble with one row per token and the columns `speaker`, `fold`,
`observed` and `predicted`. The accuracy for new speakers is
`mean(cv$predicted == cv$observed)`.

## Details

When the response is a factor with one value per speaker, such as the
L1, each fold gets the same number of speakers from each group. With the
default seed, the folds and forests are the ones in the slides of
Advanced Statistics, session 6.

## Examples

``` r
if (requireNamespace("ranger", quietly = TRUE)) {
  library(simling)
  cv <- cv_speakers(l1 ~ vot + vowel_ratio + rate, accent, num_trees = 100)
  mean(cv$predicted == cv$observed)
}
#> [1] 0.875
```
