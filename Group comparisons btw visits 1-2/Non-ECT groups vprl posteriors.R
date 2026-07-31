### GROUP VPRL DISTRIBUTIONS - NON-ECT & NO-DEPRESSION GROUPS
packages <- c("magrittr", "HDInterval", "latex2exp", "dplyr", "tidyverse", "rstan", "hBayesDM",
              "ggplot2", "cowplot", "BEST")

lapply(packages, require, character.only=TRUE)

# Visit 1
no_depression_v1_vprl_fit <- readRDS("Data/visit-1/no-depression/vprl-data/fit_vprl.rds")

no_depression_v1_group_params <- extract(
  no_depression_v1_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

no_depression_v1_group_params$mu_tau <- (
  1 / no_depression_v1_group_params$mu_tau
)

non_ect_v1_vprl_fit <- readRDS("Data/visit-1/non-ect/vprl-data/fit_vprl.rds")

non_ect_v1_group_params <- extract(
  non_ect_v1_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

non_ect_v1_group_params$mu_tau <- (
  1 / non_ect_v1_group_params$mu_tau
)

# Visit 2
no_depression_v2_vprl_fit <- readRDS("Data/visit-2/no-depression/vprl-data/fit_vprl.rds")

no_depression_v2_group_params <- extract(
  no_depression_v2_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

no_depression_v2_group_params$mu_tau <- (
  1 / no_depression_v2_group_params$mu_tau
)

non_ect_v2_vprl_fit <- readRDS("Data/visit-2/non-ect/vprl-data/fit_vprl.rds")

non_ect_v2_group_params <- extract(
  non_ect_v2_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

non_ect_v2_group_params$mu_tau <- (
  1 / non_ect_v2_group_params$mu_tau
)

#group parameters
learnrate_pos_v1 <- c(
  no_depression_v1_group_params$mu_learnrate_pos,
  non_ect_v1_group_params$mu_learnrate_pos
)

learnrate_pos_v2 <- c(
  no_depression_v2_group_params$mu_learnrate_pos,
  non_ect_v2_group_params$mu_learnrate_pos
)

discount_pos_v1 <- c(
  no_depression_v1_group_params$mu_discount_pos,
  non_ect_v1_group_params$mu_discount_pos
)

discount_pos_v2 <- c(
  no_depression_v2_group_params$mu_discount_pos,
  non_ect_v2_group_params$mu_discount_pos
)

learnrate_neg_v1 <- c(
  no_depression_v1_group_params$mu_learnrate_neg,
  non_ect_v1_group_params$mu_learnrate_neg
)

learnrate_neg_v2 <- c(
  no_depression_v2_group_params$mu_learnrate_neg,
  non_ect_v2_group_params$mu_learnrate_neg
)

discount_neg_v1 <- c(
  no_depression_v1_group_params$mu_discount_neg,
  non_ect_v1_group_params$mu_discount_neg
)

discount_neg_v2 <- c(
  no_depression_v2_group_params$mu_discount_neg,
  non_ect_v2_group_params$mu_discount_neg
)

beta_v1 <- c(
  no_depression_v1_group_params$mu_tau,
  non_ect_v1_group_params$mu_tau
)

beta_v2 <- c(
  no_depression_v2_group_params$mu_tau,
  non_ect_v2_group_params$mu_tau
)

groups <- c(
  rep(
    "no-depression",
    length(no_depression_v1_group_params$mu_learnrate_pos)
  ),
  rep(
    "non-ect",
    length(non_ect_v1_group_params$mu_learnrate_pos)
  )
)

groupParams <- data.frame(
  learnrate_pos_v1,
  learnrate_pos_v2,
  discount_pos_v1,
  discount_pos_v2,
  learnrate_neg_v1,
  learnrate_neg_v2,
  discount_neg_v1,
  discount_neg_v2,
  beta_v1,
  beta_v2,
  groups
)

saveRDS(groupParams,"Data/visit-2/group/vprl-data/groupParams.rds")


# Individual-level VPRL medians
#visit 1
no_depression_v1_individual_params <- extract(
  no_depression_v1_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

no_depression_v1_individual_params$tau <- (
  1 / no_depression_v1_individual_params$tau
)

non_ect_v1_individual_params <- extract(
  non_ect_v1_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

non_ect_v1_individual_params$tau <- (
  1 / non_ect_v1_individual_params$tau
)

#visit 2
no_depression_v2_individual_params <- extract(
  no_depression_v2_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

no_depression_v2_individual_params$tau <- (
  1 / no_depression_v2_individual_params$tau
)

non_ect_v2_individual_params <- extract(
  non_ect_v2_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

non_ect_v2_individual_params$tau <- (
  1 / non_ect_v2_individual_params$tau
)

#get medians
individual_learnrate_pos_v1 <- c(
  apply(
    no_depression_v1_individual_params$learnrate_pos,
    2,
    median
  ),
  apply(
    non_ect_v1_individual_params$learnrate_pos,
    2,
    median
  )
)

individual_learnrate_pos_v2 <- c(
  apply(
    no_depression_v2_individual_params$learnrate_pos,
    2,
    median
  ),
  apply(
    non_ect_v2_individual_params$learnrate_pos,
    2,
    median
  )
)

individual_discount_pos_v1 <- c(
  apply(
    no_depression_v1_individual_params$discount_pos,
    2,
    median
  ),
  apply(
    non_ect_v1_individual_params$discount_pos,
    2,
    median
  )
)

individual_discount_pos_v2 <- c(
  apply(
    no_depression_v2_individual_params$discount_pos,
    2,
    median
  ),
  apply(
    non_ect_v2_individual_params$discount_pos,
    2,
    median
  )
)

individual_learnrate_neg_v1 <- c(
  apply(
    no_depression_v1_individual_params$learnrate_neg,
    2,
    median
  ),
  apply(
    non_ect_v1_individual_params$learnrate_neg,
    2,
    median
  )
)

individual_learnrate_neg_v2 <- c(
  apply(
    no_depression_v2_individual_params$learnrate_neg,
    2,
    median
  ),
  apply(
    non_ect_v2_individual_params$learnrate_neg,
    2,
    median
  )
)

individual_discount_neg_v1 <- c(
  apply(
    no_depression_v1_individual_params$discount_neg,
    2,
    median
  ),
  apply(
    non_ect_v1_individual_params$discount_neg,
    2,
    median
  )
)

individual_discount_neg_v2 <- c(
  apply(
    no_depression_v2_individual_params$discount_neg,
    2,
    median
  ),
  apply(
    non_ect_v2_individual_params$discount_neg,
    2,
    median
  )
)

individual_beta_v1 <- c(
  apply(
    no_depression_v1_individual_params$tau,
    2,
    median
  ),
  apply(
    non_ect_v1_individual_params$tau,
    2,
    median
  )
)

individual_beta_v2 <- c(
  apply(
    no_depression_v2_individual_params$tau,
    2,
    median
  ),
  apply(
    non_ect_v2_individual_params$tau,
    2,
    median
  )
)

groups <- c(
  rep(
    "no-depression",
    dim(no_depression_v1_individual_params$learnrate_pos)[2]
  ),
  rep(
    "non-ect",
    dim(non_ect_v1_individual_params$learnrate_pos)[2]
  )
)

indiv_medians <- data.frame(
  individual_learnrate_pos_v1,
  individual_learnrate_pos_v2,
  individual_discount_pos_v1,
  individual_discount_pos_v2,
  individual_learnrate_neg_v1,
  individual_learnrate_neg_v2,
  individual_discount_neg_v1,
  individual_discount_neg_v2,
  individual_beta_v1,
  individual_beta_v2,
  groups
)

saveRDS(
  indiv_medians,
  "Data/visit-2/group/vprl-data/indiv_medians.rds"
)

#Calculate HDI
calc_HDI <- function(group) {
  learnrate_pos_hdi_v1 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(learnrate_pos_v1) %>%
    t() %>%
    HDIofMCMC()

  learnrate_pos_hdi_v2 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(learnrate_pos_v2) %>%
    t() %>%
    HDIofMCMC()

  discount_pos_hdi_v1 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(discount_pos_v1) %>%
    t() %>%
    HDIofMCMC()

  discount_pos_hdi_v2 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(discount_pos_v2) %>%
    t() %>%
    HDIofMCMC()

  learnrate_neg_hdi_v1 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(learnrate_neg_v1) %>%
    t() %>%
    HDIofMCMC()

  learnrate_neg_hdi_v2 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(learnrate_neg_v2) %>%
    t() %>%
    HDIofMCMC()

  discount_neg_hdi_v1 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(discount_neg_v1) %>%
    t() %>%
    HDIofMCMC()

  discount_neg_hdi_v2 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(discount_neg_v2) %>%
    t() %>%
    HDIofMCMC()

  beta_hdi_v1 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(beta_v1) %>%
    t() %>%
    HDIofMCMC()

  beta_hdi_v2 <- groupParams %>%
    filter(groups == group) %>%
    dplyr::select(beta_v2) %>%
    t() %>%
    HDIofMCMC()

  return(
    data.frame(
      learnrate_pos_hdi_v1,
      learnrate_pos_hdi_v2,
      discount_pos_hdi_v1,
      discount_pos_hdi_v2,
      learnrate_neg_hdi_v1,
      learnrate_neg_hdi_v2,
      discount_neg_hdi_v1,
      discount_neg_hdi_v2,
      beta_hdi_v1,
      beta_hdi_v2
    )
  )
}

hdi <- list(
  no_depression = calc_HDI("no-depression"),
  non_ect = calc_HDI("non-ect")
)

saveRDS(
  hdi,
  "Data/visit-2/group/vprl-data/vprl_hdi.rds"
)


# load in data -------------------------------------------------------------------------------------------------
indiv_medians <- readRDS("Data/visit-2/group/vprl-data/indiv_medians.rds")
groupParams <- readRDS("Data/visit-2/group/vprl-data/groupParams.rds")
hdi <- readRDS("Data/visit-2/group/vprl-data/vprl_hdi.rds")

# For table -
#visit 1 median info for each cohort
group_med <- function(groupParams, group, parameter) {
group_samples <- groupParams %>%
  filter(groups == group) %>%
  dplyr::select({{parameter}}) %>% unlist() %>% as.numeric()

group_median <- median(group_samples)
hdi <- HDIofMCMC(group_samples)

return(list(group_median, hdi))
}
#alter cohort & parameter
group_med(groupParams, "no-depression", learnrate_pos_v1)
group_med(groupParams, "no-depression", learnrate_pos_v2)


# Median difference between visits within cohort
med_difference <- function(groupParams, group, vis1_param, vis2_param) {
  diff_samples <- (groupParams %>% filter(groups==group) %>% select({{vis2_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group) %>% select({{vis1_param}}) %>% unlist() %>% as.numeric())

  diff_med <- median(diff_samples)
  diff_hdi <- HDIofMCMC(diff_samples)
  cred_greater <- (sum(diff_samples>0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred_lesser <- (sum(diff_samples<0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred <- paste0(cred_lesser, '% < 0 < ', cred_greater,'%')

  return(list(diff_med, diff_hdi, cred))
}
#alter cohort & parameter
med_difference(groupParams, 'no-depression', learnrate_pos_v1, learnrate_pos_v2)
