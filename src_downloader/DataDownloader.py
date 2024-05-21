## DATA DOWNLOADER ~ Alberto 7 Apr 2024
################################################

import requests
import json 
from datetime import datetime
import time
import calendar

# UTILITY

# @message {string} the log
# @level {string} log level (eg. ERROR, AUTH, INFO,...)
def writeLog(message, level):
    log = open('./log.txt','a')
    log.write(str(datetime.now())+','+message+','+level.upper()+'\n')
    log.close()


# Store data into JSON file structured like {stored: Array} -> where the array is the data
# @data {dict} the information retrieved
# @filename {string} filename with extension
# @pathDst {string} directory path where we ant to store/update the file [optional]
def storeData(data, filename, pathDst='../data_downloaded/'):

    try:  #check if the file exits
        with open(pathDst+filename,'r') as f: # Load the ClientID/ClientSecret from private json
            dummy = json.load(f)
            f.close()
    except Exception: #otherwise create the dummy variable
        dummy = dict()
        dummy['stored']= list()

    dummy['stored'].append(data);

    # write new data
    ff = open(pathDst+filename,'w')
    ff.write(json.dumps(dummy))
    ff.close


def converterHumanTimeToUnix(year,month,day):
    time_tuple = (year, month, day, 0, 0, 0, 0, 0, 0)
    # convert time_tuple to seconds since epoch
    seconds = time.mktime(time_tuple) #my timezone
    return calendar.timegm(time_tuple) #GMT timezone

#______________________________________________________
# TIKTOK INTEGRATION


TikTok_URLs={
    'auth':'https://open.tiktokapis.com/v2/oauth/token/',
    'user': 'https://open.tiktokapis.com/v2/research/user/info/?fields=display_name,bio_description,avatar_url,is_verified,follower_count,following_count,likes_count,video_count',
    'comments' : 'https://open.tiktokapis.com/v2/research/video/comment/list/?fields=id,video_id,text,like_count,reply_count,parent_comment_id,create_time',
    'videos': 'https://open.tiktokapis.com/v2/research/video/query/?fields=id,video_description,create_time,region_code,share_count,view_count,like_count,comment_count,music_id,hashtag_names,username,effect_ids,playlist_id,voice_to_text',
    'repostedVideo': 'https://open.tiktokapis.com/v2/research/user/reposted_videos/?fields=id,create_time,username,region_code,video_description,music_id,like_count,comment_count,share_count,view_count,hashtag_names',
    'followers': 'https://open.tiktokapis.com/v2/research/user/followers/',
    'following': 'https://open.tiktokapis.com/v2/research/user/following/',
    'likedVideos': 'https://open.tiktokapis.com/v2/research/user/liked_videos/'
}


#______________________________________________________
## Authentication methods

TikTok_Credentials = None
with open('./credentials.json','r') as f: # Load the ClientID/ClientSecret from private json
    TikTok_Credentials = json.load(f)

TikTok_AuthToken={ #store the token and infos
    'access_token': None,
    'expires_in': None,
    'Requested': None
}

# Authenticate to TikTok thus to get the Bearer Token (valid for 2 hours)
# @returns {None} if the request is not successful - {Dict} otherwise
# DOCS: https://developers.tiktok.com/doc/client-access-token-management
def doAuthentication():
    print('Authentication started')
    params = {
    'client_key':TikTok_Credentials['ClientKey'],
    'client_secret':TikTok_Credentials['ClientSecret'],
    'grant_type':'client_credentials' #as requested in the official documentation
    }

    # execute the auth request
    res = requests.post(TikTok_URLs['auth'], headers={
        'Content-Type': 'application/x-www-form-urlencoded', 'Cache-Control': 'no-cache' 
    }, data=params)
    # check the response and 
    if(res.status_code==200):
        writeLog('Auth ok: '+str(res.json()),'AUTH')
        return res.json()
    else:
        writeLog('Auth ko: '+str(res.json()),'AUTH_ERROR')
        return None


# Get or refresh the Auth token, then return it
# @return {string} the Bearer token
def getAuthToken():
    #there's a token and when we had requested - datetime.now() is inferior than the expiration time
    if(TikTok_AuthToken['access_token']!=None and abs((TikTok_AuthToken['Requested']-datetime.now()).total_seconds())<TikTok_AuthToken['expires_in']): 
        #returns the last token if still valid
        return TikTok_AuthToken['access_token']
    else: # No Token or expired
        tmp = doAuthentication()
        if(tmp!=None):
            TikTok_AuthToken['access_token']= tmp['access_token']
            TikTok_AuthToken['expires_in']= tmp['expires_in']
            TikTok_AuthToken['Requested'] = datetime.now() #mark the new timestamp (our request)
            return TikTok_AuthToken['access_token']
        else: #Empty token, waiting for 5min then retry (probably internet connection errors)
            writeLog('Empty token, waiting for 5min','WARNING')
            time.sleep(5*60)
            getAuthToken()      


#______________________________________________________
## Downloading methods


