# plot_word_counts.R
# Generate plots of word frequency in data.
# requires: plots/words.rds, source_data/stopwords.txt
# outputs: plots/plot_top50.png, plots/plot_weatherterms.png

# Libraries
suppressPackageStartupMessages(require(tidyverse))
options(scipen = 999)

# Data
s <- read_delim("source_data/stopwords.txt", delim = " ")
ww <- c('wind', 'winds', 'snow', 'hail', 'thunderstorm', 'flooding', 'gust', 'tornado', 'drought', 'rain', 'gusts', 'storm', 'snowfall', 'rainfall', 'flooded', 'flood', 'thunderstorms', 'freezing', 'lightning', 'sleet', 'hurricane')
all <- readRDS("plots/words.rds") %>% 
  group_by(word) %>% 
  summarize(freq = sum(n))
bytype <- readRDS("plots/words_by_type.rds") %>% 
  group_by(EVENT_TYPE, word) %>% 
  summarize(freq = sum(n), .groups = "drop_last")


# Analyze
top50 <- all %>% 
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

weatherterms <- all %>% 
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

wordsbytype <- bytype %>% 
  arrange(desc(freq)) %>% 
  filter(!str_detect(word, "0|1|2|3|4|5|6|7|8|9")) %>% 
  filter(!(word %in% s$stopwords)) %>% 
  mutate(Rank = dense_rank(desc(freq))) %>% 
  arrange(EVENT_TYPE, Rank) %>% 
  select(Rank, EVENT_TYPE, word) %>% 
  pivot_wider(names_from = EVENT_TYPE, values_from = word,
              values_fn = ~paste(., collapse = ", ")) %>% 
  head(20) %>% 
  select(Rank, Avalanche, `Excessive Heat`, Flood, Hurricane, Lightning,
         Tornado, `Winter Weather`) %>% 
  knitr::kable()

# Save
ggsave("plots/plot_top50.png", plot = top50)
ggsave("plots/plot_weatherterms.png", plot = weatherterms)
saveRDS(wordsbytype, file = "plots/kable_wordsbytype.rds")