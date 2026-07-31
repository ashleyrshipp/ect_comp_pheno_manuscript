# LOOCV LDA MODEL USING INDIVIDUALLY-FIT VPRL + SUBJ COEF PARAMS

packages <- c("graphics", "base", "MASS", "ROCR", "pROC", "FactoMineR", "factoextra",
              "dplyr", "ggplot2", "stats", "caret", "verification")
lapply(packages, require, character.only=TRUE)


#visit 1 individually fit subjective rating regression parameters
ect_v1_subj_medians <- readRDS("Data/visit-1/ect/individually-fit-data/ind_sub_medians.rds")
non_ect_v1_subj_medians <- readRDS("Data/visit-1/non-ect/individually-fit-data/ind_sub_medians.rds")
no_depression_v1_subj_medians <- readRDS("Data/visit-1/no-depression/individually-fit-data/ind_sub_medians.rds")

v1_subj_medians <- bind_rows(
  no_depression_v1_subj_medians,
  ect_v1_subj_medians,
  non_ect_v1_subj_medians
) %>%
  data.frame()

#visit 1 individually fit vprl parameters
no_depression_v1_vprl_medians <- readRDS("Data/visit-1/no-depression/individually-fit-data/ind_vprl_medians.rds")
no_depression_v1_vprl_medians <- data.frame(do.call(rbind, no_depression_v1_vprl_medians))
ect_v1_vprl_medians <- readRDS("Data/visit-1/ect/individually-fit-data/ind_vprl_medians.rds")
ect_v1_vprl_medians <- data.frame(do.call(rbind, ect_v1_vprl_medians))
non_ect_v1_vprl_medians <- readRDS("Data/visit-1/non-ect/individually-fit-data/ind_vprl_medians.rds")
non_ect_v1_vprl_medians <- data.frame(do.call(rbind, non_ect_v1_vprl_medians))

#visit 1 subjects
subject_ids <- rep(
  seq_len(nrow(no_depression_v1_vprl_medians)),
  seq_len(nrow(ect_v1_vprl_medians)),
  seq_len(nrow(non_ect_v1_vprl_medians)))

cohort_ids <- c(
  rep("no-depression", nrow(no_depression_v1_vprl_medians)),
  rep("ect", nrow(ect_v1_vprl_medians)),
  rep("non-ect", nrow(non_ect_v1_vprl_medians)))

v1_vprl_medians <- bind_rows(
  no_depression_v1_vprl_medians,
  ect_v1_vprl_medians,
  non_ect_v1_vprl_medians
) %>%
  cbind(subject_ids) %>%
  rename("subject" = "subject_ids") %>%
  mutate(
    subject = sprintf("%02d", subject),
    cohort = glue::glue("{cohort_ids}_{subject}")
  ) %>%
  dplyr::select(!(subject)) %>%
  rename("subject" = "cohort")

# tidy data
v1_data <- merge(
  v1_subj_medians,
  v1_vprl_medians,
  by = "subject"
) %>%
  data.frame() %>%
  mutate(
    cohort = case_when(
      grepl("^(ect|non_ect)_", subject) ~ "Depression",
      grepl("^no-depression_", subject) ~ "No Depression",
      TRUE ~ NA_character_
    )
  )

v1_lda_data <- v1_data[, -1]
rownames(v1_lda_data) <- v1_data[, 1]

# LOOCV LDA
loo_lda <- lda(
  cohort ~ .,
  data = v1_lda_data,
  CV = TRUE
)

confusion_table <- table(
  Predicted = loo_lda$class,
  Actual = v1_lda_data$cohort
)

confusion_results <- confusionMatrix(confusion_table)

#histograms
lda_model <- lda(
  cohort ~ .,
  data = v1_lda_data
)

lda_predictions <- predict(lda_model)

depression_cohort <- v1_lda_data$cohort
lda_scores <- data.frame(lda_predictions$x) %>%
  mutate(cohort = depression_cohort)

lda_scores$cohort <- factor(
  lda_scores$cohort,
  levels = c("Depression", "No Depression")
)

ggplot(lda_scores, aes(x=LD1, fill=cohort)) +
  geom_histogram(aes(fill=cohort, color=cohort), binwidth=.1,
                 position="identity",alpha = 1) +
  labs(y = "Count", x = "LDA Scores \n (VPRL & Subjective Experience Parameters)") +
  theme_minimal() +
  scale_fill_manual(values=c("#34ba7e","grey60"), name="",
                    labels=c("Depression", "No Depression")) +
  scale_color_manual(values=c("#34ba7e","grey60"), name="",
                     labels=c("Depression", "No Depression")) +
  theme(legend.position=c(0.85,0.927),
        axis.title.x = element_text(size=20, color="black"),
        axis.text.x = element_text(size=18, color="black"),
        axis.title.y = element_text(size=20, color="black"),
        axis.text.y = element_text(size=18, color="black"),
        legend.text = element_text(size=18, color="black")) +
  scale_y_continuous(breaks=seq(0,5,by=1)) +
  scale_x_continuous(breaks=seq(-3,3,by=1))


#ROC Curve
actual_cohorts <- v1_lda_data %>%
  mutate(
    cohort = ifelse(v1_lda_data$cohort == "Depression", 1, 0)
  ) %>%
  dplyr::select("cohort")

loo_data <- cbind(
  loo_lda$posterior,
  actual_cohorts$cohort
) %>%
  data.frame() %>%
  dplyr::select("Depression", "V3") %>%
  rename("actual" = "V3")

loo_data$actual <- factor(loo_data$actual)

#stats
loo_data <- cbind(
  loo_lda$posterior,
  actual_cohorts$cohort
) %>%
  data.frame() %>%
  dplyr::select("Depression", "V3") %>%
  rename("actual" = "V3")

roc_area <- roc.area(
  loo_data$actual,
  loo_data$Depression
)

roc_results <- roc(
  loo_data$actual,
  loo_data$Depression,
  ci = TRUE
)

#plot
ggroc(roc_results, colour = "#34ba7e", size=2, legacy.axes=TRUE) +
  labs(x = "False Positive Rate",
       y = "True Positive Rate") +
  theme_minimal() +
    theme(axis.text.x = element_text(size=18, color="black"),
        axis.text.y = element_text(size=18, color="black"),
        axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        plot.title = element_text(size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black")) +
  geom_segment(aes(x=0, xend=1, y=0, yend=1), color="grey", linetype="dashed") +
  annotate("text", x=0.7, y=0.15, label=paste("AUC = 0.90 (0.83, 0.97) \n p = 2.28e-12"), size=6) +
  scale_x_continuous(labels = function(x) ifelse(x == .00, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == .00, "0", sprintf("%.2f", x)))
