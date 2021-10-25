#' Open a pdf, get pages as images
#'
#' Open a pdf, get pages as images.
#' Decrease the resolution to create thumbnails.
#'
#' @param pdf path
#' @return a magick image object: pages are read as frames
#' @inheritParams magick::image_read_pdf
#' @export
#' @importFrom magick image_read_pdf
#' @examples
#'
#' f <- example_pdf()
#' render_page(f, density = 20)
render_page <- function(pdf, pages = NULL, density = 72) {

   if (is.null(density)) density <- 72

   # p <- pdftools::pdf_render_page(
   #    pdf = pdf,
   #    page = page,
   #    numeric = FALSE
   # )

   i <- magick::image_read_pdf(
      path = pdf,
      pages = pages,
      density = density
   )

   i
}
