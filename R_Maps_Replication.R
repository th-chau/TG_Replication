# To ensure the correct package versions are installed, we use the `renv' package. If your
# R environment does not have `renv', please run install.packages("renv")
# and library("renv")

# Please set this to where you have downloaded our files
setwd()

# Please run this command and activate the project
renv::restore()

library("sf")
library(ggplot2)
maps_data <- readRDS("DATA_maps.RDS")

# Figure 1

ggplot(data = maps_data) +
  geom_sf(aes(fill = TGFreq)) +
  scale_fill_viridis_c(trans = "log10") +
  labs(fill = "Tear Gas Frequency") +
  ggtitle("Tear Gas Frequency in DC Constituencies")

ggsave("Fig_1.png", scale =2)

# Figure A1

ggplot(data = maps_data) +
  geom_sf(aes(fill = DC_name)) +
  ggtitle("Geographical Distribution of Constituencies") +
  labs(fill = "LegCo District Name")

ggsave("Fig_A1.png",scale =2)

# Figure A2

maps_data$yoshinoya <- as.factor(maps_data$yoshinoya)
ggplot(data = maps_data) +
  geom_sf(aes(fill = yoshinoya)) +
  labs(fill = "Yoshinoya Outlet") +
  ggtitle("Yoshinoya in DC Constituencies")

ggsave("Fig_A2.png",scale =2)
