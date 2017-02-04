# Susan Huotari
# 4.2.2017
# Wrangling Student Alcohol Consumption data (https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION)

# read in datasets
math <- read.table("data/student/student-mat.csv", sep = ";", header = TRUE)
por <- read.table("data/student/student-por.csv", sep = ";", header = TRUE)

# explore structure and dimension
str(math)
dim(math)
colnames(math)

str(por)
dim(por)
colnames(por)

library(dplyr)

# join datasets (13 variables)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

colnames(math_por)

# new dataset for joined dataset, keep only joined columns
alc <- select(math_por, one_of(join_by)) # 13 variables, 382 observations
glimpse(alc)

notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
notjoined_columns

for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- (first_column)
  }
}

glimpse(alc)

# add new column 'alc_use' (average of weekday and weekend consumption)
alc <- mutate(alc, alc_use = (Dalc + Walc)/2)

# add new colums 'high_use' (alc_use > 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)
dim(alc)

# save dataset  to 'data' folder
write.csv(alc, file = "alc.csv", row.names = F)
