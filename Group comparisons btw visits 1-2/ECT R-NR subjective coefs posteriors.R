### SUBJECTIVE RATING MODEL COEFFICIENT DISTRIBUTIONS - ECT RESPONDERS & NONRESPONDERS
packages <- c("magrittr", "HDInterval", "latex2exp", "dplyr", "tidyverse", "rstan", "hBayesDM",
              "ggplot2", "cowplot", "BEST")

lapply(packages, require, character.only=TRUE)

## group parameter distributions
responder_v1_subj_coef_dists <- readRDS("Data/visit-1/clinical/ect-r/subjective-rating-model-data/subj_coefs_dist.rds")
responder_v2_subj_coef_dists <- readRDS("Data/visit-2/clinical/ect-r/subjective-rating-model-data/subj_coefs_dist.rds")
non_responder_v1_subj_coef_dists <- readRDS("Data/visit-1/clinical/ect-nr/subjective-rating-model-data/subj_coefs_dist.rds")
non_responder_v2_subj_coef_dists <- readRDS("Data/visit-2/clinical/ect-nr/subjective-rating-model-data/subj_coefs_dist.rds")

# visit 1 distributions
intercept_dist_v1 <- c(
  responder_v1_subj_coef_dists$intercept,
  non_responder_v1_subj_coef_dists$intercept
)

rpe_pos_dist_v1 <- c(
  responder_v1_subj_coef_dists$rpe_pos,
  non_responder_v1_subj_coef_dists$rpe_pos
)

rpe_abs_neg_dist_v1 <- c(
  responder_v1_subj_coef_dists$rpe_abs_neg,
  non_responder_v1_subj_coef_dists$rpe_abs_neg
)

ppe_pos_dist_v1 <- c(
  responder_v1_subj_coef_dists$ppe_pos,
  non_responder_v1_subj_coef_dists$ppe_pos
)

ppe_abs_neg_dist_v1 <- c(
  responder_v1_subj_coef_dists$ppe_abs_neg,
  non_responder_v1_subj_coef_dists$ppe_abs_neg
)

ev_chosen_pos_dist_v1 <- c(
  responder_v1_subj_coef_dists$ev_chosen_pos,
  non_responder_v1_subj_coef_dists$ev_chosen_pos
)

ev_unchosen_pos_dist_v1 <- c(
  responder_v1_subj_coef_dists$ev_unchosen_pos,
  non_responder_v1_subj_coef_dists$ev_unchosen_pos
)

ev_chosen_neg_dist_v1 <- c(
  responder_v1_subj_coef_dists$ev_chosen_neg,
  non_responder_v1_subj_coef_dists$ev_chosen_neg
)

ev_unchosen_neg_dist_v1 <- c(
  responder_v1_subj_coef_dists$ev_unchosen_neg,
  non_responder_v1_subj_coef_dists$ev_unchosen_neg
)


# Visit 2 distributions
intercept_dist_v2 <- c(
  responder_v2_subj_coef_dists$intercept,
  non_responder_v2_subj_coef_dists$intercept
)

rpe_pos_dist_v2 <- c(
  responder_v2_subj_coef_dists$rpe_pos,
  non_responder_v2_subj_coef_dists$rpe_pos
)

rpe_abs_neg_dist_v2 <- c(
  responder_v2_subj_coef_dists$rpe_abs_neg,
  non_responder_v2_subj_coef_dists$rpe_abs_neg
)

ppe_pos_dist_v2 <- c(
  responder_v2_subj_coef_dists$ppe_pos,
  non_responder_v2_subj_coef_dists$ppe_pos
)

ppe_abs_neg_dist_v2 <- c(
  responder_v2_subj_coef_dists$ppe_abs_neg,
  non_responder_v2_subj_coef_dists$ppe_abs_neg
)

ev_chosen_pos_dist_v2 <- c(
  responder_v2_subj_coef_dists$ev_chosen_pos,
  non_responder_v2_subj_coef_dists$ev_chosen_pos
)

ev_unchosen_pos_dist_v2 <- c(
  responder_v2_subj_coef_dists$ev_unchosen_pos,
  non_responder_v2_subj_coef_dists$ev_unchosen_pos
)

ev_chosen_neg_dist_v2 <- c(
  responder_v2_subj_coef_dists$ev_chosen_neg,
  non_responder_v2_subj_coef_dists$ev_chosen_neg
)

