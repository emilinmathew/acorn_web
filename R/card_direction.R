library(ggplot2)
library(dplyr)
library(tidyr)
library(lmerTest)

acorn_2024 <- read.csv("../static/2024_acorn_card.csv")
acorn_2025 <- read.csv("../static/2025_acorn_card.csv")

# Perform a paired t-test to compare acorn production on north vs. south sides of the trees
t_test_2024 <- t.test(acorn_2024$north_acorn, acorn_2024$south_acorn, paired = TRUE)

# Print results
print("Paired t-test for north vs. south acorn production:")
print(t_test_2024)

colnames(acorn_2025)

t_test_2025 <- t.test(acorn_2025$north_acorn, acorn_2025$south_acorn, paired = TRUE)
print(t_test_2025)


ggplot(acorn_2024, aes(x = "North", y = north_acorn)) +
  geom_boxplot(fill = "lightblue", alpha = 0.6) +
  geom_boxplot(data = acorn_2024, aes(x = "South", y = south_acorn), fill = "lightcoral", alpha = 0.6) +
  labs(title = "North vs. South Acorn Production (2024)", x = "Tree Side", y = "Acorn Count") +
  theme_minimal()


ggplot(acorn_2025, aes(x = "North", y = north_acorn)) +
  geom_boxplot(fill = "lightblue", alpha = 0.6) +
  geom_boxplot(data = acorn_2025, aes(x = "South", y = south_acorn), fill = "lightcoral", alpha = 0.6) +
  labs(title = "North vs. South Acorn Production (2025)", x = "Tree Side", y = "Acorn Count") +
  theme_minimal()



#This suggests no strong evidence of a difference in acorn production between the north and south sides of trees across both years.

# Combine both years into one dataframe
acorn_data <- bind_rows(
  mutate(acorn_2024, Year = 2024),  # ✅ Add Year column
  mutate(acorn_2025, Year = 2025)   # ✅ Add Year column
)
# Ensure Year is a factor
acorn_data$Year <- as.factor(acorn_data$Year)

# Run a paired t-test on the combined dataset, grouped by year
t_test_result <- t.test(acorn_data$north_acorn, acorn_data$south_acorn, paired = TRUE)

# Print the result
print(t_test_result)




# 
# # Ran a linear mixed model (LMM) to test if there is a difference between 
# # north vs. south acorn production, while accounting for repeated measurements per tree.



joint_data <- bind_rows(
  mutate(acorn_2024, Year = 2024),  
  mutate(acorn_2025, Year = 2025)
)

joint_data$Year <- as.factor(joint_data$Year)  # Convert Year to factor


model <- lmer(north_acorn - south_acorn ~ 1 + (1 | TreeID), data = joint_data)
summary(model)

ggplot(joint_data, aes(x = Year, y = north_acorn - south_acorn, fill = Year)) +
  geom_boxplot(alpha = 0.5) +
  geom_jitter(width = 0.1, alpha = 0.7) +
  labs(title = "Difference in Acorn Production (North - South) by Year",
       y = "Acorn Difference (North - South)", x = "Year") +
  theme_minimal() +
  scale_fill_manual(name = "Year", values = c("2024" = "lightblue", "2025" = "lightcoral"))

