### ECT COHORT - GET GLM REGRESSORS FOR MATLAB
source("R/utils_glm_regressors.R")
tar_load("choice_paths")
tar_load("initial_choice_data")
tar_load("raw_stan_data_vprl")


### Hierarchical-fit data ----------------------------------------------------------------------
tar_load("fit_vprl")
fit_vprl <- fit_vprl
subjective_rating_modeling_data <- readRDS("subjective_rating_model_data/sub_feels_modeling_data.rds")
learned_values <- readRDS("subjective_rating_model_data/learned_values.rds")
subjective_rating_model_fit <- readRDS("subjective_rating_model_data/sub_feels_model_fit.rds")

# Set up data

#get ratings
ratings <- subjective_rating_modeling_data %>%
  dplyr::select(subject, round, rating) %>%
  dplyr::group_split(subject) %>%
  setNames(unique(subjective_rating_modeling_data$subject))

#get choice data
choice_data <- split_choice_data(initial_choice_data)

#get VPRL parameters
vprl_parameters <- rstan::extract(fit_vprl, pars=c("learnrate_pos", "learnrate_neg", "discount_pos", "discount_neg", "tau"))
subject <- unique(initial_choice_data$subject)
vprl_parameter_medians <- data.frame(
  learnrate_pos = apply(
    vprl_parameters$learnrate_pos,
    2,
    median
  ),
  discount_pos = apply(
    vprl_parameters$discount_pos,
    2,
    median
  ),
  learnrate_neg = apply(
    vprl_parameters$learnrate_neg,
    2,
    median
  ),
  discount_neg = apply(
    vprl_parameters$discount_neg,
    2,
    median
  ),
  tau = apply(
    vprl_parameters$tau,
    2,
    median
  )
) %>%
  mutate(
    beta = 1 / tau
  ) %>%
  dplyr::select(
    -tau
  ) %>%
  mutate(
    subject = subjects
  ) %>%
  dplyr::group_split(subject) %>%
  setNames(
    unique(subjects
  ))

#get subj rating params
subjective_rating_parameters <- purrr::map(
  subjective_rating_model_fit$.extracts,
  ~ as.matrix(.x$.extracts[[1]])
)

subjective_rating_parameter_medians <- subjective_rating_parameters %>%
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

# GLM regressors
glm_regressors <-get_glm_regressors(.choice_paths = choice_paths,
                                         .learned_values = learned_values,
                                         .raw_stan_data = raw_stan_data_vprl)

#write subject-level regressors to MATLAB for imaging analysis
matlab_subject_regressors <- write_subj_regressors_to_matlab(
      regressors_list = glm_regressors,
      outdir = "subjective_rating_model_data/matlab_regressors",
      visit_number = 1)
