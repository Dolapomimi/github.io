# GooglecapstoneProject-Cyclistic

### INTRODUCTION

Cyclistic is a fictional bike sharing program which features more than 5,800 bikes and 600 docking stations. It offers reclining bikes, hand tricycles, and cargo bikes, making it more inclusive to people with disabilities and riders who can't use a standard two-wheeled bike. It was founded in 2016 and has grown tremendously into a fleet of bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.


### BUSINESS TASK

I am a junior business analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago that features more than 5,800 bicycles and 600 docking station.
The director of marketing believes the company’s future success depends on maximizing the number of annual membership. Therefore, my team wants to understand how casual riders and annual members use Cyclistic bikes differently.
To design marketing strategies aimed at converting casual riders into annual members, how? 
1. By understanding how annual members and casual riders use bikes differently,

2. why casual riders would buy a membership,

3. understanding how digital media could affect our marketing tactics.

#### GOAL
Maximize the number of annual membership.

####
In this Project, I prepared, processed, analyzed the data using R, visualized the insights gotten from the data and gave business recommendations and markeking strategies.

### PREPARE DATA
The data that would be used for analysis is Cyclistic historical trip data from the paszt 12 months (Jan 2022 -Dec 2022) https://divvy-tripdata.s3.amazonaws.com/index.html made available by Motivation International Inc.

I have downloaded the data and opened in Excel spreadsheet, it is very large but structured with each columns having headers, same datatype in each column. Saved in csv format.
The integrity of the data is not verified, The data has up to date records of trips for analyzing historic data. The data has null values in some rows and duplicates. I would have to filter and sort the data but I would not using Excel for this.

### PROCESS DATA
I am using R for processing and analyzing, because the dataset is very large and R Studio is an IDE, so my can work will be fast and I can do all of the work on here.
First 
- I would load useful packages in R studio for my data.

- Now that my packages are loaded, I will download the csv files using function read.csv under ‘readr’ package in Tidyverse.

- Merge all the dataframes into one, To create more space, i will use the remove function to delete the individual csv files. To keep the original dataframe, I will create a new one to work on.

- manipulate the data by adding these columns for a more comprehensive analysis

1. date,

2. hour,

3. day of week,

4. days,

5. month.

- I will add a new column ‘season’ using mutate function on the Month column - summer, winter, fall, spring. Also, another new column for time of day created from the hour column using mutate function - morning, afternoon, evening, night

- Next, is a calculation to get the ride length of each ride by subtracting ended_at from started_at and change the duration to minute.

- Now I will clean the data by

1. removing null values using na.omit function,

2. remove duplicates using distinct function,

3. removing errors from my new column (ride length where the duration is a negative figure or 0 and 

4. lastly, remove irrelevant columns.

- I changed the ride length data type to numeric using as.numeric function so calcula6tions can be done on my data.

### ANALYZE

Now my data has been processed and it is ready for analysis, i used groupby(), filter(), count(), summarize(), print() functions for my analysis. I also used the mean() function for aggregating. I did calculations for

1. total rides,
2. count of member type,
3. count of rideable bikes,
6. count of rides per hour,
7. by time of day,
8. by day of week,
9. by day,
10. by month and
11. by season.

Grouping by casual riders and annual members to see differences in the way the used the bikesI also did an average aggregate on each of the items above
(The codes are in my script).

### LINKS
Please click on this link to view my summary analysis, visulization and Business recommendation, [CYCLISTIC.pdf](https://github.com/Dolapomimi/googlecapstoneProject-Cyclistic/files/11039164/CYCLISTIC.pdf)


To view the R script- [Cylistics.R](https://github.com/Dolapomimi/googlecapstoneProject-Cyclistic/blob/main/Cylistics.R)

