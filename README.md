# Headline Connector

Project which do data analysis based on headline-related youtube videos from YouTube Data API (v3)

## Overview

Headline Connector do data analysis based on both headline, or the topic you interest, just by simply type in the search line.
To get the sense of the topic interesting you in a galance, we provide data analysis features, such as the text cloud based on your keyword, or the trend of the top youtubes.
With this feature, it aims to expand your keyword to multiple approches, which are for you to explore further.

## Scenario

### Scenario 1
**Issue**: Someone want to explore a new topic. He or she want to learn by search, but isn't familiar with the keywords related to this topic.

**Feature**: Based on the topic, Headline Connector expand it to a text cloud. In the text cloud, not only the keywords are presented, the closeness between the topic and the keywords are also indirectly showed by the words' font size.

### Scenario 2
**Issue**: Someone want to explore a new topic. But he or she has no idea which videos he or she should watch first.

**Feature**: Plotting the trend of the TOP videos' daily views number, he or she can decide which video he or she should read by the pattern of the trend.

## Short-term goals

 - Based on the topic or the headline of the New York Times,
    1. produce a text clound from the tags of the TOP 30 youtube videos in the search result.
    2. plot the trend of the TOP videos' daily views number in the search result.

## Long-term goals

- Using keywords from Google Analytics to allow users to follow the trend.
- Integrating industrial information with departments, for example, the Industrial Development Bureau or the Ministry of Economic Affairs.
- Displaying the most interesting video or information at the time and transforming it into a graph by the total history view count.

## Resources

### youtube

- topic
- video (renamed as feed in our app)
- channel (renamed as provider in our app)

## Elements

 - topic
  - keyword
  - search_time

- feed
  - id
  - title
  - description
  - tags
- provider
  - channel_id
  - channel_title

## Entities

These are objects that are important to the project, following my own naming conventions:

- Topic: the topics searched
- Feeds: all related feeds (ex. videos or podcasts)
- Providers: all related providers (ex. channels in Youtube)

## Database Diagram
![](https://i.imgur.com/0Zh7bZD.png)
