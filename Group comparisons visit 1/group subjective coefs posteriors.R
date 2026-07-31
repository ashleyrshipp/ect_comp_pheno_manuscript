# SUBJECTIVE RATING REGRESSION GROUP-LEVEL POSTERIOR DISTRIBUTION INFORMATION

packages <- c("dplyr", "stats", "base", "cowplot", "ggplot2", "hBayesDM", "latex2exp")
lapply(packages, require, character.only=TRUE)

# group parameters
# visit 1
vis1_no_depression_coefs_dists <- readRDS("Data/visit-1/no-depression/group-fit-data/subj/sub_feels_coefs_dists.rds")
vis1_ect_coefs_dists <- readRDS("Data/visit-1/ect/group-fit-data/subj/sub_feels_coefs_dists.rds")
vis1_non_ect_coefs_dists <- readRDS("Data/visit-1/non-ect/group-fit-data/subj/sub_feels_coefs_dists.rds")

int_dist_vis1 <- c(vis1_no_depression_coefs_dists$intercept, vis1_ect_coefs_dists$intercept, vis1_non_ect_coefs_dists$intercept)
rpe_pos_dist_vis1 <- c(vis1_no_depression_coefs_dists$rpe_pos, vis1_ect_coefs_dists$rpe_pos, vis1_non_ect_coefs_dists$rpe_pos)
rpe_abs_neg_dist_vis1 <- c(vis1_no_depression_coefs_dists$rpe_abs_neg, vis1_ect_coefs_dists$rpe_abs_neg, vis1_non_ect_coefs_dists$rpe_abs_neg)
ppe_pos_dist_vis1 <- c(vis1_no_depression_coefs_dists$ppe_pos, vis1_ect_coefs_dists$ppe_pos, vis1_non_ect_coefs_dists$ppe_pos)
ppe_abs_neg_dist_vis1 <- c(vis1_no_depression_coefs_dists$ppe_abs_neg, vis1_ect_coefs_dists$ppe_abs_neg, vis1_non_ect_coefs_dists$ppe_abs_neg)
ev_chosen_pos_dist_vis1 <- c(vis1_no_depression_coefs_dists$ev_chosen_pos, vis1_ect_coefs_dists$ev_chosen_pos, vis1_non_ect_coefs_dists$ev_chosen_pos)
ev_unchosen_pos_dist_vis1 <- c(vis1_no_depression_coefs_dists$ev_unchosen_pos, vis1_ect_coefs_dists$ev_unchosen_pos, vis1_non_ect_coefs_dists$ev_unchosen_pos)
ev_chosen_neg_dist_vis1 <- c(vis1_no_depression_coefs_dists$ev_chosen_neg, vis1_ect_coefs_dists$ev_chosen_neg, vis1_non_ect_coefs_dists$ev_chosen_neg)
ev_unchosen_neg_dist_vis1 <- c(vis1_no_depression_coefs_dists$ev_unchosen_neg, vis1_ect_coefs_dists$ev_unchosen_neg, vis1_non_ect_coefs_dists$ev_unchosen_neg)

groups <- c(rep('no-depression', length(vis1_no_depression_coefs_dists$intercept)),
            rep('ect', length(vis1_ect_coefs_dists$intercept)),
            rep('non-ect', length(vis1_non_ect_coefs_dists$intercept)))

subjective_coef_distributions <- data.frame(int_dist_vis1,
                              rpe_pos_dist_vis1,
                              rpe_abs_neg_dist_vis1,
                              ppe_pos_dist_vis1,
                              ppe_abs_neg_dist_vis1,
                              ev_chosen_pos_dist_vis1,
                              ev_unchosen_pos_dist_vis1,
                              ev_chosen_neg_dist_vis1,
                              ev_unchosen_neg_dist_vis1,
                              groups)
saveRDS(subjective_coef_distributions, "subj_data/sub_coef_dists.rds")

## Medians
vis1_no_depression_coefs <- readRDS("Data/visit-1/no-depression/group-fit-data/subj/sub_feels_coefs.rds")
vis1_ect_coefs <- readRDS("Data/visit-1/ect/group-fit-data/subj/sub_feels_coefs.rds")
vis1_non_ect_coefs <- readRDS("Data/visit-1/non-ect/group-fit-data/subj/sub_feels_coefs.rds")

