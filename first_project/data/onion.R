library(tidyverse)
library(sf)
library(geodata)

#-------------------------------------------------
# 1. Working directory & data
#-------------------------------------------------

setwd("/Users/seulgijung/Documents/슬기중요문서/2025 graduate submission/Columbia/Class/DataStudio2026/first_project")

df <- read_csv("onion.csv", show_col_types = FALSE)

#-------------------------------------------------
# 2. Wide → Long
#-------------------------------------------------

long_df <- df |>
  pivot_longer(
    cols = `2015`:`2024`,
    names_to = "year",
    values_to = "region"
  ) |>
  select(year, region, score)

# write_csv(long_df, "long_onion.csv")

#-------------------------------------------------
# 3. Map data (GADM level 2 = 시군구)
#-------------------------------------------------

korea_map <- gadm(country = "KOR", level = 2, path = tempdir()) |>
  st_as_sf()

# join key 만들기
korea_map <- korea_map |>
  mutate(
    region = paste0(NAME_2, "-", tolower(TYPE_2))
  )

#-------------------------------------------------
# 4. Expand to full region × year grid
#-------------------------------------------------

full_df <- expand_grid(
  region = unique(korea_map$region),
  year   = unique(long_df$year)
) |>
  left_join(long_df, by = c("region", "year"))

#-------------------------------------------------
# 5. Join geometry + data
#-------------------------------------------------

map_full <- korea_map |>
  left_join(full_df, by = "region")

#-------------------------------------------------
# 6. Choropleth map
#-------------------------------------------------

ggplot(map_full) +
  geom_sf(aes(fill = score), color = "grey70", size = 0.1) +
  facet_wrap(~year) +
  scale_fill_gradient(
    low = "lightyellow",
    high = "darkred",
    na.value = "white"
  ) +
  theme_void()

# save as .svg
library(svglite)
ggsave("onion_map.svg", width = 10, height = 8)
