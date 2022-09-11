README
================
Dan Morse

## hockeyR tweets

This is the brain of
[`hockeyR`](https://github.com/danmorse314/hockeyR)’s very own [twitter
account](https://twitter.com/hockeyR_). THe bulk of this account’s
tweets are automated to post the latest commits to any of the `hockeyR`
GitHub repositories:

-   [`hockeyR`](https://github.com/danmorse314/hockeyR)
-   [`hockeyR-data`](https://github.com/danmorse314/hockeyR-data)
-   [`hockeyR-models`](https://github.com/danmorse314/hockeyR-models)

The commits are scraped using the
[`scrape commits`](https://github.com/danmorse314/hockeyR-tweets/blob/main/scrape_commits.R)
function. This hasn’t been widely tested on other repositories, so use
with caution, but in general it does the job of scraping all commits to
a given repository and returns info including author, date, commit
message, and commit ID.

``` r
source("scrape_commits.R")

hockeyr_commits <- scrape_commits(user = "danmorse314", repo = "hockeyR", branch = "master")

str(hockeyr_commits)
```

    ## tibble [35 x 9] (S3: tbl_df/tbl/data.frame)
    ##  $ owner   : chr [1:35] "danmorse314" "danmorse314" "danmorse314" "danmorse314" ...
    ##  $ repo    : chr [1:35] "hockeyR" "hockeyR" "hockeyR" "hockeyR" ...
    ##  $ author  : chr [1:35] "danmorse314" "danmorse314" "danmorse314" "danmorse314" ...
    ##  $ summary : chr [1:35] "Updated get_game_ids function to include game start time in the output" "removed \"add xg\" to future work because it's done :party-parrot:" "updated xg example" "xg update" ...
    ##  $ link    : chr [1:35] "https://github.com/danmorse314/hockeyR/commit/644dc83e1c076ef21349b3952b5f4f89d9bd1513" "https://github.com/danmorse314/hockeyR/commit/f3c6c9f7a0fb8f0be9d5d313e2624e18c4b6819c" "https://github.com/danmorse314/hockeyR/commit/ef00ed22f58860e4ce29118a8a29ab9f3df5477d" "https://github.com/danmorse314/hockeyR/commit/0fba96291bec8150629b76536691f8d3372779ba" ...
    ##  $ commit  : chr [1:35] "644dc83" "f3c6c9f" "ef00ed2" "0fba962" ...
    ##  $ datetime: POSIXct[1:35], format: "2022-09-11 15:12:04" "2022-09-06 15:53:29" ...
    ##  $ date    : chr [1:35] "2022-09-11" "2022-09-06" "2022-09-06" "2022-09-06" ...
    ##  $ time    : chr [1:35] "03:12 PM" "03:53 PM" "03:27 PM" "02:54 PM" ...

Follow [@hockeyR\_](https://twitter.com/hockeyR_) on Twitter to stay up
to date with the latest updates, bug fixes, and releases to the
`hockeyR` package!
