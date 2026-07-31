# TARGETS PIPELINE TO FIT VPRL MODEL FOR ECT COHORT, VISIT 1

packages <- c("rstan", "magrittr", "tidyr", "jdtools", "stats", "targets", "base")
lapply(packages, require, character.only=TRUE)

source("R/utils_clean-data.R")
source("R/utils_gen-prp.R")
source("R/utils_stan-models.R")
source("R/utils_bridgesampling.R")
source("R/utils_loo-comparison.R")
source("R/utils_subjective-feeling.R")
source("R/utils_model-plots.R")
source("R/utils_subjective_feelings_all_trials.R")


# Read Initial Data -------------------------------------------------------
read_data <- list(
  tar_target(
    choice_paths,
    get_prp_subject_paths(
      .path = "data/",
      visit_number = 1
    )
  ),
  tar_target(
    initial_choice_data,
    prp_init_format_choice_data(
      .choice_paths = choice_paths,
      cohort = "ect",
      visit_number = 1
    )
  ),
  tar_target(
    cleaned_choice_data,
    prp_clean_choice_data(
      .init_choice_data = initial_choice_data
    )
  ),
  tar_target(
    sub_feels_ratings,
    prp_get_subjective_ratings(
      choice_paths,
      cohort = "ect",
      visit_number = 1
    )
  )
)

# Run Stan Models -----------------------------------------------------------
# VPRL
vprl_model <- list(
  tar_target(
    raw_stan_data_vprl,
    get_prp_raw_stan_data(
      cleaned_choice_data,
      partitioned = TRUE
    )
  ),
  tar_target(
    stan_data_vprl,
    format_raw_stan_data(
      raw_stan_data_vprl,
      partitioned = TRUE
    )
  ),
  tar_target(
    fit_vprl,
    run_stan_model(
      stan_data_vprl,
      chains = 4,
      cores = 4,
      stan_file = "stan-files/vprl.stan"
    )
  ),
  tar_target(
    pars_vprl,
    rstan::extract(fit_vprl)
  ),
  tar_target(
    bridge_error_vprl,
    get_bridge_error(fit_vprl,
                     stan_data = stan_data_vprl,
                     stan_file = "stan-files/vprl.stan"
    )
  ),
  tar_target(
    loo_info_vprl,
    loo_comparison(fit_vprl)
  )
)


# Final Target ------------------------------------------------------------
list(
  read_data,
  vprl_model
)
