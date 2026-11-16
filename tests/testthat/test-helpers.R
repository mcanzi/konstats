test_that("resid_acf() is 1 at lag 0 and never pairs residuals across groups", {
  res <- c(1, 2, 3, 4, 1, 2, 3, 4)
  group <- rep(c("a", "b"), each = 4)
  acf <- resid_acf(res, group, max_lag = 2)
  expect_s3_class(acf, "tbl_df")
  expect_named(acf, c("lag", "acf"))
  expect_identical(acf$lag, 0:2)
  expect_equal(acf$acf[1], 1)
  # both groups rise by 1 at every step, so every lag correlates perfectly;
  # pairing the 4 at the end of "a" with the 1 at the start of "b" would break that
  expect_equal(acf$acf, c(1, 1, 1))
})

test_that("resid_acf() recovers the autocorrelation of an AR(1) series", {
  set.seed(1)
  res <- unlist(lapply(1:200, \(i) as.numeric(stats::arima.sim(list(ar = 0.7), n = 30))))
  group <- rep(1:200, each = 30)
  acf <- resid_acf(res, group, max_lag = 3)
  expect_equal(acf$acf[2], 0.7, tolerance = 0.05)
  expect_equal(acf$acf[3], 0.49, tolerance = 0.05)
})

test_that("resid_acf() asks for residuals and groups of the same length", {
  expect_error(resid_acf(1:5, 1:4), "same length")
  expect_error(resid_acf(1:4, 1:4, max_lag = -1), "max_lag")
})

test_that("partial_dependence() averages predictions over the data", {
  d <- data.frame(x = 1:10, z = rep(c(0, 1), 5))
  d$y <- 2 * d$x + 5 * d$z
  m <- lm(y ~ x + z, data = d)
  pd <- partial_dependence(m, d, "x", c(0, 10))
  expect_named(pd, c("value", "prediction"))
  expect_equal(pd$prediction, c(2.5, 22.5))
  expect_error(partial_dependence(m, d, "w", 1), "no column")
})

test_that("partial_dependence() keeps factor levels and picks a class", {
  skip_if_not_installed("ranger")
  td <- simling::td_deletion
  rf <- ranger::ranger(deleted ~ following + age, data = td, num.trees = 50, probability = TRUE, seed = 1)
  pd <- partial_dependence(rf, td, "following", levels(td$following), class = "deleted")
  expect_identical(nrow(pd), nlevels(td$following))
  expect_true(all(pd$prediction >= 0 & pd$prediction <= 1))
  expect_error(partial_dependence(rf, td, "age", 30), "class")
  rf_class <- ranger::ranger(deleted ~ following + age, data = td, num.trees = 50, seed = 1)
  expect_error(partial_dependence(rf_class, td, "age", 30), "probability = TRUE")
})

test_that("cv_speakers() reproduces the cross-validation in the slides", {
  skip_if_not_installed("ranger")
  accent <- simling::accent
  f <- l1 ~ vot + vowel_ratio + rate
  # the code of Advanced Statistics, session 6
  set.seed(2)
  folds <- dplyr::distinct(accent, speaker, l1) |>
    dplyr::mutate(fold = sample(rep(1:5, length.out = dplyr::n())), .by = l1)
  slides <- purrr::map(1:5, \(k) {
    train <- dplyr::filter(accent, speaker %in% folds$speaker[folds$fold != k])
    test <- dplyr::filter(accent, speaker %in% folds$speaker[folds$fold == k])
    m <- ranger::ranger(f, data = train, num.trees = 100, seed = k)
    tibble::tibble(speaker = test$speaker, l1 = test$l1, pred = stats::predict(m, test)$predictions)
  }) |>
    purrr::list_rbind()

  cv <- cv_speakers(f, accent, num_trees = 100)
  expect_named(cv, c("speaker", "fold", "observed", "predicted"))
  expect_identical(cv$speaker, slides$speaker)
  expect_identical(cv$predicted, slides$pred)
})

test_that("cv_speakers() keeps every fold balanced and leaves the random seed alone", {
  skip_if_not_installed("ranger")
  accent <- simling::accent
  set.seed(10)
  before <- .Random.seed
  cv <- cv_speakers(l1 ~ vot, accent, num_trees = 20)
  expect_identical(.Random.seed, before)
  held_out <- dplyr::distinct(cv, speaker, fold, observed)
  expect_true(all(table(held_out$fold, held_out$observed) == 3))
  expect_identical(nrow(cv), nrow(accent))
  expect_error(cv_speakers(l1 ~ vot, accent, speaker = "talker"), "talker")
  # 15 speakers per L1: at most 15 folds
  expect_error(cv_speakers(l1 ~ vot, accent, k = 16), "between 2 and 15")
})

test_that("theme_paper() is a complete ggplot2 theme", {
  th <- theme_paper(base_size = 14)
  expect_s3_class(th, "theme")
  expect_identical(th$legend.position, "bottom")
  expect_identical(th$text$size, 14)
})

test_that("resid_acf() is NA at lags as long as the groups", {
  acf <- resid_acf(c(1, 3, 2, 5, 4, 6), rep(1:2, each = 3), max_lag = 4)
  expect_identical(nrow(acf), 5L)
  expect_true(all(is.na(acf$acf[acf$lag >= 2])))
})

test_that("partial_dependence() passes arguments to predict()", {
  d <- simling::td_deletion
  m <- glm(deleted ~ age, data = d, family = binomial)
  pd <- partial_dependence(m, d, "age", c(20, 80), type = "response")
  expect_true(all(pd$prediction > 0 & pd$prediction < 1))
  expect_error(partial_dependence(m, d, c("age", "rate"), 20), "one column")
})

test_that("cv_speakers() asks for a whole number of folds", {
  skip_if_not_installed("ranger")
  expect_error(cv_speakers(l1 ~ vot, simling::accent, k = 2.5), "between 2")
  expect_error(cv_speakers(l1 ~ vot, simling::accent, k = 1), "between 2")
})
