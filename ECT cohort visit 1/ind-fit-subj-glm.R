#FIT SUBJECTIVE RATING REGRESSION MODEL TO EACH INDIVIDUAL PARTICIPANT WITHIN THE ECT COHORT ONE-AT-A-TIME

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

subjects <- unique(
  linked_choice_subjective_ratings$subject
)

#Load individually-fit VPRL data
individual_vprl_fits <- readRDS(
  "ind_fit_data/ind-fit-nonHBA-null-informed.rds"
)

#transform vprl param data list - for ind-fit model
individual_subjects <- individual_vprl_fits[
  seq_along(subjects)
]

param_list <- vector(mode = "list", length = length(individual_subjects))
param_names <- c("learnrate_pos", "learnrate_neg", "discount_pos", "discount_neg", "tau")

for (i in seq_along(individual_subjects)) {
  param_list[[i]] <- rstan::extract(individual_subjects[[i]]$individual_vprl_fits, pars = param_names)
}

param_1 <- sapply(param_list, "[[", 1)
param_2 <- sapply(param_list, "[[", 2)
param_3 <- sapply(param_list, "[[", 3)
param_4 <- sapply(param_list, "[[", 4)
param_5 <- sapply(param_list, "[[", 5)

param_list_all <- list(param_1, param_2, param_3, param_4, param_5)
param_names <- c("learnrate_pos", "learnrate_neg", "discount_pos", "discount_neg", "tau")
individual_vprl_parameters<- setNames(param_list_all, param_names)

#simulate learned values:
individual_learned_values <- sim_learned_values(raw_stan_data = raw_stan_data_vprl,
                                     pars= individual_vprl_parameters)

#get expected value for subjective feelings data:
individual_subjective_rating_expected_values <-
  subjective_feeling_get_expected_value(
    learned_values = individual_learned_values,
    linked_choice_subjective_feeling_ratings_data =
      linked_choice_subjective_ratings
  )

#get prediction errors for subjective feelings:
individual_subjective_rating_prediction_errors <-
  subjective_feeling_get_prediction_errors(
    learned_values = individual_learned_values,
    linked_choice_subjective_feeling_ratings_data =
      linked_choice_subjective_ratings
  )
#generate subjective rating modeling data:
individual_subjective_rating_modeling_data <-
  generate_subjective_feels_modeling_data(
    sub_feels_ev_data =
      individual_subjective_rating_expected_values,
    sub_feels_prediction_error_data =
      individual_subjective_rating_prediction_errors
  )

#define the subjective feelings modeling specification:
individual_subjective_rating_model_spec <-  define_sub_feels_model_spec(
      iter = 3500,
      warmup = 1000,
      prior_intercept = rstanarm::normal(0, 1),
      prior = rstanarm::normal(0, 1),
      family = gaussian(link = "identity"),
      seed = 18
    )

# Define the Subjective Feeling Model Recipe (Formula and Data)
individual_subjective_rating_model_recipe <-
  define_sub_feels_model_rec(
    .data = individual_subjective_rating_modeling_data,
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
individual_subjective_rating_cv_folds <-
  define_sub_feels_cv_folds(
    .data = individual_subjective_rating_modeling_data,
    group = "subject",
    v = jdtools::how_many(
      individual_subjective_rating_modeling_data$subject
    )
  )

#Fit the Subjective Feeling Model (This function performs the resampling of the subjective feeling
#model over each cross validation fold:
individual_subjective_rating_model_fit <-
  fit_sub_feels_model(
    .model_spec = individual_subjective_rating_model_spec,
    .model_rec = individual_subjective_rating_model_recipe,
    .model_folds = individual_subjective_rating_cv_folds
  )
#get medians for regressors
individual_subjective_rating_parameters <- purrr::map(
  individual_subjective_rating_model_fit$.extracts,
  ~ as.matrix(.x$.extracts[[1]])
)
individual_subjective_rating_parameter_medians <-
  individual_subjective_rating_parameters %>%
  purrr::map(
    ~ as_tibble(
      t(
        as.matrix(
          apply(
            .x,
            2,
            median
          )
        )
      )
    )
  ) %>%
  setNames(
    unique(subjects)
  ) %>%
  purrr::map(
    ~ rename_column(
      .x,
      "(Intercept)",
      "intercept"
    )
  )
# subjective feelings regression model coefficients
individual_subjective_rating_coef_medians <-
  extract_sub_feels_coefs(
    .sub_feels_model_fit =
      individual_subjective_rating_model_fit,
    summarize = TRUE,
    summary_function = median
  )

individual_subjective_rating_coef_distributions <-
  extract_sub_feels_coefs(
    .sub_feels_model_fit =
      individual_subjective_rating_model_fit,
    summarize = FALSE
  )

#get posterior rating
individual_subjective_rating_posterior_predictions <-
  get_posterior_predict_data(
    .sub_feels_model_fit =
      individual_subjective_rating_model_fit
  )
#get prediction errors & expected values for all trials
individual_subjective_rating_expected_values_all_trials <-
  subjective_feeling_get_expected_value_all_trials(
    learned_values = individual_learned_values,
    linked_choice_subjective_feeling_ratings_data =
      linked_choice_subjective_ratings
  )

individual_subjective_rating_prediction_errors_all_trials <-
  subjective_feeling_get_prediction_errors_all_trials(
    learned_values = individual_learned_values,
    linked_choice_subjective_feeling_ratings_data =
      linked_choice_subjective_ratings
  )

individual_subjective_rating_modeling_data_all_trials <-
  generate_subjective_feels_modeling_data_all_trials(
    sub_feels_ev_data =
      individual_subjective_rating_expected_values_all_trials,
    sub_feels_prediction_error_data =
      individual_subjective_rating_prediction_errors_all_trials
  )

individual_imputed_ratings <- impute_sub_feels_by_subject(
  sub_feels_modeling_data_all_trials =
    individual_subjective_rating_modeling_data_all_trials
)

#posterior predictive scatter plot
individual_subjective_rating_posterior_predictive_plot <-
    plot_post_pred_data(
      .post_pred_rating_data = ind_sub_feels_post_pred_rating,
      plot_type = "scatterplot",
      plot_title = "pre-ECT",
      participant_corr_line_color = "#87D68D",
      overall_corr_line_color = "black",
      point_color = "#87D68D"
    )

#posterior predictive rating correlations
individual_subjective_rating_correlations <-
  get_sub_feels_post_pred_rating_cor(
    .sub_feels_post_pred_ratings =
      individual_subjective_rating_posterior_predictions
  )

#posterior predictive rating coefficients
subjective_rating_coefficients <- extract_sub_feels_coefs(.sub_feels_model_fit = sub_feels_model_fit, summarize=TRUE, summary_function = median)


#save output
output_dir <- "individually-fit-data"

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
  subjective_rating_modeling_data,
  file.path(output_dir, "subjective_rating_modeling_data.rds")
)


saveRDS(
  learned_values,
  file.path(output_dir, "learned_values.rds")
)


saveRDS(
  individual_vprl_parameters,
  file.path(output_dir, "individual_vprl_parameters.rds")
)
