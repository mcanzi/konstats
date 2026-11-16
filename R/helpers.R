#' Autocorrelation of residuals within groups
#'
#' Computes the autocorrelation of model residuals within each trajectory,
#' time series or other group, for lags from 0 to `max_lag`. At lag 1 it is
#' the correlation between each residual and the residual one measurement
#' earlier in the same group; lag 2 skips one measurement, and so on.
#' Residuals are never paired across groups. Used in Advanced Statistics to
#' check GAMMs for autocorrelated residuals; `itsadug::acf_resid()` does the
#' same with base R graphics.
#'
#' The residuals must be in the order of the data, sorted by time within
#' each group, and `res` and `group` must have the same length: if the model
#' dropped rows with missing values, drop them from `group` too.
#'
#' @param res Residuals of a model, such as `residuals(m)`.
#' @param group The trajectory or series each residual belongs to, such as
#'   `data$traj`.
#' @param max_lag The largest lag, in measurements.
#'
#' @return A tibble with one row per lag and the columns `lag` and `acf`.
#'   The autocorrelation at lag 0 is always 1. It is `NA` at lags as long as
#'   the groups, where there are too few pairs of residuals left.
#' @export
#' @examples
#' library(simling)
#' # a straight line through the PRICE trajectories: the residuals of
#' # neighbouring measurements are strongly correlated
#' m <- lm(f2 ~ time, data = price_f2)
#' resid_acf(residuals(m), price_f2$traj)
resid_acf <- function(res, group, max_lag = 8) {
  if (length(res) != length(group)) {
    cli::cli_abort(c(
      "{.arg res} and {.arg group} must have the same length, not {length(res)} and {length(group)}.",
      i = "If the model dropped rows with missing values, drop them from {.arg group} too."
    ))
  }
  if (length(max_lag) != 1 || is.na(max_lag) || max_lag < 0 || max_lag != round(max_lag)) {
    cli::cli_abort("{.arg max_lag} must be a whole number of 0 or more, not {.val {max_lag}}.")
  }
  d <- tibble::tibble(res = res, group = group)
  purrr::map(0:max_lag, \(l) {
    d |>
      dplyr::mutate(res_lag = dplyr::lag(.data$res, l), .by = "group") |>
      dplyr::summarise(acf = lag_cor(.data$res, .data$res_lag)) |>
      dplyr::mutate(lag = l)
  }) |>
    purrr::list_rbind() |>
    dplyr::relocate("lag")
}

#' Partial dependence of a model on one predictor
#'
#' Sets one predictor to the same value in every row of the data, predicts,
#' averages the predictions, and repeats for each value (Friedman, 2001).
#' Plotted against the values, the result shows how the predictions change
#' with the predictor, averaged over the other predictors. Used in Advanced
#' Statistics for random forests from ranger, but it works with any model
#' that has a `predict()` method.
#'
#' @param model A fitted model. For a classification forest from ranger,
#'   fit it with `probability = TRUE`.
#' @param data The data to predict for, usually the data the model was
#'   fitted to.
#' @param var Name of the predictor, as a string.
#' @param values Values of the predictor to set, such as
#'   `seq(18, 80, by = 2)`. For a factor, levels of the factor.
#' @param class For models that predict a probability for each class: the
#'   class whose probability to average, such as `"deleted"`.
#' @param ... Passed on to `predict()`. For a logistic regression from
#'   `glm()`, use `type = "response"` to average probabilities instead of
#'   log-odds.
#'
#' @return A tibble with one row per value and the columns `value` and
#'   `prediction`, the mean prediction (or probability of `class`).
#' @references Friedman, J. H. (2001). Greedy function approximation: A
#'   gradient boosting machine. *Annals of Statistics, 29*(5), 1189–1232.
#' @export
#' @examples
#' library(simling)
#' m <- lm(rt ~ log_freq * length, data = megastudy)
#' partial_dependence(m, megastudy, "length", 3:12)
#'
#' if (requireNamespace("ranger", quietly = TRUE)) {
#'   rf <- ranger::ranger(deleted ~ following + morph + rate + age, data = td_deletion,
#'                        num.trees = 200, probability = TRUE, seed = 1)
#'   partial_dependence(rf, td_deletion, "age", seq(20, 80, by = 10), class = "deleted")
#' }
#'
#' # a logistic regression: average the probabilities, not the log-odds
#' m <- glm(deleted ~ age + rate, data = td_deletion, family = binomial)
#' partial_dependence(m, td_deletion, "age", c(20, 50, 80), type = "response")
partial_dependence <- function(model, data, var, values, class = NULL, ...) {
  if (!is.character(var) || length(var) != 1) {
    cli::cli_abort("{.arg var} must be the name of one column, such as {.val age}.")
  }
  if (!var %in% names(data)) {
    cli::cli_abort("{.arg data} has no column {.val {var}}.")
  }
  purrr::map(values, \(v) {
    column <- rep(v, nrow(data))
    if (is.factor(data[[var]])) {
      column <- factor(column, levels = levels(data[[var]]))
    }
    data[[var]] <- column
    pred <- stats::predict(model, data, ...)
    if (is.list(pred) && !is.null(pred$predictions)) {
      pred <- pred$predictions
    }
    if (is.factor(pred)) {
      cli::cli_abort(c(
        "The model predicts classes, not probabilities.",
        i = "For a forest from ranger, fit it with {.code probability = TRUE}."
      ))
    }
    if (is.matrix(pred)) {
      if (is.null(class) || !class %in% colnames(pred)) {
        cli::cli_abort("Set {.arg class} to one of {.val {colnames(pred)}}.")
      }
      pred <- pred[, class]
    }
    tibble::tibble(value = v, prediction = mean(pred))
  }) |>
    purrr::list_rbind()
}

