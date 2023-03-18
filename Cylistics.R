
  
  # Load libraries
library(tidyverse) #Calculations
library(hms) # Date
library(lubridate)# Time


#load the cyclist data from Jan 2022 - Dec 2022
Jan_01 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202201-divvy-tripdata/New folder/202201-divvy-tripdata.csv")
Feb_02 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202202-divvy-tripdata/202202-divvy-tripdata.csv")
Mar_03 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202203-divvy-tripdata/202203-divvy-tripdata.csv")
Apr_04 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202204-divvy-tripdata/202204-divvy-tripdata.csv")
May_05 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202205-divvy-tripdata/202205-divvy-tripdata.csv")
Jun_06 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202206-divvy-tripdata/202206-divvy-tripdata.csv")
Jul_07 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202207-divvy-tripdata/202207-divvy-tripdata.csv")
Aug_08 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202208-divvy-tripdata/202208-divvy-tripdata.csv")
Sep_09 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202209-divvy-tripdata/202209-divvy-publictripdata.csv")
oct_10 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202210-divvy-tripdata/202210-divvy-tripdata.csv")
Nov_11 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202211-divvy-tripdata/202211-divvy-tripdata.csv")
Dec_12 <- read_csv("~/Dolapo's Docs/STUDIES/Capstone Project/2022 data/202212-divvy-tripdata/202212-divvy-tripdata.csv")

#I already checked the files and saw that the columnsin each file are the same, so i can join them into one dataframe

#Merge all the dataframes into one

cylistic_df <- rbind(Jan_01, Feb_02, Mar_03, Apr_04, May_05, Jun_06, Jul_07, Aug_08, Sep_09, oct_10, Nov_11, Dec_12)


remove(Jan_01, Feb_02, Mar_03, Apr_04, May_05, Jun_06, Jul_07, Aug_08, Sep_09, oct_10, Nov_11, Dec_12)

# create a new dataframe for the new columns

cylis_new <- cylistic_df

colnames(cylis_new)
head(cylis_new)
str(cylis_new)

#Calculate ride_length by subtracting ended_at from started_at

cylis_new$ride_length <- difftime(cylis_new$ended_at, cylis_new$started_at, units = 'mins')



#add  new columns to the cylis_new: date, days, month, 

cylis_new$date <- as.Date(cylis_new$started_at)# default format is yyyy-mm-dd
cylis_new$day_of_week <- wday(cylis_new$started_at)# calculate day of the week
cylis_new$day_of_week <- format(as.Date(cylis_new$date), '%A') # create column for day of the week
cylis_new$days <- format(as.Date(cylis_new$date), '%d') # create column for day
cylis_new$month <- format(as.Date(cylis_new$date), '%m') # create column for month
cylis_new$time <- format(as.Date(cylis_new$date), '%H:%M:%S') #format time as H:M:S
cylis_new$time <- as_hms(cylis_new$started_at) # create column for time
cylis_new$hour <- hour(cylis_new$time)

str(cylis_new)

#create column for diff seasons: summer, winter, fall, spring

cylis_new <- cylis_new %>% mutate(season = 
                                    
                                    case_when(month =='01' ~ 'Winter',
                                              month == '02' ~ 'Winter',
                                              month == '03' ~ 'Spring',
                                              month == '04' ~ 'Spring',
                                              month == '05' ~ 'Spring',
                                              month == '06' ~ 'Summer',
                                              month == '07' ~ 'Summer',
                                              month == '08' ~ 'Summer',
                                              month == '09' ~ 'Fall',
                                              month == '10' ~ 'Fall',
                                              month == '11' ~ 'Fall',
                                              month == '12' ~ 'Winter')
                                  
)

#create column for diff time : morning, afternoon, evening, night

cylis_new <- cylis_new %>% mutate(time_of_day =
                                    
                                    case_when(hour == "0" ~ "Night",
                                              hour == "1" ~ "Night",
                                              hour == "2" ~ "Night",
                                              hour == "3" ~ "Night",
                                              hour == "4" ~ "Night",
                                              hour == "5" ~ "Night",
                                              hour == "6" ~ "Morning",
                                              hour == "7" ~ "Morning",
                                              hour == "8" ~ "Morning",
                                              hour == "9" ~ "Morning",
                                              hour == "10" ~ "Morning",
                                              hour == "11" ~ "Morning",
                                              hour == "12" ~ "Afternoon",
                                              hour == "13" ~ "Afternoon",
                                              hour == "14" ~ "Afternoon",
                                              hour == "15" ~ "Afternoon",
                                              hour == "16" ~ "Afternoon",
                                              hour == "17" ~ "Afternoon",
                                              hour == "18" ~ "Evening",
                                              hour == "19" ~ "Evening",
                                              hour == "20" ~ "Evening",
                                              hour == "21" ~ "Evening",
                                              hour == "22" ~ "Evening",
                                              hour == "23" ~ "Evening")
)



