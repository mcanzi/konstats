test_that("course_packages() lists both courses, without duplicates", {
  packages <- course_packages()
  expect_s3_class(packages, "tbl_df")
  expect_setequal(unique(packages$course), c("statistics", "advanced"))
  expect_false(anyDuplicated(packages[c("course", "package")]) > 0)
  expect_identical(unique(course_packages("advanced")$course), "advanced")
})

test_that("Statistics packages are in Imports and Advanced packages in Imports or Suggests", {
  desc <- read.dcf(system.file("DESCRIPTION", package = "konstats"), fields = c("Imports", "Suggests"))
  deps <- function(field) trimws(sub("\\(.*", "", strsplit(desc[, field], ",")[[1]]))
  imports <- deps("Imports")
  suggests <- deps("Suggests")
  expect_true(all(course_packages("statistics")$package %in% imports))
  expect_true(all(course_packages("advanced")$package %in% c(imports, suggests)))
})

test_that("check_setup() returns one row per package", {
  report <- suppressMessages(check_setup("statistics"))
  expect_s3_class(report, "tbl_df")
  expect_identical(report$package, course_packages("statistics")$package)
  expect_type(report$installed, "logical")
  expect_true(all(report$installed))
})

test_that("a course must be statistics or advanced", {
  expect_error(course_packages("maths"), "statistics")
  expect_error(check_setup(c("statistics", "advanced")), "statistics")
  expect_identical(nrow(course_packages("Advanced")), nrow(course_packages("advanced")))
})
