# VPRL GROUP-LEVEL POSTERIOR DISTRIBUTION INFORMATION

packages <- c("dplyr", "stats", "base", "cowplot", "ggplot2", "hBayesDM", "latex2exp")
lapply(packages, require, character.only=TRUE)

# get visit 1 vprl mu distributions
no_depression_v1_group_params <- readRDS("Data/visit-1/no-depression/group-fit-data/vprl/vprl_mean_distributions.rds")
ect_v1_group_params <- readRDS("Data/visit-1/ect/group-fit-data/vprl/vprl_mean_distributions.rds")
non_ect_v1_group_params <- readRDS("Data/visit-1/non-ect/group-fit-data/vprl/vprl_mean_distributions.rds")

# group parameters
learn_rate_pos_v1 <- c(no_depression_v1_group_params$mu_LearnRate_Pos, ect_v1_group_params$mu_LearnRate_Pos, non_ect_v1_group_params$mu_LearnRate_Pos)
discount_pos_v1 <- c(no_depression_v1_group_params$mu_Discount_Pos, ect_v1_group_params$mu_Discount_Pos, non_ect_v1_group_params$mu_Discount_Pos)
learn_rate_neg_v1 <- c(no_depression_v1_group_params$mu_LearnRate_Neg, ect_v1_group_params$mu_LearnRate_Neg, non_ect_v1_group_params$mu_LearnRate_Neg)
discount_neg_v1 <- c(no_depression_v1_group_params$mu_Discount_Neg, ect_v1_group_params$mu_Discount_Neg, non_ect_v1_group_params$mu_Discount_Neg)
beta_v1 <- c(no_depression_v1_group_params$mu_Beta, ect_v1_group_params$mu_Beta, non_ect_v1_group_params$mu_Beta)

cohort <- c(
  rep('no-depression', length(no_depression_v1_group_params$mu_LearnRate_Pos)),
  rep('ect', length(ect_v1_group_params$mu_LearnRate_Pos)),
  rep('non-ect', length(non_ect_v1_group_params$mu_LearnRate_Pos)))

group_params <- data.frame(learn_rate_pos_v1, discount_pos_v1, learn_rate_neg_v1, discount_neg_v1, beta_v1, cohort)
saveRDS(group_params, "vprl_data/vprl_group_params.rds")

# get visit 1 individual-level medians
no_depression_v1_ind_params <- readRDS("Data/visit-1/no-depression/group-fit-data/vprl/vprl_medians.rds")
ect_v1_ind_params <- readRDS("Data/visit-1/ect/group-fit-data/vprl/vprl_medians.rds")
non_ect_v1_ind_params <- readRDS("Data/visit-1/non-ect/group-fit-data/vprl/vprl_medians.rds")

learn_rate_pos_ind_v1 <- c(no_depression_v1_ind_params$LearnRate_Pos, ect_v1_ind_params$LearnRate_Pos, non_ect_v1_ind_params$LearnRate_Pos)
discount_pos_ind_v1 <- c(no_depression_v1_ind_params$Discount_Pos, ect_v1_ind_params$Discount_Pos, non_ect_v1_ind_params$Discount_Pos)
learn_rate_neg_ind_v1 <- c(no_depression_v1_ind_params$LearnRate_Neg, ect_v1_ind_params$LearnRate_Neg, non_ect_v1_ind_params$LearnRate_Neg)
discount_neg_ind_v1 <- c(no_depression_v1_ind_params$Discount_Neg, ect_v1_ind_params$Discount_Neg, non_ect_v1_ind_params$Discount_Neg)
beta_ind_v1 <- c(no_depression_v1_ind_params$Beta, ect_v1_ind_params$Beta, non_ect_v1_ind_params$Beta)

cohort <- c(
  rep("no-depression", nrow(no_depression_v1_ind_params)),
  rep("ect", nrow(ect_v1_ind_params)),
  rep("non-ect", nrow(non_ect_v1_ind_params)))

individual_medians <- data.frame(learn_rate_pos_ind_v1, discount_pos_ind_v1, learn_rate_neg_ind_v1, discount_neg_ind_v1, beta_ind_v1, cohort)
saveRDS(individual_medians, "vprl_data/vprl_medians.rds")

