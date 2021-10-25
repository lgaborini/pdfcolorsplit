#' Split a PDF to a color PDF and a B&W PDF
#'
#' @param df_sheets tidy sheet dataframe, as returned by `[tidy_pdf_pages()]`
#' @param pdf input PDF to split
#' @param filename_output a template for the output PDF files
#' @param output_dir if not NULL, the directory that will contain the PDFs
#'
#' @return paths to color-separated PDFs
#' @export
#'
#' @examples
#'
#' f <- example_pdf()
#'
#' # Get sheet/color information
#' df_sheets <- f %>%
#'    tidy_pdf_pages(double_sided = TRUE)
#'
#' # Output files here
#' dir_temp <- tempdir()
#'
#' # Split
#' f_split <- df_sheets %>%
#'    split_pdf_chunks(
#'       pdf = f,
#'       output_dir = dir_temp
#'    )
#'
#' print(f_split)
#' \dontrun{
#' fs::file_show(dir_temp)
#' }
#'
split_pdf_chunks <- function(df_sheets, pdf, filename_output = "{output_dir}/{filename}_{color}.pdf", output_dir = NULL) {

   stopifnot(is.data.frame(df_sheets))
   stopifnot(all(c("page", "is_color_page") %in% colnames(df_sheets)))

   # Retrieve chunks
   # A chunk is a set of sheets that must be all printed in color or B&W.

   df_chunks <- group_sheets_chunks(df_sheets)

   # Summarize chunks with page and color information
   # One row per chunk
   df_chunk_summary <- df_chunks %>%
      dplyr::group_by(chunk) %>%
      dplyr::summarize(
         page_start = min(page),
         page_end = max(page),
         n_sheets = dplyr::n(),
         is_color_sheet = unique(is_color_sheet)
      )

   # Merge all color (B&W) chunks
   # and retrieve all pages in the merged chunk
   df_pdf_split <- df_chunk_summary %>%
      dplyr::arrange(is_color_sheet) %>%
      dplyr::group_by(is_color_sheet) %>%
      dplyr::mutate(
         pages = purrr::map2(page_start, page_end, ~ seq(from = .x, to = .y, by = 1))
      ) %>%
      dplyr::summarise(
         n_sheets = sum(n_sheets),
         pages_all = list(unlist(pages))
      ) %>%
      dplyr::mutate(
         color = dplyr::if_else(is_color_sheet, "color", "bw")
      )

   # Safety check: no pages are lost
   stopifnot(
      setequal(unlist(df_pdf_split$pages_all), df_sheets$page)
   )

   # Build output file -------------------------------------------------------

   if (!fs::is_file(pdf)) {
      rlang::abort(glue::glue("File {pdf} is not a .pdf file."))
   }

   # these variables can be read into glue
   if (is.null(output_dir)) {
      output_dir <- fs::path_norm(pdf) %>%
         fs::path_dir()
   }

   filename <- fs::path_file(pdf) %>%
      fs::path_ext_remove()

   df_pdf_split_file <- df_pdf_split %>%
      dplyr::mutate(
         output_file = glue::glue(filename_output) %>%
            fs::path_ext_set(".pdf")
      )

   # df_pdf_split_file %>%
   #    dplyr::pull(output_file)


   # Split -------------------------------------------------------------------

   paths_output <- with(df_pdf_split_file,
        purrr::map2(
           pages_all,
           output_file,
           pdftools::pdf_subset,
           input = pdf
        )
   )

   paths_output
}
