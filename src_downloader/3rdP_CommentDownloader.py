
from TikTokApi import TikTokApi
import asyncio
import os


import json 
from datetime import datetime
import time

video_id = 7352308102751898923
#ms_token = os.environ.get("wubiQOBLi-Lp0FBO2_iq8sjF3cUhAXY4DKlUJjk0Off8bHz2XPdXOFZXgLoMcqLIQiugqGCZJakxeYJ2eA5XAUh0mfI5XeidmHLTE7LQ500Ane-Bl1vVYn1kag==", None)  # set your own ms_token (index DB, setup a VPN outside italy to use tiktok w/out an account) # expires on 12 may

ms_token = os.environ.get("ywUN3rxylaMxbKuLiv1SKg7ajq9114aMvauJJbKhK1MLqpyF3lw2_he980Z9Iw6dDOMFhtNL5e1V3TpIH6RNHWbegv7DK6KWPhxgrW-DeMU3Vh5lNawMJ2UKZ0mr5gCqqRnl", None)  # set your own ms_token


# https://www.tiktok.com/@life11449/video/7365968222081912096?is_from_webapp=1&sender_device=pc&web_id=7365987734266611233
# https://www.tiktok.com/@clarksonlawson/video/7352308102751898923 -- 186comments
# https://www.tiktok.com/@notvictornieves/video/7352270389365476654 -- 530 comments (729 with replies)

#################################################

def storeData(data, filename, pathDst='../data_downloaded/'):
    # write new data
    ff = open('./'+filename,'w')
    ff.write(json.dumps(data))
    ff.close


async def get_comments():
    async with TikTokApi() as api:
        await api.create_sessions(ms_tokens=[ms_token], num_sessions=1, sleep_after=3)
        video = api.video(id=video_id)
        count = 0
        async for comment in video.comments(count=9999):
            # print(comment)
            # print(comment.as_dict)
            storeData(str(comment),str(video_id)+'.json','./')


if __name__ == "__main__":
    asyncio.run(get_comments())