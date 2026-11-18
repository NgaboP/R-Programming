# Linear Regression - My Practice
# Class work and practice at home
#
# I am using this file to practise simple and multiple
# linear regression in R. The examples use small practice data.
#
# Topics:
# - Exploring data before modelling
# - Correlation
# - Simple linear regression
# - Model summary and coefficients
# - Prediction
# - Multiple linear regression
# - Residuals and diagnostic plots
# - Checking the main regression assumptions

# ==========================================================
# 1. GETTING STARTED
# ==========================================================

# I use ggplot2 for the graphs. The other functions in this
# file are available in base R.
if (!"ggplot2" %in% rownames(installed.packages())) {
  install.packages("ggplot2")
}
library(ggplot2)


# ==========================================================
# 2. PREPARE A PRACTICE DATASET
# ==========================================================

# This is sample data I created for practice, not real student data.
# Marks is the outcome I want to explain.
# Study_Hours and Attendance are possible predictors.

regression_data <- data.frame(
  Student = paste0("Student", 1:12),
  Study_Hours = c(1, 2, 2.5, 3, 4, 4.5, 5, 6, 6.5, 7, 8, 9),
  Attendance = c(55, 60, 62, 65, 70, 72, 75, 80, 82, 85, 90, 95),
  Marks = c(42, 46, 50, 53, 58, 63, 65, 70, 74, 77, 83, 90)
)

# View the data and check the column types.
regression_data
head(regression_data)
str(regression_data)
summary(regression_data)

# Check whether there are missing values in each column.
colSums(is.na(regression_data))


# ==========================================================
# 3. UNDERSTANDING THE VARIABLES
# ==========================================================

# I use summary() to see the range and average of each variable.
summary(regression_data[c("Study_Hours", "Attendance", "Marks")])

# A scatter plot helps me see the relationship between
# study hours and marks before fitting a model.
ggplot(regression_data, aes(x = Study_Hours, y = Marks)) +
  geom_point(size = 3) +
  labs(
    title = "Study Hours and Marks",
    x = "Study Hours",
    y = "Marks"
  )

# I can also look at attendance and marks.
ggplot(regression_data, aes(x = Attendance, y = Marks)) +
  geom_point(size = 3) +
  labs(
    title = "Attendance and Marks",
    x = "Attendance (%)",
    y = "Marks"
  )


# ==========================================================
# 4. CORRELATION
# ==========================================================

# Correlation measures the direction and strength of a
# linear relationship between two numeric variables.
# It ranges from -1 to +1.
#
# Positive: both variables tend to increase together.
# Negative: one tends to decrease as the other increases.
# Near zero: little linear association.
#
# Correlation does not prove that one variable causes another.

cor(
  regression_data$Study_Hours,
  regression_data$Marks,
  method = "pearson"
)

# Correlation between all numeric variables.
cor(regression_data[c("Study_Hours", "Attendance", "Marks")])


# ==========================================================
# 5. SIMPLE LINEAR REGRESSION
# ==========================================================

# Simple linear regression uses one predictor.
# Here I predict Marks using Study_Hours.
#
# Formula: response ~ predictor
# Marks is the response variable (Y).
# Study_Hours is the predictor variable (X).

simple_model <- lm(
  Marks ~ Study_Hours,
  data = regression_data
)

# Model summary includes coefficients, R-squared,
# p-values and residual standard error.
summary(simple_model)

# Extract the estimated intercept and slope.
coef(simple_model)

# The intercept is the estimated mark at zero study hours.
# The slope is the estimated change in marks for one
# additional study hour, according to this fitted model.


# ==========================================================
# 6. REGRESSION LINE AND FITTED VALUES
# ==========================================================

# I use the model to calculate fitted values for the
# observations in the practice dataset.
regression_data$Fitted_Marks <- fitted(simple_model)

# Residual = observed value - fitted value.
regression_data$Residuals <- residuals(simple_model)

regression_data[, c("Student", "Marks", "Fitted_Marks", "Residuals")]

# Plot the observations and the fitted regression line.
ggplot(regression_data, aes(x = Study_Hours, y = Marks)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Simple Linear Regression",
    x = "Study Hours",
    y = "Marks"
  )


# ==========================================================
# 7. MAKING PREDICTIONS
# ==========================================================

# predict() estimates marks for new study-hour values.
# The new data must use the same predictor column name.
# Predictions outside the observed range are extrapolations,
# so I should be careful when interpreting them.

new_students <- data.frame(
  Study_Hours = c(3, 5, 7, 8)
)

predicted_marks <- predict(
  simple_model,
  newdata = new_students
)

prediction_table <- data.frame(
  Study_Hours = new_students$Study_Hours,
  Predicted_Marks = as.numeric(predicted_marks)
)

prediction_table

# I can also request confidence intervals for the
# estimated mean response at each study-hour value.
predict(
  simple_model,
  newdata = new_students,
  interval = "confidence"
)

# A prediction interval is wider because it estimates
# the range for an individual future observation.
predict(
  simple_model,
  newdata = new_students,
  interval = "prediction"
)


# ==========================================================
# 8. MULTIPLE LINEAR REGRESSION
# ==========================================================

# Multiple regression uses two or more predictors.
# Here I use both Study_Hours and Attendance to predict Marks.
#
# Formula: Marks ~ Study_Hours + Attendance

multiple_model <- lm(
  Marks ~ Study_Hours + Attendance,
  data = regression_data
)

summary(multiple_model)

