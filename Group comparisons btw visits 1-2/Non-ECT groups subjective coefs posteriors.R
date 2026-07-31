### SUBJECTIVE RATING MODEL COEFFICIENT DISTRIBUTIONS - NON-ECT & NO-DEPRESSION GROUPS
packages <- c("magrittr", "HDInterval", "latex2exp", "dplyr", "tidyverse", "rstan", "hBayesDM",
              "ggplot2", "cowplot", "BEST")

lapply(packages, require, character.only=TRUE)

## Group parameter distributions
# visit 1
no_depression_v1_subj_coef_dists <- readRDS("Data/visit-1/no-depression/subjective-rating-model-data/subj_coefs_dist.rds")
non_ect_v1_subj_coef_dists <- readRDS("Data/visit-1/non-ect/subjective-rating-model-data/subj_coefs_dist.rds")
intercept_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$intercept,
  non_ect_v1_subj_coef_dists$intercept
)

rpe_pos_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$rpe_pos,
  non_ect_v1_subj_coef_dists$rpe_pos
)

rpe_abs_neg_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$rpe_abs_neg,
  non_ect_v1_subj_coef_dists$rpe_abs_neg
)

ppe_pos_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$ppe_pos,
  non_ect_v1_subj_coef_dists$ppe_pos
)

ppe_abs_neg_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$ppe_abs_neg,
  non_ect_v1_subj_coef_dists$ppe_abs_neg
)

ev_chosen_pos_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$ev_chosen_pos,
  non_ect_v1_subj_coef_dists$ev_chosen_pos
)

ev_unchosen_pos_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$ev_unchosen_pos,
  non_ect_v1_subj_coef_dists$ev_unchosen_pos
)

ev_chosen_neg_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$ev_chosen_neg,
  non_ect_v1_subj_coef_dists$ev_chosen_neg
)

ev_unchosen_neg_dist_v1 <- c(
  no_depression_v1_subj_coef_dists$ev_unchosen_neg,
  non_ect_v1_subj_coef_dists$ev_unchosen_neg
)

# visit 2
no_depression_v2_subj_coef_dists <- readRDS("Data/visit-2/no-depression/subjective-rating-model-data/subj_coefs_dist.rds")
non_ect_v2_subj_coef_dists <- readRDS("Data/visit-2/non-ect/subjective-rating-model-data/subj_coefs_dist.rds")

intercept_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$intercept,
  non_ect_v2_subj_coef_dists$intercept
)

rpe_pos_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$rpe_pos,
  non_ect_v2_subj_coef_dists$rpe_pos
)

rpe_abs_neg_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$rpe_abs_neg,
  non_ect_v2_subj_coef_dists$rpe_abs_neg
)

ppe_pos_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$ppe_pos,
  non_ect_v2_subj_coef_dists$ppe_pos
)

ppe_abs_neg_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$ppe_abs_neg,
  non_ect_v2_subj_coef_dists$ppe_abs_neg
)

ev_chosen_pos_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$ev_chosen_pos,
  non_ect_v2_subj_coef_dists$ev_chosen_pos
)

ev_unchosen_pos_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$ev_unchosen_pos,
  non_ect_v2_subj_coef_dists$ev_unchosen_pos
)

ev_chosen_neg_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$ev_chosen_neg,
  non_ect_v2_subj_coef_dists$ev_chosen_neg
)

ev_unchosen_neg_dist_v2 <- c(
  no_depression_v2_subj_coef_dists$ev_unchosen_neg,
  non_ect_v2_subj_coef_dists$ev_unchosen_neg
)

groups <- c(
  rep(
    "no-depression",
    length(no_depression_v1_subj_coef_dists$intercept)
  ),
  rep(
    "non-ect",
    length(non_ect_v1_subj_coef_dists$intercept)
  )
)


subj_coef_distributions <- data.frame(
  intercept_dist_v1,
  intercept_dist_v2,
  rpe_pos_dist_v1,
  rpe_pos_dist_v2,
  rpe_abs_neg_dist_v1,
  rpe_abs_neg_dist_v2,
  ppe_pos_dist_v1,
  ppe_pos_dist_v2,
  ppe_abs_neg_dist_v1,
  ppe_abs_neg_dist_v2,
  ev_chosen_pos_dist_v1,
  ev_chosen_pos_dist_v2,
  ev_unchosen_pos_dist_v1,
  ev_unchosen_pos_dist_v2,
  ev_chosen_neg_dist_v1,
  ev_chosen_neg_dist_v2,
  ev_unchosen_neg_dist_v1,
  ev_unchosen_neg_dist_v2,
  groups
)

