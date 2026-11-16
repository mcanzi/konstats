# Open the slides of a lecture

Opens the slides of a lecture in your web browser.

## Usage

``` r
slides(lecture, course = "statistics", open = interactive())
```

## Arguments

- lecture:

  Number of the lecture, or part of its topic, such as `"mixed"` or
  `"random forests"`. A topic must match one lecture only.

- course:

  Which course: `"statistics"` or `"advanced"`.

- open:

  If `TRUE`, the default in an interactive session, open the slides in
  the browser.

## Value

The address of the slides, invisibly.

## Examples

``` r
slides(4, open = FALSE)
slides("random forests in practice", course = "advanced", open = FALSE)
```
