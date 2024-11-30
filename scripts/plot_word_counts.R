# plot_word_counts.R
# Generate plots of word frequency in data.
# requires: plots/words.rds, source_data/stopwords.txt
# outputs: plots/plot_top50.png, plots/plot_weatherterms.png

# Libraries
require(tidyverse)
options(scipen = 999)

# Data
s <- read_delim("source_data/stopwords.txt", delim = " ")
ww <- c('wind', 'winds', 'snow', 'hail', 'thunderstorm', 'flooding', 'gust', 'tornado', 'drought', 'rain', 'gusts', 'storm', 'snowfall', 'rainfall', 'flooded', 'flood', 'thunderstorms', 'freezing', 'lightning', 'sleet', 'hurricane')
all <- readRDS("plots/words.rds") %>% 
  group_by(word) %>% 
  summarize(freq = sum(n))


# Analyze
top_50 <- all %>% 
  arrange(desc(freq)) %>% 
  filter(!str_detect(word, "0|1|2|3|4|5|6|7|8|9")) %>% 
  filter(!(word %in% s$stopwords)) %>% 
  head(50) %>% 
  ggplot(aes(x = reorder(word, desc(freq)), y = freq)) +
  geom_col(fill = "lightblue") +
  labs(
    x = "Word",
    y = "Frequency"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5)
  )

weather_related <- all %>% 
  arrange(desc(freq)) %>% 
  filter(word %in% ww) %>% 
  ggplot(aes(x = reorder(word, desc(freq)), y = freq)) +
  geom_col(fill = "lightblue") +
  labs(
    x = "Word",
    y = "Frequency"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5)
  )

# Save
ggsave("plots/plot_top50.png", plot = top_50)
ggsave("plots/plot_weatherterms.png", plot = weather_related)