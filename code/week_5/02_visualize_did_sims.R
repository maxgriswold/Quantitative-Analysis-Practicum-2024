# Visualize simulation results

library(ggplot2)
library(gridExtra)
library(data.table)

df_sim <- fread("./data/did_sim/sim_results.csv")

df_sim[, scenario := paste(effect_magnitude1, effect_magnitude2, effect_magnitude3, effect_magnitude4, effect_magnitude5, effect_magnitude6)]

# Reshape effect columns long; this should probably occur during the simulation procedure
id_cols <- c("outcome", "n_implementation_periods", "n_units", "policy_speed", "effect_direction", "model_formula", "model_name", "model_call", "scenario", "iter")

sum_cols <- c("n_units", "scenario", "model_name", "ttt")

df_sim <- melt(df_sim, id.vars = id_cols, measure = patterns(estimate = "^estimate_ttt==", se = "^se_ttt==", variance = "^variance_ttt==", t_stat = "^t_stat_ttt==", p_value = "^p_value_ttt==",  true_effect = "^effect_magnitude"), variable.name = "ttt")

# Calculate GoF statistics

#Median sim error & 2.5th/97.5th percentiles
df_sim[, true_effect := -1*true_effect]
df_sim[, sim_error := true_effect - estimate]
df_sim[, sim_error_std := (true_effect - estimate)/sd(overdoses$crude.rate, na.rm = T)]

df_sim[, sim_error_50 := quantile(.SD$sim_error, 0.5), by = sum_cols]
df_sim[, sim_error_025 := quantile(.SD$sim_error, 0.025), by = sum_cols]
df_sim[, sim_error_975 := quantile(.SD$sim_error, 0.975), by = sum_cols]

df_sim[, sim_error_50_std := quantile(.SD$sim_error_std, 0.5), by = sum_cols]
df_sim[, sim_error_025_std := quantile(.SD$sim_error_std, 0.025), by = sum_cols]
df_sim[, sim_error_975_std := quantile(.SD$sim_error_std, 0.975), by = sum_cols]

#Mean error v. variance of error:
df_sim[, sim_error_mean := mean(.SD$sim_error), by = sum_cols]
df_sim[, sim_error_variance := var(.SD$sim_error), by = sum_cols]

#RMSE
df_sim[, sim_rmse := sum(.SD$sim_error^2)/.N, by = sum_cols]

#Model coverage
df_sim[, covered := ifelse((estimate + 1.96*se >= true_effect) & (estimate - 1.96*se <= true_effect), 1, 0)]
df_sim[, coverage := sum(.SD$covered)/.N, by = sum_cols]

# Average model estimate and variance
df_sim[, model_est_mean := mean(.SD$estimate), by = sum_cols]
df_sim[, model_est_025 := mean(.SD$estimate) - 1.96*(sd(.SD$estimate)), by = sum_cols]
df_sim[, model_est_975 := mean(.SD$estimate) + 1.96*(sd(.SD$estimate)), by = sum_cols]

df_sim[, model_se_mean := mean(.SD$se), by = sum_cols]
df_sim[, model_se_025 := mean(.SD$se) - 1.96*(sd(.SD$se)), by = sum_cols]
df_sim[, model_se_975 := mean(.SD$se) + 1.96*(sd(.SD$se)), by = sum_cols]

# Change variable coding to be a little more informative on scenarios, model names,
# and time to treat

scenario_names <- data.frame("scenario_name" = c("linear increasing", "linear decreasing",
                                                 "instant plateau", "slow plateau"),
                             "scenario" = sapply(time_varying_scenarios, paste, collapse = " "))

df_summary <- merge(df_sim, scenario_names, by = "scenario")
df_summary[, scenario_name := factor(scenario_name, levels = scenario_names$scenario_name)]

model_names_remap <- data.frame("new_model_name" = c("Event study: Two-way Fixed Effect", "Event study: AR(1)", "Event study: AR(1) (No clustering)", "Event study: Sun & Abraham", "Callaway & Sant'Anna", 
                                                     "Two-stage DiD", "DiD imputation", "Augmented synthetic controls"),
                                "model_name" = c("twfe", "autoregressive_cluster", "autoregressive_no_cluster", "sa", "csa_did", "gardner", "bjs", "augsynth"))

df_summary <- merge(df_summary, model_names_remap, by = "model_name")
df_summary[, model_name := factor(model_name, levels = model_names_remap$new_model_name)]