#clean the data

cylis_new <- na.omit(cylis_new) # remove null values
cylis_new <- distinct(cylis_new) #remove duplicate rows
cylis_new <- cylis_new[!(cylis_new$ride_length <= 0),] # remove where ride_length is negative and zero
cylis_new <- cylis_new %>% select(-c(start_station_id, end_station_id,start_lat,start_lng,end_lat,end_lng))

View(cylis_new)

# ConverSion of ride length to numeric so calculations can be run on the data

cylis_new$ride_length <- as.numeric(as.character(cylis_new$ride_length))
is.numeric(cylis_new$ride_length)

###----------------------------------CALCULATIONS/ANALYSIS------------------------



nrow(cylis_new)

#-----count member type-----

cylis_new %>% 
  group_by(member_casual) %>%
  count(member_casual)


#Total number of member type

cylis_new %>% 
  count(member_casual)

#-----Count of type of rideable_type----

cylis_new %>% 
  group_by(member_casual, rideable_type) %>% 
  count(rideable_type)

#total ride
cylis_new %>% 
  group_by(rideable_type)%>%
  count(rideable_type)

#-----Hour-----

#total ride by membertype
cylis_new %>% 
  group_by(member_casual) %>%
  count(hour) %>%
  print(n = 48) #lets you view the entire tibble

#total ride
cylis_new %>%
  count(hour) %>%
  print(n = 24)

#-----Time of day----

#Night

# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(time_of_day == 'Night') %>%
  count(time_of_day)

#total ride
cylis_new %>%
  filter(time_of_day == 'Night') %>%
  count(time_of_day)

#Morning
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(time_of_day == 'Morning') %>%
  count(time_of_day)

#total ride
cylis_new %>%
  filter(time_of_day == 'Morning') %>%
  count(time_of_day)

#Afternoon
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(time_of_day == 'Afternoon') %>%
  count(time_of_day)

#total ride
cylis_new %>%
  filter(time_of_day == 'Afternoon') %>%
  count(time_of_day)

#Evening
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(time_of_day == 'Evening') %>%
  count(time_of_day)

#total ride
cylis_new %>%
  filter(time_of_day == 'Evening') %>%
  count(time_of_day)

#all time of the day
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  count(time_of_day)

#total ride
cylis_new %>%
  count(time_of_day)


#----Day_of_week-----
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  count(day_of_week)%>%
  arrange(-n)

#total ride
cylis_new %>%
  count(day_of_week) 


#----Days----
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  count(days)%>%
  print(n = 62)

#total ride
cylis_new %>%
  count(time_of_day)%>%
  print(n = 31)

#----Month-----
# total ride by membertype
#Casual
cylis_new %>%
  group_by(member_casual) %>%
  filter(member_casual == 'casual')%>%
  count(month)%>%
  arrange(-n)%>%
  print(n = 12)

#Member 
cylis_new %>%
  group_by(member_casual) %>%
  filter(member_casual == 'member')%>%
  count(month)%>%
  arrange(-n)%>%
  print(n = 12)

#total ride
cylis_new %>%
  count(month)



#----SEASON----

#WINTER
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(season== 'Winter') %>%
  count(season)

#total ride
cylis_new %>%
  filter(season == 'Winter') %>%
  count(season)

#SPRING
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(season== 'Spring') %>%
  count(season)

#total ride
cylis_new %>%
  filter(season == 'Spring') %>%
  count(season)

#SUMMER
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(season== 'Summer') %>%
  count(season)

#total ride
cylis_new %>%
  filter(season == 'Summer') %>%
  count(season)

#FALL
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  filter(season== 'Fall') %>%
  count(season)

#total ride
cylis_new %>%
  filter(season == 'Fall') %>%
  count(season)

#ALL SEASONS
# total ride by membertype
cylis_new %>%
  group_by(member_casual) %>%
  count(season)

#total ride
cylis_new %>%
  count(season)



#------AVERAGE RIDE LENGTH----
# avg ride_length
cyclistic_rideAvg <- mean(cylis_new$ride_length)
print(cyclistic_rideAvg)



#---By member type---
#Avg ride_length
CasRideAvg <- cylis_new %>%
  group_by(member_casual)%>%
  filter('casual' == member_casual) %>% 
  summarize(ride_avg= mean(ride_length))

MemRideAvg <- cylis_new %>%
  group_by(member_casual)%>%
  filter('member' == member_casual) %>% 
  summarize(ride_avg= mean(ride_length))


