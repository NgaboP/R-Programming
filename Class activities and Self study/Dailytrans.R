library(readxl)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)

data <- read_excel("C:/Users/Administrator/Desktop/R/job/27-10-2026.xlsx")
head(data)

# Number of records and columns
dim(data)

# Column names
names(data)

# Structure of the dataset
str(data)

# First six records
head(data)




min(data$date_time, na.rm = TRUE)
max(data$date_time, na.rm = TRUE)


##Rename the columns by removing spaces in columns name

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

variable.names(data)

#Convert the amount to numeric

data$amount <- as.numeric(data$amount)

#Convert the transaction date and time

data$date_time <- as.POSIXct(
  data$date_time,
  format = "%y%m%d %H:%M:%S",
  tz = "Africa/Kigali"
)


data$transaction_date <- as.Date(data$date_time)


# Check date and time
head(data$date_time)

# Check reporting period
min(data$date_time, na.rm = TRUE)
max(data$date_time, na.rm = TRUE)

# Check missing dates
sum(is.na(data$date_time))

# Check missing amounts
sum(is.na(data$amount))



total_records <- nrow(data)

completed_records <- sum(data$current_state == "COMPLETED", na.rm = TRUE)

failed_records <- sum(data$current_state == "FAILED", na.rm = TRUE)



completion_rate <- (completed_records / total_records) * 100

failure_rate <- (failed_records / total_records) * 100


#Overall transaction performance

total_records <- nrow(data)

completed_records <- sum(data$current_state == "COMPLETED")
failed_records <- sum(data$current_state == "FAILED")

completion_rate <- completed_records / total_records * 100
failure_rate <- failed_records / total_records * 100

kpi_summary <- data.frame(
  Metric = c(
    "Total Transactions",
    "Completed Transactions",
    "Failed Transactions",
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

View(kpi_summary)



financial_summary <- data %>%
  filter(current_state == "COMPLETED") %>%
  summarise(
    total_completed_value = sum(amount, na.rm = TRUE),
    average_transaction_value = mean(amount, na.rm = TRUE),
    highest_transaction_value = max(amount, na.rm = TRUE),
    lowest_transaction_value = min(amount, na.rm = TRUE)
  )

print(financial_summary)
View(financial_summary)


direction_summary <- data %>%
  group_by(direction) %>%
  summarise(
    transaction_count = n(),
    percentage = n() / nrow(data) * 100,
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

print(direction_summary)
View(direction_summary)


ggplot(direction_summary,
       aes(x = direction, y = transaction_count, fill = direction)) +
  geom_col(width = 0.6) +
  geom_text(
    aes(label = paste0(
      scales::comma(transaction_count), "\n",
      round(percentage, 2), "%"
    )),
    vjust = -0.4
  ) +
  scale_fill_manual(values = c(
    "INBOUND" = "#2E8B57",
    "OUTBOUND" = "#176B45"
  )) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Transaction Distribution by Direction",
    subtitle = "Inbound vs Outbound",
    x = "Transaction Direction",
    y = "Number of Transactions"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(
      colour = "#176B45",
      face = "bold"
    )
  )



financial_summary <- data %>%
  filter(current_state == "COMPLETED") %>%
  summarise(
    total_completed_value = sum(amount, na.rm = TRUE),
    average_transaction_value = mean(amount, na.rm = TRUE),
    highest_transaction_value = max(amount, na.rm = TRUE),
    lowest_transaction_value = min(amount, na.rm = TRUE)
  )

print(financial_summary)





direction_summary <- data %>%
  group_by(direction) %>%
  summarise(
    transaction_count = n(),
    percentage = n() / nrow(data) * 100,
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

print(direction_summary)



ggplot(direction_summary,
       aes(x = reorder(direction, transaction_count),
           y = transaction_count,
           fill = direction)) +
  
  geom_col(width = 0.55) +
  
  geom_text(
    aes(label = paste0(
      scales::comma(transaction_count),
      " transactions (",
      round(percentage, 1), "%)"
    )),
    hjust = -0.1,
    size = 4
  ) +
  
  coord_flip() +
  
  scale_fill_manual(values = c(
    "INBOUND" = "#2E8B57",
    "OUTBOUND" = "#176B45"
  )) +
  
  scale_y_continuous(
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.35))
  ) +
  
  labs(
    title = "Outbound Transactions Dominate Daily Activity",
    subtitle = "Transaction volume by direction | 27 October 2026",
    x = NULL,
    y = "Number of transactions"
  ) +
  
  theme_minimal() +
  
  theme(
    legend.position = "none",
    plot.title = element_text(
      face = "bold",
      colour = "#176B45",
      size = 14
    )
  )




status_direction <- data %>%
  group_by(direction, current_state) %>%
  summarise(
    transaction_count = n(),
    .groups = "drop"
  ) %>%
  group_by(direction) %>%
  mutate(
    percentage = transaction_count / sum(transaction_count) * 100
  )

print(status_direction)




ggplot(status_direction,
       aes(x = direction,
           y = percentage,
           fill = current_state)) +
  
  geom_col(
    position = position_dodge(width = 0.75),
    width = 0.65
  ) +
  
  geom_text(
    aes(label = paste0(round(percentage, 2), "%")),
    position = position_dodge(width = 0.75),
    vjust = -0.5,
    fontface = "bold",
    size = 4
  ) +
  
  scale_fill_manual(values = c(
    "COMPLETED" = "#2E8B57",
    "FAILED" = "#E74C3C"
  )) +
  
  scale_y_continuous(
    labels = scales::label_percent(scale = 1),
    expand = expansion(mult = c(0, 0.15))
  ) +
  
  labs(
    title = "Transaction Success vs Failure by Direction",
    subtitle = "Inbound and outbound transaction performance",
    x = "Transaction Direction",
    y = "Percentage of Transactions",
    fill = "Transaction Status"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    ),
    legend.position = "bottom"
  )

