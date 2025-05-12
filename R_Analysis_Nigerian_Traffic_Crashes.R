# Loading required libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(forecast)
library(caret)
library(randomForest)
library(lubridate)

# Loading the dataset (assuming it's in CSV format)
crashes <- read.csv("C:\\Users\\DELL\\Downloads\\Nigerian_Road_Traffic_Crashes_2020_2024.csv")

# Converting Quarter to a date for time series analysis
crashes <- crashes %>%
  mutate(Date = as.Date(paste0(substr(Quarter, 4, 7), "-", 
                               case_when(
                                 substr(Quarter, 1, 2) == "Q1" ~ "01-01",
                                 substr(Quarter, 1, 2) == "Q2" ~ "04-01",
                                 substr(Quarter, 1, 2) == "Q3" ~ "07-01",
                                 substr(Quarter, 1, 2) == "Q4" ~ "10-01"
                               ))))

# 1. Exploratory Data Analysis (EDA)
# Summarizing crashes by state and year
eda_state <- crashes %>%
  group_by(State) %>%
  summarise(
    Total_Crashes = sum(Total_Crashes),
    Total_Injured = sum(Num_Injured),
    Total_Killed = sum(Num_Killed),
    Avg_Vehicles = mean(Total_Vehicles_Involved)
  ) %>%
  arrange(desc(Total_Crashes))

# Visualizing top 5 states by crashes
ggplot(head(eda_state, 5), aes(x = reorder(State, Total_Crashes), y = Total_Crashes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 5 States by Total Crashes (2020-2024)", x = "State", y = "Total Crashes") +
  theme_minimal()

# Visualizing crash causes
crash_causes <- crashes %>%
  summarise(
    SPV = sum(SPV),
    DAD = sum(DAD),
    PWR = sum(PWR),
    FTQ = sum(FTQ),
    Other = sum(Other_Factors)
  ) %>%
  pivot_longer(everything(), names_to = "Cause", values_to = "Count")

ggplot(crash_causes, aes(x = Cause, y = Count, fill = Cause)) +
  geom_bar(stat = "identity") +
  labs(title = "Crash Causes Distribution (2020-2024)", x = "Cause", y = "Count") +
  theme_minimal()

# 2. Statistical Inference
# Chi-square test: Association between SPV and Num_Killed
crashes$High_Fatality <- ifelse(crashes$Num_Killed > median(crashes$Num_Killed), 1, 0)
chisq.test(table(crashes$SPV > 0, crashes$High_Fatality))

# Linear regression: Impact of crash causes on fatalities
lm_model <- lm(Num_Killed ~ SPV + DAD + PWR + FTQ + Other_Factors, data = crashes)
summary(lm_model)

# 3. Predictive Modeling
# Random Forest to predict crash severity (Num_Killed)
set.seed(123)
train_index <- createDataPartition(crashes$Num_Killed, p = 0.8, list = FALSE)
train_data <- crashes[train_index, ]
test_data <- crashes[-train_index, ]

rf_model <- randomForest(Num_Killed ~ SPV + DAD + PWR + FTQ + Other_Factors + 
                           Total_Vehicles_Involved + State, data = train_data, ntree = 100)
predictions <- predict(rf_model, test_data)
rmse <- sqrt(mean((predictions - test_data$Num_Killed)^2))
cat("Random Forest RMSE:", rmse, "\n")

# 4. Time Series Analysis
# Aggregating crashes by quarter
ts_data <- crashes %>%
  group_by(Date) %>%
  summarise(Total_Crashes = sum(Total_Crashes)) %>%
  arrange(Date)

# Converting to time series object
ts_crashes <- ts(ts_data$Total_Crashes, start = c(2020, 4), frequency = 4)

# Decomposing time series
decomp <- stl(ts_crashes, s.window = "periodic")
plot(decomp)

# ARIMA forecasting
arima_model <- auto.arima(ts_crashes)
forecast_values <- forecast(arima_model, h = 4) # Forecast next 4 quarters
plot(forecast_values, main = "Crash Forecast for 2025")

# 5. Practical Insights
# Identifying high-risk states for intervention
high_risk_states <- eda_state %>%
  filter(Total_Killed > quantile(Total_Killed, 0.75)) %>%
  select(State, Total_Crashes, Total_Killed)

write.csv(high_risk_states, "high_risk_states.csv", row.names = FALSE)