int_med_vis1 <- c(vis1_no_depression_coefs$intercept, vis1_ect_coefs$intercept, vis1_non_ect_coefs$intercept)
rpe_pos_med_vis1 <- c(vis1_no_depression_coefs$rpe_pos, vis1_ect_coefs$rpe_pos, vis1_non_ect_coefs$rpe_pos)
rpe_abs_neg_med_vis1 <- c(vis1_no_depression_coefs$rpe_abs_neg, vis1_ect_coefs$rpe_abs_neg, vis1_non_ect_coefs$rpe_abs_neg)
ppe_pos_med_vis1 <- c(vis1_no_depression_coefs$ppe_pos, vis1_ect_coefs$ppe_pos, vis1_non_ect_coefs$ppe_pos)
ppe_abs_neg_med_vis1 <- c(vis1_no_depression_coefs$ppe_abs_neg, vis1_ect_coefs$ppe_abs_neg, vis1_non_ect_coefs$ppe_abs_neg)
ev_chosen_pos_med_vis1 <- c(vis1_no_depression_coefs$ev_chosen_pos, vis1_ect_coefs$ev_chosen_pos, vis1_non_ect_coefs$ev_chosen_pos)
ev_unchosen_pos_med_vis1 <- c(vis1_no_depression_coefs$ev_unchosen_pos, vis1_ect_coefs$ev_unchosen_pos, vis1_non_ect_coefs$ev_unchosen_pos)
ev_chosen_neg_med_vis1 <- c(vis1_no_depression_coefs$ev_chosen_neg, vis1_ect_coefs$ev_chosen_neg, vis1_non_ect_coefs$ev_chosen_neg)
ev_unchosen_neg_med_vis1 <- c(vis1_no_depression_coefs$ev_unchosen_neg, vis1_ect_coefs$ev_unchosen_neg, vis1_non_ect_coefs$ev_unchosen_neg)

groups <- c(rep('no-depression', length(vis1_no_depression_coefs$intercept)),
            rep('ect', length(vis1_ect_coefs$intercept)),
            rep('non-ect', length(vis1_non_ect_coefs$intercept)))

subjective_coef_medians <- data.frame(int_med_vis1,
                             rpe_pos_med_vis1,
                             rpe_abs_neg_med_vis1,
                             ppe_pos_med_vis1,
                             ppe_abs_neg_med_vis1,
                             ev_chosen_pos_med_vis1,
                             ev_unchosen_pos_med_vis1,
                             ev_chosen_neg_med_vis1,
                             ev_unchosen_neg_med_vis1,
                             groups)
saveRDS(subjective_coef_medians, "subj_data/sub_coef_meds.rds")

