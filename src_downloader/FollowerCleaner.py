# data cleaner
import json 
from datetime import datetime


def convertUnix2HumanTime(p_timestamp):
    ts = int(p_timestamp)
    return str(datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S'))


followers = json.load(open("../data_downloaded/followers_test.json"))
total = []

for singleInfluencer in followers.keys():

    videoID = followers.get(singleInfluencer).keys()

    for singleVideo in videoID:
        dates = followers.get(singleInfluencer).get(singleVideo).keys()

        for singleDate in dates:
            followerList = followers.get(singleInfluencer).get(singleVideo).get(singleDate).get("data").get("user_followers")
            # now just keep the username
            followerList = list(map(lambda x: x.get("username"),followerList ))

            total.append({
                "influencer": singleInfluencer,
                "videoID": singleVideo,
                "videoDate": convertUnix2HumanTime(singleDate),
                "followerList": followerList
            })


for i in range(1,len(total)):
    if(total[i].get("influencer")==total[i-1].get("influencer")): ##check if the same influencer (we don't want to remove common followers)
        
        print("previous: "+  str(total[i-1].get("videoDate")))
        print("current: "+ str(total[i].get("videoDate")))
        total[i]["followerList"] = [elem for elem in total[i-1].get("followerList") if elem not in total[i].get("followerList")]
        # print([elem for elem in total[i-1].get("followerList") if elem not in total[i].get("followerList")])
        print("\n\n")
        


f= open("./follower_cleaned.json","w")
f.write(json.dumps(total))
f.close()