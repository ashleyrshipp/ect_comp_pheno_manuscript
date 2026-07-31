# PCA - INDIVIDUALLY-FIT VPRL + SUBJ COEF PARAMETERS

packages <- c("FactoMineR", "factoextra", "kableExtra", "base", "dplyr",
              "ggplot2", "graphics", "stats", "corrplot")
lapply(packages, require, character.only=TRUE)
source("R/utils_pca_functions.R")

cohort <- c(rep("Controls", 40), rep("ECT",29), rep("non-ECT",40))

#visit 1 individually-fit subjective rating regression parameters
ect_v1_subj_medians <- readRDS("Data/visit-1/ect/individually-fit-data/ind_sub_medians.rds")
non_ect_v1_subj_medians <- readRDS("Data/visit-1/non-ect/individually-fit-data/ind_sub_medians.rds")
no_depression_v1_subj_medians <- readRDS("Data/visit-1/no-depression/individually-fit-data/ind_sub_medians.rds")

#tidy data
v1_subj_medians <- bind_rows(
  no_depression_v1_subj_medians,
  ect_v1_subj_medians,
  non_ect_v1_subj_medians
) %>%
  data.frame()

#visit 1 individually-fit vprl params
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

v1_vprl <-bind_rows(no_depression_v1_vprl_medians, ect_v1_vprl_medians, non_ect_v1_vprl_medians) %>%
  cbind(subject_ids) %>%
  rename("subject" = "subject_ids") %>%
  mutate(subject = sprintf("%02d", subject),
         cohort=glue::glue("{cohort_ids}_{subject_ids}")) %>%
  dplyr::select(!(subject)) %>%
  rename("subject" = "cohort")

# tidy data
v1_data <- merge(
  v1_subj_medians,
  v1_vprl_medians,
  by = "subject"
) %>%
  data.frame()

# pca
v1_pca_data <- v1_data[, -1]
rownames(v1_pca_data) <- v1_data[, 1]

v1_pca <- PCA(
  v1_pca_data,
  graph = FALSE,
  ncp = 14
)

#dimensions
eigenvalues <- get_eigenvalue(v1_pca)

eigenvalues %>%
  round(2) %>%
  kable(
    align = "lccrr",
    booktabs = TRUE
  ) %>%
  kable_styling(
    latex_options = "striped"
  )

# pca scores
pca_model <- prcomp(
  v1_pca_data,
  scale = TRUE
)

pca_scores <- data.frame(pca_comp$x) %>%
  mutate(cohort=cohort_ids)

## corrplot
#loadings
loadings_data <- pca_model$rotation %>%
  as.data.frame() %>%
  dplyr::select(c("PC1", "PC2"))

loadings <- process_loadings_data_subj_vprl(
  loadings_data
)

corrplot(loadings,method = 'color', tl.cex = 1, tl.col = "black",
         addgrid.col = "black",cl.pos="n",tl.srt=45,tl.offset=0.7,
         addCoef.col="black",number.cex=0.6)
corrplot(loadings,method = 'color', tl.cex = 1, tl.col = "black",
         addgrid.col = "black",cl.pos="n",tl.srt=45,tl.offset=0.7,
         addCoef.col="black",number.cex=0.6)


#plot
pca_scores$cohort <-factor(pca_scores$cohort,levels=c("non-ECT", "pre-ECT", "no-depression"))
cohort_colors <- c("#652A57","#20A4F3","#979799")
plot_theme<-theme(legend.position = 'none',
        plot.title=element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border = element_rect(color = "gray", fill = NA, size = 1),
        axis.text.y = element_text(color="black", family="Arial", size=20),
        axis.text.x = element_text(color="black", family="Arial",size=20),
        axis.title.y = element_text(color="black", family="Arial",size=22),
        axis.title.x = element_text(color="black",family="Arial",size=22))

ggplot(pca_scores, aes(x = PC1, y = PC2, fill=cohort)) +
  geom_point(aes(fill=cohort), pch=21, colour="black", size=6) +
  scale_fill_manual(values=cohort_colors, name="Cohort:") +
  scale_color_manual(values=cohort_colors, name="Cohort:") +
    labs(x='VPRL PC 1', y='Subjective Experience PC 2') +
  geom_vline(xintercept=c(0,0), linetype="dashed", color="gray") +
  geom_hline(yintercept=c(0,0), linetype="dashed", color="gray") +
  ggtheme +
  scale_x_continuous(limits=c(-2.5, 7), breaks = seq(-2.5,5,by = 2.5),
                     labels = function(x) ifelse(x == 0, "0", as.character(x))) +
  scale_y_continuous(limits=c(-4.5, 4.5), breaks = seq(-4,4,by = 2),
                     labels = function(x) ifelse(x == 0, "0", as.character(x)))

#pairs plot
components <- data.frame(pca_scores)
components$cohort <-factor(components$cohort,levels=c("non-ECT", "ECT", "Controls"))
colors <- c("#652A57", "#20A4F3", "#979799")
create_pairs_plot1t7(components, colors)
create_pairs_plot8t14(components, colors)
