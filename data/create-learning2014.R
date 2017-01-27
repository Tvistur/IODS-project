# Susan Huotari
# 27.1.2017
# RStudio Exercise 2 / part 1: data wrangling

WRANGLING
# Read in learning2014 data 
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = TRUE)

# Structure of the data
str(learning2014) # 184 observations and 60 variables

# Dimensions of the data
dim(learning2014) #184 rows and 60 columns

library(dplyr)

# Combine questions + select + create new column
# DEEP
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30")
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

surf_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
surf_columns <- select(learning2014, one_of(surf_questions))
learning2014$surf <- rowMeans(surf_columns)

stra_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
stra_columns <- select(learning2014, one_of(stra_questions))
learning2014$stra <- rowMeans(stra_columns)

# Create an analysis dataset with variables gender, age, attitude, deep, stra, surf and points
# choose columns to keep
keep_columns <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014_new <- select(learning2014, one_of(keep_columns))

# exclude observations where the exam points variable is zero
learning2014_new <- filter(learning2014_new, Points > 0)
dim(learning2014_new)

# save analysis dataset to the 'data' folder
write.csv(learning2014_new, file = "learning2014.csv", row.names = F)

# check it went ok, i.e. read new filw into R
learning2014_data <- read.csv("/Users/susanhuotari/Documents/IODS K17/IODS-project/data/learning2014.csv")
str(learning2014_data)
head(learning2014_data)