# Calculate HDI
calc_hdi <- function(group) {
  learn_rate_pos_ind_v1 <- group_params %>%
    filter(cohort == group) %>%
    dplyr::select(learn_rate_pos_v1) %>% t() %>%
    HDIofMCMC()

discount_pos_ind_v1 <- group_params %>%
    filter(cohort == group) %>%
    dplyr::select(discount_pos_v1) %>% t() %>%
    HDIofMCMC()

  learn_rate_neg_ind_v1 <- group_params %>%
    filter(cohort == group) %>%
    dplyr::select(learn_rate_neg_v1) %>% t() %>%
    HDIofMCMC()

  discount_neg_ind_v1 <- group_params %>%
    filter(cohort == group) %>%
    dplyr::select(discount_neg_v1) %>% t() %>%
    HDIofMCMC()

  beta_ind_v1 <- group_params %>%
    filter(cohort == group) %>%
    dplyr::select(beta_v1) %>% t() %>%
    HDIofMCMC()

return(data.frame(learn_rate_pos_ind_v1,discount_pos_ind_v1, learn_rate_neg_ind_v1, discount_neg_ind_v1, beta_ind_v1))
}

hdi <- list(
  ect = calc_hdi("ect"),
  non_ect = calc_hdi("non-ect"),
  no_depression = calc_hdi("no-depression"))

saveRDS(hdi, "vprl_data/vprl_hdi.rds")

# import data ------------------------------------------------------------------------------------------
group_params <- readRDS("Data/visit-1/group/vprl_data/vprl_group_params.rds")
hdi <- readRDS("Data/visit-1/group/vprl_data/vprl_hdi.rds")