ev_unchosen_neg_dist_v2 <- c(
  responder_v2_subj_coef_dists$ev_unchosen_neg,
  non_responder_v2_subj_coef_dists$ev_unchosen_neg
)

groups <- c(
  rep("R", length(responder_v1_subj_coef_dists$intercept)),
  rep("NR", length(non_responder_v1_subj_coef_dists$intercept))
)

subj_coef_dists <- data.frame(
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

saveRDS(subj_coef_dists, "Data/visit-2/clinical/ect-response-group/subjective-rating-model-data/vis1vis2_subj_coef_dists.rds")

## Group medians
responder_v1_subj_coef_medians <- readRDS("Data/visit-1/clinical/ect-r/subjective-rating-model-data/subj_coefs_med.rds")
responder_v2_subj_coef_medians <- readRDS("Data/visit-2/clinical/ect-r/subjective-rating-model-data/subj_coefs_med.rds")
non_responder_v1_subj_coef_medians <- readRDS("Data/visit-1/clinical/ect-nr/subjective-rating-model-data/subj_coefs_med.rds")
non_responder_v2_subj_coef_medians <- readRDS("Data/visit-2/clinical/ect-nr/subjective-rating-model-data/subj_coefs_med.rds")

# Visit 1 medians
intercept_median_v1 <- c(
  responder_v1_subj_coef_medians$intercept,
  non_responder_v1_subj_coef_medians$intercept
)

rpe_pos_median_v1 <- c(
  responder_v1_subj_coef_medians$rpe_pos,
  non_responder_v1_subj_coef_medians$rpe_pos
)

rpe_abs_neg_median_v1 <- c(
  responder_v1_subj_coef_medians$rpe_abs_neg,
  non_responder_v1_subj_coef_medians$rpe_abs_neg
)

ppe_pos_median_v1 <- c(
  responder_v1_subj_coef_medians$ppe_pos,
  non_responder_v1_subj_coef_medians$ppe_pos
)

ppe_abs_neg_median_v1 <- c(
  responder_v1_subj_coef_medians$ppe_abs_neg,
  non_responder_v1_subj_coef_medians$ppe_abs_neg
)

ev_chosen_pos_median_v1 <- c(
  responder_v1_subj_coef_medians$ev_chosen_pos,
  non_responder_v1_subj_coef_medians$ev_chosen_pos
)

ev_unchosen_pos_median_v1 <- c(
  responder_v1_subj_coef_medians$ev_unchosen_pos,
  non_responder_v1_subj_coef_medians$ev_unchosen_pos
)

ev_chosen_neg_median_v1 <- c(
  responder_v1_subj_coef_medians$ev_chosen_neg,
  non_responder_v1_subj_coef_medians$ev_chosen_neg
)

ev_unchosen_neg_median_v1 <- c(
  responder_v1_subj_coef_medians$ev_unchosen_neg,
  non_responder_v1_subj_coef_medians$ev_unchosen_neg
)


# Visit 2 medians
intercept_median_v2 <- c(
  responder_v2_subj_coef_medians$intercept,
  non_responder_v2_subj_coef_medians$intercept
)

rpe_pos_median_v2 <- c(
  responder_v2_subj_coef_medians$rpe_pos,
  non_responder_v2_subj_coef_medians$rpe_pos
)

rpe_abs_neg_median_v2 <- c(
  responder_v2_subj_coef_medians$rpe_abs_neg,
  non_responder_v2_subj_coef_medians$rpe_abs_neg
)

ppe_pos_median_v2 <- c(
  responder_v2_subj_coef_medians$ppe_pos,
  non_responder_v2_subj_coef_medians$ppe_pos
)

ppe_abs_neg_median_v2 <- c(
  responder_v2_subj_coef_medians$ppe_abs_neg,
  non_responder_v2_subj_coef_medians$ppe_abs_neg
)

ev_chosen_pos_median_v2 <- c(
  responder_v2_subj_coef_medians$ev_chosen_pos,
  non_responder_v2_subj_coef_medians$ev_chosen_pos
)

ev_unchosen_pos_median_v2 <- c(
  responder_v2_subj_coef_medians$ev_unchosen_pos,
  non_responder_v2_subj_coef_medians$ev_unchosen_pos
)

ev_chosen_neg_median_v2 <- c(
  responder_v2_subj_coef_medians$ev_chosen_neg,
  non_responder_v2_subj_coef_medians$ev_chosen_neg
)

ev_unchosen_neg_median_v2 <- c(
  responder_v2_subj_coef_medians$ev_unchosen_neg,
  non_responder_v2_subj_coef_medians$ev_unchosen_neg
)

groups <- c(
  rep("R", length(responder_v1_subj_coef_medians$intercept)),
  rep("NR", length(non_responder_v1_subj_coef_medians$intercept))
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

saveRDS(subj_coef_meds, "Data/visit-2/clinical/ect-response-group/subjective-rating-model-data/vis1vis2_subj_coef_meds.rds")

## Calculate HDI
calc_HDI <- function(group) {
  int_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(intercept_dist_vis1) %>% t() %>%
    HDIofMCMC()

  int_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(intercept_dist_vis2) %>% t() %>%
    HDIofMCMC()

    rpe_pos_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    rpe_pos_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_pos_dist_vis2) %>% t() %>%
    HDIofMCMC()

    rpe_abs_neg_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_abs_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    rpe_abs_neg_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(rpe_abs_neg_dist_vis2) %>% t() %>%
    HDIofMCMC()

    ppe_pos_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ppe_pos_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_pos_dist_vis2) %>% t() %>%
    HDIofMCMC()

    ppe_abs_neg_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_abs_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ppe_abs_neg_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ppe_abs_neg_dist_vis2) %>% t() %>%
    HDIofMCMC()

    ev_chosen_pos_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_chosen_pos_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_pos_dist_vis2) %>% t() %>%
    HDIofMCMC()

    ev_unchosen_pos_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_unchosen_pos_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_pos_dist_vis2) %>% t() %>%
    HDIofMCMC()

    ev_chosen_neg_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_chosen_neg_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_chosen_neg_dist_vis2) %>% t() %>%
    HDIofMCMC()

    ev_unchosen_neg_vis1 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_unchosen_neg_vis2 <- subj_coef_dists %>%
    filter(groups == group) %>%
    dplyr::select(ev_unchosen_neg_dist_vis2) %>% t() %>%
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

