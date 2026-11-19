#' konstats: Open Course in Statistics for Linguists
#'
#' Materials of two open courses in statistics for linguists, Statistics and
#' Advanced Statistics, which are also taught at the Department of
#' Linguistics, University of Konstanz. Statistics follows Winter (2019)
#' from data wrangling to mixed models. Its examples and data sets are new,
#' and the course is not endorsed by Winter or Routledge. Advanced Statistics
#' covers generalised additive mixed models, random forests, power analysis,
#' factor analysis and cluster analysis. The data sets of the courses are in
#' the simling package.
#'
#' Before the first session, [install_course()] installs the packages of a
#' course and [check_setup()] tells you whether anything is missing.
#' [course_packages()] lists the packages and what each is used for.
#'
#' [lectures()] and [slides()] find the slides of a lecture, and
#' [get_tutorial()] copies the exercise sheet of a tutorial into your
#' project. The weekly assignment starts from the *Weekly assignment*
#' template (*File > New File > R Markdown > From Template* in RStudio).
#'
#' [resid_acf()], [partial_dependence()], [cv_speakers()] and
#' [theme_paper()] are the helpers written in the Advanced Statistics slides.
#'
#' The exercise sheets are licensed under CC BY 4.0, and the rest of the
#' package under the MIT license.
#'
#' @references Winter, B. (2019). *Statistics for linguists: An introduction
#'   using R*. Routledge. \doi{10.4324/9781315165547}
#' @keywords internal
#' @importFrom rlang .data
"_PACKAGE"
