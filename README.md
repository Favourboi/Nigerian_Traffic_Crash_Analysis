# Nigerian Road Traffic Crash Analysis (2020–2024)

This repository contains an R script to analyze road traffic crashes in Nigeria from 2020 to 2024. The analysis includes exploratory data analysis (EDA), statistical inference, predictive modeling, and time series forecasting to identify crash patterns, high-risk states, and contributing factors like speed violations.

## Project Overview

The dataset (`Nigerian_Road_Traffic_Crashes_2020_2024.csv`) includes quarterly crash data across Nigerian states, with variables such as:
- Total crashes, injuries, and fatalities
- Number of vehicles involved
- Crash causes (e.g., Speed Violation, Drunk Driving, Poor Weather, Fatigue, Other Factors)

The R script (`R_Analysis_Nigerian_Traffic_Crashes.R`) performs:
- **EDA**: Visualizes crash trends by state and cause.
- **Statistical Inference**: Tests associations between crash causes and fatalities.
- **Predictive Modeling**: Uses Random Forest to predict crash severity.
- **Time Series Analysis**: Forecasts future crash trends using ARIMA.

The goal is to provide actionable insights for improving road safety in Nigeria, such as targeting high-risk states or addressing prevalent crash causes.

## Requirements

- **R**: Version 4.0 or higher
- **R Packages**:
  - `dplyr`, `tidyr` (data manipulation)
  - `ggplot2` (visualization)
  - `forecast` (time series)
  - `caret`, `randomForest` (predictive modeling)
  - `lubridate` (date handling)
- **RStudio** (optional, recommended for easier code execution)
- **Dataset**: `Nigerian_Road_Traffic_Crashes_2020_2024.csv` (not included in this repository due to size)

Install the required packages in R:
```R
install.packages(c("dplyr", "tidyr", "ggplot2", "forecast", "caret", "randomForest", "lubridate"))
