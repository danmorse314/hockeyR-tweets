scrape_latest_release <- function(pkg_author, pkg_name, filename = "pkg_release.png"){
  
  # requires:
  # install.packages("webshot")
  # webshot::install_phantomjs()
  
  url <- paste0("https://github.com/",pkg_author,"/",pkg_name,"/releases")
  
  # get release title
  latest_release <- rvest::read_html(url) |>
    rvest::html_element(".col-md-9") |>
    rvest::html_element(".flex-1") |>
    rvest::html_element("h1") |>
    rvest::html_text2()
  
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
  
  message(paste0(latest_release, " package release notes saved as ",filename))
  return(latest_release)
}
