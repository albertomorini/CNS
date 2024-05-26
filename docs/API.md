
How the api works - to insert into the paper


~~TikTok's API works as shit~~
TikTok's API need a previous authentication composed with a Secret Key and a Client ID, obtainable through a personal request to the staff of the platform.
Each calls to the API require to be authenticated with a Bearer token previously obtained via the authentication endpoint, then, the various endpoints responds to the query string and body of the HTTP request as standard.

There's a limit quota of 100'000 records per day (reset at 12 AM UTC) for videos and comments, instead for followers/following endpoint the limit is settled up to 2M of records.

In this project, every call is parametrized to retrieve the maximum of allowed data, usually 100 records. However, the APIs doesn't always provide the exactly data requested, this maybe because there's no data to download or other unknown issues.

https://developers.tiktok.com/doc/research-api-faq/