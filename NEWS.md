# konstats 0.2.0

* konstats is an open course in statistics for linguists, which is also
  taught at the University of Konstanz.
* The packages of both courses are in Suggests, so installing konstats no
  longer installs them. `install_course()` installs the packages of a course
  and now defaults to `"statistics"`; `install.packages("konstats",
  dependencies = TRUE)` installs the packages of both courses.
* `check_setup()` suggests `install.packages("simling")` when simling is too
  old for a course.
* `cv_speakers()` uses `rlang::check_installed()`, which offers to install
  ranger when it is missing.
* Examples and tests run without the suggested packages.
* `partial_dependence()` stops with an error for values that are not levels
  of a factor, for data without rows and for empty `values`. It used to
  return wrong or `NaN` predictions.
* `resid_acf()` stops with an error for residuals that are not numeric and
  for groups with missing values.
* `cv_speakers()`, `theme_paper()`, `get_tutorial()` and `install_course()`
  check their arguments and say plainly what is wrong.
* `check_setup()` returns a tibble without names on its columns.
* The exercise sheets are licensed under CC BY 4.0, as stated in
  `inst/COPYRIGHTS`.
* The help pages cite Winter (2019) and Friedman (2001) with their DOIs.
* The Advanced Statistics exercise sheets are Quarto documents (`.qmd`), like
  the slides of the course. `tutorials()` and `get_tutorial()` handle both
  `.qmd` and `.Rmd` sheets; the Statistics sheets are still R Markdown.

# konstats 0.1.0

* konstats can be installed from R-universe (<https://mcanzi.r-universe.dev>).
* First version.
* Installing konstats installs the packages of the Statistics course;
  `install_course("advanced")` installs the extra packages of Advanced
  Statistics, and `course_packages()` lists them all.
* `check_setup()` checks the version of R, the packages of a course and that
  simling has the data sets its slides use.
* `lectures()` lists the lectures of both courses with the chapters of Winter
  (2019) they follow, the data sets they use and their slides; `slides()`
  opens the slides of a lecture.
* `tutorials()` lists the exercise sheets and `get_tutorial()` copies them into
  a project folder, one at a time or all at once with `get_tutorial("all", dir)`.
  Sheets for Statistics tutorials 1 to 12 (tutorial 1 is guided, with all
  the code), and for the tutorials of the
  practical lectures of Advanced Statistics (4, 6, 9 and 11).
* An R Markdown template for the weekly assignments.
* The helpers of the Advanced Statistics slides: `resid_acf()` (residual
  autocorrelation within trajectories), `partial_dependence()` (called
  `partial()` in the slides), `cv_speakers()` (cross-validation of a random
  forest by speaker, with the folds of the slides) and `theme_paper()`.
* Hex logo: a Bodensee forget-me-not, in the blue of the University of
  Konstanz and the forest colours of mcanzi.de.