data <- data %>%
  mutate(
    transaction_hour = lubridate::hour(date_time)
  )
head(data[c("date_time", "transaction_hour")])



hourly_summary <- data %>%
  group_by(transaction_hour) %>%
  summarise(
    transaction_count = n(),
    percentage = n() / nrow(data) * 100,
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

print(hourly_summary)



ggplot(hourly_summary,
       aes(x = transaction_hour,
           y = transaction_count)) +
  
  geom_line(colour = "#176B45", linewidth = 1.2) +
  geom_point(colour = "#2E8B57", size = 3) +
  
  scale_x_continuous(breaks = 0:23) +
  scale_y_continuous(labels = scales::comma) +
  
  labs(
    title = "Hourly Transaction Activity",
    subtitle = "Transaction volume throughout 27 October 2026",
    x = "Hour of the Day",
    y = "Number of Transactions"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    )
  )


peak_hour <- hourly_summary %>%
  slice_max(transaction_count, n = 1)

print(peak_hour)


ggplot(hourly_summary,
       aes(x = transaction_hour,
           y = transaction_count)) +
  
  geom_line(
    colour = "#176B45",
    linewidth = 1.2
  ) +
  
  geom_point(
    colour = "#2E8B57",
    size = 2.5
  ) +
  
  geom_point(
    data = peak_hour,
    colour = "#E74C3C",
    size = 5
  ) +
  
  geom_text(
    data = peak_hour,
    aes(label = paste0(
      "PEAK: ",
      scales::comma(transaction_count)
    )),
    vjust = -1.2,
    colour = "#C0392B",
    fontface = "bold"
  ) +
  
  scale_x_continuous(breaks = 0:23) +
  scale_y_continuous(labels = scales::comma) +
  
  labs(
    title = "Hourly Transaction Activity",
    subtitle = "Peak transaction period highlighted | 27 October 2026",
    x = "Hour of the Day",
    y = "Number of Transactions"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold"
    )
  )


failed_data <- data %>%
  filter(current_state == "FAILED")

nrow(failed_data)


failure_summary <- failed_data %>%
  group_by(reason) %>%
  summarise(
    failure_count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(failure_count)) %>%
  mutate(
    percentage = failure_count / sum(failure_count) * 100,
    cumulative_percentage = cumsum(percentage)
  )

print(failure_summary)



