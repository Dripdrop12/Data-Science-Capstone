# Set the working directory #
setwd("~/GitHub/Data-Science-Capstone")

# Load required packages into memory #
library(dplyr)
library(data.table)
library(stringr)
library(tm)
library(hashFunction)
library(parallel)

# Preparing the parallel cluster
gc(reset=T)
cl <- makeCluster(detectCores()-2)
invisible(clusterEvalQ(cl, library(tm)))
options(mc.cores=1)

# Upload the data using readLines #
en_us_twitter <- readLines("Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
en_us_blogs <- readLines("Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
en_us_news <- readLines("Coursera-SwiftKey/final/en_US/en_US.news.txt")

# Random sample of the data #
news <- en_us_news[as.logical(rbinom(n = length(en_us_news), size = 1, prob = .04))]
blogs <- en_us_blogs[as.logical(rbinom(n = length(en_us_blogs), size = 1, prob = .01))]
twitter <- en_us_twitter[as.logical(rbinom(n = length(en_us_twitter), size = 1, prob = .007))]
rm(en_us_twitter, en_us_blogs, en_us_news)

# Creating Corpus and labelling the origin #
blogs <- Corpus(VectorSource(blogs))
news <- Corpus(VectorSource(news))
twitter <- Corpus(VectorSource(twitter))
sample <- c(blogs, news, twitter)
rm(news, blogs, twitter)

# Clean the Corpus #
badwords <- readLines('Data-Science-Capstone/badwords.txt')
rm_non_english <- function(x) gsub('[^[a-z|A-Z|[:space:]]','',x)
sample <- tm_map(sample, removeNumbers)
sample <- tm_map(sample, removePunctuation, preserve_intra_word_dashes = TRUE)
sample <- tm_map(sample, stripWhitespace)
sample <- tm_map(sample, content_transformer(tolower))
sample <- tm_map(sample, content_transformer(rm_non_english))
sample <- tm_map(sample, removeWords, badwords)

# nTokenizers #
nTokenizer2 <- function(x, n = 2L){
  # n must have an L after it (i.e. 1L, 2L, 3L, etc.)
  vapply(ngrams(strsplit(as.character(x), " ", fixed = TRUE)[[1L]], n), paste, "", collapse = " ")
}
nTokenizer3 <- function(x, n = 3L){
  # n must have an L after it (i.e. 1L, 2L, 3L, etc.)
  vapply(ngrams(strsplit(as.character(x), " ", fixed = TRUE)[[1L]], n), paste, "", collapse = " ")
}
nTokenizer4 <- function(x, n = 4L){
  # n must have an L after it (i.e. 1L, 2L, 3L, etc.)
  vapply(ngrams(strsplit(as.character(x), " ", fixed = TRUE)[[1L]], n), paste, "", collapse = " ")
}

# Create a TermDocumentMatrix for each ngram and remove sparse terms#
tdm  <- TermDocumentMatrix(sample)
tdm <- removeSparseTerms(tdm, .999)
tdm2 <- TermDocumentMatrix(sample, control = list(tokenize = nTokenizer2))
tdm2 <- removeSparseTerms(tdm2, .9997)
tdm3 <- TermDocumentMatrix(sample, control = list(tokenize = nTokenizer3))
tdm3 <- removeSparseTerms(tdm3, .9998)
tdm4 <- TermDocumentMatrix(sample, control = list(tokenize = nTokenizer4))
tdm4 <- removeSparseTerms(tdm4, .999895)

## Create a hash table
# Unigrams
dt = data.table(ngram_in=character(), ngram_number = numeric(), 
                         word_out=character(), word_number=numeric(), 
                         ngram_freq=numeric())
patt_in  <- function(x) str_trim(str_extract(x, '^(\\S+)'))
hash_fx <- function(x) as.numeric(spooky.32(x))
word_out <- sapply(as.vector(tdm$dimnames$Terms), patt_in)
ngram_in <- word_out
ngram_number <- sapply(as.vector(ngram_in), hash_fx)
word_number <- ngram_number
ngram_counts <- as.vector(rowSums(as.matrix(tdm))) 
dt = data.table(ngram_in=ngram_in, 
                ngram_number = ngram_number, 
                word_out=word_out, 
                word_number=word_number, 
                ngram_freq=ngram_counts)
dt<-dt[ngram_freq>1,]                    # Remove unique terms
saveRDS(dt, "Data-Science-Capstone/App/Data/unigram_hash.rds")
rm(dt)
gc(reset=T)

# HIGHER LEVEL NGRAM HASHES
the_input = list(bigram=list(tdm=tdm2,
                             patt_in='^(\\S+\\s+)',
                             file_name='Data-Science-Capstone/App/Data/bigram_hash.rds'),
                 trigram=list(tdm=tdm3,
                              patt_in='^((\\S+\\s+){2})',
                              file_name='Data-Science-Capstone/App/Data/trigram_hash.rds'),
                 tetragram=list(tdm=tdm4,
                                patt_in='^((\\S+\\s+){3})',
                                file_name='Data-Science-Capstone/App/Data/tetragram_hash.rds'))
for (e in the_input){
  patt_in  <- function(x) str_trim(str_extract(x, e$patt_in))
  patt_out <- function(x) str_trim(str_extract(x, '(\\S+)$'))
  hash_fx <- function(x) as.numeric(spooky.32(x))
  ngram_in <- sapply(as.vector(e$tdm$dimnames$Terms), patt_in)
  word_out <- sapply(as.vector(e$tdm$dimnames$Terms), patt_out)
  ngram_number <- sapply(as.vector(ngram_in), hash_fx)
  word_number <- sapply(as.vector(word_out), hash_fx)
  ngram_counts <- as.vector(rowSums(as.matrix(e$tdm))) 
  
  dt = data.table(ngram_in=ngram_in, 
                  ngram_number = ngram_number, 
                  word_out=word_out, 
                  word_number=word_number, 
                  ngram_freq=ngram_counts)
  
  print(e$file_name)
  saveRDS(dt, e$file_name)
  rm(dt)
  gc(reset=T)
}

# Clean local memory
rm(list=ls())


# unigram_dt<-readRDS(file.path('app_data', 'unigram_hash.rds'))
# bigram_dt<-readRDS(file.path('app_data', 'bigram_hash.rds'))
# trigram_dt<-readRDS(file.path('app_data', 'trigram_hash.rds'))
# tetragram_dt<-readRDS(file.path('tetragram_hash.rds'))


