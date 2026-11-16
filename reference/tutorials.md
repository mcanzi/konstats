# The weekly exercise sheets

Lists the exercise sheets that come with konstats. Each sheet is an R
Markdown file with the exercises of one tutorial and an empty code chunk
for each answer. Some sheets end with a weekly assignment, which you
complete at home. Copy one into your project folder with
[`get_tutorial()`](https://mcanzi.de/konstats/reference/get_tutorial.md),
or all of them with `get_tutorial("all", dir)`.

## Usage

``` r
tutorials(course = NULL)
```

## Arguments

- course:

  Which course: `"statistics"` or `"advanced"`. `NULL`, the default,
  lists both.

## Value

A tibble with one row per sheet and the columns `course`, `number` (the
number of the lecture it belongs to), `topic` and `file`.

## Examples

``` r
tutorials()
#> # A tibble: 11 × 4
#>    course     number topic                     file                         
#>    <chr>       <int> <chr>                     <chr>                        
#>  1 statistics      2 Data wrangling            02_data_wrangling.Rmd        
#>  2 statistics      3 Descriptive statistics    03_descriptive_statistics.Rmd
#>  3 statistics      4 Linear models             04_linear_models.Rmd         
#>  4 statistics      5 Transformations           05_transformations.Rmd       
#>  5 statistics      6 Multiple regression       06_multiple_regression.Rmd   
#>  6 statistics      7 Categorical predictors    07_categorical_predictors.Rmd
#>  7 statistics      8 Interactions              08_interactions.Rmd          
#>  8 statistics      9 Significance testing      09_significance_testing.Rmd  
#>  9 statistics     10 Mixed models 1            10_mixed_models_1.Rmd        
#> 10 statistics     11 Mixed models 2            11_mixed_models_2.Rmd        
#> 11 statistics     12 Mixed logistic regression 12_logistic_regression.Rmd   
```
