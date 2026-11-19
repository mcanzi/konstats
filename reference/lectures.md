# The lectures of the courses

Lists the lectures of Statistics and the sessions of Advanced
Statistics, with the chapters of Winter (2019) they follow, the simling
data sets they use and the address of their slides.

## Usage

``` r
lectures(course = NULL)
```

## Arguments

- course:

  Which course: `"statistics"` or `"advanced"`. `NULL`, the default,
  lists both.

## Value

A tibble with one row per lecture and the columns:

- course:

  `"statistics"` or `"advanced"`.

- number:

  Number of the lecture.

- topic:

  Topic of the lecture.

- winter:

  Chapters of Winter (2019), *Statistics for Linguists: An Introduction
  Using R*, that the lecture follows. `NA` for Advanced Statistics.

- datasets:

  simling data sets used in the slides, separated by commas. `penguins`
  comes from palmerpenguins.

- tutorial:

  `TRUE` if the lecture has an exercise sheet, see
  [`tutorials()`](https://mcanzi.de/konstats/reference/tutorials.md).

- slides:

  Address of the slides. `NA` for sessions still in preparation.

## References

Winter, B. (2019). *Statistics for linguists: An introduction using R*.
Routledge.
[doi:10.4324/9781315165547](https://doi.org/10.4324/9781315165547)

## Examples

``` r
lectures()
#> # A tibble: 25 × 7
#>    course     number topic                  winter datasets      tutorial slides
#>    <chr>       <int> <chr>                  <chr>  <chr>         <lgl>    <chr> 
#>  1 statistics      1 Course introduction    1      NA            TRUE     https…
#>  2 statistics      2 Data wrangling         2      penguins      TRUE     https…
#>  3 statistics      3 Descriptive statistics 3      penguins      TRUE     https…
#>  4 statistics      4 Linear models          4      penguins      TRUE     https…
#>  5 statistics      5 Transformations        5      formants, la… TRUE     https…
#>  6 statistics      6 Multiple regression    6      megastudy     TRUE     https…
#>  7 statistics      7 Categorical predictors 7      formants, ko… TRUE     https…
#>  8 statistics      8 Interactions           8      cantonese_to… TRUE     https…
#>  9 statistics      9 Significance testing   9      accent, styl… TRUE     https…
#> 10 statistics     10 Mixed models 1         14     lexical_deci… TRUE     https…
#> # ℹ 15 more rows
lectures("advanced")
#> # A tibble: 12 × 7
#>    course   number topic                         winter datasets tutorial slides
#>    <chr>     <int> <chr>                         <chr>  <chr>    <lgl>    <chr> 
#>  1 advanced      1 Statistics refresher          NA     lexical… FALSE    https…
#>  2 advanced      2 Generalised additive models   NA     price_f2 FALSE    https…
#>  3 advanced      3 Generalised additive mixed m… NA     price_f2 FALSE    https…
#>  4 advanced      4 GAMMs in practice             NA     pupil_n… TRUE     https…
#>  5 advanced      5 Random forests                NA     td_dele… FALSE    https…
#>  6 advanced      6 Random forests in practice    NA     accent   TRUE     https…
#>  7 advanced      7 Power analysis                NA     naming_… FALSE    https…
#>  8 advanced      8 Factor analysis               NA     languag… FALSE    https…
#>  9 advanced      9 Factor analysis in practice   NA     web_reg… TRUE     https…
#> 10 advanced     10 Cluster analysis              NA     korean_… FALSE    https…
#> 11 advanced     11 Cluster analysis in practice  NA     web_reg… TRUE     https…
#> 12 advanced     12 Figures for publication       NA     lexical… FALSE    https…

lecs <- lectures()
lecs[grepl("megastudy", lecs$datasets), c("course", "number", "topic")]
#> # A tibble: 3 × 3
#>   course     number topic                   
#>   <chr>       <int> <chr>                   
#> 1 statistics      5 Transformations         
#> 2 statistics      6 Multiple regression     
#> 3 statistics     13 Power and model building
```
