#' Extract page, sheet, color information from a PDF
#'
#' @param opts_detect list of parameters for [detect_color()]
#' @param force_color if not NULL, a vector of page numbers to be printed in color
#' @param force_BW if not NULL, a vector of page numbers to be printed in B&W
#' @return a tibble with columns:
#' - page: page number
#' - sheet: sheet number
#' - side: "front" or "back"
#' - img: a magick image
#' - is_color_page: TRUE if the page is in color
#' @inheritParams render_page
#' @inheritParams enumerate_pages
#' @export
#' @examples
#'
#' f <- example_pdf()
#' f %>%
#'    tidy_pdf_pages(double_sided = TRUE)
#'
#' f %>%
#'    tidy_pdf_pages(double_sided = TRUE, force_color = c(1, 2, 5))
#'
tidy_pdf_pages <- function(
   pdf, double_sided, density = NULL,
                           opts_detect = list(),
                           force_color = NULL,
                           force_BW = NULL) {

   df_pages <- enumerate_pages(
      pdf = pdf,
      double_sided = double_sided
   )

   withr::with_options(
      list(warn = -1), {
         force_color_int <- unique(as.integer(force_color))
         force_BW_int <- unique(as.integer(force_BW))

      }
   )

   stopifnot(
      is.null(force_color) | all(!is.na(force_color_int)) & all(force_color_int %in% df_pages$page)
   )
   stopifnot(
      is.null(force_BW) | all(!is.na(force_BW_int)) & all(force_BW_int %in% df_pages$page)
   )
   if (length(intersect(force_BW_int, force_color_int)) > 0) {
      s_int <- paste(intersect(force_BW_int, force_color_int), collapse = ", ")
      rlang::abort(glue::glue("`force_BW` and `force_color` intersect on page(s): {s_int}"))
   }

   # Add image information
   img_magick <- render_page(
      pdf = pdf,
      pages = df_pages$page,
      density = density
   )

   df_pages <- df_pages %>%
      dplyr::mutate(
         img = as.list(img_magick)
      )

   # Detect color
   df_pages <- df_pages %>%
      dplyr::mutate(
         is_color_page_method = purrr::map_lgl(img, detect_color, !!!opts_detect)
      )

   # Color threshold
   df_pages <- df_pages %>%
      dplyr::mutate(
         is_color_page = dplyr::case_when(
            page %in% force_color_int ~ TRUE,
            page %in% force_BW_int ~ FALSE,
            TRUE ~ is_color_page_method
         )
      ) %>%
      dplyr::select(-is_color_page_method)

   df_pages
}

