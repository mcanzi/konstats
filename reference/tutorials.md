# The weekly exercise sheets

Lists the exercise sheets that come with konstats. Each sheet is an R
Markdown file with the exercises of one tutorial and an empty code chunk
for each answer; the last exercises are the weekly assignment. Copy one
into your project folder with
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
#> # A tibble: 3 × 4
#>   course     number topic                  file                         
#>   <chr>       <int> <chr>                  <chr>                        
#> 1 statistics      2 Data wrangling         02_data_wrangling.Rmd        
#> 2 statistics      3 Descriptive statistics 03_descriptive_statistics.Rmd
#> 3 statistics      4 Linear models          04_linear_models.Rmd         
```
