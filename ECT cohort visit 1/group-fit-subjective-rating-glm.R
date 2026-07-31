#FIT SUBJECTIVE FEELING REGRESSION MODEL TO ECT GROUP & EXTRACT COEFFICIENTS

packages <- c("dplyr", "tidyr", "tibble", "rstan", "magrittr", "base", "jdtools",
              "purrr", "stats", "targets")
lapply(packages, require, character.only=TRUE)

source("R/utils_clean-data.R")
source("R/utils_subjective-feeling.R")
source("R/utils_model-plots.R")
source("R/utils_subjective_feelings_all_trials.R")

# get raw choice and rating data
tar_load("cleaned_choice_data")
raw_stan_data_vprl <- get_prp_raw_stan_data(
  cleaned_choice_data,
  partitioned = TRUE
)

choice_paths <- get_prp_subject_paths(
      .path = "data/",
      visit_number = 1)

subjective_ratings <- prp_get_subjective_ratings(
      choice_paths,
      cohort = "ect",
      visit_number = 1
    )

linked_choice_subjective_ratings <- link_choice_subjective_ratings(
  raw_stan_data_vprl,
  sub_feels_ratings)

subjective_rating_choice_list <- generate_choice_subjective_list(
  linked_choice_sub_feels
)

# Load vprl group-fit data
tar_load("fit_vprl")