ggplot(failure_summary,
       aes(x = reorder(reason, failure_count),
           y = failure_count)) +
  
  geom_col(fill = "#C0392B", width = 0.7) +
  
  geom_text(
    aes(label = paste0(
      failure_count, " (",
      round(percentage, 1), "%)"
    )),
    hjust = -0.1,
    size = 3.5
  ) +
  
  coord_flip() +
  
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.25))
  ) +
  
  labs(
    title = "Main Causes of Failed Transactions",
    subtitle = "Failure count and percentage by error reason",
    x = "Failure Reason",
    y = "Number of Failed Transactions"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    )
  )





ggplot(failure_summary,
       aes(x = reorder(reason, -failure_count))) +
  
  geom_col(
    aes(y = failure_count),
    fill = "#C0392B",
    width = 0.7
  ) +
  
  geom_line(
    aes(
      y = cumulative_percentage * 118 / 100,
      group = 1
    ),
    colour = "#176B45",
    linewidth = 1.2
  ) +
  
  geom_point(
    aes(y = cumulative_percentage * 118 / 100),
    colour = "#176B45",
    size = 3
  ) +
  
  geom_hline(
    yintercept = 118 * 0.8,
    linetype = "dashed",
    colour = "orange"
  ) +
  
  scale_y_continuous(
    name = "Number of Failed Transactions",
    sec.axis = sec_axis(
      ~ . / 118 * 100,
      name = "Cumulative Percentage",
      labels = scales::label_percent(scale = 1)
    )
  ) +
  
  labs(
    title = "Pareto Analysis of Transaction Failures",
    subtitle = "Identifying the failure reasons responsible for most failures",
    x = "Failure Reason"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold"
    ),
    axis.text.x = element_text(
      angle = 35,
      hjust = 1
    )
  )


failure_summary <- failure_summary %>%
  mutate(
    short_reason = case_when(
      grepl("078", reason) ~ "Payee 078 Timeout",
      grepl("beneficiary", reason, ignore.case = TRUE) ~ "Beneficiary Rejection",
      grepl("075", reason) ~ "Payee 075 Timeout",
      grepl("073", reason) ~ "Payee 073 Timeout",
      TRUE ~ "Other"
    )
  )


ggplot(failure_summary,
       aes(x = reorder(short_reason, -failure_count))) +
  
  geom_col(
    aes(y = failure_count),
    fill = "#C0392B",
    width = 0.65
  ) +
  
  geom_text(
    aes(y = failure_count, label = failure_count),
    vjust = -0.5,
    fontface = "bold"
  ) +
  
  geom_line(
    aes(
      y = cumulative_percentage * sum(failure_count) / 100,
      group = 1
    ),
    colour = "#176B45",
    linewidth = 1.2
  ) +
  
  geom_point(
    aes(y = cumulative_percentage * sum(failure_count) / 100),
    colour = "#176B45",
    size = 3
  ) +
  
  geom_hline(
    yintercept = sum(failure_summary$failure_count) * 0.8,
    colour = "orange",
    linetype = "dashed"
  ) +
  
  scale_y_continuous(
    name = "Failed Transactions",
    sec.axis = sec_axis(
      ~ . / sum(failure_summary$failure_count) * 100,
      name = "Cumulative Percentage"
    )
  ) +
  
  labs(
    title = "Pareto Analysis of Transaction Failures",
    subtitle = "The two leading causes account for approximately 89% of failures",
    x = "Failure Category"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    ),
    axis.text.x = element_text(
      angle = 20,
      hjust = 1
    )
  )



participant_summary <- data %>%
  group_by(corresponding_participant) %>%
  summarise(
    transaction_count = n(),
    failed_count = sum(current_state == "FAILED", na.rm = TRUE),
    completed_count = sum(current_state == "COMPLETED", na.rm = TRUE),
    total_amount = sum(amount, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    transaction_share = transaction_count / sum(transaction_count) * 100,
    failure_rate = failed_count / transaction_count * 100
  ) %>%
  arrange(desc(transaction_count))

print(participant_summary)



top_participants <- participant_summary %>%
  slice_max(transaction_count, n = 10)

print(top_participants)


ggplot(top_participants,
       aes(x = reorder(corresponding_participant, transaction_count),
           y = transaction_count)) +
  
  geom_col(fill = "#176B45", width = 0.7) +
  
  geom_text(
    aes(label = paste0(
      scales::comma(transaction_count),
      " (", round(transaction_share, 1), "%)"
    )),
    hjust = -0.1,
    size = 3.5
  ) +
  
  coord_flip() +
  
  scale_y_continuous(
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.25))
  ) +
  
  labs(
    title = "Top 10 Participants by Transaction Volume",
    subtitle = "Transaction count and share of daily activity",
    x = "Participant",
    y = "Number of Transactions"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    )
  )



