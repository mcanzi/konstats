# Copy exercise sheets into your project

Copies the exercise sheet of a tutorial into a folder, where you can
open it and write your answers in the empty chunks. The weekly
assignment is at the end of the sheet; you hand in the .Rmd file.

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
#> ✔ Copied tutorial 4 to /tmp/Rtmp87KAE6/file19371f102045/04_linear_models.Rmd.
get_tutorial("all", dir)
#> ℹ Kept /tmp/Rtmp87KAE6/file19371f102045/04_linear_models.Rmd, which is already there.
#> ✔ Copied tutorial 2 to /tmp/Rtmp87KAE6/file19371f102045/02_data_wrangling.Rmd.
#> ✔ Copied tutorial 3 to /tmp/Rtmp87KAE6/file19371f102045/03_descriptive_statistics.Rmd.
list.files(dir)
#> [1] "02_data_wrangling.Rmd"         "03_descriptive_statistics.Rmd"
#> [3] "04_linear_models.Rmd"         
```
