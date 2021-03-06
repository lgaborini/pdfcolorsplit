% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/render_page.R
\name{render_page}
\alias{render_page}
\title{Open a pdf, get pages as images}
\usage{
render_page(pdf, pages = NULL, density = 72)
}
\arguments{
\item{pdf}{path}

\item{pages}{integer vector with page numbers. Defaults to all pages.}

\item{density}{resolution to render pdf or svg}
}
\value{
a magick image object: pages are read as frames
}
\description{
Open a pdf, get pages as images.
Decrease the resolution to create thumbnails.
}
\examples{

f <- example_pdf()
render_page(f, density = 20)
}