# find median difference between cohorts - for tables
group_median_difference <- function(group_params, group_1, group_2, v1_param) {
  difference_samples <- (group_params %>% filter(cohort==group_1) %>% dplyr::select({{v1_param}}) %>% unlist() %>% as.numeric()) -
    (group_params %>% filter(cohort==group_2) %>% dplyr::select({{v1_param}}) %>% unlist() %>% as.numeric())
  difference_median <- median(difference_samples)
  difference_hdi <- HDIofMCMC(difference_samples)
  probability_greater <- (sum(difference_samples>0)/length(difference_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  probability_lesser <- (sum(difference_samples<0)/length(difference_samples) * 100) %>% round(2) %>% format(., nsmall = 2)
  probability_summary <- paste0(probability_lesser, '% < 0 < ', probability_greater,'%')
  return(list(difference_median, difference_hdi, probability_summary))
}

#alter for each comparison & parameter
group_median_difference(group_params, 'no-depression', 'ect', learn_rate_pos_v1)

#find median for each cohort - for tables
group_median <- function(group_params, group, v1_param) {
cohort_samples <- group_params %>%
  filter(cohort == group) %>%
  dplyr::select({{v1_param}}) %>% unlist() %>% as.numeric()
cohort_median <- median(cohort_samples)
hdi <- HDIofMCMC(cohort_samples)
return(list(cohort_median, hdi))
}
#alter for each cohort & parameter
group_median(group_params, "no-depression", learn_rate_pos_v1)


# Plot posterior distributions
ect_plot_params <- readRDS("Data/visit-1/ect/group-fit-data/vprl/vprl_mean_distributions.rds")
non_ect_plot_params <- readRDS("Data/visit-1/non-ect/group-fit-data/vprl/vprl_mean_distributions.rds")
no_depression_plot_params <- readRDS("Data/visit-1/no-depression/group-fit-data/vprl/vprl_mean_distributions.rds")

x_axis_breaks <- data.frame(x = c(0, 0.25, 0.50, 0.75, 1))

#mu_LearnRate_Pos
plot_data <- as.data.frame(cbind(ect_plot_params$mu_LearnRate_Pos,
                       non_ect_plot_params$mu_LearnRate_Pos,
                       no_depression_plot_params$mu_LearnRate_Pos)) %>%
  rename("pre-ECT" = V1,
         "non-ECT" = V2,
         "no-depression" = V3)

ect_hdi <- HDIofMCMC(plot_data$`pre-ECT`)
non_ect_hdi <- HDIofMCMC(plot_data$`non-ECT`)
no_depression_hdi  <- HDIofMCMC(plot_data$`no-depression`)

ect_density_plot <- ggplot(plot_data, aes(x = `pre-ECT`,y=..scaled..)) +
  geom_density(fill = I("#20A4F3"), alpha = 0.7) +
  geom_segment(aes(x = ect_hdi[1], xend = ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  #xlab(TeX("$\\alpha^{P}")) +
  ylab("Posterior \n Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_text(size=16),
        axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

non_ect_density_plot <- ggplot(plot_data, aes(x = `non-ECT`,y=..scaled..)) +
  geom_density(fill = I("#652A57"), alpha = 0.7) +
  geom_segment(aes(x = non_ect_hdi[1], xend = non_ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  #xlab(TeX("$\\alpha^{P}")) +
  ylab("Posterior \n Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_text(size=16),
        axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

no_depression_density_plot <- ggplot(plot_data, aes(x = `no-depression`, y=..scaled..)) +
  geom_density(fill = I("#979799"), alpha = 0.7) +
  geom_segment(aes(x = no_depression_hdi[1], xend = no_depression_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\alpha^{P}")) +
  ylab("Posterior \n Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_text(size=16),
        axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

learn_rate_pos_panel <- plot_grid(ect_density_plot, non_ect_density_plot, no_depression_density_plot, ncol = 1, nrow = 3) +
  theme(plot.margin = unit(c(0.5,0,0,0), "cm"))

#mu_LearnRate_Neg
plot_data <- as.data.frame(cbind(ect_plot_params$mu_LearnRate_Neg,
                       non_ect_plot_params$mu_LearnRate_Neg,
                       no_depression_plot_params$mu_LearnRate_Neg)) %>%
  rename("pre-ECT" = V1,
         "non-ECT" = V2,
         "no-depression" = V3)

ect_hdi <- HDIofMCMC(plot_data$`pre-ECT`)
non_ect_hdi <- HDIofMCMC(plot_data$`non-ECT`)
no_depression_hdi  <- HDIofMCMC(plot_data$`no-depression`)

ect_density_plot <- ggplot(plot_data, aes(x = `pre-ECT`, y=..scaled..)) +
  geom_density(fill = I("#20A4F3"), alpha = .7) +
  geom_segment(aes(x = ect_hdi[1], xend = ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\alpha^{N}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
   theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

non_ect_density_plot <- ggplot(plot_data, aes(x = `non-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#652A57"), alpha = .7) +
  geom_segment(aes(x = non_ect_hdi[1], xend = non_ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\alpha^{N}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
   theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

no_depression_density_plot <- ggplot(plot_data, aes(x = `no-depression`,y=..scaled..)) +
  geom_density(fill = I("#979799"), alpha = .7) +
  geom_segment(aes(x = no_depression_hdi[1], xend = no_depression_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\alpha^{N}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
 theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

learn_rate_neg_panel <- plot_grid(ect_density_plot, non_ect_density_plot, no_depression_density_plot, ncol = 1, nrow = 3)+
  theme(plot.margin = unit(c(0.5,0,0,0), "cm"))


#mu_Discount_Pos
plot_data <- as.data.frame(cbind(ect_plot_params$mu_Discount_Pos,
                       non_ect_plot_params$mu_Discount_Pos,
                       no_depression_plot_params$mu_Discount_Pos)) %>%
  rename("pre-ECT" = V1,
         "non-ECT" = V2,
         "no-depression" = V3)

ect_hdi <- HDIofMCMC(plot_data$`pre-ECT`)
non_ect_hdi <- HDIofMCMC(plot_data$`non-ECT`)
no_depression_hdi  <- HDIofMCMC(plot_data$`no-depression`)

ect_density_plot <- ggplot(plot_data, aes(x = `pre-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#20A4F3"), alpha = .7) +
  geom_segment(aes(x = ect_hdi[1], xend = ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\gamma^{P}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

non_ect_density_plot <- ggplot(plot_data, aes(x = `non-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#652A57"), alpha = .7) +
  geom_segment(aes(x = non_ect_hdi[1], xend = non_ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\gamma^{P}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

no_depression_density_plot <- ggplot(plot_data, aes(x = `no-depression`, y = ..scaled..)) +
  geom_density(fill = I("#979799"), alpha = .7) +
  geom_segment(aes(x = no_depression_hdi[1], xend = no_depression_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\gamma^{P}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

discount_pos_panel <-plot_grid(ect_density_plot, non_ect_density_plot, no_depression_density_plot, ncol = 1, nrow = 3)+
  theme(plot.margin = unit(c(0.5,0,0,0), "cm"))


#mu_Discount_Neg
plot_data <- as.data.frame(cbind(ect_plot_params$mu_Discount_Neg,
                       non_ect_plot_params$mu_Discount_Neg,
                       no_depression_plot_params$mu_Discount_Neg)) %>%
  rename("pre-ECT" = V1,
         "non-ECT" = V2,
         "no-depression" = V3)

ect_hdi <- HDIofMCMC(plot_data$`pre-ECT`)
non_ect_hdi <- HDIofMCMC(plot_data$`non-ECT`)
no_depression_hdi  <- HDIofMCMC(plot_data$`no-depression`)

ect_density_plot <- ggplot(plot_data, aes(x = `pre-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#20A4F3"), alpha = .7) +
  geom_segment(aes(x = ect_hdi[1], xend = ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\gamma^{N}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

non_ect_density_plot <- ggplot(plot_data, aes(x = `non-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#652A57"), alpha = .7) +
  geom_segment(aes(x = non_ect_hdi[1], xend = non_ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\gamma^{N}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

no_depression_density_plot <- ggplot(plot_data, aes(x = `no-depression`, y = ..scaled..)) +
  geom_density(fill = I("#979799"), alpha = .7) +
  geom_segment(aes(x = no_depression_hdi[1], xend = no_depression_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\gamma^{N}")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

discount_neg_panel <- plot_grid(ect_density_plot, non_ect_density_plot, no_depression_density_plot, ncol = 1, nrow = 3)+
  theme(plot.margin = unit(c(0.5,0,0,0), "cm"))

#mu_Beta
plot_data <- as.data.frame(cbind(ect_plot_params$mu_Beta,
                       non_ect_plot_params$mu_Beta,
                       no_depression_plot_params$mu_Beta)) %>%
  rename("pre-ECT" = V1,
         "non-ECT" = V2,
         "no-depression" = V3)

ect_hdi <- HDIofMCMC(plot_data$`pre-ECT`)
non_ect_hdi <- HDIofMCMC(plot_data$`non-ECT`)
no_depression_hdi  <- HDIofMCMC(plot_data$`no-depression`)

ect_density_plot <- ggplot(plot_data, aes(x = `pre-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#20A4F3"), alpha = .7) +
  geom_segment(aes(x = ect_hdi[1], xend = ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\1/tau")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

non_ect_density_plot <- ggplot(plot_data, aes(x = `non-ECT`, y = ..scaled..)) +
  geom_density(fill = I("#652A57"), alpha = .7) +
  geom_segment(aes(x = non_ect_hdi[1], xend = non_ect_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\1/tau")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

no_depression_density_plot <- ggplot(plot_data, aes(x = `no-depression`, y = ..scaled..)) +
  geom_density(fill = I("#979799"), alpha = .7) +
  geom_segment(aes(x = no_depression_hdi[1], xend = no_depression_hdi[2], y = 0, yend = 0),
               color = I("black"), linewidth = 1.5, alpha = .7) +
  xlab(TeX("$\\1/tau")) +
  ylab("Posterior Density") +
  theme_cowplot(font_size = 12) +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(size=16),
        axis.text.y = element_blank(),
       axis.title.y= element_blank()) +
  scale_x_continuous(limits = c(0,1), breaks=seq(0,1,by=.25),
                     labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x))) +
  scale_y_continuous(labels = function(x) ifelse(x == 0, "0", sprintf("%.2f", x)))

beta_panel <- plot_grid(ect_density_plot, non_ect_density_plot, no_depression_density_plot, ncol = 1, nrow = 3)+
  theme(plot.margin = unit(c(0.5,0,0,0), "cm"))

final_plot <- plot_grid(learn_rate_pos_panel, discount_pos_panel, learn_rate_neg_panel, discount_neg_panel, beta_panel, ncol=5)

final_plot + theme(plot.margin = unit(c(0.1, 0.1, 0.1, 0.1),"inches"))
