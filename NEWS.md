# konstats (development version)

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
  Sheets for Statistics tutorials 2 to 4.
* An R Markdown template for the weekly assignments.
* The helpers of the Advanced Statistics slides: `resid_acf()` (residual
  autocorrelation within trajectories), `partial_dependence()` (called
  `partial()` in the slides), `cv_speakers()` (cross-validation of a random
  forest by speaker, with the folds of the slides) and `theme_paper()`.
* Hex logo: a Bodensee forget-me-not, in the blue of the University of
  Konstanz and the forest colours of mcanzi.de.
