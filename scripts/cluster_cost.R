# cluster_cost.R
# Cluster and view storm events by property damage and location.
# requires: source_data/1974_2024-08_stormevents.rds

# Libraries
require(tidyverse)

# Data
stormevents <- readRDS("./source_data/1974_2024-08_stormevents.rds") %>% 
  select(EVENT_ID, END_LAT, END_LON, DAMAGE_PROPERTY) %>% 
  mutate(
    EVENT_ID = as.numeric(EVENT_ID),
    END_LAT = as.numeric(END_LAT),
    END_LON = as.numeric(END_LON),
    DAMAGE_PROPERTY = case_when(
      str_detect(DAMAGE_PROPERTY, "h|H") ~ str_remove(DAMAGE_PROPERTY, "H") %>% 
        as.numeric() * 100,
      str_detect(DAMAGE_PROPERTY, "K") ~ str_remove(DAMAGE_PROPERTY, "K") %>% 
        as.numeric() * 1000,
      str_detect(DAMAGE_PROPERTY, "M") ~ str_remove(DAMAGE_PROPERTY, "M") %>% 
        as.numeric() * 1000000,
      str_detect(DAMAGE_PROPERTY, "B") ~ str_remove(DAMAGE_PROPERTY, "B") %>% 
        as.numeric() * 1000000000,
      .default = as.numeric(DAMAGE_PROPERTY)
    )
  ) %>% 
  filter(!is.na(DAMAGE_PROPERTY) & !is.na(END_LAT) & !is.na(END_LON) & DAMAGE_PROPERTY != 0)

# kmeans
stormevents_klat <- add_column(
  stormevents,
  kmeans(select(stormevents, -EVENT_ID, -END_LON), 5)[1] %>% 
    as.data.frame()
)
stormevents_klon <- add_column(
  stormevents,
  kmeans(select(stormevents, -EVENT_ID, -END_LAT), 5)[1] %>% 
    as.data.frame()
)
stormevents_k <- add_column(
  stormevents,
  kmeans(select(stormevents, -EVENT_ID), 5)[1] %>% 
    as.data.frame()
) %>% 
  filter(
    cluster != pull(slice(arrange(summarize(group_by(., cluster), n = n()), desc(n)), 1), cluster)
  )
  

# Graph
plot_klat <- stormevents_klat %>% 
  ggplot(aes(x = DAMAGE_PROPERTY, y = END_LAT, color = as.character(cluster))) +
  geom_point() +
  labs(
    x = "Property Damage",
    y = "Latitude",
    color = "Cluster"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal()
plot_klon <- stormevents_klon %>% 
  ggplot(aes(x = END_LON, y = DAMAGE_PROPERTY, color = as.character(cluster))) +
  geom_point() +
  labs(
    x = "Longitude",
    y = "Property Damage",
    color = "Cluster"
  ) +
  xlim(-125, -65) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal()
plot_kmap <- ggplot() +
  geom_polygon(
    data = map_data("state"),
    aes(x = long, y = lat, group = group),
    color = "black",
    fill = "white"
  ) +
  geom_point(
    data = filter(stormevents_k),
    aes(x = END_LON, y = END_LAT, size = DAMAGE_PROPERTY / 1e9,
        color = as.character(cluster))
  ) +
  coord_map("polyconic",
            xlim = c(-125, -65),
            ylim = c(25, 50)) +
  labs(
    size = "Property Damage (millions)",
    color = "Cluster"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme_void()
