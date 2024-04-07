## DATA DOWNLOADER ~ Alberto 7 Apr 2024
################################################

import requests
import json 
from datetime import datetime
import time

# UTILITY

# @message {string} the log
# @level {string} log level (eg. ERROR, AUTH, INFO,...)
def writeLog(message, level):
    log = open('./log.txt','a')
    log.write(str(datetime.now())+','+message+','+level.upper()+'\n')
    log.close()


#______________________________________________________
# TIKTOK INTEGRATION


TikTok_URLs={
    'auth':'https://open.tiktokapis.com/v2/oauth/token/',
    'user': 'https://open.tiktokapis.com/v2/research/user/info/?fields=display_name,bio_description,avatar_url,is_verified,follower_count,following_count,likes_count,video_count',
    'comments' : 'https://open.tiktokapis.com/v2/research/video/comment/list/?fields=id,video_id,text,like_count,reply_count,parent_comment_id,create_time'
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
        print('Ok auth: ')
        writeLog('Auth ok: '+str(res.json()),'AUTH')
        return res.json()
    else:
        writeLog('Auth ko: '+str(res.json()),'AUTH_ERROR')
        return None


# Get or refresh the Auth token, then return it
# @return {string} the Bearer token
def getAuthToken():
    #there's a token and when we had requested - datetime.now() is inferior than the expiration time
    if(TikTok_AuthToken["access_token"]!=None and abs((TikTok_AuthToken["Requested"]-datetime.now()).total_seconds())<TikTok_AuthToken["expires_in"]): 
        #returns the last token if still valid
        return TikTok_AuthToken['access_token']
    else: # No Token or expired
        tmp = doAuthentication()
        if(tmp!=None):
            TikTok_AuthToken["access_token"]= tmp["access_token"]
            TikTok_AuthToken["expires_in"]= tmp["expires_in"]
            TikTok_AuthToken["Requested"] = datetime.now() #mark the new timestamp (our request)
            return TikTok_AuthToken["access_token"]
        else: #Empty token, waiting for 5min then retry (probably internet connection errors)
            writeLog("Empty token, waiting for 5min","WARNING")
            time.sleep(5*60)
            getAuthToken()      


#______________________________________________________
## Downloading methods

def downloadVideo(): ##TODO
    res = requests.post('https://open.tiktokapis.com/v2/research/video/query/?fields=id,like_count',
    #    'Authorization':'Bearer '+ auth['access_token']
    headers={
        'Authorization':'bearer clt.9x1Wq4QfCWF1SOVaGd5mvG1Pdv85LiK6obAecB5if2rixcIh7MprK20OqHBB'
    },
    data=json.dumps({
        'query': {
            'and': [
                { 'operation': 'IN', 'field_name': 'region_code', 'field_values': ['US', 'CA'] }
            ]
          }, 
        'start_date': '20220615',
        'end_date': '20220628',
        'max_count': 10
    })
    )
    print(res)
    print(res.json())

# Download the comments of a given video
# @video_id {integer} the reference of the tiktok video
# @return {dict/none}
# DOCS: https://developers.tiktok.com/doc/research-api-specs-query-video-comments/
def downloadComments(video_id):
    res = requests.post(TikTok_URLs['comments'],
    headers={
        'Content-Type':'application/json',
        'Authorization':'Bearer '+getAuthToken(),
    },
    data=json.dumps({
        'video_id': video_id,
        'max_count': 100, #Default is 10, max is 100.
        'cursor': 0 #Note: only the top 1000 comments will be returned, so cursor + max_count <= 1000.
    })
    )
    if(res.status_code==200):
        return res.json()
    else:
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
        return None



# MAIN

def storeData(data, type, filename):
    f = open('../data_downloaded/'+filename)


def main():
    print('Downloader started.')
    


# main()

