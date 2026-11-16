match_course <- function(course) {
  if (!is.character(course) || length(course) != 1) {
    cli::cli_abort("{.arg course} must be {.val statistics} or {.val advanced}.")
  }
  course <- tolower(course)
  if (!course %in% c("statistics", "advanced")) {
    cli::cli_abort("{.arg course} must be {.val statistics} or {.val advanced}, not {.val {course}}.")
  }
  course
}

course_name <- function(course) {
  c(statistics = "Statistics", advanced = "Advanced Statistics")[course]
}

course_folder <- function(course) {
  c(statistics = "statistics", advanced = "advanced_statistics")[course]
}

# The packages of the Statistics course are in Imports so that installing
# konstats installs them. konstats itself calls only a few of them; this
# function, never run, tells R CMD check that the others are used on purpose.
course_imports <- function() {
  list(
    broom::tidy,
    effsize::cohen.d,
    janitor::clean_names,
    lme4::lmer,
    lmerTest::lmer,
    palmerpenguins::path_to_file,
    simling::simling_datasets,
    simr::powerSim,
    swirl::swirl,
    tidyverse::tidyverse_packages
  )
}
