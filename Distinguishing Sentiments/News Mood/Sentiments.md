```python
# Dependencies
import tweepy
import json
import numpy as np
import pandas as pd
import seaborn as sns
from config import consumer_key, consumer_secret, access_token, access_token_secret
import matplotlib.pyplot as plt


# Setup Tweepy API Authentication
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth, parser=tweepy.parsers.JSONParser())

# Import and Initialize Sentiment Analyzer
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
analyzer = SentimentIntensityAnalyzer()
```

```python
# Target User
target_users = ("BBC", "CBS", "CNN", "FOX", "NYTIMES")

# Tweet Texts
tweet_texts = []
tweet_date = []

#variables for holding sentiments
compound_list = []
positive_list = []
negative_list = []
neutral_list = []
counter_list = []
target_list = []


for target in target_users:
    #Counter
    counter = 1
    # Create a loop to iteratively run API requests
    for x in range(1, 6):

        # Get all tweets from home feed (for each page specified)
        public_tweets = api.user_timeline(target, page=x)

        # Loop through all tweets
        for tweet in public_tweets:

            # Print Tweet
            #print(tweet["text"])

            # Store Tweet in Array
            tweet_texts.append(tweet["text"])

            # Store Tweet Date in Array
            tweet_date.append(tweet["created_at"])

            # Run Vader Analysis on each tweet
            results = analyzer.polarity_scores(tweet["text"])
            compound = results["compound"]
            pos = results["pos"]
            neu = results["neu"]
            neg = results["neg"]

            # Add each value to the appropriate list
            compound_list.append(compound)
            positive_list.append(pos)
            negative_list.append(neg)
            neutral_list.append(neu)
            counter_list.append(counter)
            target_list.append(target)
            # Store the data in dictionary
            sentiment = {
                "User": target_list,
                "Tweet": tweet_texts,
                "Date": tweet_date,
                "Compound": compound_list,
                "Positive": positive_list,
                "Neutral": negative_list,
                "Negative": neutral_list,
                "Tweets Ago": counter_list
            }
            #add to counter
            #print(target)
            counter += 1
        

```

```python
#df = pd.DataFrame(sentiment)
sentiment_df = pd.DataFrame(sentiment)
```

```python
sentiment_df.head(110)
```

```python

bbc_sentiment_df = sentiment_df.loc[sentiment_df['User'] == 'BBC']
cbs_sentiment_df = sentiment_df.loc[sentiment_df['User'] == 'CBS']
cnn_sentiment_df = sentiment_df.loc[sentiment_df['User'] == 'CNN']
fox_sentiment_df = sentiment_df.loc[sentiment_df['User'] == 'FOX']
nytimes_sentiment_df = sentiment_df.loc[sentiment_df['User'] == 'NYTIMES']
```

```python
bbc_sentiment_df.count()
```

```python
#Plot for Sentiment Analysis
#set seadboard style & size of plot
sns.set_style("darkgrid")
plt.figure(figsize=(12, 7))

#--------plot BBC ------------#
urban_plot = plt.scatter(bbc_sentiment_df['Tweets Ago'], bbc_sentiment_df['Compound'],  facecolors="cyan", edgecolors="black",
            alpha=0.75)

#--------plot CNN ------------#
urban_plot = plt.scatter(cnn_sentiment_df['Tweets Ago'], cnn_sentiment_df['Compound'],  facecolors="red", edgecolors="black",
            alpha=0.75)

#--------plot CBS ------------#
urban_plot = plt.scatter(cbs_sentiment_df['Tweets Ago'], cbs_sentiment_df['Compound'],  facecolors="green", edgecolors="black",
            alpha=0.75)

#--------plot FOX ------------#
urban_plot = plt.scatter(fox_sentiment_df['Tweets Ago'], fox_sentiment_df['Compound'],  facecolors="blue", edgecolors="black",
            alpha=0.75)

#--------plot NYTIMES ------------#
urban_plot = plt.scatter(nytimes_sentiment_df['Tweets Ago'], nytimes_sentiment_df['Compound'],  facecolors="yellow", edgecolors="black",
            alpha=0.75)

#Titles and axis'
plt.title("Sentiment Analysis of Media Tweets (4/10/18)")
plt.xlabel("Tweets Ago")
labels = ['BBC','CNN', 'CBS', 'FOX', 'New York Times']
plt.legend(labels, loc='center left', bbox_to_anchor=(1, 0.5))
#plt.xlim([-180,180])
plt.ylabel("Tweet Polarity")
plt.savefig("Sentiment_Scatter_Plot_4-10-18.png")

plt.show()

```

```python
#Average the compound vader analysis for each broadcasting company
bbc_compound_avg = (f"{np.mean(bbc_sentiment_df['Compound']):.3f}")
cbs_compound_avg = (f"{np.mean(cbs_sentiment_df['Compound']):.3f}")
cnn_compound_avg = (f"{np.mean(cnn_sentiment_df['Compound']):.3f}")
fox_compound_avg = (f"{np.mean(fox_sentiment_df['Compound']):.3f}")
nytimes_compound_avg = (f"{np.mean(nytimes_sentiment_df['Compound']):.3f}")

#create DF with all compounded averages
compound_df = [bbc_compound_avg, cbs_compound_avg, cnn_compound_avg, fox_compound_avg, nytimes_compound_avg]

```

```python
# Create a plot  
x_axis = np.arange(len(compund_df))

plt.bar(x_axis, compound_df, color=('red', 'cyan', 'blue', 'yellow', 'green'), alpha=0.5, align="edge")

# Tell matplotlib where we would like to place each of our x axis headers
tick_locations = [value+0.4 for value in x_axis]
plt.xticks(tick_locations, target_users)

# Give our chart some labels and a tile
plt.title("Overall Media Sentiment Based on Twitter (4/10/17)")
plt.xlabel("Media Company")
plt.ylabel("Tweet Populalrity")

# Sets the y limits of the current chart
#plt.ylim([-0.20,1])
# Print our chart to the screen
plt.show()
plt.savefig("Avg_Media Sentiment_Bar_Plot_4-10-18.png")
#Sentiment values left to right
#['0.118', '0.367', '0.002', '0.189', '0.015']
```
