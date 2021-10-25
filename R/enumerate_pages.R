#' Enumerate pages and sheets in a pdf
#'
#' @param double_sided if TRUE, sheets are printed on the front and back
#' @inheritParams render_page
#' @return a tibble with columns:
#' - page: page number
#' - sheet: sheet number
#' - side: "front" or "back"
enumerate_pages <- function(pdf, double_sided) {

   n_pages <- pdftools::pdf_info(pdf)$pages

   df_pages <- tibble::tibble(
      page = seq(n_pages),
   )

   # Add sheet information
   if (double_sided) {
      df_pages <- df_pages %>%
         dplyr::mutate(
            side = ifelse(page %% 2 == 1, 'front', 'back'),
            sheet = as.integer(floor((page + 1) / 2))
         )
   } else {
      df_pages <- df_pages %>%
         dplyr::mutate(
            side = 'front',
            sheet = page
         )
   }

   df_pages

}
