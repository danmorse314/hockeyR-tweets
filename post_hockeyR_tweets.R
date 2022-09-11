# post new commits to all hockeyR repos

source("scrape_commits.R")

df <- dplyr::bind_rows(
  scrape_commits(user = "danmorse314", repo = "hockeyR", branch = "master"),
  scrape_commits(user = "danmorse314", repo = "hockeyR-data"),
  scrape_commits(user = "danmorse314", repo = "hockeyR-models", branch = "master")
) |>
  dplyr::arrange(desc(datetime))

# load most recent commit that's been tweeted before
# this gets updated at the end
last_commit <- readRDS("last_commit.rds")

# only tweet if there are new commits
df <- dplyr::filter(df, datetime > last_commit$datetime)

if(nrow(df) > 0){
  
  # get token
  hockeyr_token <- rtweet::rtweet_bot(
    api_key = Sys.getenv("HOCKEYR_TWITTER_CONSUMER_API_KEY"),
    api_secret = Sys.getenv("HOCKEYR_TWITTER_CONSUMER_API_SECRET"),
    access_token = Sys.getenv("HOCKEYR_TWITTER_ACCESS_TOKEN"),
    access_secret = Sys.getenv("HOCKEYR_TWITTER_ACCESS_TOKEN_SECRET")
  )
  
  for(i in nrow(df)){
    
    # rearrange to do oldest first
    df_posting <- dplyr::arrange(df, datetime)
    
    commit <- df_posting[i,]
    
    tweet <- glue::glue(
      "New commit in {commit$repo}:
      
      {commit$summary}
      
      by {commit$author} at {commit$time} on {commit$date}

      {commit$link}"
    )
    
    rtweet::post_tweet(
      status = tweet,
      token = hockeyr_token
    )
    
    # if more tweets to do, give it a minute's rest
    if(nrow(df) - i > 0){
      Sys.sleep(60)
    }
  }
  
  # save most recent commit
  last_commit <- dplyr::slice(df, 1)
  
  last_commit |> saveRDS("last_commit.rds")
  
}

# look for new releases

source("scrape_latest_release.R")

release <- scrape_latest_release("danmorse314", "hockeyR", filename = "hockeyR-latest-release.png")

# this gets updated at the end
last_release <- readRDS("last_release.rds")

if(last_release != release$release){
  # get token
  hockeyr_token <- rtweet::rtweet_bot(
    api_key = Sys.getenv("HOCKEYR_TWITTER_CONSUMER_API_KEY"),
    api_secret = Sys.getenv("HOCKEYR_TWITTER_CONSUMER_API_SECRET"),
    access_token = Sys.getenv("HOCKEYR_TWITTER_ACCESS_TOKEN"),
    access_secret = Sys.getenv("HOCKEYR_TWITTER_ACCESS_TOKEN_SECRET")
  )
  
  tweet <- glue::glue(
    "NEW RELEASE: {release$release}
    
    Details:
    https://github.com/danmorse314/hockeyR/releases"
  )
  
  rtweet::post_tweet(
    status = tweet,
    media = release$detail_img,
    media_alt_text = release$details,
    token = hockeyr_token
  )
  
  # save most recent release
  release$release |> saveRDS("last_release.rds")
}
