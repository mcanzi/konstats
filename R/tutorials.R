#' The weekly exercise sheets
#'
#' Lists the exercise sheets that come with konstats. Each sheet has the
#' exercises of one tutorial and an empty code chunk for each answer: an R
#' Markdown file (`.Rmd`) in Statistics, a Quarto document (`.qmd`) in
#' Advanced Statistics. RStudio opens and renders both. Some sheets end with a weekly assignment, which you
#' complete at home. Tutorial 1 of Statistics is a guided tutorial, and its
#' sheet has all the code. Copy one
#' into your project folder with [get_tutorial()], or all of them with
#' `get_tutorial("all", dir)`.
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

#' Copy exercise sheets into your project
#'
#' Copies the exercise sheet of a tutorial into a folder, where you can open
#' it and write your answers in the empty chunks. If the sheet has a weekly
#' assignment, it comes at the end, and you hand in the sheet itself (the
#' `.Rmd` file).
#'
#' @param number Number of the tutorial, the same as its lecture, such as
#'   `4`. Several numbers, such as `2:4`, or `"all"` copy several sheets at
#'   once. See [tutorials()] for the sheets available.
#' @param dir Folder to copy the sheets into, such as `"."` for the current
#'   folder of your R project.
#' @param course Which course: `"statistics"` or `"advanced"`.
#' @param overwrite If `TRUE`, replace sheets of the same name that are
#'   already in `dir`, answers and all. By default a sheet that is already
#'   there is kept: with one number the copy stops with an error, with
#'   several numbers or `"all"` that sheet is skipped and the others are
#'   copied.
#' @param open If `TRUE`, the default in an interactive session, open the
#'   sheet after copying it. Only used when you copy one sheet.
#'
#' @return The paths of the sheets in `dir`, invisibly.
#' @export
#' @examples
#' dir <- tempfile()
#' dir.create(dir)
#' get_tutorial(4, dir, open = FALSE)
#' get_tutorial("all", dir)
#' list.files(dir)
get_tutorial <- function(number, dir, course = "statistics", overwrite = FALSE, open = interactive()) {
  course <- match_course(course)
  sheets <- tutorials(course)
  all <- identical(number, "all")
  if (!all && (length(number) == 0 || !is.numeric(number) || anyNA(number))) {
    cli::cli_abort("{.arg number} must be the number of a tutorial, such as {.code 4}, several numbers, or {.code \"all\"}.")
  }
  if (nrow(sheets) == 0) {
    cli::cli_abort("{course_name(course)} has no exercise sheets yet.")
  }
  number <- if (all) sheets$number else unique(number)
  missing <- setdiff(number, sheets$number)
  if (length(missing) > 0) {
    cli::cli_abort(c(
      "{course_name(course)} has no exercise sheet for {cli::qty(length(missing))}tutorial{?s} {missing}.",
      i = "Sheets are available for tutorials {.val {sheets$number}}."
    ))
  }
  if (!dir.exists(dir)) {
    cli::cli_abort("The folder {.path {dir}} does not exist.")
  }
  files <- sheets$file[match(number, sheets$number)]
  targets <- file.path(dir, files)
  kept <- file.exists(targets) & !overwrite
  if (length(number) == 1 && kept) {
    cli::cli_abort(c(
      "{.path {targets}} already exists.",
      i = "Use {.code overwrite = TRUE} to replace it, and lose the answers in it."
    ))
  }
  for (i in which(kept)) {
    cli::cli_alert_info("Kept {.path {targets[i]}}, which is already there.")
  }
  for (i in which(!kept)) {
    copied <- file.copy(system.file("sheets", course, files[i], package = "konstats"), targets[i], overwrite = TRUE)
    if (!copied) {
      cli::cli_abort("Could not write {.path {targets[i]}}. Check that you can save files in {.path {dir}}.")
    }
    cli::cli_alert_success("Copied tutorial {number[i]} to {.path {targets[i]}}.")
  }
  if (open && length(number) == 1) {
    utils::file.edit(targets)
  }
  invisible(targets)
}

tutorial_files <- function(course) {
  folder <- system.file("sheets", course, package = "konstats")
  if (!nzchar(folder)) {
    return(character())
  }
  list.files(folder, pattern = "^[0-9]{2}_.*[.](Rmd|qmd)$", full.names = TRUE)
}

rmd_title <- function(path) {
  lines <- readLines(path, n = 20, encoding = "UTF-8", warn = FALSE)
  title <- grep("^title:", lines, value = TRUE)[1]
  gsub('^title: *"?|"? *$', "", title)
}
