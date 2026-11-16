test_that("tutorials() lists the sheets with their lecture and topic", {
  sheets <- tutorials()
  expect_s3_class(sheets, "tbl_df")
  expect_gt(nrow(sheets), 0)
  lecs <- lectures()
  for (i in seq_len(nrow(sheets))) {
    lec <- lecs[lecs$course == sheets$course[i] & lecs$number == sheets$number[i], ]
    expect_identical(sheets$topic[i], lec$topic, label = sheets$file[i])
  }
  expect_identical(sort(lecs$number[lecs$tutorial & lecs$course == "statistics"]), sort(tutorials("statistics")$number))
})

test_that("no sheet contains solutions", {
  for (course in c("statistics", "advanced")) {
    for (file in konstats:::tutorial_files(course)) {
      expect_false(any(grepl(":::.*solution", readLines(file, warn = FALSE))), label = basename(file))
    }
  }
})

test_that("get_tutorial() copies a sheet and does not overwrite it", {
  dir <- new_tempdir()
  path <- suppressMessages(get_tutorial(4, dir, open = FALSE))
  expect_true(file.exists(path))
  expect_identical(basename(path), "04_linear_models.Rmd")
  writeLines("my answers", path)
  expect_error(get_tutorial(4, dir, open = FALSE), "already exists")
  expect_identical(readLines(path), "my answers")
  suppressMessages(get_tutorial(4, dir, overwrite = TRUE, open = FALSE))
  expect_false(identical(readLines(path), "my answers"))
})

test_that("get_tutorial() explains what is missing", {
  dir <- new_tempdir()
  expect_error(get_tutorial(99, dir, open = FALSE), "no exercise sheet for tutorial 99")
  expect_error(get_tutorial(4, file.path(dir, "nope"), open = FALSE), "does not exist")
  expect_error(get_tutorial(c(2, 3), dir, open = FALSE), "one tutorial")
  expect_error(get_tutorial("4", dir, open = FALSE), "one tutorial")
})

test_that("the assignment template exists", {
  template <- system.file("rmarkdown", "templates", "assignment", package = "konstats")
  expect_true(file.exists(file.path(template, "template.yaml")))
  expect_true(file.exists(file.path(template, "skeleton", "skeleton.Rmd")))
})
