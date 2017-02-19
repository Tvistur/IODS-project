# Susan Huotari
# 12.2.2018
# Wrangling “Human development” and “Gender inequality” data (http://hdr.undp.org/en/content/human-development-index-hdi)

options(stringsAsFactors = FALSE)

# Import "Human development" 
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv")

# Import "Gender inequality"
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", na.strings = "..")

# Structure
str(hd)
str(gii)

# Dimensions
dim(hd)
dim(gii)

# Summary
summary(hd)
summary(gii)

# Rename variables with shorter descriptive names
colnames(hd)
colnames(hd)[1] <- "HDI_rank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "life_exp"
colnames(hd)[5] <- "edu_exp"
colnames(hd)[6] <- "edu_mean"
colnames(hd)[7] <- "GNI"  
colnames(hd)[8] <- "GNI_netrank"

colnames(gii)
colnames(gii)[1] <- "GII_rank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "mat_mort"
colnames(gii)[5] <- "adol_birth"
colnames(gii)[6] <- "parl_rep"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labF"
colnames(gii)[10] <- "labM"

# Add new variable to gii dataset: ratio of female and male populations with secondary education in each country
gii <- mutate(gii, edu2_FM = edu2F / edu2M)

# Add new variable to gii dataset: ratio of labour force participation of females and males in each country 
gii <- mutate(gii, lab_FM = labF / labM)

# Join the two dataset using the variable Country as the identifier. Keep only the countries in both datasets.
library(dplyr)
hd_gii <- inner_join(hd, gii, by = "country")

# Call the new joined data human and save it in data folder.
write.csv(hd_gii, file = "human.csv", row.names = F)






####################################
# 18.2.2017
# wrangling continued

human_new <- read.csv("human.csv", sep = ",", header = TRUE)

# Mutate the data: transform the Gross National Income (GNI) variable to numeric using string manipulation
str(human_new$GNI)
library(stringr)
human_new$GNI <- str_replace(human_new$GNI, pattern = ",", replace = "") %>% as.numeric()

# Keep only "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"
## check column names in my data (renamed earlier)
colnames(human_new)
## select variables to keep
keep <- c("country", "edu2_FM", "lab_FM", "edu_exp", "life_exp", "GNI", "mat_mort", "adol_birth", "parl_rep")
## select the 'keep' columns
human_new <- select(human_new, one_of(keep))

# Remove all rows with missing values
complete.cases(human_new)
human_new <- filter(human_new, complete.cases(human_new))

# Remove the observations which relate to regions instead of countries
## check values in column
list(human_new$country) # last 7 observations are regions
## select rows up to 155 (which are countries)
human_new <- human_new[1:155,]

# Define the row names of the data by the country names 
rownames(human_new) <- human_new$country
# and remove the country name column from the data
human_new <- select(human_new, -country)
 
#The data should now have 155 observations and 9 variables??? 
## It was instructed to keep 9 variables and the the country variable was removed - should be 8???


# Save the human data in your data folder including the row names. 
# You can overwrite your old ‘human’ data.

write.csv(human_new, file = "human_new.csv", row.names = TRUE)
