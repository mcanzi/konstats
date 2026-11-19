# The weekly exercise sheets

Lists the exercise sheets that come with konstats. Each sheet has the
exercises of one tutorial and an empty code chunk for each answer: an R
Markdown file (`.Rmd`) in Statistics, a Quarto document (`.qmd`) in
Advanced Statistics. RStudio opens and renders both. Some sheets end
with a weekly assignment, which you complete at home. Tutorial 1 of
Statistics is a guided tutorial, and its sheet has all the code. Copy
one into your project folder with
[`get_tutorial()`](https://mcanzi.de/konstats/reference/get_tutorial.md),
or all of them with `get_tutorial("all", dir)`. The sheets are licensed
under CC BY 4.0.

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
#> # A tibble: 16 × 4
#>    course     number topic                        file                          
#>    <chr>       <int> <chr>                        <chr>                         
#>  1 statistics      1 Getting started              01_getting_started.Rmd        
#>  2 statistics      2 Data wrangling               02_data_wrangling.Rmd         
#>  3 statistics      3 Descriptive statistics       03_descriptive_statistics.Rmd 
#>  4 statistics      4 Linear models                04_linear_models.Rmd          
#>  5 statistics      5 Transformations              05_transformations.Rmd        
#>  6 statistics      6 Multiple regression          06_multiple_regression.Rmd    
#>  7 statistics      7 Categorical predictors       07_categorical_predictors.Rmd 
#>  8 statistics      8 Interactions                 08_interactions.Rmd           
#>  9 statistics      9 Significance testing         09_significance_testing.Rmd   
#> 10 statistics     10 Mixed models 1               10_mixed_models_1.Rmd         
#> 11 statistics     11 Mixed models 2               11_mixed_models_2.Rmd         
#> 12 statistics     12 Mixed logistic regression    12_logistic_regression.Rmd    
#> 13 advanced        4 GAMMs in practice            04_gamm_practical.qmd         
#> 14 advanced        6 Random forests in practice   06_random_forests_practical.q…
#> 15 advanced        9 Factor analysis in practice  09_factor_analysis_practical.…
#> 16 advanced       11 Cluster analysis in practice 11_cluster_analysis_practical…
```
