#-----  fit index model to the simulated data
library(dplyr)
library(ggplot2)
library(sdmTMB)

# load simulated data
sim_dat <- readRDS("sim_dat/sim_dat_10.RDS")

# sample 100 locations from each year using simple random sampling
set.seed(99)
sim_dat_obs <- sim_dat %>%
  group_by(year) %>%
  slice_sample(n = 100) 

# plot samples over surface of mean without observation error (taken as "true")
ggplot(sim_dat, aes(X, Y)) +
  geom_raster(aes(fill = eta)) +
  geom_point(aes(size = observed), data = sim_dat_obs, pch = 21) +
  facet_wrap(~year) +
  scale_fill_viridis_c() +
  scale_size_area() +
  coord_cartesian(expand = FALSE)

# fit new model
mesh <- make_mesh(sim_dat_obs, xy_cols = c("X", "Y"), type = "cutoff_search", n_knots = 50)

fit <- sdmTMB(
  formula = observed ~ 0 + as.factor(year), # or year + depth_scaled if including covariate
  data = sim_dat_obs,
  mesh = mesh,
  time = "year",
  family = tweedie(), 
  spatial = "on", # c("on", "off")
  spatiotemporal = "iid", # c("iid", "ar1", "rw", "off")
)

fit

sanity(fit) # model checking

#---- inspect model and fit, predict, get abundance index (following vignette)
#https://pbs-assess.github.io/sdmTMB/articles/index-standardization.html

# replicate grid for each year to make prediction grid
grid <- readRDS("sim_dat/grid_depth.RDS")
grid_yrs <- replicate_df(grid, "year", unique(sim_dat$year))

#predict
predictions <- predict(fit, newdata = grid_yrs, return_tmb_object = TRUE)

# compute index
index <- get_index(predictions, area = 1, bias_correct = TRUE)

# plot index
ggplot(index, aes(year, est)) + geom_line() +
  geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.4) +
  xlab('Year') + ylab('Biomass estimate (kg)')