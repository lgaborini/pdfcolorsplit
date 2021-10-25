#' Summarize saturation values from an image
#'
#' Steps:
#'
#' - extract the saturation channel using [extract_saturation()]
#' - apply a morphological erosion if asked
#' - round saturation values when too low/high
#' - sum all values in each image
#'
#' @param img a `magic-image` as returned by `[render_page()]`
#' @param sat_threshold_low pixels with saturation lower than this value (from 0 to 255) will be clipped to 0
#' @param sat_threshold_high pixels with saturation higher than this value (from 0 to 255) will be clipped to 255
#' @param thr_erode morphologically erode the saturation before thresholding with a square kernel of side `thr_erode`
#' @return a numeric vector with the same length as `img`
#' @importFrom magick image_convert image_channel image_data
#' @importFrom purrr map map_dbl
#' @export
#'
#' @examples
#' example_pdf() %>%
#'    render_page() %>%
#'    get_total_saturation()
#'
get_total_saturation <- function(img, sat_threshold_low = 5, sat_threshold_high = 255, thr_erode = 0) {

   n_img <- length(img)

   # extract the saturation channel
   # one frame per page
   img_sat <- img %>%
      extract_saturation()

   # apply morphological erosion
   if (thr_erode > 0) {
      img_sat_morpho <- magick::image_morphology(
         image = img_sat,
         method = "Erode",
         kernel = paste0("Square:", as.integer(thr_erode))
      )
   } else {
      img_sat_morpho <- img_sat
   }

   # convert frames to list of images
   list_mtx <- as.list(img_sat_morpho) %>%
      as.list() %>%
      purrr::map(~ as.integer(magick::image_data(.x)))

   list_mtx_clip <- list_mtx %>%
      purrr::map(
         clip_vector,
         thr_low = sat_threshold_low,
         thr_high = sat_threshold_high
      )

   total_saturation <- list_mtx_clip %>%
      purrr::map_dbl(sum)

   stopifnot(length(total_saturation) == n_img)

   total_saturation
}

#' Extract the saturation channel
extract_saturation <- function(img) {

   # extract the saturation channel
   # one frame per page
   img_sat <- magick::image_convert(
         image = img,
         format = "rgb",
         colorspace = "HSV",
         antialias = FALSE
      ) %>%
      magick::image_channel("Saturation")

   img_sat
}

#' Clip a vector from [a,b] to [0,1]
clip_vector <- function(m, thr_low = 0, thr_high = 255, val_low = 0, val_high = 255) {
   m_clip <- m
   m_clip[m < thr_low] <- val_low
   m_clip[m > thr_high] <- val_high
   m_clip
}