# View the estimated coefficients.
coef(multiple_model)

# Compare the R-squared values of the two models.
summary(simple_model)$r.squared
summary(multiple_model)$r.squared

# I should not choose a model using R-squared alone.
# I also need to consider the assumptions, data quality,
# adjusted R-squared and the purpose of the analysis.


# ==========================================================
# 9. PREDICTION WITH MULTIPLE REGRESSION
# ==========================================================

# For multiple regression, newdata must include all
# predictor columns used in the model.

new_data_multiple <- data.frame(
  Study_Hours = c(4, 6, 8),
  Attendance = c(70, 80, 90)
)

multiple_predictions <- predict(
  multiple_model,
  newdata = new_data_multiple
)

data.frame(
  new_data_multiple,
  Predicted_Marks = as.numeric(multiple_predictions)
)


# ==========================================================
# 10. MAIN LINEAR REGRESSION ASSUMPTIONS
# ==========================================================

# These are the main assumptions I am reviewing:
#
# 1. Linearity:
#    The relationship between predictors and the response
#    should be reasonably linear.
#
# 2. Independence:
#    Observations/errors should be independent. This is
#    considered from how the data was collected and ordered.
#
# 3. Homoscedasticity:
#    Residuals should have roughly constant variance across
#    fitted values.
#
# 4. Normality of residuals:
#    Residuals should be approximately normally distributed
#    for standard small-sample inference.
#
# I use diagnostic plots to look for warning signs.
# The plots support judgement; they do not prove assumptions.


# ==========================================================
# 11. DIAGNOSTIC PLOTS
# ==========================================================

# These are the four standard diagnostic plots for an lm model.
#
# 1. Residuals vs Fitted:
#    Look for a random pattern around zero. A curve may
#    suggest non-linearity; a funnel may suggest unequal spread.
#
# 2. Normal Q-Q:
#    Points should be reasonably close to the reference line.
#    Large departures may suggest non-normal residuals.
#
# 3. Scale-Location:
#    Look for a fairly even band. A changing spread may
#    suggest heteroscedasticity.
#
# 4. Residuals vs Leverage:
#    Helps identify observations that may have strong influence.

par(mfrow = c(2, 2))
plot(simple_model)
par(mfrow = c(1, 1))


# ==========================================================
# 12. CHECKING RESIDUAL NORMALITY
# ==========================================================

# A histogram gives another view of the residual distribution.
model_residuals <- residuals(simple_model)

hist(
  model_residuals,
  main = "Histogram of Regression Residuals",
  xlab = "Residuals",
  col = "lightblue",
  border = "white"
)

# A Q-Q plot compares the residual quantiles with
# theoretical normal quantiles.
qqnorm(model_residuals)
qqline(model_residuals, col = "red")

# Shapiro-Wilk test can be used for a small sample.
# H0: the data are consistent with a normal distribution.
# A small p-value is evidence against normality.
# I should interpret this together with the Q-Q plot.
shapiro.test(model_residuals)


# ==========================================================
# 13. CHECKING CONSTANT VARIANCE
# ==========================================================

# I plot residuals against fitted values.
# A roughly even vertical spread is what I look for.
plot(
  fitted(simple_model),
  residuals(simple_model),
  main = "Residuals vs Fitted Values",
  xlab = "Fitted Values",
  ylab = "Residuals",
  pch = 19
)
abline(h = 0, lty = 2, col = "red")


# ==========================================================
# 14. CHECKING INFLUENTIAL OBSERVATIONS
# ==========================================================

# Cook's distance helps identify observations that may
# strongly influence the fitted model.
cook_values <- cooks.distance(simple_model)
cook_values

plot(
  cook_values,
  type = "h",
  main = "Cook's Distance",
  xlab = "Observation",
  ylab = "Cook's Distance"
)

# This common reference line is only a screening guide,
# not an automatic rule for deleting observations.
abline(h = 4 / nrow(regression_data), lty = 2, col = "red")


# ==========================================================
# 15. MODEL COMPARISON
# ==========================================================

# I can compare the two fitted models using their summaries.
# Adjusted R-squared accounts for the number of predictors.
simple_summary <- summary(simple_model)
multiple_summary <- summary(multiple_model)

model_comparison <- data.frame(
  Model = c("Simple regression", "Multiple regression"),
  R_Squared = c(
    simple_summary$r.squared,
    multiple_summary$r.squared
  ),
  Adjusted_R_Squared = c(
    simple_summary$adj.r.squared,
    multiple_summary$adj.r.squared
  ),
  Residual_Standard_Error = c(
    simple_summary$sigma,
    multiple_summary$sigma
  )
)

model_comparison


# ==========================================================
# 16. PRACTICE QUESTIONS
# ==========================================================

# 1. Fit a simple model using Attendance to predict Marks.
#
# 2. Explain the intercept and slope from the simple model.
#
# 3. Use predict() to estimate marks for 5 study hours.
#
# 4. Fit a multiple regression model using Study_Hours
#    and Attendance.
#
# 5. Explain R-squared and adjusted R-squared.
#
# 6. What is the difference between a confidence interval
#    and a prediction interval?
#
# 7. Use plot(simple_model) and explain the four plots.
#
# 8. What pattern in Residuals vs Fitted may suggest
#    non-linearity or unequal variance?
#
# 9. Why does correlation not prove causation?
#
# 10. Explain why I should not automatically remove an
#     observation just because Cook's distance is high.

# End of my linear regression practice.
