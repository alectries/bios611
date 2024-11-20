# map_events.R
# Create a map of all storm events in the database, regardless of year and type. Jumping-off point for analysis.
# requires: source_data/1974_2024-08_stormevents.rds
# outputs: plots/plot_events.png, plots/plot_recent.png

# Libraries
require(tidyverse)

# Data
stormevents <- readRDS("./source_data/1974_2024-08_stormevents.rds")

# Pivot
stormevents <- stormevents %>% 
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
plot_events <- ggplot() +
  geom_polygon(
    data = map_data("state"),
    aes(x = long, y = lat, group = group),
    color = "black",
    fill = "white"
  ) +
  geom_point(
    data = stormevents,
    aes(x = long, y = lat, group = EVENT_ID),
    color = "limegreen"
  ) +
  coord_map("polyconic",
            xlim = c(-125, -65),
            ylim = c(25, 50)) +
  theme_void()
plot_recent <- ggplot() +
  geom_polygon(
    data = map_data("state"),
    aes(x = long, y = lat, group = group),
    color = "black",
    fill = "white"
  ) +
  geom_point(
    data = filter(stormevents, YEAR %in% as.character(2004:2024)),
    aes(x = long, y = lat, group = EVENT_ID),
    color = "aquamarine"
  ) +
  coord_map("polyconic",
            xlim = c(-125, -65),
            ylim = c(25, 50)) +
  theme_void()
plot_tornado <- ggplot() +
  geom_polygon(
    data = map_data("state"),
    aes(x = long, y = lat, group = group),
    color = "black",
    fill = "white"
  ) +
  geom_point(
    data = filter(stormevents, YEAR %in% as.character(2004:2024) & EVENT_TYPE == "Tornado"),
    aes(x = long, y = lat, group = EVENT_ID),
    color = "purple"
  ) +
  coord_map("polyconic",
            xlim = c(-125, -65),
            ylim = c(25, 50)) +
  theme_void()

# Render
ggsave("plots/plot_events.png", plot = plot_events)
ggsave("plots/plot_recent.png", plot = plot_recent)
ggsave("plots/plot_tornado.png", plot = plot_tornado)
