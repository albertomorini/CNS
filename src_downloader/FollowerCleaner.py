# # # data cleaner
import json 
from datetime import datetime


def convertUnix2HumanTime(p_timestamp):
    ts = int(p_timestamp)
    return str(datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S'))

followers = json.load(open("../data_downloaded/followers_huffpost-marzo.json"))
total = []

for singleInfluencer in followers.keys():

    videoID = followers.get(singleInfluencer).keys()

    for singleVideo in videoID:
        dates = followers.get(singleInfluencer).get(singleVideo).keys()

        for singleDate in dates:
            try:
                followerList = followers.get(singleInfluencer).get(singleVideo).get(singleDate).get("data").get("user_followers")
                # now just keep the username
                followerList = list(map(lambda x: x.get("username"),followerList ))

                total.append({
                    "influencer": singleInfluencer,
                    "videoID": singleVideo,
                    "videoDate": convertUnix2HumanTime(singleDate),
                    "followerList": followerList
                })
            except Exception:
                pass


for i in range(0,len(total)-1):
    for j in range(i+1, len(total)):
        if(total[i].get("influencer")==total[j].get("influencer")): ##check if the same influencer (we don't want to remove common followers)

            print("current: "+ str(total[j].get("influencer")) + " - " + str(total[i].get("influencer")))

            total[i]["followerList"] = [elem for elem in total[i].get("followerList") if elem not in total[j].get("followerList")]

            print("\n\n")
        


f= open("./follower_cleaned.json","w")
f.write(json.dumps(total))
f.close()


a = [1,2,3]
b = [3,4,5]

print(list(elem for elem in a if elem not in b))