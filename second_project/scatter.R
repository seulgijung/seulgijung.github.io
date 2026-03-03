library(tidyverse)

setwd("/Users/seulgijung/Documents/슬기중요문서/2025 graduate submission/Columbia/Class/DataStudio2026/second_project")

df <- read_csv("packs.csv", show_col_types = FALSE)


df <- df |>
  mutate(
    charge_pct_of_base = 100 * env_levy / base_cost
  ) |>
  select(
    company,
    year,
    total_packs_n,
    gel_share_pct,
    base_cost,
    env_levy,
    charge_pct_of_base
  ) |>
  arrange(company, year)

# csv for main table 
write_csv(df, "main_table.csv")

# making a scattor plot to show levy per pack rises as gel packs share is big
scatter_df <- df |>
  mutate(
    levy_per_pack_usd = env_levy / total_packs_n, 
    year = factor(year) # year is a categorial variable
  )

scatter_plot <- ggplot(scatter_df) +
  aes(x = gel_share_pct,
      y = levy_per_pack_usd,
      size = total_packs_n,
      color = company) +
  geom_point() +
  facet_wrap(~ year) +
  labs(
    x = "Gel share of packs (%)",
    y = "Levy per pack (USD)",
    size = "Total packs (n)"
  ) +
  scale_size(range = c(3, 7)) + # enlarge the size of points, minimum 6, maximum 12
  scale_color_manual(
    values = c(
      "ssg" = "#4fabee",
      "nh_hanaro" = "#acdfff"
    ) # specify colors
  ) +
  scale_x_continuous(minor_breaks = NULL) + # minor break makes minor grid so turn if off
  scale_y_continuous(
    breaks = seq(0.04, 0.095, 0.01),
    minor_breaks = NULL # again, minor break makes unnecessary minor grid so shut if off
  ) +
  coord_cartesian(ylim = c(0.04, 0.095)) + # control the length of y-axis with coordinates
  guides(size = "none") + # delete the Total packs (n) legend
  theme_minimal() +
  theme(
    panel.grid.minor.x = element_blank(), # minor grid removal on x-axis
    panel.grid.minor.y = element_blank() # minor grid removal on y-axis
  )

scatter_plot
# save it as .svg
ggsave("scatter_plot.svg", plot = scatter_plot, width = 10, height = 4)
