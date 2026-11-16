test_that("tutorials() lists the sheets with their lecture and topic", {
  sheets <- tutorials()
  expect_s3_class(sheets, "tbl_df")
  expect_gt(nrow(sheets), 0)
  lecs <- lectures()
  # a guided tutorial (Statistics tutorial 1) has a title of its own
  guided <- vapply(konstats:::tutorial_files("statistics"), \(f) any(readLines(f, n = 10) == "guided: true"), logical(1))
  guided <- sheets$course == "statistics" & sheets$file %in% basename(names(guided)[guided])
  for (i in which(!guided)) {
    lec <- lecs[lecs$course == sheets$course[i] & lecs$number == sheets$number[i], ]
    expect_identical(sheets$topic[i], lec$topic, label = sheets$file[i])
  }
  expect_identical(sort(lecs$number[lecs$tutorial & lecs$course == "statistics"]), sort(tutorials("statistics")$number))
  expect_identical(lecs$number[lecs$tutorial & lecs$course == "advanced"], c(4L, 6L, 9L, 11L))
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
  expect_error(get_tutorial(c(2, 99, 98), dir, open = FALSE), "tutorials 99 and 98")
  expect_error(get_tutorial("4", dir, open = FALSE), "number of a tutorial")
  expect_error(get_tutorial(NA_real_, dir, open = FALSE), "number of a tutorial")
  expect_error(get_tutorial(numeric(), dir, open = FALSE), "number of a tutorial")
})

test_that("get_tutorial() copies several sheets or all of them, keeping answers", {
  dir <- new_tempdir()
  paths <- suppressMessages(get_tutorial(c(2, 4, 4), dir, open = FALSE))
  expect_identical(basename(paths), c("02_data_wrangling.Rmd", "04_linear_models.Rmd"))
  writeLines("my answers", paths[2])
  messages <- capture_messages(paths <- get_tutorial("all", dir, open = FALSE))
  expect_match(messages, "Kept", all = FALSE)
  expect_setequal(basename(paths), tutorials("statistics")$file)
  expect_setequal(list.files(dir), tutorials("statistics")$file)
  expect_identical(readLines(file.path(dir, "04_linear_models.Rmd")), "my answers")
  suppressMessages(get_tutorial("all", dir, overwrite = TRUE, open = FALSE))
  expect_false(identical(readLines(file.path(dir, "04_linear_models.Rmd")), "my answers"))
})

test_that("the assignment template exists", {
  template <- system.file("rmarkdown", "templates", "assignment", package = "konstats")
  expect_true(file.exists(file.path(template, "template.yaml")))
  expect_true(file.exists(file.path(template, "skeleton", "skeleton.Rmd")))
})
