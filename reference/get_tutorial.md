# Copy an exercise sheet into your project

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

  Number of the tutorial, the same as its lecture. See
  [`tutorials()`](https://mcanzi.de/konstats/reference/tutorials.md) for
  the sheets available.

- dir:

  Folder to copy the sheet into, such as `"."` for the current folder of
  your R project.

- course:

  Which course: `"statistics"` or `"advanced"`.

- overwrite:

  If `TRUE`, replace a sheet of the same name that is already in `dir`,
  answers and all. By default the copy stops instead.

- open:

  If `TRUE`, the default in an interactive session, open the sheet after
  copying it.

## Value

The path of the copied sheet, invisibly.

## Examples

``` r
dir <- tempfile()
dir.create(dir)
get_tutorial(4, dir, open = FALSE)
#> ✔ Copied tutorial 4 to /tmp/RtmpyGY86G/file1902691160ac/04_linear_models.Rmd.
list.files(dir)
#> [1] "04_linear_models.Rmd"
```
