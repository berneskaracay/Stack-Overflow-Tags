library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(plotly)
library(RColorBrewer)

# load the dataset of the most popular Russian tags and their proportions
russianData <- readRDS('./data/RussianMostPopWProp.RDS')
englishData <- readRDS('./data/EnglishMostPopWProp.RDS')

# adding Language column for facet grid 
russianData <- russianData %>%
  mutate(Language = "Russian")
englishData <- englishData %>%
  mutate(Language = "English")

# joining two data sets into one
bothLangData <- bind_rows(russianData, englishData)

# create sorted years for dropdown
dropDownYears <- as.data.frame(bothLangData) %>% 
  select(Year) %>% 
  unique()

# sorting years for the widget
dropDownYears <- sort(dropDownYears$Year)

# create sorted tags for multiple checkbox selection
dropDownTags <- as.data.frame(bothLangData) %>%
  group_by(Tag) %>%
  arrange(desc(TagProp)) %>%
  select(Tag) %>%
  unique()

# finding unique tags for each of the communities
englishOnly <- anti_join(englishData, russianData, by = "Tag")
russianOnly <- anti_join(russianData, englishData, by = "Tag")

engSpecTags <- as.data.frame(englishOnly) %>%
  group_by(Tag) %>%
  arrange(desc(TagProp)) %>%
  select(Tag) %>%
  unique()

rusSpecTags <- as.data.frame(russianOnly) %>%
  group_by(Tag) %>%
  arrange(desc(TagProp)) %>%
  select(Tag) %>%
  unique()