hdi <- list(R=calc_HDI("R"),
            NR=calc_HDI("NR"))
saveRDS(hdi, "Data/visit-2/clinical/ect-response-group/subjective-rating-model-data/vis1vis2_subj_coef_hdi.rds")


# load in data ------------------------------------------------------------------------------------
groupParams <- readRDS("Data/visit-2/clinical/ect-response-group/subjective-rating-model-data/vis1vis2_subj_coef_dists.rds")
indiv_medians <- readRDS("Data/visit-2/clinical/ect-response-group/subjective-rating-model-data/vis1vis2_subj_coef_meds.rds")
hdi <- readRDS("Data/visit-2/clinical/ect-response-group/subjective-rating-model-data/vis1vis2_subj_coef_hdi.rds")

## For table -
#Median & HDI info for each cohort, visit, & coefficient
group_med <- function(groupParams, group, parameter) {
group_samples <- groupParams %>%
  filter(groups == group) %>%
  dplyr::select({{parameter}}) %>% unlist() %>% as.numeric()

group_median <- median(group_samples)

hdi <- HDIofMCMC(group_samples)

return(list(group_median, hdi))
}
#alter for each cohort & coefficient
group_med(groupParams, "R", rpe_pos_dist_vis1)
group_med(groupParams, "R", rpe_pos_dist_vis2)

# Median difference btw visits within a cohort
med_difference <- function(groupParams, group, vis1_param, vis2_param) {
  diff_samples <- (groupParams %>% filter(groups==group) %>% dplyr::select({{vis2_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group) %>% dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric())

  diff_median <- median(diff_samples)
  diff_hdi <- HDIofMCMC(diff_samples)

  cred_greater <- (sum(diff_samples>0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred_lesser <- (sum(diff_samples<0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred <- paste0(cred_lesser, '% < 0 < ', cred_greater,'%')

  return(list(diff_median, diff_hdi, cred))
}
#alter for each cohort, coefficient & visit
med_difference(groupParams, 'R', rpe_pos_dist_vis1, rpe_pos_dist_vis2)

# Median difference in visit coefficient changes between cohorts
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
#alter for each comparison
group_med_difference(groupParams, 'R', 'NR', rpe_pos_dist_vis1, rpe_pos_dist_vis2)
