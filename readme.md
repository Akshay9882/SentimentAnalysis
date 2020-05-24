**Opinion Mining Twitter**

**Introduction:**

The application reads the hashtags from a CSV file and then downloads all tweets corresponding to those hashtags. The downloaded data is stored in database and then further analyzed.

**Tools Used:**

R Studio

Web browser

**Language:**

R

**Database:**  
MongoDB


**SCREENSHOTS:**

**User interface of the Application:**

1.  The tweets slider allows the user to select the frequency of twitter tags
    that are to be downloaded. Minimum frequency is 10 and maximum is 1,000.

>   The twitter API has limitations on the frequency of tweets that can be
>   downloaded and is set max to around 1500. The tweets slider is set to
>   maximum frequency of 1000 to avoid getting blocked by twitter as there is
>   limitations on the tweets that can be downloaded

1.  The File Input dialog(Choose CSV file) provides an file dialog box where we
    can pass the CSV file as input.

2.  The CSV file would contain all the tags that are to be downloaded. The
    downloaded data is stored in MongoDB for further analysis.

3.  On clicking “Download Tweets” button all the tweets corresponding to tags
    specified in CSV file are downloaded.

 ![alt text](https://github.com/Akshay9882/SentimentAnalysis/blob/master/readme_images/1.jpg)

**File Dialog Box:**

 ![alt text](https://github.com/Akshay9882/SentimentAnalysis/blob/master/readme_images/2.jpg)

**Once the CSV file is selected its tags are read and the status of progress bar
changes to Upload complete.**

 ![alt text](https://github.com/Akshay9882/SentimentAnalysis/blob/master/readme_images/3.jpg)

**Now, We can analyze the data that exists in MongoDB database.**

To do so **click on Analyze button**, the data present in MongoDB is displayed
in table format and its sentiment analysis is displayed in tabs below in the
form of histogram.

In the below output there are four hash-tags present in MongoDB database

1.raees

2.force2

3.dearZindagi

4.FAN

The no. of tweets present for each hash-tag is also displayed. All tags here
have 500 tweets. i.e 500 rows for each hash-tag

 ![alt text](https://github.com/Akshay9882/SentimentAnalysis/blob/master/readme_images/4.jpg)

**Histogram Explanation:**

1.  The tweets that are negative are plotted on X-axis **below zero** with their
    frequency been represented on by Y-axis.

2.  The tweets that are positive are plotted on X-axis **above zero** with their
    frequency been represented on by Y-axis.

3.  The tweets that are neutral(neither positive nor negative) are plotted on
    X-axis **on zero** with their frequency been represented on by Y-axis.

4.  The score of positive and negative tweets is represented by X-axis

5.  The co-ordinate (-1) is less negative as compared to (-3)

6.  The co-ordinate (3) is more positive as compared to (1)

In the above graph we can say that the “raees” movie has more positive tweets as
compared to negative tweets.



**How to Run this application**  
1. Open R Studio 
2. Paste code in TweetsAnalysis.r file into R studio step by step by reading instruction in the file  

