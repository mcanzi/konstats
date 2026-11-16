#' The packages each course uses
#'
#' Lists the packages used in the slides and tutorials of each course. The
#' packages of the Statistics course are installed together with konstats;
#' the extra packages of Advanced Statistics are installed with
#' [install_course()].
#'
#' @param course Which course: `"statistics"` or `"advanced"`. `NULL`, the
#'   default, lists both.
#'
#' @return A tibble with one row per package and course, and the columns:
#' \describe{
#'   \item{course}{`"statistics"` or `"advanced"`.}
#'   \item{package}{Name of the package.}
#'   \item{use}{What the package is used for in the course.}
#' }
#' @export
#' @examples
#' course_packages()
#' course_packages("advanced")
course_packages <- function(course = NULL) {
  packages <- packages_meta()
  if (is.null(course)) {
    return(packages)
  }
  packages[packages$course == match_course(course), ]
}

#' Install the packages of a course
#'
#' Installs the packages a course uses that are not installed yet, from
#' CRAN. The packages of the Statistics course come with konstats, so
#' `install_course("advanced")` is the one you need: run it once before the
#' first session of Advanced Statistics.
#'
#' @inheritParams check_setup
#' @param update If `TRUE`, also reinstall the packages that are already
#'   installed, to get their latest versions.
#'
#' @return The names of the packages it installed, invisibly.
#' @export
#' @examples
#' \dontrun{
#' install_course("advanced")
#' }
install_course <- function(course = "advanced", update = FALSE) {
  course <- match_course(course)
  packages <- course_packages(course)$package
  missing <- packages[!vapply(packages, is_installed, logical(1))]
  todo <- if (update) packages else missing
  # simling is not on CRAN yet: it comes with konstats from GitHub
  todo <- setdiff(todo, "simling")
  if (length(todo) == 0) {
    cli::cli_alert_success("All packages of {course_name(course)} are installed.")
    return(invisible(character()))
  }
  cli::cli_alert_info("Installing {length(todo)} package{?s}: {.pkg {todo}}")
  utils::install.packages(todo)
  invisible(todo)
}

#' Check that your computer is ready for a course
#'
#' Reports your version of R and checks that every package the course uses
#' is installed. It also checks that your version of simling has every
#' data set the slides of the course use. Run it before the first session,
#' and again whenever course code fails on your computer.
#'
#' @param course Which course: `"statistics"` or `"advanced"`.
#'
#' @return A tibble with one row per package and the columns `package`,
#'   `installed` (`TRUE` or `FALSE`) and `version`, invisibly. The function
#'   is called for the report it prints.
#' @export
#' @examples
#' check_setup("statistics")
check_setup <- function(course = "statistics") {
  course <- match_course(course)
  cli::cli_h2("Setup for {course_name(course)}")

  # konstats needs R >= 4.1.0 to load at all, so the version is only reported
  cli::cli_alert_success("R {getRversion()}")

  packages <- course_packages(course)$package
  installed <- vapply(packages, is_installed, logical(1))
  version <- vapply(packages, package_version_or_na, character(1))
  report <- tibble::tibble(package = packages, installed = installed, version = version)

  if (all(installed)) {
    cli::cli_alert_success("All {length(packages)} packages are installed.")
  } else {
    cli::cli_alert_danger("Missing: {.pkg {packages[!installed]}}")
    cli::cli_alert_info("Run {.run konstats::install_course(\"{course}\")} to install them.")
  }

  if (is_installed("simling")) {
    needed <- course_datasets(course)
    absent <- needed[!has_dataset("simling", needed)]
    if (length(absent) > 0) {
      cli::cli_alert_danger("simling is too old for the course: it has no {.code {absent}}.")
      cli::cli_alert_info("Run {.run remotes::install_github(\"mcanzi/simling\")} to update it.")
    }
  }

  invisible(report)
}

packages_meta <- function() {
  tibble::tribble(
    ~course, ~package, ~use,
    "statistics", "tidyverse", "Data wrangling and figures",
    "statistics", "simling", "Simulated linguistic data sets",
    "statistics", "palmerpenguins", "The penguins data of the first lectures",
    "statistics", "broom", "Model results as tibbles",
    "statistics", "janitor", "Cleaning column names",
    "statistics", "effsize", "Effect sizes",
    "statistics", "lme4", "Mixed models",
    "statistics", "lmerTest", "p-values for mixed models",
    "statistics", "simr", "Power analysis by simulation",
    "statistics", "swirl", "Interactive R lessons",
    "advanced", "simling", "Simulated linguistic data sets",
    "advanced", "tidyverse", "Data wrangling and figures",
    "advanced", "broom", "Model results as tibbles",
    "advanced", "lme4", "Mixed models",
    "advanced", "lmerTest", "p-values for mixed models",
    "advanced", "mgcv", "Generalised additive (mixed) models",
    "advanced", "tidygam", "Predictions from GAMs as tibbles",
    "advanced", "itsadug", "Plots and autocorrelation for GAMMs",
    "advanced", "rpart", "Classification and regression trees",
    "advanced", "ranger", "Random forests",
    "advanced", "simr", "Power analysis by simulation",
    "advanced", "psych", "Factor analysis",
    "advanced", "GPArotation", "Rotations for factor analysis",
    "advanced", "lavaan", "Confirmatory factor analysis",
    "advanced", "patchwork", "Combining figures",
    "advanced", "ggeffects", "Model predictions for figures",
    "advanced", "ggrepel", "Labels that do not overlap",
    "advanced", "ggridges", "Ridgeline plots"
  )
}

is_installed <- function(package) {
  nzchar(system.file(package = package))
}

package_version_or_na <- function(package) {
  if (!is_installed(package)) {
    return(NA_character_)
  }
  as.character(utils::packageVersion(package))
}

# the simling data sets used in the slides of a course (penguins is from palmerpenguins)
course_datasets <- function(course) {
  datasets <- lectures(course)$datasets
  datasets <- trimws(unlist(strsplit(datasets[!is.na(datasets)], ",")))
  setdiff(unique(datasets), "penguins")
}

has_dataset <- function(package, dataset) {
  dataset %in% utils::data(package = package)$results[, "Item"]
}
