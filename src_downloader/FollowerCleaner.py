# # # data cleaner
import json 
from datetime import datetime
import os

def convertUnix2HumanTime(p_timestamp):
    ts = int(p_timestamp)
    return str(datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S'))

def cleanFollowers(pdict):

    followers = pdict
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
                    tmpDate = followers.get(singleInfluencer).get(singleVideo).get(singleDate).get("data").get("cursor")
                    total.append({
                        "influencer": singleInfluencer,
                        "videoID": singleVideo,
                        "videoDate": convertUnix2HumanTime(tmpDate),
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
        
    return total



def main():
    directory="/Users/alby/unipd/CNS/CNS/data_downloaded/processed"
    total = []
    for file in os.listdir(directory):
        try:
            filename = os.fsdecode(file)
            print(filename)
            with open(directory+"/"+filename) as f:
                tmpJson =(json.load(f))
                x = cleanFollowers(tmpJson)
                total.append(x)
        except Exception:
            pass
        

    
    f= open("./follower_cleaned.json","w")
    f.write(json.dumps(total))
    f.close()
        

# open('strings.json') as f:
#     d = json.load(f)
#     print(d)
        # jsonTodo = json.load(str(fTodo.read()))
        # print(jsonTodo)
        
    # f= open("./follower_cleaned.json","w")
    # tmp = f.read()
    # tmp.
    # f.write(json.dumps(total))
    # f.close()



main()