# api.user.videos() 
# returns Iterator(Video) object
# so a list of videos of the user

async def videos(self, count=30, cursor=0, **kwargs) -> Iterator[Video]:

#Returns a user's videos
#
#Args:
#    count (int): The amount of videos you want returned.
#    cursor (int): The the offset of videos from 0 you want to get
#
#Returns:
#    async iterator/generator: Yields TikTokApi.video objects
#
#Raises:
#    InvalidResponseException: If TikTok returns an invalid response, or one we don't understand
#
#Example Usage:
#    .. code-block:: pytho
#        async for video in api.user(username="davidteathercodes").videos():
#            # do something


#########################################################################################

# api.video represents a tiktok video
# video.as_dict  raw video data as dict
# video.comments()  gets me an iterator of comment objects (so te comments for the video)

async def comments(self, count=20, cursor=0, **kwargs) -> Iterator[Comment]:
#"""
#Returns the comments of a TikTok Video.
#
#Parameters:
#    count (int): The amount of comments you want returned.
#    cursor (int): The the offset of comments from 0 you want to get.
#
#Returns:
#    async iterator/generator: Yields TikTokApi.comment objects.
#
#Example Usage
#.. code-block:: python
#    async for comment in api.video(id='7041997751718137094').comments():
#        # do something
#```
#"""

##############################################################################################

# api.comment  represent tiktok comment
# comment.author -> api.user
# comment.replies -> Iterator[Comment]


#THEN-> iterate trhough all video commments-> get usernames -> count

#    async for comment in api.video(id='7041997751718137094').comments():
#        # comment.author.username              <-------------------------------------------------- comment author


# also
# for comment in video.comments:
#     print(comment.text)
