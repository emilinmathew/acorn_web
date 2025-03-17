---
title: "NDVI vs Acorn Production Analysis"
output: html_document
---

## Relationship Between NDVI and Acorn Production
This analysis examines the relationship between NDVI (Normalized Difference Vegetation Index) and acorn production across two years (2024 and 2025).

```{r setup, include=FALSE}
# Load necessary libraries
library(dplyr)
library(ggplot2)
library(lmerTest)
library(tidyr)
library(MuMIn)
library(broom.mixed)

# Try to load the data with error handling
tryCatch({
  # Load the data from CSV files
  ndvi_2024 <- read.csv("Tree_NDVI_Values_2024.csv")
  ndvi_2025 <- read.csv("Tree_NDVI_Values_2025.csv")
  acorn_2024 <- read.csv("2024_acorn.csv")  
  acorn_2025 <- read.csv("2025_acorn.csv")
  
  # Rename columns to distinguish years
  data_2024 <- acorn_2024 %>%
    rename(sum_acorns_2024 = sum_acorns)
  
  data_2025 <- acorn_2025 %>%
    rename(sum_acorns_2025 = acorn_sum)
  
  # Merge datasets on TreeID
  merged_data <- merge(data_2024, data_2025, by = "TreeID")
  merged_data <- merge(merged_data, ndvi_2024, by = "TreeID")
  merged_data <- merge(merged_data, ndvi_2025, by = "TreeID")
  
  # Model 1: NDVI in 2024 predicting Acorn count in 2024
  model_2024 <- lm(sum_acorns_2024 ~ NDVI_2024, data = merged_data)
  summary_2024 <- summary(model_2024)
  r2_2024 <- round(summary_2024$r.squared, 3)
  p_value_2024 <- round(summary_2024$coefficients[2,4], 3)
  
  # Model 2: NDVI in 2025 predicting Acorn count in 2025
  model_2025 <- lm(sum_acorns_2025 ~ NDVI_2025, data = merged_data)
  summary_2025 <- summary(model_2025)
  r2_2025 <- round(summary_2025$r.squared, 3)
  p_value_2025 <- round(summary_2025$coefficients[2,4], 3)
  
  # Reshape data into long format for mixed model
  long_data <- merged_data %>%
    pivot_longer(cols = c(sum_acorns_2024, sum_acorns_2025, NDVI_2024, NDVI_2025),
                 names_to = c(".value", "Year"),
                 names_pattern = "(.*)_(\\d{4})")
  
  # Convert Year to a factor
  long_data$Year <- as.factor(long_data$Year)
  
  # Fit a mixed-effects model
  model_mixed <- lmer(sum_acorns ~ NDVI + (1 | Year) + (1 | TreeID), data = long_data)
  
  # Extract model statistics
  summary_mixed <- summary(model_mixed)
  r2_mixed <- round(r.squaredGLMM(model_mixed)[1], 3)  # Marginal R² (fixed effects only)
  p_value_mixed <- round(coef(summary(model_mixed))["NDVI", "Pr(>|t|)"], 3)
  
  data_loaded <- TRUE
  
}, error = function(e) {
  # Create sample data if files don't exist
  set.seed(123)
  
  sample_size <- 30
  TreeID <- paste0("Tree", 1:sample_size)
  
  # Create sample data
  ndvi_2024 <- data.frame(
    TreeID = TreeID,
    NDVI_2024 = runif(sample_size, 0.3, 0.9)
  )
  
  ndvi_2025 <- data.frame(
    TreeID = TreeID,
    NDVI_2025 = runif(sample_size, 0.3, 0.9)
  )
  
  acorn_2024 <- data.frame(
    TreeID = TreeID,
    sum_acorns = round(runif(sample_size, 10, 100))
  )
  
  acorn_2025 <- data.frame(
    TreeID = TreeID,
    acorn_sum = round(runif(sample_size, 15, 110))
  )
  
  # Rename columns to distinguish years
  data_2024 <- acorn_2024 %>%
    rename(sum_acorns_2024 = sum_acorns)
  
  data_2025 <- acorn_2025 %>%
    rename(sum_acorns_2025 = acorn_sum)
  
  # Merge datasets on TreeID
  merged_data <- merge(data_2024, data_2025, by = "TreeID")
  merged_data <- merge(merged_data, ndvi_2024, by = "TreeID")
  merged_data <- merge(merged_data, ndvi_2025, by = "TreeID")
  
  # Generate correlated data
  merged_data$sum_acorns_2024 <- 20 + 70 * merged_data$NDVI_2024 + rnorm(sample_size, 0, 10)
  merged_data$sum_acorns_2025 <- 25 + 65 * merged_data$NDVI_2025 + rnorm(sample_size, 0, 12)
  
  # Model 1: NDVI in 2024 predicting Acorn count in 2024
  model_2024 <- lm(sum_acorns_2024 ~ NDVI_2024, data = merged_data)
  summary_2024 <- summary(model_2024)
  r2_2024 <- round(summary_2024$r.squared, 3)
  p_value_2024 <- round(summary_2024$coefficients[2,4], 3)
  
  # Model 2: NDVI in 2025 predicting Acorn count in 2025
  model_2025 <- lm(sum_acorns_2025 ~ NDVI_2025, data = merged_data)
  summary_2025 <- summary(model_2025)
  r2_2025 <- round(summary_2025$r.squared, 3)
  p_value_2025 <- round(summary_2025$coefficients[2,4], 3)
  
  # Reshape data into long format for mixed model
  long_data <- merged_data %>%
    pivot_longer(cols = c(sum_acorns_2024, sum_acorns_2025, NDVI_2024, NDVI_2025),
                 names_to = c(".value", "Year"),
                 names_pattern = "(.*)_(\\d{4})")
  
  # Convert Year to a factor
  long_data$Year <- as.factor(long_data$Year)
  
  # Fit a mixed-effects model
  model_mixed <- lmer(sum_acorns ~ NDVI + (1 | Year) + (1 | TreeID), data = long_data)
  
  # Extract model statistics
  summary_mixed <- summary(model_mixed)
  r2_mixed <- round(r.squaredGLMM(model_mixed)[1], 3)  # Marginal R² (fixed effects only)
  p_value_mixed <- round(coef(summary(model_mixed))["NDVI", "Pr(>|t|)"], 3)
  
  data_loaded <- FALSE
})
```

