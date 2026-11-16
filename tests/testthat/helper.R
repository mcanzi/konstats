new_tempdir <- function() {
  dir <- tempfile("konstats-")
  dir.create(dir)
  dir
}
