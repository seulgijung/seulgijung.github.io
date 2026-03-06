library(tidyverse)
library(sf)
library(geodata)

# set up the path
setwd("/Users/seulgijung/Documents/슬기중요문서/2025 graduate submission/Columbia/Class/Algorithms/koreandogs")

# read csv
df <- read_csv("summary.csv", show_col_types = FALSE)

# pivot to long
long_df <- df |>
  pivot_longer(
    cols = c(-Year),
    names_to = "country",
    values_to = "number_of_dogs"
  )

long_df |> head()

# ggplot
ggplot(long_df) +
  aes(x=Year, y=number_of_dogs, group=country, color=country) +
  geom_line() +
  scale_x_continuous(breaks = c(2014, 2017, 2019, 2021, 2022, 2023, 2025))
  theme_minimal() +
  labs(
    title='The number of dogs coming to the US and Canada jumped in post pandemic',
    subtitle=str_wrap('The 2020 COVID-19 pandemic spurred the adoption of thousands of rescue dogs from South Korea by the US and Canada, peaking in 2021 and continuing through 2022 and 2023.')
  )

install.packages('gganimate')
install.packages("gifski")

library(gganimate)
library(gifski)

g <- ggplot(long_df) +
  aes(x = Year, y = number_of_dogs, group = country, color = country) +
  geom_line(size=1.2) +
  scale_x_continuous(breaks = c(2014, 2017, 2019, 2021, 2022, 2023, 2025)) +
  scale_y_continuous(breaks = c(0, 500, 1500, 3000, 5000, 10000, 15000)) +
  theme_minimal() +
  labs(
    title = 'The number of dogs coming to the US and Canada jumped in post pandemic',
    subtitle = str_wrap('The 2020 COVID-19 pandemic spurred the adoption of thousands of rescue dogs from South Korea by the US and Canada, peaking in 2021 and continuing through 2022 and 2023.', width=90),
    x = "",
    y = "Number of dogs"
  ) +
  theme(
    plot.title = element_text(size = 18, face = "bold", margin = margin(b = 22)),
    plot.subtitle = element_text(size = 14, margin = margin(b = 30)),
    plot.margin = margin(30, 20, 20, 20)
  ) +
  transition_reveal(Year)

g

animate(
  g,
  renderer = gifski_renderer("chart_2.gif"),
  width = 700,
  height = 400,
  fps = 20,
  duration = 8
)


g