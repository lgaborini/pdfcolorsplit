#' An example PDF with some color and B&W pages
#'
#' Page index:
#'
#' 1. color (vector)
#' 2. B&W (vector)
#' 3. (blank)
#' 4. B&W (vector)
#' 5. color (image)
#' 6. B&W (image, color antialias)
#' 7. color (vector)
#' 8. color (vector)
#' 9. color (vector)
#' 10. B&W  (image, true B&W)
#'
#' @return path to a PDF file
#' @md
#' @examples
#' example_pdf()
example_pdf <- function(){
   system.file("data/test_pdf.pdf", package = "pdfcolorsplit")
}
