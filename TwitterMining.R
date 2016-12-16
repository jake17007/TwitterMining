# # INSTALL PACKAGES FOR TWITTER API
# install.packages("twitteR")
# install.packages("RCurl")

# 
# # INSTALL PACKAGES FOR IBM WATSON
# install.packages("devtools")
# install.packages("https://github.com/jeroenooms/curl/archive/master.tar.gz", repos = NULL)
# devtools::install_github("ColumbusCollaboratory/cognizer")
# install.packages(c("rmsfact", "testthat"))

# require(twitteR)
# require(RCurl)
# require(dplyr)

getCurRateLimitInfo()
watsonUsed <- 0

setup_twitter_oauth(Sys.getenv("Q370_TWITTER_CONSUMER_KEY")
                    , Sys.getenv("Q370_TWITTER_CONSUMER_SECRET")
                    , Sys.getenv("Q370_TWITTER_ACCESS_TOKEN")
                    , Sys.getenv("Q370_TWITTER_ACCESS_TOKEN_SECRET"))


# Purpose: Get sentiment scores for multiple tweets for multiple locations
# Example: getSentsByLocs(highIneqLocs, "rich", "15mi")
getSentsByLocs <- function(dfIn, searchWord, radius) {
  
  # Initialize df to return
  df <- data.frame(loc=factor(),
                   ratio=double(), 
                   word=character(),
                   tweet=character(),
                   sentScore=double(),
                   sentType=factor())
  
  for (i in 1:length(dfIn[,1])) { # For each city:
    
    # Get tweets
    curDf <- as.data.frame(getMaxTweetsUpToN(searchWord, 100, paste(dfIn[i,]$Lat, ",", dfIn[i,]$Lon, sep=""), radius))
    
    if (length(curDf[,1]) > 0) {
    
      # Combine other column info
      curDf <- cbind(city = dfIn[i,]$City, ratio = dfIn[i,]$Ratio, word = searchWord, curDf)
      
      # Analyze the tweets with Watson
      curDf <- analyzeTweets(curDf)
      
      # correct the column names
      colnames(curDf) <- c("city", "ratio", "word", "tweet", "score", "type")

      # Add the curDf to the main df to be returned
      df <- rbind(df,curDf)
   
    } else {
      print(paste(dfIn[i,]$City, " returned zero results."))
    }
    
  }
  
  return(df)
}


# Purpose: Analyze a column of tweets in a dataframe with Watson for sentiment
#          adding the Sentiment Type and Sentiment Score to a copy of that df
#          which will be returned
# (df input should have columns: rank, city, ratio, tweet)
analyzeTweets <- function(df) {
  
  # Put the tweets in a vector
  tweets <- df[,4]
  
  watsonResp <- text_sentiment(tweets, Sys.getenv("Q370_WATSON_SENT_API_KEY")) # Response from Watson
  watsonUsed <- watsonUsed + length(tweets) #12/04/2016

  sentScore = c()
  sentType = c()

  # Get only OK results
  watsonRespOnlyOK = c()
  rowsToDelete = c()
  for (i in 1:length(watsonResp)) {
    if (watsonResp[[i]]$status == "OK") {
      watsonRespOnlyOK<-append(watsonRespOnlyOK, watsonResp[i])
    } else {
      rowsToDelete <- append(rowsToDelete, i)
    }
  }
  
  # Delete the non-OK rows from the dataframe of Tweets 
  if (length(rowsToDelete) > 0) {
    df <- df[-rowsToDelete,]
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

# Purpose: Get as many tweets as many tweets as possible up to your given
#          number n (stripping Retweets between)
# Example: getMaxTweetsUpToN("rich", 100, "37.781157,-122.39720", "15mi")
getMaxTweetsUpToN <- function(word, n, loc, radius, lang, strip){
  if (missing(lang)) lang <- "en"
  if (missing(strip)) strip <- TRUE
  df <- searchTwitter(word, 1000, lang=lang, geocode=paste(loc, ",", radius, sep=""))
  numResults <- length(df)
  if (numResults > 0) {
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
  } else {
    # If no tweets are found, return an empty df of the same structure as 
    # what would have been returned if at least one had been found
    return(data.frame(tweet=character())) 
  }
  
}