df_summary[, ttt_name := ifelse(ttt == 1, paste0(ttt, " year since \ntreatment"), paste0(ttt, " years since \ntreatment"))]
df_summary[, ttt_name := factor(ttt_name, levels = unique(df_summary$ttt_name))]

df_summary[, n_units_name := paste0(n_units, " treated units")]
df_summary[, n_units_name := factor(n_units_name, levels = unique(df_summary$n_units_name))]

df_summary[, scenario := NULL]
df_summary[, model_name := NULL]
setnames(df_summary, "new_model_name", "model_name")

# Collapse to summaries:
df_summary <- unique(df_summary[, .(n_units, n_units_name, scenario_name, model_name, ttt, ttt_name,
                                    sim_error_mean, sim_error_variance, sim_error_50, sim_error_025,
                                    sim_error_975, sim_error_50_std, sim_error_025_std, sim_error_975_std, 
                                    model_est_mean, model_est_025, model_est_975, model_se_mean, model_se_025, model_se_975,
                                    coverage, sim_rmse)])

#############
# GOF Plots #
#############

################################
# Mean error v. variance error #
################################

plot_colors_bw <- c('#d9d9d9','#bdbdbd','#969696','#737373','#525252','#252525','#000000')
plot_colors_col <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f', '#cab2d6')

plot_colors <- plot_colors_col

# Scale size of PDF to improve sizing of points for canvas.
# I played around with this number to find an aesthetic I preferred.

mult <- 1.1

bias_variance <- function(dd, n_treat, scene){
  
  dd <- dd[n_units == n_treat & scenario_name == scene,]
  
  plot_scatter <- ggplot(dd, aes(y = model_se_mean, x = sim_error_mean, color = model_name)) +
    facet_wrap(~ttt_name, nrow = 2) +
    geom_hline(yintercept = 0, linetype = 21) +
    geom_point(size = 3, shape = 19) +
    labs(title = sprintf("Model error v. model variance: \n%s treated units and %s effects", n_treat, scene),
         y = "Mean model \nerror",
         x = "Mean model \nvariance",
         color = "Estimator") +
    geom_errorbar(aes(ymin = model_se_025, ymax = model_se_975),  linewidth = 0.5, width = 0) +
    geom_errorbarh(aes(xmin = sim_error_025, xmax = sim_error_975), linewidth = 0.5, width = 0) +
    theme_bw() +
    scale_color_manual(values = plot_colors) +
    theme(plot.title = element_text(hjust = 0.5, family = 'sans', size = 16),
          strip.background = element_blank(),
          strip.text = element_text(family = "sans", size = 10),
          legend.position = "bottom",
          legend.text = element_text(family = 'sans', size = 10),
          axis.ticks = element_line(linewidth = 1),
          axis.ticks.length = unit(5.6, "points"),
          axis.title = element_text(size = 12, family = 'sans'),
          axis.title.y = element_text(size = 12, family = 'sans', angle = 0),
          axis.text = element_text(size = 10, family = 'sans'),
          axis.text.x = element_text(size = 10, family = 'sans',
                                     margin = margin(t = 5, r = 0, b = 10, l = 0)),
          legend.title = element_text(family = 'sans', size = 14))
  
  return(plot_scatter)
  
}

args <- expand.grid(n_treat = unique(df_summary$n_units),
                    scene = unique(df_summary$scenario_name))

args <- with(args, args[order(scene),])

bias_v_variance_plots <- mapply(bias_variance, n_treat = args$n_treat, scene = args$scene, MoreArgs = list(dd = df_summary),
                                SIMPLIFY = F, USE.NAMES = F)

ggsave(filename = "./time_vary_plots/time_vary_model_error_v_variance.pdf", plot = marrangeGrob(bias_v_variance_plots, nrow=1, ncol=1, top=NULL), 
       height = 8.27*mult, width = 11.69*mult, units = "in")

#####################
# Error comparisons #
#####################