participant_failure <- participant_summary %>%
  filter(transaction_count >= 100) %>%
  arrange(desc(failure_rate))

print(participant_failure)


ggplot(participant_failure,
       aes(x = reorder(corresponding_participant, failure_rate),
           y = failure_rate)) +
  
  geom_col(fill = "#C0392B", width = 0.65) +
  
  geom_text(
    aes(label = paste0(round(failure_rate, 2), "%")),
    hjust = -0.1,
    fontface = "bold"
  ) +
  
  coord_flip() +
  
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.25))
  ) +
  
  labs(
    title = "Participant Failure Rate Comparison",
    subtitle = "Failure percentage among participants with at least 100 transactions",
    x = "Participant",
    y = "Failure Rate (%)"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    )
  )





participant_value <- data %>%
  filter(current_state == "COMPLETED") %>%
  group_by(corresponding_participant) %>%
  summarise(
    transaction_count = n(),
    total_value = sum(amount, na.rm = TRUE),
    average_value = mean(amount, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    value_share = total_value / sum(total_value) * 100
  ) %>%
  arrange(desc(total_value))

print(participant_value)



top_value_participants <- participant_value %>%
  slice_max(total_value, n = 10)

print(top_value_participants)


ggplot(top_value_participants,
       aes(x = reorder(corresponding_participant, total_value),
           y = total_value)) +
  
  geom_col(fill = "#176B45", width = 0.7) +
  
  geom_text(
    aes(label = paste0(
      scales::comma(total_value),
      " RWF (",
      round(value_share, 1), "%)"
    )),
    hjust = -0.1,
    size = 3.5
  ) +
  
  coord_flip() +
  
  scale_y_continuous(
    labels = scales::comma,
    expand = expansion(mult = c(0, 0.35))
  ) +
  
  labs(
    title = "Top 10 Participants by Completed Transaction Value",
    subtitle = "Financial value and share of daily completed transactions",
    x = "Participant",
    y = "Completed Transaction Value (RWF)"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    )
  )


participant_comparison <- data %>%
  group_by(corresponding_participant) %>%
  summarise(
    total_transactions = n(),
    completed_value = sum(
      amount[current_state == "COMPLETED"],
      na.rm = TRUE
    ),
    average_completed_value = mean(
      amount[current_state == "COMPLETED"],
      na.rm = TRUE
    ),
    .groups = "drop"
  )

print(participant_comparison)



ggplot(
  participant_comparison,
  aes(
    x = total_transactions,
    y = completed_value,
    label = corresponding_participant
  )
) +
  
  geom_point(
    colour = "#2E8B57",
    size = 4,
    alpha = 0.8
  ) +
  
  geom_text(
    nudge_y = 0.15,
    check_overlap = TRUE,
    size = 3
  ) +
  
  scale_x_log10(labels = scales::comma) +
  scale_y_log10(labels = scales::comma) +
  
  labs(
    title = "Transaction Volume vs Financial Value",
    subtitle = "Comparison of participant activity and completed transaction value",
    x = "Number of Transactions (log scale)",
    y = "Completed Transaction Value (RWF, log scale)"
  ) +
  
  theme_minimal() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 14
    )
  )




missing_summary <- data %>%
  summarise(
    missing_transaction_id = sum(is.na(homeTransactionId)),
    missing_transfer_id = sum(is.na(transfer_id)),
    missing_direction = sum(is.na(direction)),
    missing_participant = sum(is.na(corresponding_participant)),
    missing_amount = sum(is.na(amount)),
    missing_currency = sum(is.na(currency)),
    missing_status = sum(is.na(current_state)),
    missing_date = sum(is.na(date_time))
  )

