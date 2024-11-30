# count_words.R
# Count word frequency in data.
# requires: source_data/1974_2024-08_stormevents.rds
# outputs: plots/words.rds

# Libraries
`%>%` <- magrittr::`%>%`

# Count words
stormevents <- readRDS("./source_data/1974_2024-08_stormevents.rds") %>% 
  dplyr::select(EVENT_ID, EVENT_NARRATIVE) %>% 
  dplyr::filter(!is.na(EVENT_NARRATIVE)) %>%
  dplyr::mutate(EVENT_ID = as.numeric(EVENT_ID)) %>%
  tidytext::unnest_tokens(word, EVENT_NARRATIVE) %>%
  dplyr::count(EVENT_ID, word)

# Save data
saveRDS(stormevents, "plots/words.rds")

# Cleanup
rm(stormevents)
gc()

# Count words after grouping by event type
stormevents2 <- readRDS("./source_data/1974_2024-08_stormevents.rds") %>% 
  dplyr::select(EVENT_ID, EVENT_TYPE, EVENT_NARRATIVE) %>% 
  dplyr::mutate(EVENT_ID = as.numeric(EVENT_ID)) %>% 
  tidytext::unnest_tokens(word, EVENT_NARRATIVE) %>% 
  dplyr::count(EVENT_ID, EVENT_TYPE, word)

# Save data
saveRDS(stormevents2, "plots/words_by_type.rds")