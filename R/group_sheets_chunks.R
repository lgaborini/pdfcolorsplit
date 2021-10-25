#' Group sheets in contiguous chunks
#'
#' A chunk is a set of sheets that must be all printed in color or B&W.
#'
#' @param df_pages the return value of [tidy_pdf_pages()]
#' @return df_pages with the new column `chunk`
#' @export
#' @examples
#'
#' df_pages <- example_pdf() %>%
#'    tidy_pdf_pages(double_sided = TRUE)
#'
#' df_chunks <- df_pages %>%
#'    group_sheets_chunks()
#'
group_sheets_chunks <- function(df_pages) {

   stopifnot(is.data.frame(df_pages))
   stopifnot(all(
      c("is_color_sheet") %in% colnames(df_pages)
   ))

   df_chunks <- df_pages %>%
      dplyr::mutate(
         chunk = data.table::rleid(is_color_sheet)
      )

   df_chunks
}
