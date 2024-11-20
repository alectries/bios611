# map_tornadoes.R
# Create an animated timeline map of tornado events.
# requires: source_data/1974_2024-08_stormevents.rds

# Libraries
require(tidyverse)
require(gganimate)
options(bitmapType = "cairo")
png("plot.png", type="cairo")

# Data
stormevents <- readRDS("./source_data/1974_2024-08_stormevents.rds")

# Pivot
stormevents <- stormevents %>% 
  filter(EVENT_TYPE == "Tornado") %>% 
  pivot_longer(
    cols = c(BEGIN_LAT, BEGIN_LON, END_LAT, END_LON),
    names_to = 'end',
    values_to = 'value'
  ) %>% 
  mutate(
    'time' = case_when(
      str_detect(end, "BEGIN") ~ "begin",
      str_detect(end, "END") ~ "end",
      .default = NA
    ),
    'll' = case_when(
      str_detect(end, "LAT") ~ "lat",
      str_detect(end, "LON") ~ "long",
      .default = NA
    ),
    'value' = as.numeric(value)
  ) %>% 
  pivot_wider(
    id_cols = c(-end),
    names_from = ll,
    values_from = value
  )

# Map
plot <- ggplot() +
  geom_polygon(
    data = map_data("state"),
    aes(x = long, y = lat, group = group),
    color = "black",
    fill = "white"
  ) +
  geom_point(
    data = stormevents,
    aes(x = long, y = lat, group = EVENT_ID),
    color = "lightblue2"
  ) +
  coord_map("polyconic",
            xlim = c(-125, -65),
            ylim = c(25, 50)) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5)
  ) +
  transition_states(YEAR, state_length = 2) +
  labs(title = '{closest_state}')

anim <- animate(plot, 
                renderer = gifski_renderer("tornado_plot.gif"),
                device = 'png',
                height = 800, 
                width = 1200)

anim_save("tornado_plot.gif", animation = anim)

dev.off()