### COMPARE VPRL GROUP DISTRIBUTIONS BTW ECT RESPONDERS & NONRESPONDERS

packages <- c("magrittr", "HDInterval", "latex2exp", "dplyr", "tidyverse", "rstan", "hBayesDM",
              "ggplot2", "cowplot", "BEST")

lapply(packages, require, character.only=TRUE)


# ECT Responders
responder_v1_vprl_fit <- readRDS("Data/visit-1/clinical/ect-r/vprl-data/fit_vprl.rds")

responder_v1_group_params <- extract(
  responder_v1_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

responder_v1_group_params$mu_tau <- (
  1 / responder_v1_group_params$mu_tau
)

responder_v2_vprl_fit <- readRDS("Data/visit-2/clinical/ect-r/vprl-data/fit_vprl.rds")

responder_v2_group_params <- extract(
  responder_v2_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

responder_v2_group_params$mu_tau <- (
  1 / responder_v2_group_params$mu_tau
)


# Non-responders
non_responder_v1_vprl_fit <- readRDS("Data/visit-1/clinical/ect-nr/vprl-data/fit_vprl.rds")

non_responder_v1_group_params <- extract(
  non_responder_v1_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

non_responder_v1_group_params$mu_tau <- (
  1 / non_responder_v1_group_params$mu_tau
)

non_responder_v2_vprl_fit <- readRDS(
  "Data/visit-2/clinical/ect-nr/vprl-data/fit_vprl.rds"
)

non_responder_v2_group_params <- extract(
  non_responder_v2_vprl_fit,
  pars = c(
    "mu_learnrate_pos",
    "mu_learnrate_neg",
    "mu_discount_pos",
    "mu_discount_neg",
    "mu_tau"
  )
)

non_responder_v2_group_params$mu_tau <- (
  1 / non_responder_v2_group_params$mu_tau
)


#group parameters
learnrate_pos_v1 <- c(
  responder_v1_group_params$mu_learnrate_pos,
  non_responder_v1_group_params$mu_learnrate_pos
)

learnrate_pos_v2 <- c(
  responder_v2_group_params$mu_learnrate_pos,
  non_responder_v2_group_params$mu_learnrate_pos
)

discount_pos_v1 <- c(
  responder_v1_group_params$mu_discount_pos,
  non_responder_v1_group_params$mu_discount_pos
)

discount_pos_v2 <- c(
  responder_v2_group_params$mu_discount_pos,
  non_responder_v2_group_params$mu_discount_pos
)

learnrate_neg_v1 <- c(
  responder_v1_group_params$mu_learnrate_neg,
  non_responder_v1_group_params$mu_learnrate_neg
)

learnrate_neg_v2 <- c(
  responder_v2_group_params$mu_learnrate_neg,
  non_responder_v2_group_params$mu_learnrate_neg
)

discount_neg_v1 <- c(
  responder_v1_group_params$mu_discount_neg,
  non_responder_v1_group_params$mu_discount_neg
)

discount_neg_v2 <- c(
  responder_v2_group_params$mu_discount_neg,
  non_responder_v2_group_params$mu_discount_neg
)

beta_v1 <- c(
  responder_v1_group_params$mu_tau,
  non_responder_v1_group_params$mu_tau
)

beta_v2 <- c(
  responder_v2_group_params$mu_tau,
  non_responder_v2_group_params$mu_tau
)

groups <- c(
  rep("R",
    length(responder_v1_group_params$mu_learnrate_pos)
  ),
  rep("NR",
    length(non_responder_v1_group_params$mu_learnrate_pos)
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

saveRDS(groupParams,"Data/visit-2/clinical/ect-response-group/vprl-data/groupParams.rds")


# Individual-level VPRL parameter medians
#responders
responder_v1_individual_params <- extract(
  responder_v1_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

responder_v1_individual_params$tau <- (
  1 / responder_v1_individual_params$tau
)

responder_v2_individual_params <- extract(
  responder_v2_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

responder_v2_individual_params$tau <- (
  1 / responder_v2_individual_params$tau
)

#nonresponders
non_responder_v1_individual_params <- extract(
  non_responder_v1_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

non_responder_v1_individual_params$tau <- (
  1 / non_responder_v1_individual_params$tau
)

non_responder_v2_individual_params <- extract(
  non_responder_v2_vprl_fit,
  pars = c(
    "learnrate_pos",
    "learnrate_neg",
    "discount_pos",
    "discount_neg",
    "tau"
  )
)

non_responder_v2_individual_params$tau <- (
  1 / non_responder_v2_individual_params$tau
)

#get medians
individual_learnrate_pos_v1 <- c(
  apply(
    responder_v1_individual_params$learnrate_pos,
    2,
    median
  ),
  apply(
    non_responder_v1_individual_params$learnrate_pos,
    2,
    median
  )
)

individual_learnrate_pos_v2 <- c(
  apply(
    responder_v2_individual_params$learnrate_pos,
    2,
    median
  ),
  apply(
    non_responder_v2_individual_params$learnrate_pos,
    2,
    median
  )
)

individual_discount_pos_v1 <- c(
  apply(
    responder_v1_individual_params$discount_pos,
    2,
    median
  ),
  apply(
    non_responder_v1_individual_params$discount_pos,
    2,
    median
  )
)

individual_discount_pos_v2 <- c(
  apply(
    responder_v2_individual_params$discount_pos,
    2,
    median
  ),
  apply(
    non_responder_v2_individual_params$discount_pos,
    2,
    median
  )
)

individual_learnrate_neg_v1 <- c(
  apply(
    responder_v1_individual_params$learnrate_neg,
    2,
    median
  ),
  apply(
    non_responder_v1_individual_params$learnrate_neg,
    2,
    median
  )
)

individual_learnrate_neg_v2 <- c(
  apply(
    responder_v2_individual_params$learnrate_neg,
    2,
    median
  ),
  apply(
    non_responder_v2_individual_params$learnrate_neg,
    2,
    median
  )
)

individual_discount_neg_v1 <- c(
  apply(
    responder_v1_individual_params$discount_neg,
    2,
    median
  ),
  apply(
    non_responder_v1_individual_params$discount_neg,
    2,
    median
  )
)

individual_discount_neg_v2 <- c(
  apply(
    responder_v2_individual_params$discount_neg,
    2,
    median
  ),
  apply(
    non_responder_v2_individual_params$discount_neg,
    2,
    median
  )
)

individual_beta_v1 <- c(
  apply(
    responder_v1_individual_params$tau,
    2,
    median
  ),
  apply(
    non_responder_v1_individual_params$tau,
    2,
    median
  )
)

individual_beta_v2 <- c(
  apply(
    responder_v2_individual_params$tau,
    2,
    median
  ),
  apply(
    non_responder_v2_individual_params$tau,
    2,
    median
  )
)

groups <- c(
  rep(
    "R",
    dim(responder_v1_individual_params$learnrate_pos)[2]
  ),
  rep(
    "NR",
    dim(non_responder_v1_individual_params$learnrate_pos)[2]
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

saveRDS(indiv_medians,"Data/visit-2/clinical/ect-response-group/vprl-data/indiv_medians.rds")

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
  R = calc_HDI("R"),
  NR = calc_HDI("NR")
)

saveRDS(hdi,"Data/visit-2/clinical/ect-response-group/vprl-data/ind_level_hdi.rds")


# load in data -------------------------------------------------------------------------------------------------
indiv_medians <- readRDS("Data/visit-2/clinical/ect-response-group/vprl-data/indiv_medians.rds")
groupParams <- readRDS("Data/visit-2/clinical/ect-response-group/vprl-data/groupParams.rds")
hdi <- readRDS("Data/visit-2/clinical/ect-response-group/vprl-data/ind_level_hdi.rds")

# For table -
#visit 1 median & HDI info for each cohort & paremeter
group_med <- function(groupParams, group, parameter) {
group_samples <- groupParams %>%
  filter(groups == group) %>%
  dplyr::select({{parameter}}) %>% unlist() %>% as.numeric()

group_median <- median(group_samples)
hdi <- HDIofMCMC(group_samples)
return(list(group_median, hdi))
}
#alter for each group & parameter
group_med(groupParams, "R", learnrate_pos_v1)
group_med(groupParams, "R", learnrate_pos_v2)


# median difference between visits within cohort
med_difference <- function(groupParams, group, vis1_param, vis2_param) {
  diff_samples <- (groupParams %>% filter(groups==group) %>% dplyr::select({{vis2_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group) %>% dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric())

  diff_med <- median(diff_samples)
  diff_hdi <- HDIofMCMC(diff_samples)
  cred_greater <- (sum(diff_samples>0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred_lesser <- (sum(diff_samples<0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred <- paste0(cred_lesser, '% < 0 < ', cred_greater,'%')

  return(list(diff_med, diff_hdi, cred))
}
#alter for each cohort & parameter comparison
med_difference(groupParams, 'R', learnrate_pos_v1, learnrate_pos_v2)


# median difference in visit parameter changes between cohorts
group_med_difference <- function(groupParams, group1, group2, vis1_param, vis2_param) {
  diff_samples_group1 <- (groupParams %>% filter(groups==group1) %>% dplyr::select({{vis2_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group1) %>% dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric())
  diff_samples_group2 <- (groupParams %>% filter(groups==group2) %>% dplyr::select({{vis2_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group2) %>% dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric())
  group_difference_samples <- (diff_samples_group1 - diff_samples_group2)
  group_difference_samples_med <- median(group_difference_samples)
  diff_hdi <- HDIofMCMC(group_difference_samples)
  cred_greater <- (sum(group_difference_samples>0)/length(group_difference_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred_lesser <- (sum(group_difference_samples<0)/length(group_difference_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred <- paste0(cred_lesser, '% < 0 < ', cred_greater,'%')
  return(list(group_difference_samples_med, diff_hdi, cred))
}

group_med_difference(groupParams, 'R', 'NR', learnrate_pos_v1, learnrate_pos_v2)
