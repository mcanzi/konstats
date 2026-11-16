# The packages each course uses

Lists the packages used in the slides and tutorials of each course. The
packages of the Statistics course are installed together with konstats;
the extra packages of Advanced Statistics are installed with
[`install_course()`](https://mcanzi.de/konstats/reference/install_course.md).

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
#> # A tibble: 28 × 3
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
#> # ℹ 18 more rows
course_packages("advanced")
#> # A tibble: 18 × 3
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
#> 15 advanced patchwork   Combining figures                  
#> 16 advanced ggeffects   Model predictions for figures      
#> 17 advanced ggrepel     Labels that do not overlap         
#> 18 advanced ggridges    Ridgeline plots                    
```
