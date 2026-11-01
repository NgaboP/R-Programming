library(readxl)
library(dplyr)
library(ggplot2)
library(scales)

data <- read_excel("C:/Users/Administrator/Desktop/R/27-10-2026.xlsx")
head(data)

str(data)


# Convert transaction date and time
data$`Date time` <- as.POSIXct(
  data$`Date time`,
  format = "%y%m%d %H:%M:%S"
)
data$transaction_date <- as.Date(data$'Date time')
names(data)


data <- data %>%
  rename(
    homeTransactionId = `Home Transaction ID`,
    transfer_id = `Transfer ID`,
    direction = Direction,
    corresponding_participant = `Corresponding participant`,
    payer = Payer,
    account = `Account No`,
    amount = Amount,
    currency = Currency,
    current_state = `Current state`,
    date_time = `Date time`,
    settlementWindowCode = `Settlement Window Code`,
    reason = `Error message`
  )
names(data)


data$date_time <- as.POSIXct(
  data$date_time,
  format = "%y%m%d %H:%M:%S",
  tz = "Africa/Kigali"
)

data$transaction_date <- as.Date(data$date_time)





total_records <- nrow(data)
total_records


completed_records <- sum(data$current_state == "COMPLETED")
failed_records <- sum(data$current_state == "FAILED")
completion_rate <- completed_records / total_records *100
failure_rate <- failed_records / total_records * 100

kpi_summary <- data.frame(
  Metric = c(
    "Total Records",
    "Completed Records",
    "Failed Records",
    "Completion Rate (%)",
    "Failure Rate (%)"
    
  ),
  Value = c(
  total_records,
    completed_records,
    failed_records,
    round(completion_rate, 2),
    round(failure_rate, 2)
  )
)

print(kpi_summary)

print("R is working")

print(table(data$current_state, useNA = "ifany"))



status_summary <- data %>%
  count(current_state, name = "records")

print(status_summary)

p <- ggplot(status_summary,
            aes(x = current_state, y = records, fill = current_state)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = scales::comma(records)), vjust = -0.4) +
  scale_fill_manual(values = c(
    "COMPLETED" = "#176B45",
    "FAILED" = "#B64A4A"
  )) +
  labs(
    title = "Transaction Processing Outcomes",
    x = "Transaction Status",
    y = "Number of Transactions"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(p)




daily_volume <- data %>%
  group_by(transaction_date, direction) %>%
  summarise(
    records = n(),
    .groups = "drop"
  )

print(daily_volume, n = Inf)



ggplot(daily_volume,
       aes(x = transaction_date, y = records, fill = direction)) +
  geom_col(position = "dodge") +
  geom_text(
    aes(label = comma(records)),
    position = position_dodge(width = 0.9),
    vjust = -0.3,
    size = 3
  ) +
  scale_fill_manual(
    values = c(
      "INBOUND" = "#2E8B57",
      "OUTBOUND" = "#B64A4A"
    )
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Daily Transaction Volume",
    x = "Transaction Date",
    y = "Number of Transactions",
    fill = "Direction"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(colour = "#176B45", face = "bold")
  )


class(data$amount)
head(data$amount, 10)

daily_amount <- data %>%
  group_by(transaction_date, direction) %>%
  summarise(
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

data$amount <- as.numeric(gsub(",", "", data$amount))


  


print(daily_amount, n = Inf)


daily_amount <- data %>%
  group_by(transaction_date, direction) %>%
  summarise(
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

print(daily_amount, n = Inf)
\\