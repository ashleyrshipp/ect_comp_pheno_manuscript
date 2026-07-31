#FIT VPRL MODEL TO EACH INDIVIDUAL PARTICIPANT ONE-AT-A-TIME - ECT COHORT

packages <- c("rstan", "magrittr", "tidyr", "jdtools", "stats", "base")
lapply(packages, require, character.only=TRUE)

source("R/utils_fit-individual-null.R")

#load participants' cleaned choice data
tar_load("cleaned_choice_data")

#parse data by individual
results_null_informed_nonHBA <- list()
cleaned_choice_data <- cleaned_choice_data
parsed_cleaned_choice_data <- split(cleaned_choice_data, cleaned_choice_data$subject)

# Loop through unique subject IDs and fit model
for (i in 1:length(parsed_cleaned_choice_data)) {
  # Get the subject-specific data
  subject_data <- parsed_cleaned_choice_data[[i]]
  subject_results <- fit_ind_null(subject_data)
  results_null_informed_nonHBA[[i]] <- subject_results
}

combined_list <- c(`ind-fit-nonHBA-null-informed`, results_null_informed_nonHBA)
saveRDS(combined_list, "individually-fit-data/ind-fit-vprl.rds")


#get individual parameter medians
individual_vprl_medians <- list()
# Loop through unique subject IDs
for (i in 1:length(combined_list)) {
  # Get the subject-specific data
  pars_vprl <- combined_list[[i]]$pars_vprl_null
  pars_results <- data.frame(
  LearnRate_Pos = apply(pars_vprl$learnrate_pos, 2, median),
  Discount_Pos = apply(pars_vprl$discount_pos, 2, median),
  LearnRate_Neg = apply(pars_vprl$learnrate_neg, 2, median),
  Discount_Neg = apply(pars_vprl$discount_neg, 2, median),
  Tau = apply(pars_vprl$tau, 2, median)
) %>%
  mutate(Beta = 1/Tau) %>%
  dplyr::select(!c("Tau"))
  individual_vprl_medians[[i]] <- pars_results
}

saveRDS(vprl_results, "individually-fit-data/vprl_medians.rds")