print(missing_summary)


duplicate_ids <- data %>%
  count(homeTransactionId) %>%
  filter(n > 1)

print(duplicate_ids)

invalid_amounts <- data %>%
  filter(is.na(amount) | amount <= 0)

nrow(invalid_amounts)


print(as.data.frame(missing_summary))



blank_summary <- data %>%
  summarise(
    blank_direction = sum(trimws(direction) == "", na.rm = TRUE),
    blank_participant = sum(trimws(corresponding_participant) == "", na.rm = TRUE),
    blank_currency = sum(trimws(currency) == "", na.rm = TRUE),
    blank_status = sum(trimws(current_state) == "", na.rm = TRUE),
    blank_error_message = sum(trimws(reason) == "", na.rm = TRUE)
  )

print(as.data.frame(blank_summary))


# Check transaction statuses
status_check <- data %>%
  count(current_state)

print(status_check)


# Check transaction currencies
currency_check <- data %>%
  count(currency)

print(currency_check)


# Check transaction directions
direction_check <- data %>%
  count(direction)

print(direction_check)


total_records <- nrow(data)

completed_records <- sum(
  data$current_state == "COMPLETED",
  na.rm = TRUE
)

failed_records <- sum(
  data$current_state == "FAILED",
  na.rm = TRUE
)

total_completed_value <- sum(
  data$amount[data$current_state == "COMPLETED"],
  na.rm = TRUE
)

completion_rate <- completed_records / total_records * 100

failure_rate <- failed_records / total_records * 100


print(total_records)
print(completed_records)
print(failed_records)
print(total_completed_value)
print(completion_rate)
print(failure_rate)


kpi_data <- data.frame(
  metric = c(
    "TOTAL TRANSACTIONS",
    "COMPLETED TRANSACTIONS",
    "FAILED TRANSACTIONS",
    "COMPLETED VALUE (RWF)"
  ),
  
  value = c(
    scales::comma(total_records),
    scales::comma(completed_records),
    scales::comma(failed_records),
    scales::comma(total_completed_value)
  ),
  
  x = c(1, 2, 1, 2),
  y = c(2, 2, 1, 1)
)

print(kpi_data)



ggplot(kpi_data, aes(x = x, y = y)) +
  
  geom_tile(
    fill = "#E8F3EC",
    colour = "#176B45",
    width = 0.9,
    height = 0.8,
    linewidth = 1
  ) +
  
  geom_text(
    aes(label = paste0(metric, "\n", value)),
    colour = "#176B45",
    fontface = "bold",
    size = 5
  ) +
  
  scale_x_continuous(
    breaks = NULL,
    limits = c(0.4, 2.6)
  ) +
  
  scale_y_continuous(
    breaks = NULL,
    limits = c(0.4, 2.6)
  ) +
  
  labs(
    title = "DAILY FINANCIAL TRANSACTION DASHBOARD",
    subtitle = "27 October 2026 | Transaction Performance Overview"
  ) +
  
  theme_void() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 16,
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 11
    )
  )


kpi_data <- data.frame(
  metric = c(
    "TOTAL TRANSACTIONS",
    "COMPLETED TRANSACTIONS",
    "FAILED TRANSACTIONS",
    "COMPLETION RATE",
    "FAILURE RATE",
    "COMPLETED VALUE (RWF)"
  ),
  
  value = c(
    scales::comma(total_records),
    scales::comma(completed_records),
    scales::comma(failed_records),
    paste0(round(completion_rate, 2), "%"),
    paste0(round(failure_rate, 2), "%"),
    scales::comma(total_completed_value)
  ),
  
  x = c(1, 2, 3, 1, 2, 3),
  y = c(2, 2, 2, 1, 1, 1)
)