# Download the information of videos which are include into a research (query)
# @query {Object/Dict} the query to filter videos
# @start_date {string} in format UTC (eg: 20210123)
# @end_date {string} must be no more than 30 days after the start_date
# DOCS: https://developers.tiktok.com/doc/research-api-specs-query-videos/
def downloadVideo(query, start_date, end_date, cursor): 
    res = requests.post(TikTok_URLs['videos'],
    headers={
        'Content-Type':'application/json',
        'Authorization':'Bearer ' + getAuthToken()
    },
    data=json.dumps({
        'query': query, 
        'start_date': start_date,
        'end_date': end_date,
        'max_count': 100,
        'cursor': cursor,
        #'is_random':'false' => if omitted is false
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
        writeLog('Error downloading USER comments code: '+str(res.status_code),'ERROR')
        return None


# Download the comments of a given video
# @video_id {integer} the reference of the tiktok video
# @return {dict/none}
# DOCS: https://developers.tiktok.com/doc/research-api-specs-query-video-comments/
def downloadComments(video_id, cursor):
    res = requests.post(TikTok_URLs['comments'],
    headers={
        'Content-Type':'application/json',
        'Authorization':'Bearer '+getAuthToken(),
    },
    data=json.dumps({
        'video_id': video_id,
        'max_count': 100, #Default is 10, max is 100.
        'cursor': cursor #Note: only the top 1000 comments will be returned, so cursor + max_count <= 1000.
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
        writeLog('Error downloading USER comments code: '+str(res.status_code),'ERROR')
        return None

# Download the public data (defined in the URL) of a user
# @username {string}
# @return {dict/none} the information otherwise None
# DOCS: https://developers.tiktok.com/doc/research-api-specs-query-user-info/
def downloadUser(username):
    res = requests.post(TikTok_URLs['user'],
    headers={
        'Authorization':'Bearer '+getAuthToken(),
        'Content-Type': 'text/plain'
    },
    data=json.dumps({
        'username': username
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
        writeLog('Error downloading USER status code: '+str(res.status_code),'ERROR')
        return None


# DOCS: https://developers.tiktok.com/doc/research-api-specs-query-user-reposted-videos/
def repostedVideo(username, cursor):
    res = requests.post(TikTok_URLs['repostedVideo'],
    headers={
        'Authorization':'Bearer '+getAuthToken(),
        'Content-Type': 'application/json'
    },
    data=json.dumps({
        'username': username,
        'max_count': 100, #Default is 10, max is 100.
        'cursor': cursor #Note: only the top 1000 comments will be returned, so cursor + max_count <= 1000.
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
        writeLog('Error downloading reposted video code: '+str(res.status_code),'ERROR')
        return None

# DOCS: https://developers.tiktok.com/doc/research-api-specs-query-user-followers/
def getFollowers(username,cursor):
    time.sleep(0.01)
    res = requests.post(TikTok_URLs['followers'],
    headers={
        'Authorization':'Bearer '+getAuthToken(),
        'Content-Type': 'application/json'
    },
    data=json.dumps({
        'username': username,
        'max_count': 100, #Default is 20, max is 100.
        'cursor': cursor #NOTE: unix timestamp of the day that we want to download (on 24th may user X,Y has started following $username -> return X,Y)
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
        writeLog('Error downloading followers, code: '+str(res.status_code),'ERROR')
        return None



#______________________________________________________


# MAIN

# def main(query, limitVideo, limitComment, preambleFileName):
#     print('started for: '+preambleFileName)
#     for counter_video in range (0, limitVideo,100): #download each video (incrementing the TikTok cursors by 100 each time - is the max)
#         resVideo = downloadVideo(query,'20240301','20240330',counter_video)
#         storeData(resVideo,(preambleFileName+'video.json')) # store the videos retrieved
#         print('Downloaded video '+str(counter_video)+'/' + str(limitVideo))
#         if(resVideo is not None):
#             for singleVideo in resVideo['data']['videos']: #for each video downloaded
#                 try:
#                     writeLog('Processing video id: '+str(singleVideo['id']),'INFO')
#                     for counter_comment in range(0,limitComment,100): # download the comment of the video
#                         resComments = downloadComments(singleVideo['id'],counter_comment)
#                         storeData(resComments,(preambleFileName+'comments.json')) #store the comments retrieved
#                         print('\t Downloaded comment '+str(counter_comment)+"/"+str(limitComment))
#                     #TODO: download also profile information?
#                 except Exception as e:
#                     writeLog('Error downloading comments of video: '+str(singleVideo['id'])+' - err: '+str(e),'WARNING')
#                     pass
#         else:
#             writeLog('Video NoneType','ERROR') # just a warning, 



def main(influencerPools,year,month,day,nrDays):
    #STORE the data retrieved in a structure like: {influencer+unixDate:followersPool}
    storing = dict()
    for influencer in influencerPools:
        dummy = dict()
        for ith_day in range(0,nrDays):
            unixDate = converterHumanTimeToUnix(year,month,day)-(86400*ith_day) ##to reverse from 30 may - 0h | 30 may - 24h | 30 may - 48h
            try:
                followersPool = getFollowers(influencer,unixDate)

                dummy[str(year)+"/"+str(month)+"/"+str(day+ith_day)]=followersPool
                time.sleep(0.02) ## wait just two sec before download another set
            except Exception:
                print(Exception)
                pass
            print(str(ith_day)+"--"+influencer)
            #TODO: here the point where we can hook up for the followers of followers (Marco's idea)
            '''
            for follower in followersPool:
            getFollowers(follower)
            '''
        storing[influencer]=dummy
        storeData(dummy,str(influencer)+".json")
        time.sleep(2) ## wait just two sec before download another set
    storeData(storing, str(year)+"_"+str(month)+"_"+str(day)+"x"+str(nrDays)+'.json')


main(['aocinthehouse','huffpost','dailymail','cnn','alynicolee1126'],2023,10,20,90)