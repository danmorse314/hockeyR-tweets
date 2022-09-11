scrape_latest_release <- function(pkg_author, pkg_name, filename = "pkg_release.png"){
  
  # requires:
  # install.packages("webshot")
  webshot::install_phantomjs()
  
  url <- paste0("https://github.com/",pkg_author,"/",pkg_name,"/releases")
  
  # get release title
  release_version <- rvest::read_html(url) |>
    rvest::html_element(".col-md-9") |>
    rvest::html_element(".flex-1") |>
    rvest::html_element("h1") |>
    rvest::html_text2()
  
  # get release details
  # can be used for alt text
  release_details <- rvest::read_html(url) |>
    rvest::html_element(".markdown-body") |>
    rvest::html_text2() |>
    stringr::str_replace_all("\n",". ")
  
  # alt text can only be 420 characters
  if(nchar(release_details) > 415){ #room for error
    release_details <- paste0(substr(release_details,1,405),"...TRUNCATED")
  }
  
  # take screenshot of latest release notes
  webshot::webshot(
    url = url,
    file = filename,
    selector = "div.col-md-9",
    zoom = 2)
  
  # automatically uses transparent background, need to change to white
  release_img <- magick::image_read(filename)
  
  magick::image_background(release_img, color = "white") |>
    # remove whitespace at top
    magick::image_trim() |>
    magick::image_write(filename)
  
  message(paste0(release_version, " package release notes saved as ",filename))
  
  latest_release <- dplyr::tibble(
    release = release_version,
    details = release_details,
    detail_img = filename
  )
  
  return(latest_release)
}
