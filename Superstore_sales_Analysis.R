# 1. Load libraries
# 2. Import dataset
# 3. Data cleaning
# 4. Exploratory data analysis (EDA)
# 5. Key business questions
#    a) Total revenue & quantity
#    b) Revenue by segment
#    c) Monthly sales trend


# Load libraries 
install.packages("readr")
install.packages("dplyr")
install.packages("readxl")

library(readxl)
library(readr)
library(dplyr)



getwd()
setwd("~/Documents")

# Read CSV with automatic UTF-8 handling 

sales <- read_csv()

Sales11 <- read_excel("~/Documents/SUPERSTORE5.xlsx")

View(Sales11)

# See Column Names
colnames(Sales11)

# Summary of data
summary(Sales11)

# Count rows
nrow(Sales11)

# Check for missing Values
colSums(is.na(Sales11))

# Total revenue and quantity
Sales11 %>%
  summarise(
    Total_Revenue = sum(Sales, na.rm = TRUE),
             Total_Quantity = sum(Quantity, na.rm = TRUE)
    ) %>% View()

# Revenue By Segment
Sales11 %>% 
  group_by(Segment) %>% 
  summarise(Revenue = sum(Sales, na.rm = TRUE)) %>%
  arrange(desc(Revenue)) %>% View()

# Monthly trend
Sales11 %>%
  mutate(Order_Month = format(as.Date(`Order Date`), "%Y-%m")) %>% View()


library(ggplot2)

# Revenue by segment (bar chart)
Consumer segment accounts for the highest revenue, contributing nearly half of sales.

Sales11 %>%
  group_by(Segment) %>%
  summarise(Revenue = sum(Sales, na.rm = TRUE)) %>%
  ggplot(aes(x = Segment, y = Revenue, fill = Segment)) +
  geom_col() +
  labs(title = "Revenue by Customer Segment")

# Monthly sales trend
Sales11 %>%
  mutate(Order_Month = format(as.Date(`Order Date`), "%Y-%m")) %>%
  group_by(Order_Month) %>%
  summarise(Monthly_Revenue = sum(Sales, na.rm = TRUE)) %>%
  ggplot(aes(x = Order_Month, y = Monthly_Revenue, group = 1)) +
  geom_line(color = "blue") +
  labs(title = "Monthly Sales Trend") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
