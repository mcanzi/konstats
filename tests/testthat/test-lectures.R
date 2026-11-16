test_that("lectures() lists 13 + 12 lectures, numbered from 1", {
  lecs <- lectures()
  expect_s3_class(lecs, "tbl_df")
  expect_identical(nrow(lectures("statistics")), 13L)
  expect_identical(nrow(lectures("advanced")), 12L)
  for (course in c("statistics", "advanced")) {
    expect_identical(lectures(course)$number, seq_len(nrow(lectures(course))))
  }
})

test_that("every data set listed is in simling or is penguins", {
  sets <- unlist(strsplit(stats::na.omit(lectures()$datasets), ", "))
  simling_sets <- utils::data(package = "simling")$results[, "Item"]
  expect_true(all(sets %in% c(simling_sets, "penguins")), label = paste(setdiff(sets, c(simling_sets, "penguins")), collapse = ", "))
})

test_that("slide addresses point to the course folders", {
  lecs <- lectures()
  urls <- stats::na.omit(lecs$slides)
  expect_true(all(grepl("^https://mcanzi[.]de/(statistics|advanced_statistics)/[0-9]{2}_[a-z0-9_]+[.]html$", urls)))
  expect_identical(slides(4, open = FALSE), "https://mcanzi.de/statistics/04_linear_models.html")
})

test_that("slides() finds a lecture by its topic", {
  expect_identical(slides("Random forests", course = "advanced", open = FALSE), "https://mcanzi.de/advanced_statistics/05_random_forests.html")
  expect_error(slides("in practice", course = "advanced", open = FALSE), "matches 4 lectures")
  expect_error(slides("bayes", open = FALSE), "No lecture")
  expect_error(slides(20, open = FALSE), "no lecture 20")
  expect_error(slides(c(1, 2), open = FALSE), "one lecture")
  expect_error(slides(" ", open = FALSE), "one lecture")
  # a topic is matched as text, not as a regular expression
  expect_error(slides("models (", open = FALSE), "No lecture")
})
