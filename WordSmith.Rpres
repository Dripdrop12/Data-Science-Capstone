WordSmith - Text Completion Software
========================================================
author: Jonathan Hill
date: August 23, 2015

Johns Hopkin's Bloomberg School of Public Health, Coursera &
SwiftKey

Introduction to WordSmith
========================================================

WordSmith suggests the next word to a sequence of words provided by the user. It also provides information on the number of word sequences that match the input and the weighted probabilities of its suggestions.

- It randomly samples over 500 MB of text scraped from news sites, blogs and twitter
- Therefore, WordSmith includes trending topics and new phrases as they come into use
- Although the data source is very large, WordSmith is very compact and deployable on the web


Mechanics
========================================================
- The input data are cleaned, removing profanity and sparse terms
- Then WordSmith uses a Markov process based on a modified "Stupid Backoff" algorithm (Brants 2007). It considers single, double, triple and quadruple word sequences (4-grams to 1-grams) that match the input, then calculates the probability for all potential completion words (MLE). Then it sums all N-gram collections (1 to k) to obtain a weight (W):
$$W_{word}=\\sum_{n=1}^k(MLE_{word})_{n}$$
- Word sequences are stored in hash tables (using data.table and spooky.32), which make WordSmith memory efficient and fast
- WordSmith can also handle punctuation and special characters

Performance
========================================================

Try [WordSmith]()!

- The current implementation of WordSmith does not use a Key-Neisser, or similar, algorithm to deal with words that almost always follow another word or word sequence such as "Francisco," which almost always follows "San."
- It only considers the last 4 words of the input, and discards the rest.
- Average bytes per N-gram could be decreased by storing unique words as numbers for higher order N-grams.
- Finally, considering WordSmith was developed by one person as a side project, it demonstrates the power of the R programming language and Shiny applications in harnessing unstructured textual data and putting it to use.