ggplot(kpi_data, aes(x = x, y = y)) +
  
  geom_tile(
    fill = "#E8F3EC",
    colour = "#176B45",
    width = 0.9,
    height = 0.8,
    linewidth = 1
  ) +
  
  geom_text(
    aes(label = paste0(metric, "\n", value)),
    colour = "#176B45",
    fontface = "bold",
    size = 4
  ) +
  
  scale_x_continuous(
    breaks = NULL,
    limits = c(0.4, 3.6)
  ) +
  
  scale_y_continuous(
    breaks = NULL,
    limits = c(0.4, 2.6)
  ) +
  
  labs(
    title = "DAILY FINANCIAL TRANSACTION DASHBOARD",
    subtitle = "27 October 2026 | Transaction Performance Overview"
  ) +
  
  theme_void() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 16,
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 11
    )
  )



kpi_data <- kpi_data %>%
  mutate(
    card_color = case_when(
      metric %in% c(
        "FAILED TRANSACTIONS",
        "FAILURE RATE"
      ) ~ "#FCE4E4",
      TRUE ~ "#E8F3EC"
    ),
    
    text_color = case_when(
      metric %in% c(
        "FAILED TRANSACTIONS",
        "FAILURE RATE"
      ) ~ "#C0392B",
      TRUE ~ "#176B45"
    )
  )


ggplot(kpi_data, aes(x = x, y = y)) +
  
  geom_tile(
    aes(fill = card_color),
    colour = "#176B45",
    width = 0.9,
    height = 0.8,
    linewidth = 1
  ) +
  
  geom_text(
    aes(
      label = paste0(metric, "\n", value),
      colour = text_color
    ),
    fontface = "bold",
    size = 3.5
  ) +
  
  scale_fill_identity() +
  scale_colour_identity() +
  
  scale_x_continuous(
    breaks = NULL,
    limits = c(0.4, 3.6)
  ) +
  
  scale_y_continuous(
    breaks = NULL,
    limits = c(0.4, 2.6)
  ) +
  
  labs(
    title = "DAILY FINANCIAL TRANSACTION DASHBOARD",
    subtitle = "27 October 2026 | Transaction Performance Overview"
  ) +
  
  theme_void() +
  
  theme(
    plot.title = element_text(
      colour = "#176B45",
      face = "bold",
      size = 16,
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 11
    )
  )


hourly_failures <- data %>%
  filter(current_state == "FAILED") %>%
  group_by(transaction_hour) %>%
  summarise(
    failed_transactions = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(failed_transactions))

print(hourly_failures)


peak_failure <- hourly_failures %>%
  slice_max(failed_transactions, n = 1)

print(peak_failure)



ggplot(hourly_failures,
       aes(x = factor(transaction_hour),
           y = failed_transactions)) +
  geom_col(fill = "red") +
  geom_col(
    data = peak_failure,
    fill = "darkred"
  ) +
  geom_text(
    aes(label = failed_transactions),
    vjust = -0.5
  ) +
  labs(
    title = "Hourly Failed Transaction Activity",
    subtitle = "Peak failure hour highlighted",
    x = "Hour of Day",
    y = "Number of Failed Transactions"
  ) +
  theme_minimal()




participant_summary <- data %>%
  filter(current_state == "COMPLETED") %>%
  group_by(corresponding_participant) %>%
  summarise(
    transaction_volume = n(),
    financial_value = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )


ggplot(participant_summary,
       aes(x = transaction_volume,
           y = financial_value,
           label = corresponding_participant)) +
  
  geom_point(color = "darkgreen", size = 3) +
  
  geom_text(vjust = -0.8, size = 3) +
  
  scale_x_log10(labels = scales::comma) +
  
  scale_y_log10(labels = scales::comma) +
  
  labs(
    title = "Transaction Volume vs Financial Value",
    subtitle = "Completed transactions by participant",
    x = "Transaction Volume (log scale)",
    y = "Financial Value in RWF (log scale)"
  ) +
  
  theme_minimal()


install.packages("ggrepel")  # Run once
library(ggrepel)



ggplot(participant_summary,
       aes(x = transaction_volume,
           y = financial_value,
           label = corresponding_participant)) +
  
  geom_point(color = "darkgreen", size = 3) +
  
  geom_label_repel(
    size = 3.2,
    max.overlaps = Inf,
    force = 3,
    box.padding = 0.8,
    point.padding = 0.6,
    direction = "both",
    min.segment.length = 0,
    seed = 123
  ) +
  
  scale_x_log10(labels = scales::comma) +
  scale_y_log10(labels = scales::comma) +
  
  labs(
    title = "Transaction Volume vs Financial Value",
    subtitle = "Completed transactions by participant",
    x = "Transaction Volume (log scale)",
    y = "Financial Value (RWF, log scale)"
  ) +
  
  theme_minimal(base_size = 13)


