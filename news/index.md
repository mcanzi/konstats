# Changelog

## konstats (development version)

- First version.
- Installing konstats installs the packages of the Statistics course;
  `install_course("advanced")` installs the extra packages of Advanced
  Statistics, and
  [`course_packages()`](https://mcanzi.de/konstats/reference/course_packages.md)
  lists them all.
- [`check_setup()`](https://mcanzi.de/konstats/reference/check_setup.md)
  checks the version of R, the packages of a course and that simling has
  the data sets its slides use.
- [`lectures()`](https://mcanzi.de/konstats/reference/lectures.md) lists
  the lectures of both courses with the chapters of Winter
  2019. they follow, the data sets they use and their slides;
        [`slides()`](https://mcanzi.de/konstats/reference/slides.md)
        opens the slides of a lecture.
- [`tutorials()`](https://mcanzi.de/konstats/reference/tutorials.md)
  lists the exercise sheets and
  [`get_tutorial()`](https://mcanzi.de/konstats/reference/get_tutorial.md)
  copies them into a project folder, one at a time or all at once with
  `get_tutorial("all", dir)`. Sheets for Statistics tutorials 1 to 12
  (tutorial 1 is guided, with all the code), and for the tutorials of
  the practical lectures of Advanced Statistics (4, 6, 9 and 11).
- An R Markdown template for the weekly assignments.
- The helpers of the Advanced Statistics slides:
  [`resid_acf()`](https://mcanzi.de/konstats/reference/resid_acf.md)
  (residual autocorrelation within trajectories),
  [`partial_dependence()`](https://mcanzi.de/konstats/reference/partial_dependence.md)
  (called `partial()` in the slides),
  [`cv_speakers()`](https://mcanzi.de/konstats/reference/cv_speakers.md)
  (cross-validation of a random forest by speaker, with the folds of the
  slides) and
  [`theme_paper()`](https://mcanzi.de/konstats/reference/theme_paper.md).
- Hex logo: a Bodensee forget-me-not, in the blue of the University of
  Konstanz and the forest colours of mcanzi.de.
