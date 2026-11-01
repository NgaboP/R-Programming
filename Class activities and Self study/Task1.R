library(readxl)
library(dplyr)
library(ggplot2)


data <- read_excel("C:/Users/Administrator/Desktop/R/Book2.xlsx")

head(data)
dim(data)
names(data)
str(data)
unique(data$current_state)
unique(data$direction)
unique(data$currency)
colSums(is.na(data))
head(data)

table(data$direction, useNA= "ifany")

round(
  prop.table(table(data$current_state))*100,2
)

table(
  Direction = data$direction,
  Status = data$current_state
)


data %>%
  group_by(direction, current_state) %>%
  summarise(
    records = n(),
    total_amount = sum(amount, na.rm = TRUE),
    average_amount = mean(amount, na.rm = TRUE),
    .groups = "drop"
  )


data$date_time <- as.POSIXct(
  data$date_time,
  format = "%y%m%d %H:%M:%S",
  tz = "Africa/Kigali"
)

head(data$date_time)


data$transaction_date <- as.Date(data$date_time)

table(data$transaction_date)




daily_summary <- data %>%
  group_by(transaction_date, direction, current_state) %>%
  summarise(
    records = n(),
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

print(daily_summary, n = Inf)


failed_transactions <- data %>%
  filter(current_state == "FAILED") %>%
  group_by(direction, reason) %>%
  summarise(
    failed_records = n(),
    failed_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(failed_records))

print(failed_transactions, n = Inf)



duplicate_ids <- data %>%
  count(homeTransactionId, name = "record_count") %>%
  filter(record_count > 1) %>%
  arrange(desc(record_count))

head(duplicate_ids, 10)

nrow(duplicate_ids)
