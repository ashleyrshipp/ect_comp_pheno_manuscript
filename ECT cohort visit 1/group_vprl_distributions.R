### ECT COHORT
# extract posterior distributions
tar_load("fit_vprl")
ect_vprl <- fit_vprl
tar_load("initial_choice_data")

#get medians
vprl_individual_parameters <- rstan::extract(
  fit_vprl,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)
subject <- unique(initial_choice_data$subject)
vprl_medians <- data.frame(
  learnrate_pos = apply(
    vprl_individual_parameters$learnrate_pos,
    2,
    median
  ),
  discount_pos = apply(
    vprl_individual_parameters$discount_pos,
    2,
    median
  ),
  learnrate_neg = apply(
    vprl_individual_parameters$learnrate_neg,
    2,
    median
  ),
  discount_neg = apply(
    vprl_individual_parameters$discount_neg,
    2,
    median
  ),
  tau = apply(
    vprl_individual_parameters$tau,
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
  )

saveRDS(
  vprl_medians,
  "vprl_data/vprl_medians.rds"
)


# Group VPRL parameter distributions
vprl_group_parameters <- rstan::extract(
  fit_vprl,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

vprl_group_distributions <- data.frame(
  mu_learnrate_pos = vprl_group_parameters$mu_learnrate_pos,
  mu_discount_pos = vprl_group_parameters$mu_discount_pos,
  mu_learnrate_neg = vprl_group_parameters$mu_learnrate_neg,
  mu_discount_neg = vprl_group_parameters$mu_discount_neg,
  mu_tau = vprl_group_parameters$mu_tau
) %>%
  mutate(
    mu_beta = 1 / mu_tau
  ) %>%
  dplyr::select(!c("mu_Tau"))

saveRDS(
  vprl_group_distributions,
  "vprl_data/vprl_distributions.rds"
)
