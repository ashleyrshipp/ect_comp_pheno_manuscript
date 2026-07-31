# SEPARATE PCAs USING PARAMETER MEDIANS FROM GROUP-FIT VPRL + SUBJECTIVE RATING REGRESSION MODELS

packages <- c("FactoMineR", "factoextra", "kableExtra", "base", "dplyr", "ggplot2", "graphics", "stats", "corrplot")
lapply(packages, require, character.only=TRUE)
source("codes/R/utils_pca_functions.R")

# VPRL params  ------------------------------------

#vprl visit 1
ect_v1_vprl_medians <- readRDS("Data/visit-1/ect/group-fit-data/vprl/vprl_medians.rds")
non_ect_v1_vprl_medians <- readRDS("Data/visit-1/non-ect/group-fit-data/vprl/vprl_medians.rds")
no_depression_v1_vprl_medians <- readRDS("Data/visit-1/no-depression/group-fit-data/vprl/vprl_medians.rds")

v1_vprl_medians <- bind_rows(
  ect_v1_vprl_medians,
  non_ect_v1_vprl_medians,
  no_depression_v1_vprl_medians
)

vprl_cohort <- c(
  rep("pre-ECT", nrow(ect_v1_vprl_medians)),
  rep("non-ECT", nrow(non_ect_v1_vprl_medians)),
  rep("no-depression", nrow(no_depression_v1_vprl_medians))
)

#visit 1 pca
v1_vprl_pca_data <- v1_vprl_medians[, -6]
rownames(v1_vprl_pca_data) <- v1_vprl_medians[, 6]
v1_vprl_pca <- PCA(v1_vprl_pca_data, graph = FALSE, ncp = 5)

#dimensions
vprl_eigenvalues <- get_eigenvalue(v1_vprl_pca)
vprl_eigenvalues %>%
  round(2) %>%
  kable(align = "lccrr", booktabs = TRUE) %>%
  kable_styling(latex_options = "striped")

#pca scores
vprl_pca_model <- prcomp(v1_vprl_pca_data, scale = TRUE)
vprl_pca_scores <- data.frame(vprl_pca_model$x) %>%
  mutate(cohort = vprl_cohort)

## corrplot
#loadings
vprl_loadings_data <- vprl_pca_model$rotation %>%
  as.data.frame() %>%
  dplyr::select(c("PC1", "PC2"))

par(family = "Arial")
vprl_loadings <- process_loadings_data_vprl(vprl_loadings_data)

corrplot(
  vprl_loadings,
  method = "color",
  tl.cex = 1.75,
  tl.col = "black",
  addgrid.col = "black",
  cl.pos = "n",
  tl.offset = 0.7,
  addCoef.col = "black",
  number.cex = 1.5,
  mar = c(2, 0, 1, 0)
)

corrplot(
  vprl_loadings,
  method = "color",
  tl.pos = "n",
  addgrid.col = "black",
  cl.pos = "n",
  addCoef.col = "black",
  number.cex = 1.5
)

corrplot(
  vprl_loadings,
  method = "color",
  addgrid.col = "black",
  addCoef.col = "black",
  number.cex = 1.5
)

#plot
vprl_pca_scores$cohort <- factor(
  vprl_pca_scores$cohort,
  levels = c("no-depression", "pre-ECT", "non-ECT")
)

cohort_colors <- c("#979799", "#20A4F3", "#652A57")

plot_theme <- theme(
  legend.position = "none",
  plot.title = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  panel.border = element_rect(color = "gray", fill = NA, size = 1),
  axis.text.y = element_text(color = "black", family = "Arial", size = 20),
  axis.text.x = element_text(color = "black", family = "Arial", size = 20),
  axis.title.y = element_text(color = "black", family = "Arial", size = 22),
  axis.title.x = element_text(color = "black", family = "Arial", size = 22)
)


ggplot(vprl_pca_scores, aes(x = PC1, y = PC2, fill = cohort)) +
  geom_point(aes(fill = cohort), pch = 21, colour = "black", size = 6) +
  stat_ellipse(
    aes(x = PC1, y = PC2, fill = cohort, color = cohort),
    type = "norm",
    level = 0.8,
    size = 0.4,
    geom = "polygon",
    alpha = 0.1
  ) +
  scale_fill_manual(values = cohort_colors, name = "Cohort:") +
  scale_color_manual(values = cohort_colors, name = "Cohort:") +
  labs(x = "Principal Component 1", y = "Principal Component 2") +
  geom_vline(xintercept = c(0, 0), linetype = "dashed", color = "gray") +
  geom_hline(yintercept = c(0, 0), linetype = "dashed", color = "gray") +
  plot_theme +
  scale_x_continuous(
    limits = c(-4, 5),
    breaks = seq(-4, 4, by = 2),
    labels = function(x) ifelse(x == 0, "0", as.character(x))
  ) +
  scale_y_continuous(
    limits = c(-3, 3.5),
    breaks = seq(-2, 2, by = 2),
    labels = function(x) ifelse(x == 0, "0", as.character(x))
  )

