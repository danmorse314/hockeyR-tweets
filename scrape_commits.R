scrape_commits <- function(user = NULL, repo = NULL, branch = "main"){
  
  # generate commits url
  url <- paste0("https://github.com/",user,"/",repo,"/commits/",branch)
  
  # get to the commits
  site <- rvest::read_html(url) |>
    rvest::html_elements(".TimelineItem-body") |>
    rvest::html_elements("ol") |>
    rvest::html_elements("li") |>
    rvest::html_elements("div")
  
  # get commit author
  authors <- dplyr::tibble(
    author = site |>
      rvest::html_elements("div") |>
      rvest::html_elements("div") |>
      rvest::html_elements("div") |>
      rvest::html_attr("aria-label")
  ) |>
    dplyr::filter(!is.na(author))
  
  # get date times
  times <- dplyr::tibble(
    datetime = site |>
      rvest::html_elements("div") |>
      rvest::html_elements("relative-time") |>
      rvest::html_attr("datetime")
  ) |>
    dplyr::mutate(
      datetime = lubridate::with_tz(lubridate::as_datetime(datetime),"US/Pacific"),
      date = format(datetime, "%Y-%m-%d"),
      time = format(datetime, "%I:%M %p")
    )
  
  # get commit links
  links <- dplyr::tibble(
    # link to commit
    link = paste0(
      "https://github.com",
      site |>
        rvest::html_elements("p") |>
        rvest::html_elements("a") |>
        rvest::html_attr("href")
    ),
    # commit code
    commit = substr(sub(".*commit/", "", link), 1, 7)
  ) |>
    dplyr::filter(stringr::str_detect(link, paste0(user,"/",repo,"/commit/"))) |>
    dplyr::distinct()
  
  # get commit info and bind
  df <- dplyr::tibble(
    # commit messages
    summary = site |>
      rvest::html_elements("p") |>
      rvest::html_text2()
  ) |>
    dplyr::mutate(
      owner = user,
      repo = repo
    ) |>
    dplyr::bind_cols(links, times, authors) |>
    dplyr::select(owner, repo, author, dplyr::everything())
  
  return(df)
}