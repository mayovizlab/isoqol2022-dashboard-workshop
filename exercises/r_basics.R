#_____________________________________________________________________
#_____________________________________________________________________
## Title: Introduction to R for Flexdashboard
## Date: 06/20/2022
#_____________________________________________________________________
#_____________________________________________________________________


#---- R is a calculator ----
1+1 
74*80
4*(3+1)
4*3+1

# Exercise 1: 
# 1. Solve (75-54)*2. 
# 2. What is 385 divided by 3?
# 3. What is 45 squared? 


#---- Assigning elements ----
# We use a <- or = to assign elements
a <- 2
b <- 1
a+b
a*b

#---- * Types of Elements ---- 
# Elements can be numeric but they can also be strings or T/F (boolean)
c <- T
d <- "Hello programmers"


#---- Vectors ----
# A collection of elements 
v <- c(1,5,10)
z <- c(0,T,"Hey")


#---- Functions --- 
# Functions perform actions on elements through arguments 
sum(v)
sum(a)
log(v)
log(a)
v <- c(1,2,4,NA)
# Performing multiple functions at once 
sum(log(v),na.rm=T)

# Discuss the help options (??, tab, help search)
# Exercise 2: Find a function that would allow you take the absolute value of a number. 


#---- Reading in data ---- 
# Data we will use for an example dashboard. 
#data <- read.csv("https://raw.githubusercontent.com/mgolafshar/clinical-dashboards/master/data/mock_cohort.csv")
data <- read_xlsx("/projects/bsi/az/projects/radonc/vizlab/s305577_isoqol2022_workshop/data/isoqol_data.xlsx")
data <- read.xlsx("/projects/bsi/az/projects/radonc/vizlab/s305577_isoqol2022_workshop/data/isoqol_data.xlsx",detectDates=T,sheet=1)
data <- readRDS("/projects/bsi/az/projects/radonc/vizlab/s305577_isoqol2022_workshop/data/isoqol_data.RDS")

#---- * Viewing a dataset ----
# We can see our data is now in our environment and we can view the data by clicking on the dataset in our environment.
View(data)

#Print a column
data$age

#---- * Summarizing a databaset ----
summary(data)
summary(data$age)
names(data) # gives us our variable names

# Let's try a few new functions
mean(data$age)
median(data$wt)

# Exercise 3: 
# 1. Try a function we have already used on ht. 
# 2. What function would we use if we wanted to know the counts of the arm variable? Find the counts.


#---- * Subset a database ----
# A package is a collection of functions. 
# To add a new package to your environment you just install the package with the code below
# You only need to install a package once and then you can just library() to bring the package 
# into your environment. 
# Add how some come with R 
#install.packages("tidyverse")
library(tidyverse)
# Using dplyr 
# dplyr: library within the tidyverse (a collection of commonly used libraries)
# The tidyverse uses a very special function called the pipe %>% which allows you to 
# easily string together multiple functions in a way that you can read the code like 
# English. pass it first arguement 
## subset rows (skip lines and comment)
arm1 <- data %>% filter(arm=="A: IFL") # Filter to just the first arm 

# Excerise 4: 
# 1. Filter to the cases that are above 6 feet. 
# 2. What is the tallest patient in the dataset? 

# Select just the survey data
ex1 <- data %>% 
  select(
    case,pro1_bsl:pro3_mo6
  )


#---- * Counts ---- 
length(unique(data$case))

#---- * Create new variables with dplyr ----

data <- data %>% 
  mutate(
    # case_when is a function that allows you to group the variable 
    age_group = case_when(
      age<=50  ~ "<=50",
      age>50 & age<=60  ~ "51-60",
      age>60 & age<=70  ~ "61-70",
      age>70  ~ "70+",
      TRUE ~ NA_character_
    )
  )

# Exercise 5: 
# 1. Create a BMI variable in the data set.
# The weight is measured in kilograms and height is measured in centimeters 
# Here is the formula BMI= (weight*10000)/(height^2)

#---- * Datatable ---- 
library(DT)
sum <- datatable(data)
sum # This print the datatable in the Viewer


#---- Plots ---- 
#---- * Base R ----
#---- ** Histogram ----
hist(data$ht)
hist(data$bmi)


#---- ** Boxplot ----
boxplot(data$age)
boxplot(age ~ arm, data = data)


#---- * ggplot ----
# Uses layers 
p<-ggplot(data, aes(x=arm, y=age,fill=arm)) +
  geom_boxplot()
p <- p + theme_bw() + ylab("Age at Enrollment (yrs)") 
p

# Exercise 6: How would we change the label of the x-axis? 

p<-ggplot(data, aes(x=arm, y=age,fill=arm)) +
  geom_boxplot() + theme_bw() + ylab("Age at Enrollment") + 
  xlab("Arm") + scale_fill_manual(values=c("red", "midnightblue","green"))
p
# Base R Colors: chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf 
# Exercise 7: What would we change from the code above if we wanted colors that were more appealing. HTML color codes. 
#https://htmlcolorcodes.com/ gives all of the colors of the rainbow with hex codes

#---- ** Pie Chart --- 
# Let's try a pie chart
pie_data <- data %>% group_by(site) %>% 
  count()
pie <- ggplot(pie_data, aes(x="", y=n, fill=site)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) + theme_void()
pie

#---- * plotly ----
library(plotly)
ggplotly(p)

# These packages will help us make our example dashboard. 
library(shiny)
library(knitr)
library(flexdashboard)
