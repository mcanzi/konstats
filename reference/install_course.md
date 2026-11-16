# Install the packages of a course

Installs the packages a course uses that are not installed yet, from
CRAN. The packages of the Statistics course come with konstats, so
`install_course("advanced")` is the one you need: run it once before the
first session of Advanced Statistics.

## Usage

``` r
install_course(course = "advanced", update = FALSE)
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
if (FALSE) { # \dontrun{
install_course("advanced")
} # }
```
