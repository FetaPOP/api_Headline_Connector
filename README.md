# Headline Connector

Project to search and gather headline-related youtube videos from YouTube Data API (v3)

## Overview

Headline Connector will display the video of the news that you are interested in. 

We hope our users find this tool useful when they want to quickly filter the related youtube video from the daily news. The purpose of this is to save users' time. Also, we will integrate with sources from other departments that allow users to explore the top videos in a day.

## Short-term goals

- Using keywords from Google Analytics to allow users to follow the trend.
- Integrating industrial information with departments, for example, the Industrial Development Bureau or the Ministry of Economic Affairs.
- Displaying the most interesting video or information at the time and transforming it into a graph by the total history view count.

## Resources

- search result
- video (renamed as feed in our app)
- channel (renamed as provider in our app)

## Elements

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

- Feeds: all related feeds (ex. videos or podcasts)
- Providers: all related providers (ex. channels in Youtube)

## Database Diagram
![](https://i.imgur.com/0Zh7bZD.png)
