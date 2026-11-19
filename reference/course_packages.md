# The packages each course uses

Lists the packages used in the slides and tutorials of each course.
[`install_course()`](https://mcanzi.de/konstats/reference/install_course.md)
installs them and
[`check_setup()`](https://mcanzi.de/konstats/reference/check_setup.md)
tells you which are missing.

## Usage

``` r
course_packages(course = NULL)
```

## Arguments

- course:

  Which course: `"statistics"` or `"advanced"`. `NULL`, the default,
  lists both.

## Value

A tibble with one row per package and course, and the columns:

- course:

  `"statistics"` or `"advanced"`.

- package:

  Name of the package.

- use:

  What the package is used for in the course.

## Examples

``` r
course_packages()
#> # A tibble: 30 × 3
#>    course     package        use                                    
#>    <chr>      <chr>          <chr>                                  
#>  1 statistics tidyverse      Data wrangling and figures             
#>  2 statistics simling        Simulated linguistic data sets         
#>  3 statistics palmerpenguins The penguins data of the first lectures
#>  4 statistics broom          Model results as tibbles               
#>  5 statistics janitor        Cleaning column names                  
#>  6 statistics effsize        Effect sizes                           
#>  7 statistics lme4           Mixed models                           
#>  8 statistics lmerTest       p-values for mixed models              
#>  9 statistics simr           Power analysis by simulation           
#> 10 statistics swirl          Interactive R lessons                  
#> # ℹ 20 more rows
course_packages("advanced")
#> # A tibble: 20 × 3
#>    course   package     use                                           
#>    <chr>    <chr>       <chr>                                         
#>  1 advanced simling     Simulated linguistic data sets                
#>  2 advanced tidyverse   Data wrangling and figures                    
#>  3 advanced broom       Model results as tibbles                      
#>  4 advanced lme4        Mixed models                                  
#>  5 advanced lmerTest    p-values for mixed models                     
#>  6 advanced mgcv        Generalised additive (mixed) models           
#>  7 advanced tidygam     Predictions from GAMs as tibbles              
#>  8 advanced itsadug     Plots and autocorrelation for GAMMs           
#>  9 advanced rpart       Classification and regression trees           
#> 10 advanced ranger      Random forests                                
#> 11 advanced simr        Power analysis by simulation                  
#> 12 advanced psych       Factor analysis                               
#> 13 advanced GPArotation Rotations for factor analysis                 
#> 14 advanced lavaan      Confirmatory factor analysis                  
#> 15 advanced cluster     Silhouettes and k-medoids for cluster analysis
#> 16 advanced mclust      Gaussian mixtures and the adjusted Rand index 
#> 17 advanced patchwork   Combining figures                             
#> 18 advanced ggeffects   Model predictions for figures                 
#> 19 advanced ggrepel     Labels that do not overlap                    
#> 20 advanced ggridges    Ridgeline plots                               
```
