library(tidyverse)
library(sf)
library(geodata)

#-------------------------------------------------
# 1. Working directory & data
#-------------------------------------------------

setwd("/Users/seulgijung/Documents/슬기중요문서/2025 graduate submission/Columbia/Class/DataStudio2026/first_project/data")

df <- read_csv("garlic.csv", show_col_types = FALSE)

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

# write_csv(long_df, "long_garlic.csv")

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
ggsave("garlic_map.svg", width = 10, height = 8)


# add lat colunn with latitude extracted from geometry column
map_full <- map_full |>
  mutate(
    lat = st_coordinates(st_centroid(geometry))[,2]
  )

# st_centroid(geometry) : calculate a centroid to each polygon
# that is a point that represents a group of border dots (shape)
# because polygon has no such a single latitude & summary statistics needs representative geometry

# st_coordinates( ... )
# transform geometry objects into matrix (numerical coordinates matrix)
#       X        Y       > X = lon, Y = lat
#.    129.02   35.19.    > usually looking like this!
# that is, calculating spatial object (centroid) into numerical matrix

# [,2]
# only select the second column (Y) from the matrix

# summary statistics 1
map_full |>
  filter(!is.na(score)) |>
  summarise(
    min = min(lat),
    q1 = quantile(lat, 0.25),
    median = median(lat),
    mean = mean(lat),
    q3 = quantile(lat, 0.75),
    max = max(lat),
    sd = sd(lat)
  )
# summary statistics 2
summary(map_full$lat[!is.na(map_full$score)])

# create a lat dataframe to ggplot
lat_summary <- map_full |>
  filter(!is.na(score)) |>
  group_by(year) |>
  summarise(
    mean = mean(lat, na.rm = TRUE), #na.rm = TRUE : remove(ignore) NA values
    median = median(lat, na.rm = TRUE)
  ) |>
  pivot_longer(
    cols = c(mean, median),
    names_to = "stat",
    values_to = "value"
  )

# ggplot to see if mean or median rises over time
ggplot(lat_summary) +
  aes(x=year, y=value, group=1) + # group=1 means line the dots
  geom_point(size=2) +
  geom_line() +
  facet_wrap(~stat, scale="free_y") + # only y axis free; scale=free means x, y both free
  theme_minimal()

ggsave("garlic_summarystats.svg", width = 10, height = 8)


