renv::restore()
library("sf")
library(ggplot2)
maps_data <- readRDS("maps.RDS")

ggplot(data = maps_data) +
  geom_sf(aes(fill = TGFreq)) +
  scale_fill_viridis_c(trans = "log10") +
  labs(fill = "Tear Gas Frequency") +
  ggtitle("Tear Gas Frequency in DC Constituencies")

ggsave("Fig_1.png", scale =2)

ggplot(data = maps_data) +
  geom_sf(aes(fill = DC_name)) +
  ggtitle("Geographical Distribution of Constituencies") +
  labs(fill = "LegCo District Name")

ggsave("Fig_A1.png",scale =2)

maps_data$yoshinoya <- as.factor(maps_data$yoshinoya)
ggplot(data = maps_data) +
  geom_sf(aes(fill = yoshinoya)) +
  labs(fill = "Yoshinoya Outlet") +
  ggtitle("Yoshinoya in DC Constituencies")

ggsave("Fig_A2.png",scale =2)