#----BY Bike type----

#Avg ride by membertype
cylis_new %>%
  group_by(member_casual, rideable_type)%>%
  summarize(ride_avg = mean(ride_length))

#Avg ride_length
cylis_new %>%
  group_by(rideable_type)%>%
  summarize(ride_avg = mean(ride_length))


#----Hour----

#avg ride length by membertype
cylis_new %>%
  group_by(member_casual, hour)%>%
  summarize(ride_avg = mean(ride_length))%>%
  print(n = 48)

#Avg ride length total
cylis_new %>%
  group_by(hour)%>%
  summarize(ride_avg= mean(ride_length))%>%
  print(n = 24)

#----Time of day----

#Night
#Avg ride_length by membertype
cylis_new %>%
  group_by(member_casual)%>%
  filter(time_of_day == 'Night')%>%
  summarize(ride_avg = mean(ride_length))

#Total Avg
cylis_new %>%
  group_by(time_of_day)%>%
  filter(time_of_day == 'Night')%>%
  summarize(ride_avg = mean(ride_length))

#Morning
#Avg ride_length by membertype
cylis_new %>%
  group_by(member_casual)%>%
  filter(time_of_day == 'Morning')%>%
  summarize(ride_avg = mean(ride_length))

#Total Avg
cylis_new %>%
  group_by(time_of_day)%>%
  filter(time_of_day == 'Morning')%>%
  summarize(ride_avg= mean(ride_length))


#Afternoon
#Avg ride_length by membertype
cylis_new %>%
  group_by(member_casual)%>%
  filter(time_of_day == 'Afternoon')%>%
  summarize(ride_avg = mean(ride_length))

#Total Avg
cylis_new %>%
  group_by(time_of_day)%>%
  filter(time_of_day == 'Afternoon')%>%
  summarize(ride_avg = mean(ride_length))


#Evening
#Avg ride_length by membertype
cylis_new %>%
  group_by(member_casual)%>%
  filter(time_of_day == 'Evening')%>%
  summarize(ride_avg = mean(ride_length))

#Total Avg
cylis_new %>%
  group_by(time_of_day)%>%
  filter(time_of_day == 'Evening')%>%
  summarize(ride_avg = mean(ride_length))

#All times of the day
#Total avg by member type
cylis_new  %>%
  group_by(member_casual, time_of_day)%>%
  summarize(ride_avg = mean(ride_length))

#Total Avg
cylis_new  %>%
  group_by(time_of_day)%>%
  summarize(ride_avg = mean(ride_length))


#----Day_of_week-----

#Avg ride_length by member type

cylis_new %>%
  group_by(member_casual,day_of_week)%>%
  summarize(ride_avg = mean(ride_length))

#Total Avg

cylis_new %>%
  group_by(day_of_week)%>%
  summarize(ride_avg = mean(ride_length))




#-----Day-----

#Avg ride_length by member type

cylis_new %>%
  group_by(member_casual,days)%>%
  summarize(ride_avg = mean(ride_length))%>%
  print(n = 62)

#Total Avg

cylis_new %>%
  group_by(days)%>%
  summarize(ride_avg = mean(ride_length))%>%
  print( n = 31)


#------MONTH-----

#Avg ride_length by member type

cylis_new %>%
  group_by(member_casual,month)%>%
  summarize(ride_avg = mean(ride_length))%>%
  print( n = 24)

#Total Avg

cylis_new %>%
  group_by(month)%>%
  summarize(ride_avg = mean(ride_length))%>%
  print( n = 24 )


#----SEASONS----

#---WINTER----
#Avg ride_length by member type

cylis_new %>%
  group_by(member_casual)%>%
  filter(season == 'Winter') %>%
  summarize(ride_avg= mean(ride_length))

#Total Avg

cylis_new %>%
  filter(season == 'Winter')%>%
  summarize(ride_avg = mean(ride_length))


#---SPRING----
#Avg ride_length by member type

cylis_new %>%
  group_by(member_casual)%>%
  filter(season == 'Spring') %>%
  summarize(ride_avg= mean(ride_length))

#Total Avg

cylis_new %>%
  filter(season == 'Spring')%>%
  summarize(ride_avg = mean(ride_length))

#---SUMMER----
#AVG RIDE BY MEMBER TYPE

cylis_new %>%
  group_by(member_casual)%>%
  filter(season == 'Summer') %>%
  summarize(ride_avg = mean(ride_length))

#Total Avg

cylis_new %>%
  filter(season == 'Summer')%>%
  summarize(ride_avg = mean(ride_length))


#---FALL----
#AVG RIDE BY MEMBER TYPE
cylis_new %>%
  group_by(member_casual)%>%
  filter(season == 'Fall') %>%
  summarize(ride_avg = mean(ride_length))