saveRDS(subj_coef_distributions,"Data/visit-2/non-ect-vs-no-depression/subjective-rating-model-data/vis1vis2_subj_coef_dists.rds")


## Medians
#visit 1
no_depression_v1_subj_coef_medians <- readRDS("Data/visit-1/no-depression/subjective-rating-model-data/subj_coefs_med.rds")
non_ect_v1_subj_coef_medians <- readRDS("Data/visit-1/non-ect/subjective-rating-model-data/subj_coefs_med.rds")

intercept_median_v1 <- c(
  no_depression_v1_subj_coef_medians$intercept,
  non_ect_v1_subj_coef_medians$intercept
)

rpe_pos_median_v1 <- c(
  no_depression_v1_subj_coef_medians$rpe_pos,
  non_ect_v1_subj_coef_medians$rpe_pos
)

rpe_abs_neg_median_v1 <- c(
  no_depression_v1_subj_coef_medians$rpe_abs_neg,
  non_ect_v1_subj_coef_medians$rpe_abs_neg
)

ppe_pos_median_v1 <- c(
  no_depression_v1_subj_coef_medians$ppe_pos,
  non_ect_v1_subj_coef_medians$ppe_pos
)

ppe_abs_neg_median_v1 <- c(
  no_depression_v1_subj_coef_medians$ppe_abs_neg,
  non_ect_v1_subj_coef_medians$ppe_abs_neg
)

ev_chosen_pos_median_v1 <- c(
  no_depression_v1_subj_coef_medians$ev_chosen_pos,
  non_ect_v1_subj_coef_medians$ev_chosen_pos
)

ev_unchosen_pos_median_v1 <- c(
  no_depression_v1_subj_coef_medians$ev_unchosen_pos,
  non_ect_v1_subj_coef_medians$ev_unchosen_pos
)

ev_chosen_neg_median_v1 <- c(
  no_depression_v1_subj_coef_medians$ev_chosen_neg,
  non_ect_v1_subj_coef_medians$ev_chosen_neg
)

ev_unchosen_neg_median_v1 <- c(
  no_depression_v1_subj_coef_medians$ev_unchosen_neg,
  non_ect_v1_subj_coef_medians$ev_unchosen_neg
)


# Visit 2
no_depression_v2_subj_coef_medians <- readRDS("Data/visit-2/no-depression/subjective-rating-model-data/subj_coefs_med.rds")
non_ect_v2_subj_coef_medians <- readRDS("Data/visit-2/non-ect/subjective-rating-model-data/subj_coefs_med.rds")

intercept_median_v2 <- c(
  no_depression_v2_subj_coef_medians$intercept,
  non_ect_v2_subj_coef_medians$intercept
)

rpe_pos_median_v2 <- c(
  no_depression_v2_subj_coef_medians$rpe_pos,
  non_ect_v2_subj_coef_medians$rpe_pos
)

rpe_abs_neg_median_v2 <- c(
  no_depression_v2_subj_coef_medians$rpe_abs_neg,
  non_ect_v2_subj_coef_medians$rpe_abs_neg
)

ppe_pos_median_v2 <- c(
  no_depression_v2_subj_coef_medians$ppe_pos,
  non_ect_v2_subj_coef_medians$ppe_pos
)

ppe_abs_neg_median_v2 <- c(
  no_depression_v2_subj_coef_medians$ppe_abs_neg,
  non_ect_v2_subj_coef_medians$ppe_abs_neg
)

ev_chosen_pos_median_v2 <- c(
  no_depression_v2_subj_coef_medians$ev_chosen_pos,
  non_ect_v2_subj_coef_medians$ev_chosen_pos
)

ev_unchosen_pos_median_v2 <- c(
  no_depression_v2_subj_coef_medians$ev_unchosen_pos,
  non_ect_v2_subj_coef_medians$ev_unchosen_pos
)

ev_chosen_neg_median_v2 <- c(
  no_depression_v2_subj_coef_medians$ev_chosen_neg,
  non_ect_v2_subj_coef_medians$ev_chosen_neg
)

ev_unchosen_neg_median_v2 <- c(
  no_depression_v2_subj_coef_medians$ev_unchosen_neg,
  non_ect_v2_subj_coef_medians$ev_unchosen_neg
)

groups <- c(
  rep("no-depression", length(no_depression_v1_subj_coef_medians$intercept)),
  rep("non-ect", length(non_ect_v1_subj_coef_medians$intercept))
)

