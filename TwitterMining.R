# # INSTALL PACKAGES FOR TWITTER API
# install.packages("twitteR")
# install.packages("RCurl")
# 
# # INSTALL PACKAGES FOR IBM WATSON
# install.packages("devtools")
# install.packages("https://github.com/jeroenooms/curl/archive/master.tar.gz", repos = NULL)
# devtools::install_github("ColumbusCollaboratory/cognizer")
# install.packages(c("rmsfact", "testthat"))


# List of Cities High



getCurRateLimitInfo()

# require(twitteR)
# require(RCurl)
# require(dplyr)

twitter_consumer_key <- Sys.getenv("Q370_TWITTER_CONSUMER_KEY")
twitter_consumer_secret <- Sys.getenv("Q370_TWITTER_CONSUMER_SECRET")
twitter_access_token <- Sys.getenv("Q370_TWITTER_ACCESS_TOKEN")
twitter_access_secret <- Sys.getenv("Q370_TWITTER_ACCESS_TOKEN_SECRET")

setup_twitter_oauth(twitter_consumer_key
                    , twitter_consumer_secret
                    , twitter_access_token
                    , twitter_access_secret)

# Trump <- searchTwitter("Trump"
#                        , n=1
#                        , lang="en"
#                        , since="2015-11-08"
#                        , until="2016-11-17")

### GET TWITTER DATA FOR GROUP "A" ###

# SearchResultsA <- searchTwitter("rich", n=100, lang="en", geocode='43.4799,-110.7624,15mi')
# SearchResultsA <- strip_retweets(SearchResultsA)
# length(SearchResultsA)
# SearchResultsA <- SearchResultsA[ ! sapply(SearchResultsA, is.null) ] # remove nulls
# # SearchResults <- SearchResults[1:5] # to limit results
# SearchResultsADf <- twListToDF(SearchResultsA)
# SearchResultsAVec <- SearchResultsADf[,1]
# print(SearchResultsAVec)

# DONE
# N = 13
# HighIneq01 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "43.4799,-110.7624", "15mi"))
# HighIneq01 <- cbind(city = "Jackson, WY/ID", HighIneq01)
# HighIneq01 <- analyzeTweets(HighIneq01)

# DONE
# N = 99
# HighIneq02 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "41.1192,-73.3807", "15mi"))
# HighIneq02 <- cbind(city = "Bridgeport-Stamford-Norwalk, CT", HighIneq02)
# HighIneq02Test <- analyzeTweets(HighIneq02)
# HighIneq02 <- HighIneq02Test

# DONE
# N = 99
# HighIneq03 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "26.1667,-81.6399", "15mi"))
# HighIneq03 <- cbind(city = "Naples-Immokalee-Marco Island, FL", HighIneq03)
# HighIneq03Test <- analyzeTweets(HighIneq03)
# HighIneq03 <- HighIneq03Test

# DONE 
# N = 33
# HighIneq04 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "27.7275,-80.43395", "15mi"))
# HighIneq04 <- cbind(city = "Sebastian-Vero Beach, FL", HighIneq04)
# HighIneq04Test <- analyzeTweets(HighIneq04)
# HighIneq04 <- HighIneq04Test

# DONE
# N = 18
# HighIneq05 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "24.5551,-81.78", "15mi"))
# HighIneq05 <- cbind(city = "Key West, FL", HighIneq05)
# HighIneq05Test <- analyzeTweets(HighIneq05)
# HighIneq05 <- HighIneq05Test

HighIneq06 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "38.8882,-119.7413", "15mi"))
HighIneq07 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "26.1998,-80.1275", "15mi"))
HighIneq08 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "31.9973,-102.0779", "15mi"))
HighIneq09 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "39.5505,-107.3248", "15mi"))
HighIneq10 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "31.4638,-100.437", "15mi"))









### ANALYZE "A" DATA WITH WATSON SENTIMENT ANALYSIS ###

# require(cognizer)
# require(data.table)

watson_sent_api_key <- Sys.getenv("Q370_WATSON_SENT_API_KEY")
textA <- SearchResultsAVec

resultA <- text_sentiment(textA, watson_sent_api_key)
watsonUsed <- watsonUsed + length(textA) #12/04/2016
str(resultA)
#install.packages("data.table")

#result <- rbindlist(result, fill=TRUE)
sentimentScore = c()
sentimentType = c()

# Get only OK results
resultAOnlyOK = c()
for (i in 1:length(resultA)) {
  if (resultA[[i]]$status == "OK") {
    resultAOnlyOK<-append(resultAOnlyOK, resultA[i])
  } else {
    SearchResultsADf <- SearchResultsADf[-i,] # Delete the non-OK row from the dataframe of Tweets
  }
}

# Get sentimentScore for all "OK" - if Tweet is neutral, put 0
for (i in 1:length(resultAOnlyOK)) {
  if (resultAOnlyOK[[i]]$docSentiment$type == "neutral") {
    sentimentScore<-append(sentimentScore, 0)
  } else {
    sentimentScore<-append(sentimentScore, resultAOnlyOK[[i]]$docSentiment$score)
  }
}

