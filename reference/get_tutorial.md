# Copy exercise sheets into your project

Copies the exercise sheet of a tutorial into a folder, where you can
open it and write your answers in the empty chunks. If the sheet has a
weekly assignment, it comes at the end, and you hand in the .Rmd file.

## Usage

``` r
get_tutorial(
  number,
  dir,
  course = "statistics",
  overwrite = FALSE,
  open = interactive()
)
```

## Arguments

- number:

  Number of the tutorial, the same as its lecture, such as `4`. Several
  numbers, such as `2:4`, or `"all"` copy several sheets at once. See
  [`tutorials()`](https://mcanzi.de/konstats/reference/tutorials.md) for
  the sheets available.

- dir:

  Folder to copy the sheets into, such as `"."` for the current folder
  of your R project.

- course:

  Which course: `"statistics"` or `"advanced"`.

- overwrite:

  If `TRUE`, replace sheets of the same name that are already in `dir`,
  answers and all. By default a sheet that is already there is kept:
  with one number the copy stops with an error, with several numbers or
  `"all"` that sheet is skipped and the others are copied.

- open:

  If `TRUE`, the default in an interactive session, open the sheet after
  copying it. Only used when you copy one sheet.

## Value

The paths of the sheets in `dir`, invisibly.

## Examples

``` r
dir <- tempfile()
dir.create(dir)
get_tutorial(4, dir, open = FALSE)
#> ✔ Copied tutorial 4 to /tmp/Rtmp8hvuh0/file19824cb096c9/04_linear_models.Rmd.
get_tutorial("all", dir)
#> ℹ Kept /tmp/Rtmp8hvuh0/file19824cb096c9/04_linear_models.Rmd, which is already there.
#> ✔ Copied tutorial 1 to /tmp/Rtmp8hvuh0/file19824cb096c9/01_getting_started.Rmd.
#> ✔ Copied tutorial 2 to /tmp/Rtmp8hvuh0/file19824cb096c9/02_data_wrangling.Rmd.
#> ✔ Copied tutorial 3 to /tmp/Rtmp8hvuh0/file19824cb096c9/03_descriptive_statistics.Rmd.
#> ✔ Copied tutorial 5 to /tmp/Rtmp8hvuh0/file19824cb096c9/05_transformations.Rmd.
#> ✔ Copied tutorial 6 to /tmp/Rtmp8hvuh0/file19824cb096c9/06_multiple_regression.Rmd.
#> ✔ Copied tutorial 7 to /tmp/Rtmp8hvuh0/file19824cb096c9/07_categorical_predictors.Rmd.
#> ✔ Copied tutorial 8 to /tmp/Rtmp8hvuh0/file19824cb096c9/08_interactions.Rmd.
#> ✔ Copied tutorial 9 to /tmp/Rtmp8hvuh0/file19824cb096c9/09_significance_testing.Rmd.
#> ✔ Copied tutorial 10 to /tmp/Rtmp8hvuh0/file19824cb096c9/10_mixed_models_1.Rmd.
#> ✔ Copied tutorial 11 to /tmp/Rtmp8hvuh0/file19824cb096c9/11_mixed_models_2.Rmd.
#> ✔ Copied tutorial 12 to /tmp/Rtmp8hvuh0/file19824cb096c9/12_logistic_regression.Rmd.
list.files(dir)
#>  [1] "01_getting_started.Rmd"        "02_data_wrangling.Rmd"        
#>  [3] "03_descriptive_statistics.Rmd" "04_linear_models.Rmd"         
#>  [5] "05_transformations.Rmd"        "06_multiple_regression.Rmd"   
#>  [7] "07_categorical_predictors.Rmd" "08_interactions.Rmd"          
#>  [9] "09_significance_testing.Rmd"   "10_mixed_models_1.Rmd"        
#> [11] "11_mixed_models_2.Rmd"         "12_logistic_regression.Rmd"   
```
