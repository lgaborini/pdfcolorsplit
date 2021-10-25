# Functions to check whether one image is in color or B&W


#' Detect if one image is in color or B&W
#'
#' @return a logical vector, as many frames as `img`
#' @export
#' @inheritParams get_total_saturation
#' @inheritDotParams get_total_saturation
#' @examples
#'
#' img <- magick::wizard()
#'
#' detect_color(img)
#'
#' # The saturated areas
#' magick::wizard() %>% extract_saturation()
#'
detect_color <- function(img, ...) {

   n_img <- length(img)

   list_img <- as.list(img)

   total_saturation <- purrr::map_dbl(list_img, get_total_saturation, ...)
   color_threshold(total_saturation)
}

color_threshold <- function(x) {
   x > 0
}
