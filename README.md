# Advanced Topics

## Phase 1
> Downloading data from TikTok

### Influencer list


**right wing**:
- breitbartofficial (3k followers)
- dailymail (8M followers)
- foxnews1412 (19k followers - UNOFFICIAL)
- dailywire (3M followers - *Facts don’t care about your feelings.Conservative News, Opinion & Entertainment*)
- donaldtrumppage (270k followers)
- donaldtrumpwasright (290k followers)
- 


**left wing**:
- buzzfeednews (93k followers ~ not strictly politics)
- huffpost (200k followers)
- nytimes (600k followers)
- the guardian (300k followers)
- vox (~400k followers)
- washingtonpost (1.7M follower)


- bidenhq (300k followers - verified but unofficial??)
- democracycoalition (170k followers )

### TESTING PHASE

**RIGHT WING:** 'dailywire','mikepence50','notvictornieves','clarksonlawson','haley2024','donaldtrumppage'

**LEFT WING**: 'aocinthehouse', 'washingtonpost', 'bidenhq','bernie', 'chrisdmowrey', 'harryjsisson'

**NOT USED**:

*Hashtag*: 'US','presidential','uspresidential','election','presidentialelection','us2024','2024', 'haley2024', 'trump2024','biden2024','republican', 'democrat','politics','usa','usapresidential','usa2024','MAGA'


## Phase 2
> Data analysis in R

### TODO

1. Eco chamber graph and data
2. Cosine similarity
3. Followers flow (small granuality)
   1. Also with a good span between time (from different month)
4. Engagement
   1. Also of comments (sentiment analysis etc)

**Meeting 21/05/2024:**
- On followers:
   - smaller time stamps to increase granularity
   - pick user with low followers and see how data are returned
      - see growth rate (+-)
      - suppose it applies to big influencers 
   - *cumulata* on number of followers 
      - observe APIs response on curve changes
   - understand what *has_more* means
- On social graph:
   - for each influencer do *cosine similarity*
   - for each user following do *ideology* score (polarization score)
- User engagement
- Sentiment analysis on comments
   - Chat GPT (or other LMs)
   - Bert
- User followers + ideology = see increment or decrement of polarization


## Phase 3
> Report + Powerpoint

### Report still TODO


- ~~Alby correzione manuale un grafico (aggiunta legenda)~~
- ~~Conclusioni~~
- ~~Io leggo e correggo Marco~~ (Marco ha spaccato)


- Marco legge e corregge la mia
- Plotting SAN
- Compilazione in Latex
- Lettura finale
- > Da aggiungere alle conclusioni: The data has been download with a Python 3.9 script on MacOS 

### Powerpoint
- WIP