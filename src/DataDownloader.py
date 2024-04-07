## DATA DOWNLOADER ~ Alberto 7 Apr 2024
################################################

import requests
import json 
credentials = None
with open("./credentials.json","r") as f:
    credentials = json.load(f)



TikTok_URL_Auth= 'https://open.tiktokapis.com/v2/oauth/token/'


# Returns the Bearer Token to use into the request
# @returns None if the request is not successful - Dict otherwise
def doAuthentication():

    params = {
    "client_key":credentials["ClientKey"],
    "client_secret":credentials["ClientSecret"],
    "grant_type":"client_credentials" ##as requested in the official documentation
    }

    res = requests.post(TikTok_URL_Auth, headers={
        "Content-Type": "application/x-www-form-urlencoded", "Cache-Control": "no-cache" 
    }, data=params)
    if(res.status_code==200):
        print(res.json())
        return res.json()
    else:
        return None



def main():
    print("Downloader started.")
    pass


main()









#     curl -X POST \
#   'https://open.tiktokapis.com/v2/research/video/query/?fields=id,like_count' \
#   -H 'authorization: bearer clt.example12345Example12345Example' \
#   -d '{ 
#           "query": {
#               "and": [
#                    { "operation": "IN", "field_name": "region_code", "field_values": ["US", "CA"] },
#                    { "operation": "EQ", "field_name": "keyword", "field_values": ["hello world"] }
#                ]
#           }, 
#           "start_date": "20220615",
#           "end_date": "20220628",
#           "max_count": 10
# }'
