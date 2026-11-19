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

is_flag <- function(x) {
  is.logical(x) && length(x) == 1 && !is.na(x)
}
