
const fs = require("fs");

followers = JSON.parse(fs.readFileSync("../data_downloaded/followers_test.json"))["stored"]


let influencerNames = Object.keys(followers)

var total = []

influencerNames.forEach(singInfluencer=>{
    console.log(
        singInfluencer
    );
    videoID = Object.keys(followers[singInfluencer]);

    videoID.forEach(singVideo=>{
        dates = Object.keys(followers[singInfluencer][singVideo])
        console.log(dates);
        dates.forEach(singData=>{
            followerList = (followers[singInfluencer][singVideo][singData]).data.user_followers
            followerList = followerList.map(o=> o.username)
            console.log(followerList);
            total.push({
                username: singInfluencer,
                videoID : singVideo,
                data: singData,
                followerList : followerList
            })
        })
    })
})


fs.writeFileSync("./test.json",JSON.stringify(total))

