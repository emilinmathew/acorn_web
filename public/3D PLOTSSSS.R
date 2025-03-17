install.packages("leaflet")  # Install leaflet for interactive maps
install.packages("dplyr")    # Install dplyr for data manipulation
install.packages("readr")    # Install readr for reading CSV files

library(readr)
library(dplyr)
library(leaflet)

# Load all datasets
tree_data <- read_csv("~/Downloads/tree_data.csv")  
fall_2023 <- read_csv("~/Downloads/2023Fall_Koenig_binocular_acorn_count.csv") %>%
  rename(Acorns_Fall_2023 = N30_count_Koenig_method)

fall_2024 <- read_csv("~/Downloads/2024Fall_Koenig_binocular_acorn_count.csv") %>%
  rename(Acorns_Fall_2024 = N30_count_Koenig_method)

winter_2024 <- read_csv("~/Downloads/2024Winter_quadrat_acorn_counts_dataset1_clean_class_data.csv") %>%
  rename(Acorns_Winter_2024 = `Acorn production (number of cups/quadrat) - North`)

winter_2025 <- read_csv("~/Downloads/2025Winter_quadrat_acorn_counts_dataset1_clean_class_data.csv") %>%
  rename(Acorns_Winter_2025 = `Acorn Production - North (cups/quadrat)`)

# Merge all datasets by TreeID
tree_full <- tree_data %>%
  left_join(fall_2023, by = "TreeID") %>%
  left_join(fall_2024, by = "TreeID") %>%
  left_join(winter_2024, by = "TreeID") %>%
  left_join(winter_2025, by = "TreeID")

# Rename Tree Structure column
tree_full <- tree_full %>%
  rename(Tree_Structure = `Single/Multi Stemmed?`)

# Handle missing values (replace NAs with "No Data")
tree_full <- tree_full %>%
  mutate(
    Acorns_Fall_2023 = ifelse(is.na(Acorns_Fall_2023), "No Data", Acorns_Fall_2023),
    Acorns_Winter_2024 = ifelse(is.na(Acorns_Winter_2024), "No Data", Acorns_Winter_2024),
    Acorns_Fall_2024 = ifelse(is.na(Acorns_Fall_2024), "No Data", Acorns_Fall_2024),
    Acorns_Winter_2025 = ifelse(is.na(Acorns_Winter_2025), "No Data", Acorns_Winter_2025)
  )

# Define Stanford Colors
stanford_red <- "#8C1515"  # Single-Stemmed (Circles)
stanford_blue <- "#00008B"  # Multi-Stemmed (Squares)

# Assign colors based on tree structure
tree_full$color <- ifelse(tree_full$Tree_Structure == "Single-stemmed", stanford_red, stanford_blue)

# Make multi-stemmed trees appear "square-like" by using a thick stroke
tree_full$border_weight <- ifelse(tree_full$Tree_Structure == "Single-stemmed", 1, 6)

# Function to create popups with all seasons displayed (NO BUTTONS)
create_popup <- function(TreeID, Tree_Structure, DBH, Crown, Acorn_Fall_2023, Acorn_Winter_2024, Acorn_Fall_2024, Acorn_Winter_2025) {
  paste0(
    "<b>Tree ID:</b> ", TreeID, "<br>",
    "<b>Structure:</b> ", Tree_Structure, "<br><br>",
    "<b>🌿 Seasonal Data:</b><br><br>",
    "<b>🍂 Fall 2023</b><br>",
    "- <b>DBH:</b> ", DBH, " cm<br>",
    "- <b>Crown Diameter:</b> ", Crown, " cm<br>",
    "- <b>Acorn Count:</b> ", Acorn_Fall_2023, "<br><br>",
    "<b>❄️ Winter 2024</b><br>",
    "- <b>DBH:</b> ", DBH, " cm<br>",
    "- <b>Crown Diameter:</b> ", Crown, " cm<br>",
    "- <b>Acorn Count:</b> ", Acorn_Winter_2024, "<br><br>",
    "<b>🍂 Fall 2024</b><br>",
    "- <b>DBH:</b> ", DBH, " cm<br>",
    "- <b>Crown Diameter:</b> ", Crown, " cm<br>",
    "- <b>Acorn Count:</b> ", Acorn_Fall_2024, "<br><br>",
    "<b>❄️ Winter 2025</b><br>",
    "- <b>DBH:</b> ", DBH, " cm<br>",
    "- <b>Crown Diameter:</b> ", Crown, " cm<br>",
    "- <b>Acorn Count:</b> ", Acorn_Winter_2025
  )
}

# Create the interactive map
leaflet(tree_full) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  setView(lng = -122.23, lat = 37.41, zoom = 14) %>%
  
  # Single-stemmed trees (Stanford Cardinal Red Circles)
  addCircleMarkers(
    data = tree_full[tree_full$Tree_Structure == "Single-stemmed", ],
    ~Longitude, ~Latitude,
    radius = 6,
    color = stanford_red,
    fillOpacity = 0.7,
    stroke = TRUE,
    weight = 1,  # Normal stroke
    popup = ~create_popup(TreeID, Tree_Structure, `Diameter at breast height (DBH) (cm)`, `Crown diameter 1 (cm)`, Acorns_Fall_2023, Acorns_Winter_2024, Acorns_Fall_2024, Acorns_Winter_2025)
  ) %>%
  
  # Multi-stemmed trees (Stanford Blue "Squares" using thick stroke)
  addCircleMarkers(
    data = tree_full[tree_full$Tree_Structure == "Multi-stemmed", ],
    ~Longitude, ~Latitude,
    radius = 6,
    color = stanford_blue,
    fillOpacity = 0.7,
    stroke = TRUE,
    weight = 6,  # Thicker border for square-like appearance
    popup = ~create_popup(TreeID, Tree_Structure, `Diameter at breast height (DBH) (cm)`, `Crown diameter 1 (cm)`, Acorns_Fall_2023, Acorns_Winter_2024, Acorns_Fall_2024, Acorns_Winter_2025)
  ) %>%
  
  addLegend("bottomright",
            colors = c(stanford_red, stanford_blue),
            labels = c("Single-stemmed", "Multi-stemmed"),
            title = "Tree Structure")
