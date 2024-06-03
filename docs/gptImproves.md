TikTok's API requires prior authentication using a Secret Key and a Client ID, which can be obtained by making a personal request to the platform's staff. Each call to the API must be authenticated with a Bearer token, previously acquired through the authentication endpoint. After authentication, the various endpoints respond to the query string and body of the HTTP request as standard.

There is a daily limit of 100,000 records (reset at 12 AM UTC) for videos and comments. For the followers/following endpoint, the limit is set at 2 million records.

In this project, every call is parameterized to retrieve the maximum allowed data, typically 100 records. However, the APIs do not always provide the exact data requested, possibly due to a lack of data to download or other unknown issues.

https://developers.tiktok.com/doc/research-api-faq/




### how much data we retrieved

For each video, followers have been downloaded for up to 5 days, within 3-hour intervals.

With this method, for every video, the following can be retrieved:

    100 users per request
    8 requests per day (24 hours / 3-hour intervals)
    40 requests over 5 days (8 requests/day * 5 days)

In theory, this amounts to 4,000 followers per video.

However, these numbers assume that there are always new, distinct followers, which is difficult to achieve within such a short time span.

The TikTok followers API returns users who started following the influencer from the date (in Unix format) specified in the body of the request (called cursor). This can result in duplicate accounts.

For example, if JohnDoe follows MrWhite on 31/12/2023 at 10:00:00 and MrWhite does not gain 100 new followers in the next 3 hours, JohnDoe will also be included in the request at 31/12/2023 at 13:00:00.

To address this problem, a Python script (DataCleaner.py) was created. This script keeps only the first occurrence (sorted by ascending date) of each username found in the total downloaded data.

Additionally, video information has been stored and later analyzed.

We also download the public information of the influencer, with a single call for each one.



------



We aim to analyze the impact of new content posted by an influencer on their follower count.

To do this, we downloaded all videos posted by influencers over the past five months (as explained in previous chapters). For each video, we tracked the users who followed the influencer within five days after the video was posted.

There is a potential bias in this approach, as new followers can be gained independently of new posts. However, on social networks today, content either goes viral almost immediately or not at all.

For this analysis, influencers with fewer than nn new followers have been excluded, marked as “dead.”

In the initial analysis, we monitored the simple increase in new followers, which for most influencers was fairly continuous.
Graph

For the most prominent outlier influencers, a detailed analysis was conducted. This involved creating a detailed curve of the median, enriched with timestamps of new post creations. For example, there is a noticeable increase in new followers for "aocinthehouse" after the content posted on [date].

----------------

Studying engagement on TikTok can reveal how many people are reached and the approval rate of content.

Each post (in this case, only videos) includes several pieces of information that can be used to analyze the content's impact. For example, the API returns data such as the number of views, comments, likes, shares, and more.

Naturally, views have the highest numbers, followed by likes and comments. For these video topics, there is a very low "repost" rate (called shares), which refers to users reposting the influencer's video.

Some data in the analysis has been normalized, with views, likes, and comments reported in thousands.

To compare the two political wings, all the data has been divided into two subgroups based on the political side of the influencers.
Insert Graph

A curious fact can be observed: "quelloGay" has the highest engagement numbers among the content analyzed.
