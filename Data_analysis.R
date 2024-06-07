#Load Packages
library(tidyverse)
library(lubridate)
library(janitor)
library(data.table)
library(readr)
library(psych)
library(hrbrthemes)
library(ggplot2)

#import the cleaned data
clean_all_trip <- read_csv("C:\\Users\\saulo\\OneDrive\\Desktop\\clean_all_trip.csv")
str(clean_all_trip)
names(clean_all_trip)

#order the data
clean_all_trip$month <- ordered(clean_all_trip$month,levels=c("Jan_21","Feb_21","Mar_21", 
                                                                   "Apr_21","May_21","Jun_21","Jul_21", 
                                                                   "Aug_21","Sep_21","Oct_21","Nov_21","Dec_21"))

clean_all_trip$week_day <- ordered(clean_all_trip$week_day, levels = c("Sunday", "Monday", "Tuesday", 
                                                                           "Wednesday", "Thursday", 
                                                                           "Friday", "Saturday"))

#Analysis:- min, max, median, average
View(describe(clean_all_trip$ride_length, fast=TRUE))

#Total no. of customers
View(table(clean_all_trip$member_casual))

#Average ride_length by month
View(clean_all_trip %>% 
       group_by(month) %>% 
       summarise(Avg_length = mean(ride_length),
                 number_of_ride = n()))

#Average ride_length by week day
View(clean_all_trip %>% 
       group_by(week_day) %>% 
       summarise(Avg_length = mean(ride_length),
                 number_of_ride = n()))


