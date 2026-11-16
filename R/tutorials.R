#' The weekly exercise sheets
#'
#' Lists the exercise sheets that come with konstats. Each sheet is an R
#' Markdown file with the exercises of one tutorial and an empty code chunk
#' for each answer; the last exercises are the weekly assignment. Copy one
#' into your project folder with [get_tutorial()].
#'
#' @param course Which course: `"statistics"` or `"advanced"`. `NULL`, the
#'   default, lists both.
#'
#' @return A tibble with one row per sheet and the columns `course`,
#'   `number` (the number of the lecture it belongs to), `topic` and `file`.
#' @export
#' @examples
#' tutorials()
tutorials <- function(course = NULL) {
  courses <- if (is.null(course)) c("statistics", "advanced") else match_course(course)
  files <- unlist(lapply(courses, tutorial_files), use.names = FALSE)
  tibble::tibble(
    course = basename(dirname(files)),
    number = as.integer(substr(basename(files), 1, 2)),
    topic = vapply(files, rmd_title, character(1), USE.NAMES = FALSE),
    file = basename(files)
  )
}

#' Copy an exercise sheet into your project
#'
#' Copies the exercise sheet of a tutorial into a folder, where you can open
#' it and write your answers in the empty chunks. The weekly assignment is at
#' the end of the sheet; you hand in the .Rmd file.
#'
#' @param number Number of the tutorial, the same as its lecture. See
#'   [tutorials()] for the sheets available.
#' @param dir Folder to copy the sheet into, such as `"."` for the current
#'   folder of your R project.
#' @param course Which course: `"statistics"` or `"advanced"`.
#' @param overwrite If `TRUE`, replace a sheet of the same name that is
#'   already in `dir`, answers and all. By default the copy stops instead.
#' @param open If `TRUE`, the default in an interactive session, open the
#'   sheet after copying it.
#'
#' @return The path of the copied sheet, invisibly.
#' @export
#' @examples
#' dir <- tempfile()
#' dir.create(dir)
#' get_tutorial(4, dir, open = FALSE)
#' list.files(dir)
get_tutorial <- function(number, dir, course = "statistics", overwrite = FALSE, open = interactive()) {
  course <- match_course(course)
  if (length(number) != 1 || !is.numeric(number) || is.na(number)) {
    cli::cli_abort("{.arg number} must be the number of one tutorial, such as {.code 4}.")
  }
  sheets <- tutorials(course)
  if (!number %in% sheets$number) {
    cli::cli_abort(c(
      "{course_name(course)} has no exercise sheet for tutorial {number}.",
      i = if (nrow(sheets) > 0) "Sheets are available for tutorials {.val {sheets$number}}." else "No sheets are available yet."
    ))
  }
  if (!dir.exists(dir)) {
    cli::cli_abort("The folder {.path {dir}} does not exist.")
  }
  file <- sheets$file[sheets$number == number]
  target <- file.path(dir, file)
  if (file.exists(target) && !overwrite) {
    cli::cli_abort(c(
      "{.path {target}} already exists.",
      i = "Use {.code overwrite = TRUE} to replace it, and lose the answers in it."
    ))
  }
  copied <- file.copy(system.file("sheets", course, file, package = "konstats"), target, overwrite = TRUE)
  if (!copied) {
    cli::cli_abort("Could not write {.path {target}}. Check that you can save files in {.path {dir}}.")
  }
  cli::cli_alert_success("Copied tutorial {number} to {.path {target}}.")
  if (open) {
    utils::file.edit(target)
  }
  invisible(target)
}

tutorial_files <- function(course) {
  folder <- system.file("sheets", course, package = "konstats")
  if (!nzchar(folder)) {
    return(character())
  }
  list.files(folder, pattern = "^[0-9]{2}_.*[.]Rmd$", full.names = TRUE)
}

rmd_title <- function(path) {
  lines <- readLines(path, n = 20, encoding = "UTF-8", warn = FALSE)
  title <- grep("^title:", lines, value = TRUE)[1]
  gsub('^title: *"?|"? *$', "", title)
}
