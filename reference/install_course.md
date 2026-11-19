# Install the packages of a course

Installs the packages a course uses that are not installed yet, with
[`utils::install.packages()`](https://rdrr.io/r/utils/install.packages.html)
from R-universe (<https://mcanzi.r-universe.dev>, where simling is) and
the repositories set in `getOption("repos")`. Run it once before the
first session of a course, and
[`check_setup()`](https://mcanzi.de/konstats/reference/check_setup.md)
afterwards. Installing konstats with
`install.packages("konstats", dependencies = TRUE)` installs the
packages of both courses at once.

## Usage

``` r
install_course(course = "statistics", update = FALSE)
```

## Arguments

- course:

  Which course: `"statistics"` or `"advanced"`.

- update:

  If `TRUE`, also reinstall the packages that are already installed, to
  get their latest versions.

## Value

The names of the packages it installed, invisibly.

## Examples

``` r
if (FALSE) { # interactive()
install_course("statistics")
install_course("advanced")
}
```