subj_coef_medians <- data.frame(
  intercept_median_v1,
  intercept_median_v2,
  rpe_pos_median_v1,
  rpe_pos_median_v2,
  rpe_abs_neg_median_v1,
  rpe_abs_neg_median_v2,
  ppe_pos_median_v1,
  ppe_pos_median_v2,
  ppe_abs_neg_median_v1,
  ppe_abs_neg_median_v2,
  ev_chosen_pos_median_v1,
  ev_chosen_pos_median_v2,
  ev_unchosen_pos_median_v1,
  ev_unchosen_pos_median_v2,
  ev_chosen_neg_median_v1,
  ev_chosen_neg_median_v2,
  ev_unchosen_neg_median_v1,
  ev_unchosen_neg_median_v2,
  groups
)

saveRDS(subj_coef_medians,"Data/visit-2/non-ect-vs-no-depression/subjective-rating-model-data/vis1vis2_subj_coef_meds.rds")


## Calculate HDI
calc_HDI <- function(group) {
  intercept_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(intercept_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  intercept_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(intercept_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  rpe_pos_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_pos_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  rpe_pos_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_pos_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  rpe_abs_neg_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_abs_neg_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  rpe_abs_neg_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_abs_neg_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  ppe_pos_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_pos_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  ppe_pos_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_pos_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  ppe_abs_neg_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_abs_neg_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  ppe_abs_neg_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_abs_neg_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  ev_chosen_pos_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_pos_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  ev_chosen_pos_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_pos_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  ev_unchosen_pos_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_pos_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  ev_unchosen_pos_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_pos_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  ev_chosen_neg_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_neg_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  ev_chosen_neg_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_neg_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  ev_unchosen_neg_v1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_neg_dist_v1) %>%
    t() %>%
    HDIofMCMC()

  ev_unchosen_neg_v2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_neg_dist_v2) %>%
    t() %>%
    HDIofMCMC()

  return(
    data.frame(
      intercept_v1,
      intercept_v2,
      rpe_pos_v1,
      rpe_pos_v2,
      rpe_abs_neg_v1,
      rpe_abs_neg_v2,
      ppe_pos_v1,
      ppe_pos_v2,
      ppe_abs_neg_v1,
      ppe_abs_neg_v2,
      ev_chosen_pos_v1,
      ev_chosen_pos_v2,
      ev_unchosen_pos_v1,
      ev_unchosen_pos_v2,
      ev_chosen_neg_v1,
      ev_chosen_neg_v2,
      ev_unchosen_neg_v1,
      ev_unchosen_neg_v2
    )
  )
}

hdi <- list(
  no_depression = calc_HDI("no-depression"),
  non_ect = calc_HDI("non-ect")
)

saveRDS(hdi,"Data/visit-2/non-ect-vs-no-depression/subjective-rating-model-data/vis1vis2_subj_coef_hdi.rds")

# load in data ------------------------------------------------------------------------------------
groupParams <- readRDS("Data/visit-2/non-ect-vs-no-depression/subjective-rating-model-data/vis1vis2_subj_coef_dists.rds")
indiv_medians <- readRDS("Data/visit-2/non-ect-vs-no-depression/subjective-rating-model-data/vis1vis2_subj_coef_meds.rds")
hdi <- readRDS("Data/visit-2/non-ect-vs-no-depression/subjective-rating-model-data/vis1vis2_subj_coef_hdi.rds")


## For table -
#visit 1 median info for each cohort
group_med <- function(groupParams, group, vis1_param) {
group_samples <- groupParams %>%
  filter(groups == group) %>%
  dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric()

group_median <- median(group_samples)
hdi <- HDIofMCMC(group_samples)

return(list(group_median, hdi))
}
#alter cohort & coefficient
group_med(groupParams, "no-depression", rpe_pos_dist_v1)
group_med(groupParams, "no-depression", rpe_pos_dist_v2)

# Median difference between visits within cohort
med_difference <- function(groupParams, group, vis1_param, vis2_param) {
  diff_samples <- (groupParams %>% filter(groups==group) %>% select({{vis2_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group) %>% select({{vis1_param}}) %>% unlist() %>% as.numeric())

  diff_median <- median(diff_samples)
  diff_hdi <- HDIofMCMC(diff_samples)

  cred_greater <- (sum(diff_samples>0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred_lesser <- (sum(diff_samples<0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred <- paste0(cred_lesser, '% < 0 < ', cred_greater,'%')

  return(list(diff_med, diff_hdi, cred))
}

#alter cohort & coefficient
med_difference(groupParams, 'no-depression', rpe_pos_dist_vis1, rpe_pos_dist_vis2)