plot_bias <- ggplot(df_summary, aes(x = ttt, y = sim_error_50_std, color = model_name)) +
  geom_hline(yintercept = 0, linetype = 21) +
  geom_point(size = 1, shape = 19, position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = sim_error_025_std, ymax = sim_error_975_std), linewidth = 0.5, 
                width = 0, position = position_dodge(width = 0.8)) +
  facet_grid(rows = vars(n_units_name), cols = vars(scenario_name), labeller = "label_value") +
  theme_bw() +
  labs(title = "Median standardized bias (2.5th, 97.5th percentiles) across simulation runs",
       y = "Bias",
       x = "Years since treatment",
       color = "Estimator") +
  scale_color_manual(values = plot_colors) +
  theme(plot.title = element_text(hjust = 0.5, family = 'sans', size = 16),
        strip.background = element_blank(),
        strip.text = element_text(family = "sans", size = 10),
        legend.position = "bottom",
        legend.text = element_text(family = 'sans', size = 10),
        axis.ticks = element_line(linewidth = 1),
        axis.ticks.length = unit(5.6, "points"),
        axis.title = element_text(size = 12, family = 'sans'),
        axis.title.y = element_text(size = 12, family = 'sans', angle = 0),
        axis.text = element_text(size = 10, family = 'sans'),
        axis.text.x = element_text(size = 10, family = 'sans',
                                   margin = margin(t = 5, r = 0, b = 10, l = 0)),
        legend.title = element_text(family = 'sans', size = 14))

ggsave(filename = "./time_vary_plots/time_vary_sim_bias_ui.pdf", plot = plot_bias, height = 8.27*mult, width = 11.69*mult, units = "in")

############
# Coverage #
############

plot_cover <- ggplot(df_summary, aes(x = ttt, y = coverage, color = model_name)) +
  geom_point(size = 1.5, shape = 19) +
  geom_line(aes(group = model_name), linewidth = 0.7) +
  facet_grid(rows = vars(n_units_name), cols = vars(scenario_name), labeller = "label_value") +
  theme_bw() +
  labs(title = "Percent of sim runs with true effect \ncovered by estimated effect",
       y = "Coverage",
       x = "Years since treatment",
       color = "Estimator") +
  scale_color_manual(values = plot_colors) +
  scale_y_continuous(labels = scales::percent) +
  theme(plot.title = element_text(hjust = 0.5, family = 'sans', size = 16),
        strip.background = element_blank(),
        strip.text = element_text(family = "sans", size = 10),
        legend.position = "bottom",
        legend.text = element_text(family = 'sans', size = 10),
        axis.ticks = element_line(linewidth = 1),
        axis.ticks.length = unit(5.6, "points"),
        axis.title = element_text(size = 12, family = 'sans'),
        axis.title.y = element_text(size = 12, family = 'sans', angle = 0),
        axis.text = element_text(size = 10, family = 'sans'),
        axis.text.x = element_text(size = 10, family = 'sans',
                                   margin = margin(t = 5, r = 0, b = 10, l = 0)),
        legend.title = element_text(family = 'sans', size = 14))

ggsave(filename = "./time_vary_plots/time_vary_sim_coverage.pdf", plot = plot_cover, height = 8.27*mult, width = 11.69*mult, units = "in")

########
# RMSE #
########

plot_rmse <- ggplot(df_summary, aes(x = ttt, y = sim_rmse, color = model_name)) +
  geom_point(size = 1, shape = 19, position = position_dodge(width = 0.8)) +
  geom_linerange(aes(x = ttt, ymin = 0, ymax = rmse), 
                 linewidth = 0.6, position = position_dodge(width = 0.8)) +
  facet_grid(rows = vars(n_units_name), cols = vars(scenario_name), labeller = "label_value") +
  theme_bw() +
  labs(title = "RMSE of sim runs",
       y = "RMSE",
       x = "Years since treatment",
       color = "Estimator") +
  scale_color_manual(values = plot_colors) +
  theme(plot.title = element_text(hjust = 0.5, family = 'sans', size = 16),
        strip.background = element_blank(),
        strip.text = element_text(family = "sans", size = 10),
        legend.position = "bottom",
        legend.text = element_text(family = 'sans', size = 10),
        axis.ticks = element_line(linewidth = 1),
        axis.ticks.length = unit(5.6, "points"),
        axis.title = element_text(size = 12, family = 'sans'),
        axis.title.y = element_text(size = 12, family = 'sans', angle = 0),
        axis.text = element_text(size = 10, family = 'sans'),
        axis.text.x = element_text(size = 10, family = 'sans',
                                   margin = margin(t = 5, r = 0, b = 10, l = 0)),
        legend.title = element_text(family = 'sans', size = 14))

ggsave(filename = "./time_vary_plots/time_vary_sim_rmse.pdf", plot = plot_rmse, height = 8.27*mult, width = 11.69*mult, units = "in")