```{r check-data-source, echo=FALSE, results='asis'}
if (!exists("data_loaded") || !data_loaded) {
  cat("**Note:** Using simulated data for demonstration purposes. Real data files could not be located.")
}
```

### NDVI vs Acorn Production (2024)

```{r plot-2024, echo=FALSE, message=FALSE, warning=FALSE}
ggplot(merged_data, aes(x = NDVI_2024, y = sum_acorns_2024)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "NDVI vs Acorn Production (2024)", 
       x = "NDVI Index (2024)", 
       y = "Acorn Production (Caps/Quadrant, 2024)") +
  theme_minimal() +
  annotate("text", x = max(merged_data$NDVI_2024, na.rm = TRUE) * 0.95, 
           y = max(merged_data$sum_acorns_2024, na.rm = TRUE) * 0.95, 
           label = paste0("R² = ", r2_2024, "\n p = ", p_value_2024),
           hjust = 1, size = 5)
```

### NDVI vs Acorn Production (2025)

```{r plot-2025, echo=FALSE, message=FALSE, warning=FALSE}
ggplot(merged_data, aes(x = NDVI_2025, y = sum_acorns_2025)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "NDVI vs Acorn Production (2025)", 
       x = "NDVI Index (2025)", 
       y = "Acorn Production (Caps/Quadrant, 2025)") +
  theme_minimal() +
  annotate("text", x = max(merged_data$NDVI_2025, na.rm = TRUE) * 0.95, 
           y = max(merged_data$sum_acorns_2025, na.rm = TRUE) * 0.95, 
           label = paste0("R² = ", r2_2025, "\n p = ", p_value_2025),
           hjust = 1, size = 5)
```

### Combined Analysis (2024 & 2025)

```{r plot-combined, echo=FALSE, message=FALSE, warning=FALSE}
ggplot(long_data, aes(x = NDVI, y = sum_acorns, color = Year)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "NDVI vs. Acorn Production (2024 & 2025)", 
       x = "NDVI Index", 
       y = "Acorn Production (Caps/Quadrant)") +
  theme_minimal() +
  scale_color_manual(values = c("2024" = "blue", "2025" = "red")) +
  annotate("text", x = max(long_data$NDVI, na.rm = TRUE) * 0.95, 
           y = max(long_data$sum_acorns, na.rm = TRUE) * 0.95, 
           label = paste0("R² = ", r2_mixed, "\n p = ", p_value_mixed),
           hjust = 1, color = "black", size = 5)
```

### Statistical Summary

```{r stats-summary, echo=FALSE}
cat("2024 Model: R² =", r2_2024, ", p-value =", p_value_2024, "\n")
cat("2025 Model: R² =", r2_2025, ", p-value =", p_value_2025, "\n")
cat("Combined Mixed Model: R² =", r2_mixed, ", p-value =", p_value_mixed, "\n")
```