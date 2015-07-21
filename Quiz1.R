# Set the working directory #
setwd("~/GitHub/Data-Science-Capstone")

# Load required packages into memory #
library(dplyr)
library(data.table)
library(stringr)
library(tm)

# Upload the data using readLines #
en_us_twitter <- readLines("Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
en_us_blogs <- readLines("Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
en_us_news <- readLines("Coursera-SwiftKey/final/en_US/en_US.news.txt")

# Question 1 #
file.info("Coursera-SwiftKey/final/en_US/en_US.blogs.txt")$size / 1024^2

# Question 2 #
length(en_us_twitter)

# Question 3 #
# Which of the 3 datasets has the longest line of text and how long is it? #
which.max(sapply(en_us_twitter, str_length))
which.max(sapply(en_us_news, str_length))
which.max(sapply(en_us_blogs, str_length))

# Question 4 #
# Lines with love divided by lines with hate in the twitter file #
sum(grepl("love", en_us_twitter))/sum(grepl("hate", en_us_twitter))

# Question 5 #
grep("biostats", en_us_twitter, value = TRUE)

# Question 6 #
sum(grepl("A computer once beat me at chess, but it was no match for me at kickboxing", en_us_twitter))
