library("twitteR")
library("RCurl")
library("tm")
library("wordcloud")
library("SnowballC")

consumer_key<-'7JpkeMEj55lNn5TKUZpRQ82oP'
consumer_secret<-'jBQt9KVxl9Hood9daT7JszzX0zPTFyE0FGG5eUG4Hwz787CR8O'
access_token<-'1088853370318872576-fkSpPBYJmVG6p9k9sVTuxz3nk4A8EQ'
access_token_secret<-'u4Ax9OGDHbvX0x2NhFJTwytPKz2xcH1AR7ELvRdPcgN2G'
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)

rstudio_tweets <- searchTwitter("rstudio", n=20, lang = "en")
rstudio_tweets

# save text
rstudio_tweets_text <- sapply(rstudio_tweets, function(x) x$getText() )

# The below would be the same
# Analyze review
docs <- Corpus(VectorSource(rstudio_tweets_text))

# If using Mac OS run this
rstudio_tweets_text2 <- sapply(rstudio_tweets_text,function(row) iconv(row,"latin1","ASCII",""))
docs <- Corpus(VectorSource(rstudio_tweets_text2))


toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))

# Remove numbers
docs <- tm_map(docs, removeNumbers)

# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))

# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("https", "tco")) 

# Remove punctuations
docs <- tm_map(docs, removePunctuation)

# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

# Text stemming
docs <- tm_map(docs, stemDocument)

# Word counts
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,max.words=200, random.order=FALSE, rot.per=0.35,colors=brewer.pal(8, "Dark2"))

# association of words
# draw dendrogram
dtm_top <- removeSparseTerms(dtm,sparse=0.8) # distance between .89 and .9
df <- as.data.frame(inspect(dtm_top))
dscale <- scale(df)
distance <- dist(dscale, method="euclidean") # distance matrix
fit <- hclust(distance, method="complete")
plot(fit)

# association of words
asso <- findAssocs(dtm,'rstudio',0.1)
asso