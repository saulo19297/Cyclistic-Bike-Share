install.packages("tidyverse")
install.packages("janitor")
install.packages("psych")
install.packages("hrbrthemes")
#Load Packages
library(tidyverse)
library(lubridate)
library(janitor)
library(data.table)
library(readr)
library(psych)
library(hrbrthemes)
library(ggplot2)

#Import Data
january_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202101-divvy-tripdata.csv")
february_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202102-divvy-tripdata.csv")
march_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202103-divvy-tripdata.csv")
april_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202104-divvy-tripdata.csv")
may_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202105-divvy-tripdata.csv")
june_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202106-divvy-tripdata.csv")
july_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202107-divvy-tripdata.csv")
august_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202108-divvy-tripdata.csv")
september_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202109-divvy-tripdata.csv")
october_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202110-divvy-tripdata.csv")
november_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202111-divvy-tripdata.csv")
december_2021 <- read.csv("C:\\Users\\saulo\\OneDrive\\Desktop\\coursera capstone\\Downloads\\202112-divvy-tripdata.csv")

#Data Validation
colnames(january_2021)
colnames(february_2021)
colnames(march_2021)
colnames(april_2021)
colnames(may_2021)
colnames(june_2021)
colnames(july_2021)
colnames(august_2021)
colnames(september_2021)
colnames(october_2021)
colnames(november_2021)
colnames(december_2021)

# Total number of rows
sum( nrow(january_2021) + nrow(february_2021) 
    + nrow(march_2021) + nrow(april_2021) + nrow(may_2021) 
    + nrow(june_2021) + nrow(july_2021) + nrow(august_2021)
    + nrow(september_2021) + nrow(october_2021) + nrow(november_2021)+ nrow(december_2021))

# Combine Data of 12 month into for smooth workflow
all_trip <- rbind(january_2021,february_2021,march_2021,april_2021,
                    may_2021,june_2021,july_2021,august_2021,september_2021,october_2021,november_2021,december_2021)

# Save the combined files
write.csv(all_trip,"C:\\Users\\saulo\\OneDrive\\Desktop\\all_trip.csv",row.names=FALSE)

# Setting global variable size to inf
options(future.globals.maxSize = Inf)

#Final data validation
str(all_trip)
View(head(all_trip))
View(tail(all_trip))
dim(all_trip)
summary(all_trip)
names(all_trip)

#Data Cleaning

#Count rows with "na" values
colSums(is.na(all_trip))

#Remove missing
clean_all_trip <- all_trip[complete.cases(all_trip), ]

colSums(is.na(clean_all_trip))

#Remove duplicates
clean_all_trip <- distinct(clean_all_trip)

#Remove data with greater start_at than end_at
clean_all_trip<- clean_all_trip %>% 
  filter(started_at < ended_at)

#Remove na
clean_all_trip <- drop_na(clean_all_trip)
clean_all_trip <- remove_empty(clean_all_trip)
clean_all_trip <- remove_missing(clean_all_trip)

#Check Cleaned data
colSums(is.na(clean_all_trip))

#Separate date in date, day, month, year for better analysis
clean_all_trip$date <- as.Date(clean_all_trip$started_at)
clean_all_trip$week_day <- format(as.Date(clean_all_trip$date), "%A")
clean_all_trip$month <- format(as.Date(clean_all_trip$date), "%b_%y")
clean_all_trip$year <- format(clean_all_trip$date, "%Y")

#Add ride length column
clean_all_trip$ride_length <- difftime(clean_all_trip$ended_at, clean_all_trip$started_at, units = "mins")

#Remove stolen bikes
clean_all_trip <- clean_all_trip[!clean_all_trip$ride_length>1440,] 
clean_all_trip <- clean_all_trip[!clean_all_trip$ride_length<5,]

#Save the cleaned data 
write.csv(clean_all_trip,"C:\\Users\\saulo\\OneDrive\\Desktop\\clean_all_trip.csv",row.names=FALSE)