#Total Avg

cylis_new %>%
  filter(season == 'Fall')%>%
  summarize(ride_avg = mean(ride_length))

#ALL SEASONS

cylis_new %>%
  group_by(member_casual, season)%>%
  summarize(ride_avg = mean(ride_length))


#Total Avg

cylis_new %>%
  group_by(season)%>%
  summarize(ride_avg_mins = mean(ride_length))





###---------------------------------------VISUALIZATIONS---------------------------

 cylis_new %>%
  group_by(member_casual)%>%
  summarize(count_mem = n())%>%
  ggplot(aes( x = '',y = member_casual, fill = member_casual)) +
  geom_bar( stat = 'identity', width = 1, color = 'white' )+
  coord_polar( 'y', start = 0)+
  theme_void()+ # remove background, grid, numeric labels
  labs(title = 'Total Count Of Member Type', x = 'Member Type', y = 'Count of Trips')
 
   

 cylis_new %>%
  group_by(member_casual,rideable_type)%>%
  summarise(count_bike = n()) %>%
  ggplot(aes(x = rideable_type, y = count_bike, fill = member_casual, color = member_casual)) +
  geom_bar( stat ='identity', position = 'dodge')+
  labs(title = 'Total count of Bikes', x = 'Bike types', y = 'Count of trips')

 cylis_new %>%
  group_by(member_casual, hour)%>%
  summarise(count_trip = n()) %>%
  ggplot(aes(x = hour, y = count_trip, fill = member_casual, color = member_casual))+
  geom_bar(stat = 'identity', position = 'dodge')+
  labs(title = 'Total Count of Ride per hour', x = 'hours', y = 'count of tirps')

#Arrange time of day
 cylis_new %>%
  mutate (cylis_new$time_of_day <- ordered(cylis_new$time_of_day, levels = c('Morning', 'Afternoon', 'Evening', 'Night'))) %>% 
  group_by(time_of_day,member_casual)%>%
  summarise(count_trip = n()) %>%
  ggplot(aes(x = time_of_day, y = count_trip, fill = member_casual, color = member_casual))+
  geom_bar(stat = 'identity', position = 'dodge')+
  labs(title = 'Number of ride by Time of the day', x = 'Time of the day', y = 'count of tirps')

#Arrange day of week
 cylis_new %>%
  mutate(cylis_new$day_of_week <- ordered(cylis_new$day_of_week, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))) %>% 
  group_by(member_casual, day_of_week)%>%
  summarise(count_trip = n()) %>%
  ggplot(aes(x = day_of_week, y = count_trip, fill = member_casual, color = member_casual))+
  geom_bar(stat = 'identity', position = 'dodge')+
  labs(title = 'Number of Rides by Days of the Week', x = 'Days of the Week', y = 'count of tirps')

cylis_new %>%
  group_by(member_casual, month)%>%
  summarise(count_trip = n()) %>%
  ggplot(aes(x = month, y = count_trip, fill = member_casual, color = member_casual))+
  geom_bar(stat = 'identity', position = 'dodge')+
  labs(title = 'Number of Rides by Month', x = 'Month', y = 'count of tirps')

cylis_new %>%
  group_by(member_casual, season)%>%
  summarise(count_trip = n()) %>%
  ggplot(aes(x = season, y = count_trip, fill = member_casual, color = member_casual))+
  geom_bar(stat = 'identity', position = 'dodge')+
  labs(title = 'Number of Rides by Season', x = 'Seasons', y = 'count of tirps')


#-----Most Popular start stations by Member Bikers-----

 cylis_new %>%  
  group_by(member_casual, start_station_name)%>%
  summarise(num_of_ride = n())%>%
  filter(start_station_name != "", "member"== member_casual)%>%
  arrange(-num_of_ride)%>%
  print( n = 20)


#-----Most Popular start stations by Casual Bikers-----

cylis_new %>%
  group_by(member_casual, start_station_name)%>%
  summarise(num_of_ride = n())%>%
  filter(start_station_name != "", "casual"== member_casual)%>%
  arrange(-num_of_ride)%>%
  print( n = 20)

#------AVERAGE RIDE LENGTH----
# avg ride_length
cyclistic_rideAvg <- mean(cylis_new$ride_length)
print(cyclistic_rideAvg)



#---By member type---
#Avg ride_length
cylis_new %>%
  group_by(member_casual)%>%
  filter('casual' == member_casual) %>% 
  summarize(ride_avg= mean(ride_length))

cylis_new %>%
  group_by(member_casual)%>%
  filter('member' == member_casual) %>% 
  summarize(ride_avg= mean(ride_length))



