## Calculate HDI
calc_HDI <- function(group) {
  int_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(int_dist_vis1) %>% t() %>%
    HDIofMCMC()

    rpe_pos_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(rpe_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    rpe_abs_neg_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(rpe_abs_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ppe_pos_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(ppe_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ppe_abs_neg_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(ppe_abs_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_chosen_pos_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(ev_chosen_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_unchosen_pos_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(ev_unchosen_pos_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_chosen_neg_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(ev_chosen_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

    ev_unchosen_neg_vis1 <- subjective_coef_distributions %>%
    filter(groups == group) %>%
    select(ev_unchosen_neg_dist_vis1) %>% t() %>%
    HDIofMCMC()

return(data.frame(int_vis1,
                  rpe_pos_vis1,
                  rpe_abs_neg_vis1,
                  ppe_pos_vis1,
                  ppe_abs_neg_vis1,
                  ev_chosen_pos_vis1,
                  ev_unchosen_pos_vis1,
                  ev_chosen_neg_vis1,
                  ev_unchosen_neg_vis1))

}

hdi <- list(no_depression=calc_hdi_results("no-depression"),
            ect=calc_hdi_results("ect"),
            non_ect=calc_hdi_results("non-ect"))
saveRDS(hdi, "subj_data/sub_coef_hdi.rds")


# load in data ------------------------------------------------------------------------------------
group_params <- readRDS("Data/visit-1/group/subj_data/sub_coef_dists.rds")
individual_medians <- readRDS("Data/visit-1/group/subj_data/sub_coef_meds.rds")
hdi <- readRDS("Data/visit-1/group/subj_data/sub_coef_hdi.rds")


## For table -
#median info for each cohort
group_med <- function(group_params, group, vis1_param) {
group_samples <- group_params %>%
  filter(groups == group) %>%
  dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric()
group_median <- median(group_samples)
hdi <- HDIofMCMC(group_samples)
return(list(group_med, hdi))
}
#alter for each cohort & coefficient
group_median(group_params, "no-depression", rpe_pos_dist_vis1)


#median difference between cohorts
group_med_difference <- function(group_params, group1, group2, vis1_param) {
  diff_samples <- (groupParams %>% filter(groups==group1) %>% dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric()) -
    (groupParams %>% filter(groups==group2) %>% dplyr::select({{vis1_param}}) %>% unlist() %>% as.numeric())
  diff_samples_med <- median(diff_samples)
  diff_hdi <- HDIofMCMC(diff_samples)
  cred_greater <- (sum(diff_samples>0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred_lesser <- (sum(diff_samples<0)/length(diff_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  cred <- paste0(cred_lesser, '% < 0 < ', cred_greater,'%')
  return(list(diff_samples_med, diff_hdi, cred))
}
#alter cohorts and coefficient
group_median_difference(group_params, 'no-depression', 'ect', rpe_pos_dist_vis1)

# Posterior Density Plots with HDI and individual medians on the HDIs
#plot aesthetics
point_size <- 2
alpha_value <- 0.5
group_colors <- c("#20A4F3", "#652A57","#979799")
group_line_colors <- c("#20A4F3", "#652A57","#979799")
font_size <- 1

plot_theme <- theme(legend.position = "none",
        axis.text.x=element_text(color="black",size=18),
        axis.text.y=element_text(color="black",size=18),
        axis.title.x=element_text(color="black",size=24),
        axis.title.y=element_blank())

# Set y-axis offset in graph for each group's individual medians
individual_medians$groupsY <- c(-1)
group_params$groups <- factor(group_params$groups, levels=c("ect", "non-ect", "no-depression"))

#Plot subj coef comparisons
#beta +RPE
individual_medians$groupsY[individual_medians$groups=="ect"] <- -0.04
individual_medians$groupsY[individual_medians$groups=="non-ect"] <- -0.08
individual_medians$groupsY[individual_medians$groups=="no-depression"] <- -0.12

rpe_pos_plot<-ggplot(group_params, aes(x=rpe_pos_dist_vis1, y = ..scaled.., fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{+delta^{P}_{t}}")) +
  geom_segment(aes(x = hdi$ect$rpe_pos_vis1[1],   xend = hdi$ect$rpe_pos_vis1[2],   y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$rpe_pos_vis1[1],    xend = hdi$non_ect$rpe_pos_vis1[2],    y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$rpe_pos_vis1[1], xend = hdi$no_depression$rpe_pos_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=rpe_pos_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))
#beta -RPE
rpe_neg_plot<-ggplot(group_params, aes(x=rpe_abs_neg_dist_vis1, y=..scaled..,fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{-delta^{P}_{t}}")) +
  geom_segment(aes(x = hdi$ect$rpe_abs_neg_vis1[1],   xend = hdi$ect$rpe_abs_neg_vis1[2],   y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$rpe_abs_neg_vis1[1],    xend = hdi$non_ect$rpe_abs_neg_vis1[2],    y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$rpe_abs_neg_vis1[1], xend = hdi$no_depression$rpe_abs_neg_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
 # geom_point(individual_medians, mapping = aes(x=rpe_abs_neg_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))
#beta +PPE
ppe_pos_plot<-ggplot(group_params, aes(x=ppe_pos_dist_vis1, y = ..scaled.., fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{+delta^{N}_{t}}")) +
  geom_segment(aes(x = hdi$ect$ppe_pos_vis1[1],   xend = hdi$ect$ppe_pos_vis1[2],   y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$ppe_pos_vis1[1],    xend = hdi$non_ect$ppe_pos_vis1[2],    y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$ppe_pos_vis1[1], xend = hdi$no_depression$ppe_pos_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=ppe_pos_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))
#beta -PPE
ppe_neg_plot<-ggplot(group_params, aes(x=ppe_abs_neg_dist_vis1, y = ..scaled.., fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{-delta^{N}_{t}}")) +
  geom_segment(aes(x = hdi$ect$ppe_abs_neg_vis1[1],   xend = hdi$ect$ppe_abs_neg_vis1[2],   y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$ppe_abs_neg_vis1[1],    xend = hdi$non_ect$ppe_abs_neg_vis1[2],     y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$ppe_abs_neg_vis1[1], xend = hdi$no_depression$ppe_abs_neg_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=ppe_abs_neg_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))
#beta Pos EV Chosen
ev_chosen_pos_plot<-ggplot(group_params, aes(x=ev_chosen_pos_dist_vis1, y=..scaled.., fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{Q^{P}_{s_t,a_t,chosen}}")) +
  geom_segment(aes(x = hdi$ect$ev_chosen_pos_vis1[1],   xend = hdi$ect$ev_chosen_pos_vis1[2],   y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$ev_chosen_pos_vis1[1],    xend = hdi$non_ect$ev_chosen_pos_vis1[2],     y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$ev_chosen_pos_vis1[1], xend = hdi$no_depression$ev_chosen_pos_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=ev_chosen_pos_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))
#beta Pos EV Unchosen
ev_unchosen_pos_plot<-ggplot(group_params, aes(x=ev_unchosen_pos_dist_vis1, y=..scaled..,fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{Q^{P}_{s_t,a_t,unchosen}}")) +
  geom_segment(aes(x = hdi$ect$ev_unchosen_pos_vis1[1],   xend = hdi$ect$ev_unchosen_pos_vis1[2],  y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$ev_unchosen_pos_vis1[1],    xend = hdi$non_ect$ev_unchosen_pos_vis1[2],     y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$ev_unchosen_pos_vis1[1], xend = hdi$no_depression$ev_unchosen_pos_vis1[2],y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=ev_unchosen_pos_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))
#beta Neg EV Chosen
ev_chosen_neg_plot<-ggplot(group_params, aes(x=ev_chosen_neg_dist_vis1, y=..scaled..,fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{Q^{N}_{s_t,a_t,chosen}}")) +
  geom_segment(aes(x = hdi$ect$ev_chosen_neg_vis1[1],   xend = hdi$ect$ev_chosen_neg_vis1[2],   y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$ev_chosen_neg_vis1[1],    xend = hdi$non_ect$ev_chosen_neg_vis1[2],     y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$ev_chosen_neg_vis1[1], xend = hdi$no_depression$ev_chosen_neg_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=ev_chosen_neg_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors, name = c(""), labels=c("pre-ECT", "non-ECT", "Controls")) +
  scale_fill_manual(values=group_colors, name = c(""), labels=c("pre-ECT", "non-ECT", "Controls")) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))


#beta Neg EV Unchosen
ev_unchosen_neg_plot<-ggplot(group_params, aes(x=ev_unchosen_neg_dist_vis1, y=..scaled.., fill=groups), color="black") +
  geom_density(alpha = 0.4) + theme_classic() + labs(x=TeX("$\\beta_{Q^{N}_{s_t,a_t,unchosen}}")) +
  geom_segment(aes(x = hdi$ect$ev_unchosen_neg_vis1[1],   xend = hdi$ect$ev_unchosen_neg_vis1[2],  y = -0.04, yend = -0.04), color = I(group_colors[1]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$non_ect$ev_unchosen_neg_vis1[1],    xend = hdi$non_ect$ev_unchosen_neg_vis1[2],    y = -0.08, yend = -0.08), color = I(group_colors[2]), size = 2, alpha = 1) +
  geom_segment(aes(x = hdi$no_depression$ev_unchosen_neg_vis1[1], xend = hdi$no_depression$ev_unchosen_neg_vis1[2], y = -0.12, yend = -0.12), color = I(group_colors[3]), size = 2, alpha = 1) +
  #geom_point(individual_medians, mapping = aes(x=ev_unchosen_neg_med_vis1 , y=groupsY), color='#634821', stroke=0, alpha=0.5, size=point_size)  +
  scale_color_manual(values=group_line_colors)+
  scale_fill_manual(values=group_colors) +
  plot_theme +
  scale_x_continuous(labels = function(x) ifelse(x == 0.00, "0", as.character(x))) +
  scale_y_continuous(limits=c(-0.12,1), breaks=seq(0,1, by = 0.5),
                     labels = function(x) ifelse(x == 0.00, "0", as.character(x)))

p1 <- plot_grid(rpe_pos_plot,rpe_neg_plot,ev_chosen_pos_plot,ev_unchosen_pos_plot, ncol=4, nrow=1)
p2 <- plot_grid(ppe_pos_plot,ppe_neg_plot,ev_chosen_neg_plot,ev_unchosen_neg_plot, ncol=4, nrow=1)
