test_that("course_packages() lists both courses, without duplicates", {
  packages <- course_packages()
  expect_s3_class(packages, "tbl_df")
  expect_setequal(unique(packages$course), c("statistics", "advanced"))
  expect_false(anyDuplicated(packages[c("course", "package")]) > 0)
  expect_identical(unique(course_packages("advanced")$course), "advanced")
})

test_that("the packages of both courses are in Suggests, not Imports", {
  desc <- read.dcf(system.file("DESCRIPTION", package = "konstats"), fields = c("Imports", "Suggests"))
  deps <- function(field) trimws(sub("\\(.*", "", strsplit(desc[, field], ",")[[1]]))
  course <- unique(course_packages()$package)
  expect_true(all(course %in% deps("Suggests")))
  expect_false(any(course %in% deps("Imports")))
})

test_that("check_setup() returns one row per package", {
  report <- suppressMessages(check_setup("statistics"))
  expect_s3_class(report, "tbl_df")
  expect_identical(report$package, course_packages("statistics")$package)
  expect_type(report$installed, "logical")
  expect_identical(report$installed, nzchar(vapply(report$package, \(p) system.file(package = p), character(1), USE.NAMES = FALSE)))
  expect_null(names(report$installed))
})

test_that("simling has every data set the slides use", {
  skip_if_not_installed("simling")
  for (course in c("statistics", "advanced")) {
    needed <- konstats:::course_datasets(course)
    expect_gt(length(needed), 0)
    expect_true(all(konstats:::has_dataset("simling", needed)), label = course)
  }
  expect_false("penguins" %in% konstats:::course_datasets("statistics"))
})

test_that("a course must be statistics or advanced", {
  expect_error(course_packages("maths"), "statistics")
  expect_error(check_setup(c("statistics", "advanced")), "statistics")
  expect_identical(nrow(course_packages("Advanced")), nrow(course_packages("advanced")))
})

test_that("install_course() installs nothing when every package is there", {
  local_mocked_bindings(is_installed = function(package) TRUE)
  expect_identical(suppressMessages(install_course("advanced")), character())
  expect_error(install_course("statistics", update = NA), "update")
})
