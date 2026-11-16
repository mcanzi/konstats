# Check that your computer is ready for a course

Reports your version of R and checks that every package the course uses
is installed. For Advanced Statistics it also checks that simling is
recent enough to have all the data sets of the course. Run it before the
first session, and again whenever course code fails on your computer.

## Usage

``` r
check_setup(course = "statistics")
```

## Arguments

- course:

  Which course: `"statistics"` or `"advanced"`.

## Value

A tibble with one row per package and the columns `package`, `installed`
(`TRUE` or `FALSE`) and `version`, invisibly. The function is called for
the report it prints.

## Examples

``` r
check_setup("statistics")
#> 
#> ── Setup for Statistics ──
#> 
#> ✔ R 4.6.2
#> ✔ All 10 packages are installed.
```
