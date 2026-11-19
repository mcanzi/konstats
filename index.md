# konstats

[![R-CMD-check](https://github.com/mcanzi/konstats/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mcanzi/konstats/actions/workflows/R-CMD-check.yaml)

konstats has the materials of two open courses in statistics for
linguists, *Statistics* and *Advanced Statistics*, which I also teach at
the Department of Linguistics, University of Konstanz. Statistics
follows Winter (2019), *Statistics for Linguists: An Introduction Using
R*, from data wrangling to mixed models. Its examples and data sets are
new, and the course is not endorsed by Winter or Routledge. Advanced
Statistics covers generalised additive mixed models, random forests,
power analysis, factor analysis and cluster analysis. The slides are
online, the exercise sheets are in the package, and the data sets are in
[simling](https://mcanzi.de/simling/).

## Installation

Install konstats from R-universe:

``` r

install.packages("konstats", repos = c("https://mcanzi.r-universe.dev", "https://cloud.r-project.org"))
```

Then install the packages of the course you take, once:

``` r

konstats::install_course("statistics")
konstats::install_course("advanced")
```

To install konstats and the packages of both courses at once, add
`dependencies = TRUE` to
[`install.packages()`](https://rdrr.io/r/utils/install.packages.html).

Before the first session, check that your computer is ready:

``` r

library(konstats)
check_setup("statistics")
check_setup("advanced")
```

## Usage

### Lectures and slides

[`lectures()`](https://mcanzi.de/konstats/reference/lectures.md) lists
the lectures of both courses, with their textbook chapters and data
sets. [`slides()`](https://mcanzi.de/konstats/reference/slides.md) opens
the slides of one, by number or by part of its topic:

``` r

lectures("statistics")
slides(4)
slides("random forests", course = "advanced")
```

### Exercise sheets

Each tutorial has an exercise sheet with the exercises and an empty code
chunk for each answer. Some sheets end with a weekly assignment, which
you complete at home. In Advanced Statistics, the practical lectures 4,
6, 9 and 11 have a sheet each. The Statistics sheets are R Markdown
files (`.Rmd`), the Advanced Statistics sheets Quarto documents
(`.qmd`); RStudio opens and renders both.
[`get_tutorial()`](https://mcanzi.de/konstats/reference/get_tutorial.md)
copies a sheet into your project folder, or all of them at once:

``` r

tutorials()
get_tutorial(4, ".")
get_tutorial("all", ".")
get_tutorial(4, ".", course = "advanced")
```

You write your answers in the copy, and a sheet that is already in the
folder is never overwritten unless you ask.

### Weekly assignments

In RStudio, *File \> New File \> R Markdown \> From Template \> Weekly
assignment (konstats)* starts the file you hand in for a weekly
assignment, with a section per exercise.

### Helpers from the slides

The functions written in the Advanced Statistics slides are in the
package too:

| Function | What it does | Session |
|----|----|----|
| [`resid_acf()`](https://mcanzi.de/konstats/reference/resid_acf.md) | Autocorrelation of model residuals within trajectories | 3, 4 |
| [`partial_dependence()`](https://mcanzi.de/konstats/reference/partial_dependence.md) | Mean prediction of a model as one predictor changes (`partial()` in the slides) | 5, 6 |
| [`cv_speakers()`](https://mcanzi.de/konstats/reference/cv_speakers.md) | Accuracy of a random forest on speakers it has not seen | 6 |
| [`theme_paper()`](https://mcanzi.de/konstats/reference/theme_paper.md) | A plain ggplot2 theme for papers and theses | 11 |

``` r

library(simling)
m <- lm(f2 ~ time, data = price_f2)
resid_acf(residuals(m), price_f2$traj)
```

## The packages of each course

[`course_packages()`](https://mcanzi.de/konstats/reference/course_packages.md)
lists them, with what each is used for in the course:

``` r

course_packages("advanced")
```

## License

Code: MIT © Massimiliano Canzi. The exercise sheets in `inst/sheets` are
course materials, © Massimiliano Canzi, licensed under [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/).