#' Cross-validate a random forest by speaker
#'
#' Splits the speakers into `k` folds, fits a random forest from ranger on
#' all folds but one, and predicts the tokens of the speakers left out, so
#' that every token is predicted by a forest that never saw its speaker.
#' This estimates the accuracy for new speakers, which the out-of-bag
#' accuracy overestimates when tokens of the same speaker are alike.
#'
#' When the response is a factor with one value per speaker, such as the L1,
#' each fold gets the same number of speakers from each group. With the
#' default seed, the folds and forests are the ones in the slides of
#' Advanced Statistics, session 6.
#'
#' @param formula Formula of the forest, such as `l1 ~ vot + vowel_ratio + rate`.
#' @param data A data frame with one row per token.
#' @param speaker Name of the column with the speakers, as a string.
#' @param k Number of folds.
#' @param seed Seed for assigning speakers to folds and for breaking ties
#'   between the votes of the trees. The forest of fold `i` uses seed `i`.
#'   Your own random seed is left as it was.
#' @param num_trees Number of trees in each forest.
#'
#' @return A tibble with one row per token and the columns `speaker`,
#'   `fold`, `observed` and `predicted`. The accuracy for new speakers is
#'   `mean(cv$predicted == cv$observed)`.
#' @export
#' @examples
#' if (requireNamespace("ranger", quietly = TRUE)) {
#'   library(simling)
#'   cv <- cv_speakers(l1 ~ vot + vowel_ratio + rate, accent, num_trees = 100)
#'   mean(cv$predicted == cv$observed)
#' }
cv_speakers <- function(formula, data, speaker = "speaker", k = 5, seed = 2, num_trees = 500) {
  if (!is_installed("ranger")) {
    cli::cli_abort("{.fn cv_speakers} needs ranger. Run {.run konstats::install_course(\"advanced\")} to install it.")
  }
  response <- all.vars(formula)[1]
  missing <- setdiff(c(speaker, response), names(data))
  if (length(missing) > 0) {
    cli::cli_abort("{.arg data} has no column{?s} {.val {missing}}.")
  }
  speakers <- dplyr::distinct(data, dplyr::across(dplyr::all_of(c(speaker, response))))
  stratify <- (is.factor(data[[response]]) || is.character(data[[response]])) && !anyDuplicated(speakers[[speaker]])
  # each fold needs at least one speaker (of each group, when stratified)
  smallest <- if (stratify) min(table(speakers[[response]])) else length(unique(data[[speaker]]))
  if (length(k) != 1 || !is.numeric(k) || is.na(k) || k != round(k) || k < 2 || k > smallest) {
    cli::cli_abort("{.arg k} must be between 2 and {smallest}, the number of speakers{if (stratify) ' in the smallest group' else ''}.")
  }
  # everything random runs under the seed, in the order of the slides: the
  # folds, then the forests and their predictions (predict() breaks ties
  # between votes at random)
  with_seed(seed, {
    folds <- if (stratify) {
      dplyr::mutate(speakers, fold = sample(rep(seq_len(k), length.out = dplyr::n())), .by = dplyr::all_of(response))
    } else {
      dplyr::distinct(data, dplyr::across(dplyr::all_of(speaker))) |>
        dplyr::mutate(fold = sample(rep(seq_len(k), length.out = dplyr::n())))
    }
    purrr::map(seq_len(k), \(i) {
      held_out <- folds[[speaker]][folds$fold == i]
      train <- data[!data[[speaker]] %in% held_out, ]
      test <- data[data[[speaker]] %in% held_out, ]
      m <- ranger::ranger(formula, data = train, num.trees = num_trees, seed = i)
      tibble::tibble(
        speaker = test[[speaker]],
        fold = i,
        observed = test[[response]],
        predicted = stats::predict(m, test)$predictions
      )
    }) |>
      purrr::list_rbind()
  })
}

#' A ggplot2 theme for papers
#'
#' A plain theme for figures in papers and theses: white background, light
#' grid without minor lines, bold left-aligned facet labels, a title that
#' starts at the left edge of the figure and the legend at the bottom. Built in Advanced Statistics,
#' session 11. `ggplot2::theme_set(theme_paper())` makes it the default.
#'
#' @param base_size Base font size, in points.
#' @param base_family Base font family.
#'
#' @return A ggplot2 theme.
#' @export
#' @examples
#' library(ggplot2)
#' library(simling)
#' ggplot(vowel_duration, aes(x = voicing, y = duration)) +
#'   geom_boxplot() +
#'   labs(x = "Following consonant", y = "Vowel duration (ms)") +
#'   theme_paper()
theme_paper <- function(base_size = 11, base_family = "") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(colour = "grey90"),
      axis.title = ggplot2::element_text(colour = "grey30"),
      strip.text = ggplot2::element_text(face = "bold", hjust = 0),
      plot.title.position = "plot",
      legend.position = "bottom"
    )
}

# correlation of the complete pairs, NA when there are fewer than three
lag_cor <- function(x, y) {
  ok <- !is.na(x) & !is.na(y)
  if (sum(ok) < 3) {
    return(NA_real_)
  }
  stats::cor(x[ok], y[ok])
}

with_seed <- function(seed, code) {
  env <- globalenv()
  old <- if (exists(".Random.seed", envir = env, inherits = FALSE)) get(".Random.seed", envir = env) else NULL
  on.exit(if (is.null(old)) rm(".Random.seed", envir = env) else assign(".Random.seed", old, envir = env))
  set.seed(seed)
  code
}