#Get sentiment type for all "OK"
for (i in 1:length(resultAOnlyOK)) sentimentType<-append(sentimentType, resultAOnlyOK[[i]]$docSentiment$type)


# (Should be the same length)
length(sentimentScore)
length(sentimentType)


SearchResultsADf$score <- as.numeric(sentimentScore)
SearchResultsADf$type <- sentimentType


mean(SearchResultsADf$score)


analyzeTweets <- function(df) {
  
  tweets <- df[,2]
  
  watson_sent_api_key <- Sys.getenv("Q370_WATSON_SENT_API_KEY")
  watsonResp <- text_sentiment(tweets, watson_sent_api_key) # Response from Watson
  watsonUsed <- watsonUsed + length(textA) #12/04/2016
  
  sentScore = c()
  sentType = c()
  
  # Get only OK results
  watsonRespOnlyOK = c()
  for (i in 1:length(watsonResp)) {
    if (watsonResp[[i]]$status == "OK") {
      watsonRespOnlyOK<-append(watsonRespOnlyOK, watsonResp[i])
    } else {
      df <- df[-i,] # Delete the non-OK row from the dataframe of Tweets
    }
  }
  
  # Get sentScore for all "OK" - if Tweet is neutral, put 0
  for (i in 1:length(watsonRespOnlyOK)) {
    if (watsonRespOnlyOK[[i]]$docSentiment$type == "neutral") {
      sentScore<-append(sentScore, 0)
    } else {
      sentScore<-append(sentScore, watsonRespOnlyOK[[i]]$docSentiment$score)
    }
  }
  
  #Get sentiment type for all "OK"
  for (i in 1:length(watsonRespOnlyOK)) sentType<-append(sentType, watsonRespOnlyOK[[i]]$docSentiment$type)
  
  if (length(sentScore) != length(sentType)) {
    return("Error: Sentiment Score length and Sentiment Type length do not match.")
  } 
  
  df$score <- as.numeric(sentScore)
  df$type <- sentType
  
  return (df)
  
}





### GET TWITTER DATA FOR GROUP "B" ###

SearchResultsB <- searchTwitter("poor", n=100, lang="en", geocode='43.4799,-110.7624,15mi')
SearchResultsB <- strip_retweets(SearchResultsB)
length(SearchResultsB)
SearchResultsB <- SearchResultsB[ ! sapply(SearchResultsB, is.null) ] # remove nulls
# SearchResults <- SearchResults[1:5] # to limit results
SearchResultsBDf <- twListToDF(SearchResultsB)
SearchResultsBVec <- SearchResultsBDf[,1]


### ANALYZE DATA WITH WATSON SENTIMENT ANALYSIS ###

# require(cognizer)
# require(data.table)

watson_sent_api_key <- Sys.getenv("Q370_WATSON_SENT_API_KEY")
textB <- SearchResultsBVec
print(textB)

resultB <- text_sentiment(textB, watson_sent_api_key)
str(resultB)
watsonUsed <- watsonUsed + length(textB) #12/04/2016
#install.packages("data.table")

#result <- rbindlist(result, fill=TRUE)
sentimentScore = c()
sentimentType = c()

# Get only OK results
resultBOnlyOK = c()
for (i in 1:length(resultB)) {
  if (resultB[[i]]$status == "OK") {
    resultBOnlyOK<-append(resultBOnlyOK, resultB[i])
  } else {
    SearchResultsBDf <- SearchResultsBDf[-i,] # Delete the non-OK row from the dataframe of Tweets
  }
}

# Get sentimentScore for all "OK" - if Tweet is neutral, put 0
for (i in 1:length(resultBOnlyOK)) {
  if (resultBOnlyOK[[i]]$docSentiment$type == "neutral") {
    sentimentScore<-append(sentimentScore, 0)
  } else {
    sentimentScore<-append(sentimentScore, resultBOnlyOK[[i]]$docSentiment$score)
  }
}

#Get sentiment type for all "OK"
for (i in 1:length(resultBOnlyOK)) sentimentType<-append(sentimentType, resultBOnlyOK[[i]]$docSentiment$type)


# (Should be the same length)
length(sentimentScore)
length(sentimentType)

SearchResultsBDf$score <- as.numeric(sentimentScore)
SearchResultsBDf$type <- sentimentType


mean(SearchResultsBDf$score)


# Example: getMaxTweetsUpToN("rich", 100, "37.781157,-122.39720", "15mi")
getMaxTweetsUpToN <- function(word, n, loc, radius, lang, strip){
  if (missing(lang)) lang <- "en"
  if (missing(strip)) strip <- TRUE
  df <- searchTwitter(word, 1000, lang, geocode=paste(loc, ",", radius, sep=""))
  numResults <- length(df)
  if (strip == TRUE) {
    df <- strip_retweets(df)
    df <- df[!sapply(df, is.null)] # Remove nulls
  }
  df <- twListToDF(df)
  df <- df[,1]
  
  if (length(df) > n) {
    df <- head(df, 100)
  }
  
  if (numResults >= 1000 & length(df) < 100) print(paste("Found 1000 Tweets but too many were RT's. Try again for loc: ", loc))

  return(df)
}