ggsave(
  "participant_volume_vs_value.png",
  width = 12,
  height = 8,
  dpi = 300
)




failed_then_successful <- data %>%
  group_by(homeTransactionId) %>%
  filter(
    any(current_state == "FAILED") &
      any(current_state == "COMPLETED")
  ) %>%
  arrange(date_time, .by_group = TRUE) %>%
  filter(
    first(current_state) == "FAILED"
  ) %>%
  ungroup()

print(failed_then_successful)



failed_then_successful %>%
  summarise(
    recovered_transactions = n_distinct(homeTransactionId)
  )


recovery_rate <- n_distinct(
  failed_then_successful$homeTransactionId
) / n_distinct(
  data$homeTransactionId[data$current_state == "FAILED"]
) * 100

print(recovery_rate)


id_check <- data %>%
  summarise(
    total_records = n(),
    unique_home_ids = n_distinct(homeTransactionId),
    unique_transfer_ids = n_distinct(transfer_id),
    repeated_home_ids = sum(duplicated(homeTransactionId)),
    repeated_transfer_ids = sum(duplicated(transfer_id))
  )

print(id_check)



check_home <- data %>%
  group_by(homeTransactionId) %>%
  summarise(
    has_failed = any(current_state == "FAILED"),
    has_completed = any(current_state == "COMPLETED"),
    records = n(),
    .groups = "drop"
  )

check_transfer <- data %>%
  group_by(transfer_id) %>%
  summarise(
    has_failed = any(current_state == "FAILED"),
    has_completed = any(current_state == "COMPLETED"),
    records = n(),
    .groups = "drop"
  )

# Count matches
check_home %>%
  summarise(matches = sum(has_failed & has_completed))

check_transfer %>%
  summarise(matches = sum(has_failed & has_completed))



