#Setting up working directory
#Copy the SentimentAnalysis folder from github in your working directory
setwd("C:\\Users\\Akshay\\Documents\\SentimentAnalysis")

#Importing libraries
#Install these libraries by reading package_installation manual file
library(shiny) 
library(twitteR)
library(ROAuth)
library(rmongodb)
library(mongolite)
library(base64enc)
library(plyr)
require(RCurl)
library(stringr)
library(ggplot2)
library(rjson)
library(bit64)
library(httr)
library(DT)

#twitter connection to download tweets
#Create an developer application on twitter to get consumerKey,consumerSecret,accesstoken and access_secret

reqURL<- "https://api.twitter.com/oauth/request_token"
accessURL<- "https://api.twitter.com/oauth/access_token"
authURL<- "https://api.twitter.com/oauth/authorize"
consumerKey<- "my_key"
consumerSecret<- "my_secret"
Cred <- OAuthFactory$new(consumerKey=consumerKey,
consumerSecret=consumerSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)

Cred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl") )

accesstoken <- "my_token"
access_secret <- "my_secret1"

setup_twitter_oauth(consumerKey, consumerSecret, accesstoken, access_secret)

#Press 1 to connect
#Check if twitter connection is successfull before proceding
#############################


ui<-shinyUI(pageWithSidebar(
	headerPanel("Sentiment Analysis"),
	sidebarPanel(sliderInput("freq", "How many tweets?",min = 10, max = 1000,  step = 10,  value = 10),
	fileInput("file1", "Choose CSV File",
		accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
	uiOutput('helptext'),	
	actionButton("goButton", "Download Tweets"),
	actionButton("Calc", "Analyze"),
	br()),
	
	mainPanel(dataTableOutput('mytable'),br(),br(),
			  uiOutput("plots"))
))



#settting up mongodb twitter configuration
mongo <- mongo(collection = "tweets", db = "twitter", url = "mongodb://localhost")

#loading up positive and negative words
#Checkout the project inside folder SentimentAnalysis on your drive and provide the storage path
pos <- scan('C:/Users/Akshay/Documents/SentimentAnalysis/Dictionary/positive.txt', what='character', comment.char=';') 
neg <- scan('C:/Users/Akshay/Documents/SentimentAnalysis/Dictionary/negative.txt', what='character', comment.char=';') 

#Adding up few more words in positive and negative dictionary
pos.words <- c(pos, 'upgrade')
neg.words <- c(neg, 'wtf', 'wait', 'waiting', 'epicfail')

#calling the sentiment function
score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
	#processing each tweets from collection of sentences
	scores <- laply(sentences, function(sentence, pos.words, neg.words){
	#cleaning the tweets by removing special characters
		 sentence<- gsub("[\\s\\S]*?\n", "", sentence)
		 sentence<- gsub("#\\w+ *", "", sentence)
		 sentence<- gsub("@\\w+ *", "", sentence)
		 sentence<- gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "",sentence )

		 sentence <- gsub('[[:punct:]]', "", sentence)
		 sentence <- gsub('[[:cntrl:]]', "", sentence)
		 sentence <- gsub('\\d+', "", sentence)
		 sentence <- tolower(sentence)
	#Extracting words from each tweets and then comparing them with positive and negative list of words	 
		 word.list <- str_split(sentence, '\\s+')
		 words <- unlist(word.list)
		 pos.matches <- match(words, pos.words)
		 neg.matches <- match(words, neg.words)
		 pos.matches <- !is.na(pos.matches)
		 neg.matches <- !is.na(neg.matches)
		 score <- sum(pos.matches) - sum(neg.matches)
		 return(score)
	},pos.words, neg.words, .progress=.progress)
    scores.df <- data.frame(score=scores, text=sentences)
    return(scores.df)
}
 
#function to download tweets from twitter
download <- function(hashtagss,num)
{
	print("--------")
	laply(hashtagss, function(hashtags,num){
	tags <- hashtags
	list <- searchTwitter(tags, num)
	dataframe = twListToDF(list)

	#assigning an identification variable to each tweet
	tags<- gsub("#", "", tags)
	tagname <- c(tags)
	dataframe$tagname <- tagname

	#storing the downloaded data from twitter to MongoDB
	b=mongo.bson.from.df(dataframe)
	mongo <- mongo.create()
	icoll <- paste("twitter", "tweets", sep=".")
	mongo.insert.batch(mongo, icoll, b)
	},num)
}	
 
#shinyServer executed on GUI activity
server<-shinyServer(function(input, output) 
{
    observeEvent(input$goButton, 
	{
	   #setting up progress-bar
		 progress <- Progress$new(min=1, max=4)
		 progress$set(value = 1)
		 progress$set(message = 'Downloading in progress',detail = 'This may take a while...')
     
	    #reading tags from CSV file
		inFile <- input$file1
		readtags <- read.csv(inFile$datapath)
		readtags$c1 <- as.factor(readtags$tags)
		readtags$c1 <- lapply(readtags$c1, as.character)
		
		#updating progress bar
		 progress$set(value = 2)
		download(readtags$c1,input$freq)
		 progress$set(value = 3)
		 progress$set(value = 4)
		 progress$set(message = 'Download completed successfully',detail = '')
	})

   #the below observeEvent gets executed when Analyze button is clicked by User
	observeEvent(input$Calc,
	{
		#Identifying tweets available in MongoDB
		agg_df <- mongo$aggregate('[{ "$group" : 
                      { "_id" : "$tagname", 
                        "number_records" : { "$sum" : 1}
                      }
                  }]')
				  
		row.names(agg_df) <- NULL
		rows <- nrow(agg_df)
		
		#If database does not exist show appropriate message
		if((rows<1))
		{
			output$helptext <- renderUI({
			helpText('Dataset is Empty')})
			return(NULL)
		}
	
		print(typeof(agg_df))
		print(agg_df)
		
		#Displaying available data in MongoDB to User	
		output$mytable = renderDataTable({agg_df})
	  
		#Insert the right number of plot output objects into the web page
		output$plots <- renderUI({
			plot_output_list <-  lapply(1:rows, function(i) 
				{
					plotname <- paste("plot", i, sep="")
					tabPanel(agg_df[i,1],plotOutput(plotname, height = 600, width = 600))
				})

			do.call(tabsetPanel, plot_output_list)
		})
  
		# Call renderPlot for each one. Plots are only actually generated when they
		# are visible on the web page.
		for (i in 1:rows) 
		{
			print(agg_df[i,1])
			qry <- paste0('{ "tagname" : "',agg_df[i,1] , '"}')

			Datasetkejriwal <- mongo$find(qry)
			Datasetkejriwal$text <- sapply(Datasetkejriwal$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
			Datasetkejriwal$text <- as.factor(Datasetkejriwal$text)
			kejriwal.scores <- score.sentiment(Datasetkejriwal$text, pos.words, neg.words, .progress="text")

			# Need local so that each item gets its own number. Without it, the value
			# of i in the renderPlot() will be the same across all instances, because
			# of when the expression is evaluated.
			local({
				my_i <- i
				ks <- kejriwal.scores$score
				print(my_i)
				plotname <- paste("plot", my_i, sep="")
				output[[plotname]] <- renderPlot({
						(wwt <- hist(ks,plot = TRUE))
						plot(wwt, border = "dark blue", col = "light blue",
						main = agg_df[my_i,1], xlab = "Tweets Polarity")
						
						
					
				})
			})
		}
	})
})


shinyApp(ui=ui,server=server)