#transform vprl param data list
vprl_parameters <- rstan::extract(
 fit_vprl,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

#simulated learned values:
learned_values <- sim_learned_values(raw_stan_data = raw_stan_data_vprl,
                                     pars= vprl_parameters)

#get expected values for subjective rating data:
subjective_rating_expected_values <- subjective_feeling_get_expected_value(
  learned_values = learned_values,
  linked_choice_subjective_feeling_ratings_data =
    linked_choice_subjective_ratings
)

#get prediction errors for subjective rating data:
subjective_rating_prediction_errors <- subjective_feeling_get_prediction_errors(
  learned_values = learned_values,
  linked_choice_subjective_feeling_ratings_data =
    linked_choice_subjective_ratings
)

#generate subjective feeling modeling data:
subjective_rating_modeling_data <- generate_subjective_feels_modeling_data(
  sub_feels_ev_data = subjective_rating_expected_values,
  sub_feels_prediction_error_data =
    subjective_rating_prediction_errors
)

#define the subjective feelings modeling specification:
subjective_rating_model_spec <-  define_sub_feels_model_spec(
      iter = 3500,
      warmup = 1000,
      prior_intercept = rstanarm::normal(0, 1),
      prior = rstanarm::normal(0, 1),
      family = gaussian(link = "identity"),
      seed = 18
    )

# Define the Subjective Feeling Model Recipe (Formula and Data)
subjective_rating_model_recipe <- define_sub_feels_model_rec(
  .data = subjective_rating_modeling_data,
  .formula = (
    z_score_rating ~
      rpe_pos +
      rpe_abs_neg +
      ppe_pos +
      ppe_abs_neg +
      ev_chosen_pos +
      ev_unchosen_pos +
      ev_chosen_neg +
      ev_unchosen_neg
  )
)

#Create CV Folds for Subjective Feeling Model (This function wraps [rsample::group_vfold_cv] for creating
#'splits of the `.data` based on grouping variables -- subject by default)
subjective_rating_cv_folds <- define_sub_feels_cv_folds(
  .data = subjective_rating_modeling_data,
  group = "subject",
  v = jdtools::how_many(
    subjective_rating_modeling_data$subject
  )
)
#Fit the Subjective Feeling Model (This function performs the resampling of the subjective feeling
#model over each cross validation fold:
subjective_rating_model_fit <- fit_sub_feels_model(
  .model_spec = subjective_rating_model_spec,
  .model_rec = subjective_rating_model_recipe,
  .model_folds = subjective_rating_cv_folds
)
# get subjective feelings regression model coefficients
subjective_rating_coef_medians <- extract_sub_feels_coefs(
  .sub_feels_model_fit = subjective_rating_model_fit,
  summarize = TRUE,
  summary_function = median
)

subjective_rating_coef_distributions <- extract_sub_feels_coefs(
  .sub_feels_model_fit = subjective_rating_model_fit,
  summarize = FALSE
)
# get predictive ratings
subjective_rating_posterior_predictions <- get_posterior_predict_data(
  .sub_feels_model_fit = subjective_rating_model_fit
)
#get prediction errors & expected values for all trials
subjective_rating_expected_values_all_trials <-
  subjective_feeling_get_expected_value_all_trials(
    learned_values = learned_values,
    linked_choice_subjective_feeling_ratings_data =
      linked_choice_subjective_ratings
  )

subjective_rating_prediction_errors_all_trials <-
  subjective_feeling_get_prediction_errors_all_trials(
    learned_values = learned_values,
    linked_choice_subjective_feeling_ratings_data =
      linked_choice_subjective_ratings
  )

subjective_rating_modeling_data_all_trials <-
  generate_subjective_feels_modeling_data_all_trials(
    sub_feels_ev_data =
      subjective_rating_expected_values_all_trials,
    sub_feels_prediction_error_data =
      subjective_rating_prediction_errors_all_trials
  )

imputed_ratings <- impute_sub_feels_by_subject(
  sub_feels_modeling_data_all_trials =
    subjective_rating_modeling_data_all_trials
)

#posterior predictive scatter plot
subjective_rating_posterior_predictive_plot <-
    plot_post_pred_data(
      .post_pred_rating_data = sub_feels_post_pred_rating,
      plot_type = "scatterplot",
      plot_title = "ECT",
      participant_corr_line_color = "#20A4F3",
      overall_corr_line_color = "black",
      point_color = "#20A4F3"
    )

#posterior predictive rating correlations
get_sub_feels_post_pred_rating_cor <- function(
    .sub_feels_post_pred_ratings,
    by_subject = FALSE,
    summary_fun = mean
) {
  initial_subject_cor <- .sub_feels_post_pred_ratings %>%
    dplyr::group_split(subject) %>%
    purrr::map_df(
      ~ {
        correlation_test <- cor.test(
          .x[["z_score_rating"]],
          .x[["pred_z_score_rating"]],
          method = "pearson"
        )

        tibble::tibble(
          subject = .x[["subject"]],
          r_squared = correlation_test$estimate ^ 2,
          p_val = correlation_test$p.value
        )
      }
    ) %>%
    dplyr::distinct(
      .keep_all = TRUE
    )
  if (by_subject) {
    out <- initial_subject_cor
  } else if (!by_subject) {

    prefix <- as.character(substitute(summary_fun))

    out <- initial_subject_cor %>%
      dplyr::summarize("{prefix}_r_squared" := summary_fun(r_squared),
                       "{prefix}_p_val" := summary_fun(p_val))
  }
  out
}
get_sub_feels_post_pred_rating_cor(.sub_feels_post_pred_ratings = subjective_rating_posterior_predictions)

sub_feels_coefs <- extract_sub_feels_coefs(.sub_feels_model_fit = sub_feels_model_fit, summarize=TRUE, summary_function = median)

#save outputs
output_dir <- "group-fit-data"

saveRDS(
  subjective_rating_coef_medians,
  file.path(output_dir, "subjective_rating_coef_medians.rds")
)

saveRDS(
  subjective_rating_coef_distributions,
  file.path(output_dir, "subjective_rating_coef_distributions.rds")
)

saveRDS(
  subjective_rating_model_fit,
  file.path(output_dir, "subjective_rating_model_fit.rds")
)

saveRDS(
  learned_values,
  file.path(output_dir, "learned_values.rds")
)

saveRDS(
  linked_choice_subjective_ratings,
  file.path(output_dir, "linked_choice_subjective_ratings.rds")
)

saveRDS(
  subjective_rating_modeling_data,
  file.path(output_dir, "subjective_rating_modeling_data.rds")
)