data %>%
  group_by(
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  summarise(
    failed_count = sum(current_state == "FAILED"),
    completed_count = sum(current_state == "COMPLETED"),
    .groups = "drop"
  ) %>%
  filter(failed_count > 0, completed_count > 0) %>%
  arrange(desc(failed_count))


variable.names(data)




possible_retries <- data %>%
  group_by(
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  filter(
    any(current_state == "FAILED") &
      any(current_state == "COMPLETED")
  ) %>%
  arrange(date_time, .by_group = TRUE) %>%
  ungroup()

print(possible_retries, n = 20)


retry_candidates <- data %>%
  group_by(
    payer,
    account,
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  filter(
    any(current_state == "FAILED") &
      any(current_state == "COMPLETED")
  ) %>%
  arrange(date_time, .by_group = TRUE) %>%
  ungroup()

print(retry_candidates, n = 20)


retry_analysis <- retry_candidates %>%
  group_by(
    payer,
    account,
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  summarise(
    failed_time = min(date_time[current_state == "FAILED"]),
    completed_time = min(date_time[current_state == "COMPLETED"]),
    .groups = "drop"
  ) %>%
  mutate(
    time_difference_minutes = as.numeric(
      difftime(completed_time, failed_time, units = "mins")
    )
  ) %>%
  filter(time_difference_minutes >= 0)

print(retry_analysis, n = 20)



nrow(retry_analysis)



possible_retries <- data %>%
  group_by(
    account,
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  filter(
    any(current_state == "FAILED") &
      any(current_state == "COMPLETED")
  ) %>%
  arrange(date_time, .by_group = TRUE) %>%
  ungroup()

print(possible_retries, n = 20)



recovery_candidates <- possible_retries %>%
  group_by(
    account,
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  summarise(
    first_failure = min(date_time[current_state == "FAILED"]),
    first_success = min(date_time[current_state == "COMPLETED"]),
    .groups = "drop"
  ) %>%
  filter(first_success > first_failure) %>%
  mutate(
    delay_minutes = as.numeric(
      difftime(first_success, first_failure, units = "mins")
    )
  )

print(recovery_candidates, n = 20)


nrow(recovery_candidates)




recovery_candidates <- data %>%
  group_by(
    account,
    direction,
    corresponding_participant,
    amount,
    currency
  ) %>%
  group_modify(~ {
    failed <- .x %>%
      filter(current_state == "FAILED")
    
    completed <- .x %>%
      filter(current_state == "COMPLETED")
    
    if (nrow(failed) == 0 || nrow(completed) == 0) {
      return(tibble())
    }
    
    failed %>%
      rowwise() %>%
      mutate(
        success_time = {
          later <- completed$date_time[
            completed$date_time > date_time
          ]
          
          if (length(later) == 0) {
            as.POSIXct(NA)
          } else {
            min(later)
          }
        }
      ) %>%
      ungroup() %>%
      filter(!is.na(success_time)) %>%
      mutate(
        delay_minutes = as.numeric(
          difftime(success_time, date_time, units = "mins")
        )
      )
  }) %>%
  ungroup()

print(recovery_candidates, n = 20)




recovery_summary <- recovery_candidates %>%
  summarise(
    possible_recoveries = n(),
    average_delay = mean(delay_minutes),
    shortest_delay = min(delay_minutes),
    longest_delay = max(delay_minutes)
  )

print(recovery_summary)


recovery_candidates %>%
  mutate(
    delay_category = case_when(
      delay_minutes <= 5 ~ "Within 5 minutes",
      delay_minutes <= 15 ~ "6–15 minutes",
      delay_minutes <= 30 ~ "16–30 minutes",
      delay_minutes <= 60 ~ "31–60 minutes",
      TRUE ~ "Above 60 minutes"
    )
  ) %>%
  count(delay_category)


recovery_delay_summary <- recovery_candidates %>%
  mutate(
    delay_category = case_when(
      delay_minutes <= 5 ~ "Within 5 minutes",
      delay_minutes <= 15 ~ "6–15 minutes",
      delay_minutes <= 30 ~ "16–30 minutes",
      delay_minutes <= 60 ~ "31–60 minutes",
      TRUE ~ "Above 60 minutes"
    )
  ) %>%
  count(delay_category) %>%
  mutate(
    percentage = round(n / sum(n) * 100, 1)
  )

print(recovery_delay_summary)



ggplot(recovery_delay_summary,
       aes(x = delay_category, y = n)) +
  geom_col(fill = "darkgreen") +
  geom_text(aes(label = n), vjust = -0.5) +
  labs(
    title = "Distribution of Possible Recovery Delays",
    subtitle = "Failed transactions followed by matching completed transactions",
    x = "Recovery Delay",
    y = "Number of Possible Recoveries"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))





library(dplyr)
library(ggplot2)

recovery_delay_summary <- recovery_candidates %>%
  mutate(
    delay_category = case_when(
      delay_minutes <= 5 ~ "Within 5 minutes",
      delay_minutes <= 15 ~ "6–15 minutes",
      delay_minutes <= 30 ~ "16–30 minutes",
      delay_minutes <= 60 ~ "31–60 minutes",
      TRUE ~ "Above 60 minutes"
    )
  ) %>%
  count(delay_category) %>%
  mutate(
    percentage = round(n / sum(n) * 100, 1),
    delay_category = factor(
      delay_category,
      levels = c(
        "Within 5 minutes",
        "6–15 minutes",
        "16–30 minutes",
        "31–60 minutes",
        "Above 60 minutes"
      )
    )
  )


ggplot(recovery_delay_summary,
       aes(x = delay_category, y = n)) +
  
  geom_col(fill = "darkgreen", width = 0.7) +
  
  geom_text(
    aes(label = paste0(n, "\n", percentage, "%")),
    vjust = -0.3,
    size = 4
  ) +
  
  labs(
    title = "Failed Transactions and Possible Recoveries",
    subtitle = "Time between failed transactions and matching completed transactions",
    x = "Recovery Delay",
    y = "Number of Possible Recoveries",
    caption = "Total possible recoveries: 47"
  ) +
  
  theme_minimal(base_size = 13) +
  
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 20, hjust = 1)
  )