CNS

# TikTok Social Analysis 

University of Padua's Advance Topics for Cybersecurity course's project.
Made by 
- Alberto Morini ([albertomorini](https://github.com/albertomorini)) 
- Marco Bellò ([mhetacc](https://github.com/mhetacc))

## Project Goals

The idea is utilize TikTok's official [APIs](https://developers.tiktok.com/doc) in order to study users behaviors and political positioning in the context of the next 2024 US presidential elections.

### Goal 1 : Social Graph

The idea behind a Social Network Graph is to clearly show relations (represented as edges) between users (represented as nodes). \
This is done in order to see how high is the degree of intersection between different political fields (or how low it is, leading to echo chambers), starting from "root" nodes represented by a list of selected influencer and moving on through their respective followers. 

Let's see an example: 
![social_graph_mocUP](../docs/images/san_moc.png)

We can clearly see the idea in action: user *@corylapen* represent an intersection between the user-bases of *@aoc* and *@huffpost*. In this case we do not have a bridge between two political areas (both these influencer are left-leaning) but its clear how this could be utilized.

### Goal 2 : Followers Region

It could be of interest to learn the followers nationality of our pool of influencers: this will allow us to either conjecture about possible outsider's influence, and to whom it is directed (left or right wing). \
This information can also be intertwined with data from both the social graph and the sentiment analysis, to get even more insights about the political landscape.

### Goal 3 : Video Comments Sentiment Analysis 

The idea is to use libraries and services from either R or AWS to do a sentiment analysis on the comments under the videos of our pools of influencers. \
We can then use this information to see if the user-base is aggressive or supportive and, provided more information about it, we can see if this has any correlation with the political orientation or nationality of the users.

### Goal n

TODO?
 
## Methodology  

First, two lists (left-leaning and right-leaning) of influencer have been compiled, in order to have two "pools" of data with a clear political orientation. \
This has been done to avoid creating the pools with automated tools, like ML or NLP, that have been deemed not precise enough. \
**TODO**
The influencer's handles used to gather data are summarized in the following list (EITHER the complete list can be found [here](https://github.com/albertomorini/CNS/blob/main/msc/handles.txt))(OR not all of the following handles have been used to gather the data presented in this report):
- Right: 
    - [@huffpost](https://www.tiktok.com/@huffpost)
    - @aoc 
    - tre
- Left: 
    - uno
    - due 
    - tre

### Social Graph

Starting from the influencers pool, we query their followers using TikTok's official [APIs](https://developers.tiktok.com/doc/research-api-specs-query-user-followers/)

```python
def getFollowers(username,cursor):
    res = requests.post(TikTok_URLs['followers'],
    headers={
        'Authorization':'Bearer '+getAuthToken(),
        'Content-Type': 'application/json'
    },
    data=json.dumps({
        'username': username,
        'max_count': 100, #Default is 20, max is 100.
        'cursor': cursor #NOTE: unix timestamp
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
        writeLog('Error downloading followers, code: '+str(res.status_code),'ERROR')
        return None

```

TODO

## Results

### Social Graph

TODO \
a lot / not a lot of echo chambering 

## Extensions

### Social Graph

TODO \
- increase data layers 
    - influencer -> user follower -> user follower following -> repeat
- give node weight based on followers count
    - from user info

## Problems -> just put in methodolgy paragraph?

### Social Graph

TODO \
User pooling via official APIs:
- not truly randomic
- no transparency
- only 100 user per request -> per time stamp 



-------- 
## API

How the api works - to insert into the paper


~~TikTok's API works as shit~~
TikTok's API needs a previous authentication composed with a Secret Key and a Client ID, obtainable through a personal request to the staff of the platform.
Each calls to the API require to be authenticated with a Bearer token previously obtained via the authentication endpoint, then, the various endpoints responds to the query string and body of the HTTP request as standard.

There's a limit quota of 100'000 records per day (reset at 12 AM UTC) for videos and comments, instead for followers/following endpoint the limit is settled up to 2M of records.

In this project, every call is parametrized to retrieve the maximum of allowed data, usually 100 records. However, the APIs doesn't always provide the exactly data requested, this maybe because there's no data to download or other unknown issues.

https://developers.tiktok.com/doc/research-api-faq/

### how much data we retrieved

For each video has been downloaded the followers up next to 5 days within an hour span of 3hours.
With this method for every video can be retrieved:
100 users * (24h/3h = 8 request per a single day, for 5 days= 40 request)
In theory: 4000 followers for each video.

But these numbers are right if and only if, there are new distinct followers, which is very difficult to obtain a slot of hundreds of new follower in that time span.

Since the TikTok’s followers API returns the user which has started following the influencer from the date (in unix format) declared in the body of the request (called cursor). There’s the problem of duplicated accounts.

i.e. if JohnDoe follows MrWhite in date 31/12/2023T10:00:00, and MrWhite doesn’t get 100 new followers between the next 3 hours, JohnDoe will be downloaded also in the request of the 31/12/2023T13:00:00 

To avoid these problem, has been created a python script (DataCleaner.py) which keeps just the first occurrence (sorted by ascending  date) of the username founded in the total data downloaded. 

Also the video informations has been stored and later analyzed

We also provide to download the public information of the influencer, so a single call for each one.

In DATA:
- quanti followers?
- Quanti video?

## post impact

We would analyze what's the impact of a new content posted by an influencer in terms of followers.

So basically, has been downloaded all the video of the influencers in the last five month (as explained in chapters before), then, for each video has been downloaded the users which had followed the influencer between 5 days after.
Certanly, this could be a bias, because a new follower can gained indipendently of the new post, but, nowadays in social network a content became virual almost immediatly or never will.


FOR THIS ANALYSIS HAS BEEN REMOVED THE INFLUENCER WITH LESS OF $n NEW FOLLOWERS —> marked as “dead”

In the first analysis has been monitored a simple amount of increment of new users, where almost for every influencer is pretty much continuous.
**grafico**

For the most outliner influencer instead, has been made a detailed analysis creating a detailed curve of the median, enriched with the timestamp of the creation of the new “post”.
In example, is noticeable the increasing of new user of “aocinthehouse” after the content of $data.
** inserire il grafico **




## Engagement

Study the engagement on TikTok can shows how many people are reached and what's the approval quota of a content.

Each “post” (in this case only video) has several information which can be used to give a dimension of the content in analysis.

In example, the API's returns data like the numbers of view, comments, likes, shares and so on.

Naturally, the views are the information with higher data, followed up to likes and comments.
For these videos topic there’s a very low “repost” (called shares), which consist in a user to repost the video of the influencer.

SOME DATA IN THE ANALYSIS HAS BEEN NORMALIZED: the views/likes/comments are in order of thousands.

To compare the two political wings, all the data has been divided into two subgroup based on the political side of the influencers.
**inserire il grafico**

And with a more detailed information, a curious fact can be noticed, about “$quelloGay” which owns the majority of the number in the content retrieved.
>>>Can be defined as an “outliner” since is a very controversial person



-----------------------------------

## Influencer downloaded:

**right wing**:
- alynicolee1126
- babylonbee
- real.benshapiro
- clarksonlawson
- notvictornieves

**left wing**:

- thedailybeast
- huffpost
- aocinthehouse
- repbowman