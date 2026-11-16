#' The lectures of the courses
#'
#' Lists the lectures of Statistics and the sessions of Advanced Statistics,
#' with the chapters of Winter (2019) they follow, the simling data sets
#' they use and the address of their slides.
#'
#' @param course Which course: `"statistics"` or `"advanced"`. `NULL`, the
#'   default, lists both.
#'
#' @return A tibble with one row per lecture and the columns:
#' \describe{
#'   \item{course}{`"statistics"` or `"advanced"`.}
#'   \item{number}{Number of the lecture.}
#'   \item{topic}{Topic of the lecture.}
#'   \item{winter}{Chapters of Winter (2019), *Statistics for Linguists: An
#'   Introduction Using R*, that the lecture follows. `NA` for Advanced
#'   Statistics.}
#'   \item{datasets}{simling data sets used in the slides, separated by
#'   commas. `penguins` comes from palmerpenguins.}
#'   \item{tutorial}{`TRUE` if the lecture has an exercise sheet, see
#'   [tutorials()].}
#'   \item{slides}{Address of the slides. `NA` for sessions still in
#'   preparation.}
#' }
#' @export
#' @examples
#' lectures()
#' lectures("advanced")
#'
#' # lectures that use a given data set
#' lecs <- lectures()
#' lecs[grepl("megastudy", lecs$datasets), c("course", "number", "topic")]
lectures <- function(course = NULL) {
  lecs <- lectures_meta()
  sheets <- tutorials()
  lecs$tutorial <- paste(lecs$course, lecs$number) %in% paste(sheets$course, sheets$number)
  lecs$slides <- ifelse(
    is.na(lecs$file),
    NA_character_,
    paste0("https://mcanzi.de/", course_folder(lecs$course), "/", lecs$file, ".html")
  )
  lecs$file <- NULL
  if (!is.null(course)) {
    lecs <- lecs[lecs$course == match_course(course), ]
  }
  lecs
}

#' Open the slides of a lecture
#'
#' Opens the slides of a lecture in your web browser.
#'
#' @param lecture Number of the lecture, or part of its topic, such as
#'   `"mixed"` or `"random forests"`. A topic must match one lecture only.
#' @param course Which course: `"statistics"` or `"advanced"`.
#' @param open If `TRUE`, the default in an interactive session, open the
#'   slides in the browser.
#'
#' @return The address of the slides, invisibly.
#' @export
#' @examples
#' slides(4, open = FALSE)
#' slides("random forests in practice", course = "advanced", open = FALSE)
slides <- function(lecture, course = "statistics", open = interactive()) {
  course <- match_course(course)
  lecs <- lectures(course)
  row <- find_lecture(lecs, lecture, course)
  url <- lecs$slides[row]
  if (is.na(url)) {
    cli::cli_abort("The slides of lecture {lecs$number[row]} ({lecs$topic[row]}) are not online yet.")
  }
  if (open) {
    utils::browseURL(url)
  }
  invisible(url)
}

find_lecture <- function(lecs, lecture, course) {
  if (length(lecture) != 1 || is.na(lecture) || !(is.numeric(lecture) || is.character(lecture)) || !nzchar(trimws(lecture))) {
    cli::cli_abort("{.arg lecture} must be one lecture number or one topic, such as {.code 4} or {.val mixed}.")
  }
  if (is.numeric(lecture)) {
    row <- which(lecs$number == lecture)
    if (length(row) == 0) {
      cli::cli_abort("{course_name(course)} has no lecture {lecture}. Lectures are {.val {lecs$number}}.")
    }
    return(row)
  }
  exact <- which(tolower(lecs$topic) == tolower(lecture))
  if (length(exact) == 1) {
    return(exact)
  }
  row <- which(grepl(tolower(lecture), tolower(lecs$topic), fixed = TRUE))
  if (length(row) == 0) {
    cli::cli_abort("No lecture of {course_name(course)} matches {.val {lecture}}.")
  }
  if (length(row) > 1) {
    cli::cli_abort(c(
      "{.val {lecture}} matches {length(row)} lectures: {.val {lecs$topic[row]}}.",
      i = "Use the lecture number or more of the topic."
    ))
  }
  row
}

lectures_meta <- function() {
  tibble::tribble(
    ~course, ~number, ~topic, ~winter, ~datasets, ~file,
    "statistics", 1L, "Course introduction", "1", NA, "01_course_introduction",
    "statistics", 2L, "Data wrangling", "2", "penguins", "02_data_wrangling",
    "statistics", 3L, "Descriptive statistics", "3", "penguins", "03_descriptive_statistics",
    "statistics", 4L, "Linear models", "4", "penguins", "04_linear_models",
    "statistics", 5L, "Transformations", "5", "formants, language_attitudes, megastudy, zipf_rt", "05_transformations",
    "statistics", 6L, "Multiple regression", "6", "megastudy", "06_multiple_regression",
    "statistics", 7L, "Categorical predictors", "7", "formants, korean_stops, rhythm_metrics, speech_styles, vowel_voicing", "07_categorical_predictors",
    "statistics", 8L, "Interactions", "8", "cantonese_tone_merger, freq_length, korean_stops, l2_frequency, style_voicing", "08_interactions",
    "statistics", 9L, "Significance testing", "9", "accent, style_voicing, vowel_voicing", "09_significance_testing",
    "statistics", 10L, "Mixed models 1", "14", "lexical_decision", "10_mixed_models_1",
    "statistics", 11L, "Mixed models 2", "15", "lexical_decision_l2, vowel_duration", "11_mixed_models_2",
    "statistics", 12L, "Mixed logistic regression", "12, 15.8", "lexical_accuracy, reading_skipping", "12_logistic_regression",
    "statistics", 13L, "Power and model building", "10, 11, 16", "megastudy, naming_pilot, rhythm_metrics, speech_styles", "13_power_and_models",
    "advanced", 1L, "Statistics refresher", NA, "lexical_decision_l2", "01_refresher",
    "advanced", 2L, "Generalised additive models", NA, "price_f2", "02_gams",
    "advanced", 3L, "Generalised additive mixed models", NA, "price_f2", "03_gamms",
    "advanced", 4L, "GAMMs in practice", NA, "pupil_noise", "04_gamm_practical",
    "advanced", 5L, "Random forests", NA, "td_deletion", "05_random_forests",
    "advanced", 6L, "Random forests in practice", NA, "accent", "06_random_forests_practical",
    "advanced", 7L, "Power analysis", NA, "naming_pilot", "07_power_analysis",
    "advanced", 8L, "Factor analysis", NA, "language_attitudes", "08_factor_analysis",
    "advanced", 9L, "Factor analysis in practice", NA, "web_registers", "09_factor_analysis_practical",
    "advanced", 10L, "Cluster analysis", NA, NA, NA,
    "advanced", 11L, "Figures for publication", NA, "lexical_decision_l2", "11_figures"
  )
}
