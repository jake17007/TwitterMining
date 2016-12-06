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

highIneqLocs <- read.csv("/Users/jb/Documents/IU/2016Fall/Q370/FinalProject/HighIneqLocs.csv")


# DONE
# N = 13
# HighIneq01 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "43.4799,-110.7624", "15mi"))
# HighIneq01 <- cbind(city = "Jackson, WY/ID", HighIneq01)
# HighIneq01 <- analyzeTweets(HighIneq01)
HighIneq01New <- cbind.data.frame(HighIneq01$city, ratio = highIneqLocs[1,]$Ratio, word = "rich", tweet = HighIneq01[,2], score = HighIneq01[,3], type = HighIneq01[,4])
colnames(HighIneq01New) <- c("city", "ratio", "word", "tweet", "score", "type")

# DONE
# N = 99
# HighIneq02 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "41.1192,-73.3807", "15mi"))
# HighIneq02 <- cbind(city = "Bridgeport-Stamford-Norwalk, CT", HighIneq02)
# HighIneq02Test <- analyzeTweets(HighIneq02)
# HighIneq02 <- HighIneq02Test
HighIneq02New <- cbind.data.frame(HighIneq02$city, ratio = highIneqLocs[2,]$Ratio, word = "rich", tweet = HighIneq02[,2], score = HighIneq02[,3], type = HighIneq02[,4])
colnames(HighIneq02New) <- c("city", "ratio", "word", "tweet", "score", "type")

# DONE
# N = 99
# HighIneq03 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "26.1667,-81.6399", "15mi"))
# HighIneq03 <- cbind(city = "Naples-Immokalee-Marco Island, FL", HighIneq03)
# HighIneq03Test <- analyzeTweets(HighIneq03)
# HighIneq03 <- HighIneq03Test
HighIneq03New <- cbind.data.frame(HighIneq03$city, ratio = highIneqLocs[3,]$Ratio, word = "rich", tweet = HighIneq03[,2], score = HighIneq03[,3], type = HighIneq03[,4])
colnames(HighIneq03New) <- c("city", "ratio", "word", "tweet", "score", "type")

# DONE 
# N = 33
# HighIneq04 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "27.7275,-80.43395", "15mi"))
# HighIneq04 <- cbind(city = "Sebastian-Vero Beach, FL", HighIneq04)
# HighIneq04Test <- analyzeTweets(HighIneq04)
# HighIneq04 <- HighIneq04Test
HighIneq04New <- cbind.data.frame(HighIneq04$city, ratio = highIneqLocs[4,]$Ratio, word = "rich", tweet = HighIneq04[,2], score = HighIneq04[,3], type = HighIneq04[,4])
colnames(HighIneq04New) <- c("city", "ratio", "word", "tweet", "score", "type")

# DONE
# N = 18
# HighIneq05 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "24.5551,-81.78", "15mi"))
# HighIneq05 <- cbind(city = "Key West, FL", HighIneq05)
# HighIneq05Test <- analyzeTweets(HighIneq05)
# HighIneq05 <- HighIneq05Test
HighIneq05New <- cbind.data.frame(HighIneq05$city, ratio = highIneqLocs[5,]$Ratio, word = "rich", tweet = HighIneq05[,2], score = HighIneq05[,3], type = HighIneq05[,4])
colnames(HighIneq05New) <- c("city", "ratio", "word", "tweet", "score", "type")

# HighIneq06 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "38.8882,-119.7413", "15mi"))
# HighIneq07 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "26.1998,-80.1275", "15mi"))
# HighIneq08 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "31.9973,-102.0779", "15mi"))
# HighIneq09 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "39.5505,-107.3248", "15mi"))
# HighIneq10 <- as.data.frame(getMaxTweetsUpToN("rich", 100, "31.4638,-100.437", "15mi"))

highIneqLocs.rows6to7.result <- getSentsByLocs(highIneqLocs.rows6to7, "rich", "15mi")
highIneqLocs.rows8to10 <- highIneqLocs[8:10,]
highIneqLocs.rows8to10.result <- getSentsByLocs(highIneqLocs.rows8to10, "rich", "15mi")

testNewDf01 <- HighIneqAllCities.rich
dump("testNewDf01", "/Users/jb/Documents/IU/2016Fall/Q370/FinalProject/testNewDf01.Rdmpd")
rm(testNewDf01)

highIneqLocs.rows1to5.result <- rbind(HighIneq01New, HighIneq02New, HighIneq03New, HighIneq04New, HighIneq05New)

HighIneqAllCities.rich <- rbind(highIneqLocs.rows1to5.result, highIneqLocs.rows6to7.result, highIneqLocs.rows8to10.result)

write.table(HighIneqAllCities.rich, "/Users/jb/Documents/IU/2016Fall/Q370/FinalProject/HighIneqAllCities_rich.txt", sep="\t")
dump("HighIneqAllCities.rich", "/Users/jb/Documents/IU/2016Fall/Q370/FinalProject/HighIneqAllCities_rich.Rdmpd")

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
    
    # Combine other column info
    curDf <- cbind(city = dfIn[i,]$City, ratio = dfIn[i,]$Ratio, word = searchWord, curDf)
    
    # Analyze the tweets with Watson
    curDf <- analyzeTweets(curDf)
    
    # correct the column names
    colnames(curDf) <- c("city", "ratio", "word", "tweet", "score", "type")
    
    # Add the curDf to the main df to be returned
    df <- rbind(df,curDf)
    
  }
  
  return(df)
}




# rm(df)
# dfTest <- data.frame(loc=factor(),
#                  ratio=double(), 
#                  word=character(),
#                  tweet=character(),
#                  sentScore=double(),
#                  sentType=factor())
# curDf01 <- as.data.frame(getMaxTweetsUpToN("rich", 10, paste(highIneqLocs[1,]$Lat, ",", highIneqLocs[1,]$Lon, sep=""), "15mi"))
# curDf <- cbind(city = highIneqLocs[1,]$City, ratio = highIneqLocs[1,]$Ratio, word = "rich", curDf01)
# curDfAfterAnalysis <- analyzeTweets(curDf)
# colnames(curDfAfterAnalysis) <- c("city", "ratio", "word", "tweet", "score", "type")
# dfTest <- rbind(curDfAfterAnalysis)

# df should have columns: CITY, TWEET
analyzeTweets <- function(df) {
  
  tweets <- df[,4]
  
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
