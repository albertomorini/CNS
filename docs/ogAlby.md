# API 

TikTok's API requires prior authentication using a Secret Key and a Client ID, which can be obtained by making a personal request to the platform's staff. Then, each call to the API must be authenticated with a Bearer token, previously obtained through the opportune authentication endpoint.
Each endpoints has it's own query string and body parameter required in the HTTP request.

There is a daily limit of 100,000 records (reset at 12 AM UTC) for videos and comments. Meanwhile for the followers/following endpoint, the limit is set at 2 million records.

In this project, every call is parameterized to retrieve the maximum allowed data, typically 100 records. However, the APIs do not always provide the exact data requested, possibly due to a lack of content requested or other unknown issues.

https://developers.tiktok.com/doc/research-api-faq/


## Amount of data downloaded

For each video, followers have been downloaded for up to 5 days, within 3-hour intervals.

With this method for every video can be retrieved:
```
100 users * (24h/3h = 8 request per a single day, for 5 days= 40 request)
In theory: 4000 followers for each video.
```

However these theoretical number are reached only if the nwe followers are distinct in very call, which is difficult to achieve within such a short time span.

Since the TikTok’s followers API returns the user which has started following the influencer from the date (in unix format) declared in the body of the request (called cursor). There’s the problem of duplicated accounts.

For example, *if JohnDoe follows MrWhite on 31/12/2023 at 10:00:00 and MrWhite does not gain 100 new followers in the next 3 hours, JohnDoe will also be included in the request at 31/12/2023 at 13:00:00.*

To solve this problem, a Python script (DataCleaner.py) was created, which keeps only the first occurrence (sorted by ascending date) of each username found in the total downloaded data.

Additionally, video information has been stored and later analyzed.

Has also been downloaded the public information of the influencer, with a single call for each one.

In the end, the amount of data downloaded is:
- 35798 distinct followers
- 182 videos divided of 10 influencers

--------- 

# POST IMPACT

One aim of this research is to analyze the impact of new content posted by an influencer on their followers count.

To reach this purpose, has been downloaded all videos posted by influencers over the past five months. For each video, has been registered the users who followed the influencer within five days after the video was posted.

There is a potential bias in this approach, as new followers can be gained independently of new posts. However, on social networks today, content either goes viral almost immediately or not at all. For this reason this approach has been considered valid.

The query included in the body of the request contains simply the username, without filtering other parameters (such as hashtag, region). This decision has been made since an influencer can talks about various topics but still is belongs to a specific wing.
```json
{
     "and": [
        {
            "operation": "IN",
            "field_name": "username",
            "field_values": [
                "$influencer" 
            ]
        }
    ]
}
```

For this analysis, has been considered just some influencer as considered the most influential (with more followers and engagement)

TODO: ![imgAllFollowers](TO)
> Monitoring the simple increasing of new followers through time, as can be seen, is slowly incrementing for almost all influencer


Has been done a more specific analysis on two interesting influencer: "aocinthehouse" and "real.benshapiro".

TODO: !img specific on influencer
> This analysis consisted in the average trend of new followers, creating so a detailed curve enriched with timestamps of new post creations.

In example, there is a noticeable increase of new followers for "aocinthehoue" after the content posted on data TODO


----------------


# ENGAGEMENT

Studying engagement on TikTok can reveal how many people are reached and the approval rate of content.

Each post (in this case, only videos) includes several pieces of information that can be used to analyze the content's impact. For example, the API returns data such as the number of views, comments, likes, shares, and more.

Naturally, views have the highest numbers, followed by likes and comments. For these video topics, there is a very low "repost" rate (called shares), which refers to users reposting the influencer's video.

In the analysis, some attributes has been normalized thus to obtain a graph well formed.
In detail: views, likes, comments are reported in thousands

!INSERT GRAPH

To compare the two political wings, the data has been divided into two subgroups based on the side of influencers.

!Insert Graph

# CONCLUSION

Sono le 00:15 bro, domani