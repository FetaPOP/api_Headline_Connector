# YouTube Data API

Project to search and gather headline-related youtube videos from YouTube Data API (v3)

## Resources
- search result
- video
- videoCategory
- channel

## Elements

- search result
  - list: matched videos
  - q: querying keyword
  - publishedAfter: A date
  - order: returned video order
  - eventType: restrict the search result to broadcast events
  - regionCode
  - relevanceLanguage
- video
  - list: video data for a single video
- videoCategory
  - list: a list of categories that can be associated with YouTube videos
- channel
  - list: channel data for a single channel

## Entities

These are objects that are important to the project, following my own naming conventions:

- Videos: all related videos
- Channels: all related channels