#pairs plot
vprl_components <- data.frame(vprl_pca_scores)
vprl_components$cohort <- factor(
  vprl_components$cohort,
  levels = c("no-depression", "pre-ECT", "non-ECT")
)

create_pairs_plot1t5(vprl_components, cohort_colors)


# Subj params  ------------------------------------

#subj vis 1
ect_v1_subj_medians <- readRDS("Data/visit-1/ect/group-fit-data/subj/sub_feels_coefs.rds")
non_ect_v1_subj_medians <- readRDS("Data/visit-1/non-ect/group-fit-data/subj/sub_feels_coefs.rds")
no_depression_v1_subj_medians <- readRDS("Data/visit-1/no-depression/group-fit-data/subj/sub_feels_coefs.rds")

v1_subj_medians <- bind_rows(
  ect_v1_subj_medians,
  non_ect_v1_subj_medians,
  no_depression_v1_subj_medians
) %>%
  dplyr::select(-c("sigma"))

subj_cohort <- c(
  rep("pre-ECT", nrow(ect_v1_subj_medians)),
  rep("non-ECT", nrow(non_ect_v1_subj_medians)),
  rep("no-depression", nrow(no_depression_v1_subj_medians))
)

#visit 1 pca
v1_subj_pca_data <- v1_subj_medians[, -10]
rownames(v1_subj_pca_data) <- v1_subj_medians[, 10]
v1_subj_pca <- PCA(v1_subj_pca_data, graph = FALSE, ncp = 9)

#dimensions
subj_eigenvalues <- get_eigenvalue(v1_subj_pca)
subj_eigenvalues %>%
  round(2) %>%
  kable(align = "lccrr", booktabs = TRUE) %>%
  kable_styling(latex_options = "striped")

#pca scores
subj_pca_model <- prcomp(v1_subj_pca_data, scale = TRUE)
subj_pca_scores <- data.frame(subj_pca_model$x) %>%
  mutate(cohort = subj_cohort)

## corrplot
#loadings
subj_loadings_data <- subj_pca_model$rotation %>%
  as.data.frame() %>%
  dplyr::select(c("PC1", "PC2"))

subj_loadings_data_rotated <- subj_loadings_data * -1

subj_loadings <- process_loadings_data_subj(subj_loadings_data_rotated)

corrplot(
  subj_loadings,
  method = "color",
  tl.cex = 1.3,
  tl.col = "black",
  addgrid.col = "black",
  cl.pos = "n",
  tl.srt = 45,
  tl.offset = 0.7,
  addCoef.col = "black",
  number.cex = 1,
  cl.align.text = "r"
)

corrplot(
  subj_loadings,
  method = "color",
  tl.pos = "n",
  addgrid.col = "black",
  cl.pos = "n",
  addCoef.col = "black",
  number.cex = 1.4
)

#plot
subj_pca_scores$cohort <- factor(
  subj_pca_scores$cohort,
  levels = c("no-depression", "pre-ECT", "non-ECT")
)

subj_cohort <- subj_pca_scores$cohort

subj_pca_scores_rotated <- data.frame(subj_pca_scores[, 1:9] * -1) %>%
  mutate(cohort = subj_cohort)

subj_pca_scores_rotated$cohort <- factor(
  subj_pca_scores_rotated$cohort,
  levels = c("no-depression", "pre-ECT", "non-ECT")
)

cohort_colors <- c("#979799", "#20A4F3", "#652A57")

plot_theme <- theme(
  legend.position = "none",
  plot.title = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  panel.border = element_rect(color = "gray", fill = NA, size = 1),
  axis.text.y = element_text(color = "black", family = "Arial", size = 20),
  axis.text.x = element_text(color = "black", family = "Arial", size = 20),
  axis.title.y = element_text(color = "black", family = "Arial", size = 22),
  axis.title.x = element_text(color = "black", family = "Arial", size = 22)
)

ggplot(subj_pca_scores_rotated, aes(x = PC1, y = PC2, fill = cohort)) +
  geom_point(aes(fill = cohort), pch = 21, colour = "black", size = 6) +
  stat_ellipse(
    aes(x = PC1, y = PC2, fill = cohort, color = cohort),
    type = "norm",
    level = 0.8,
    size = 0.4,
    geom = "polygon",
    alpha = 0.1
  ) +
  scale_fill_manual(values = cohort_colors, name = "Cohort:") +
  scale_color_manual(values = cohort_colors, name = "Cohort:") +
  labs(x = "Principal Component 1", y = "Principal Component 2") +
  geom_vline(xintercept = c(0, 0), linetype = "dashed", color = "gray") +
  geom_hline(yintercept = c(0, 0), linetype = "dashed", color = "gray") +
  plot_theme


#pairs plot
subj_components <- data.frame(subj_pca_scores)
subj_components$cohort <- factor(
  subj_components$cohort,
  levels = c("no-depression", "pre-ECT", "non-ECT")
)

create_pairs_plot1t9(subj_components, cohort_colors)

