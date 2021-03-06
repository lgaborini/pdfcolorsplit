% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/group_sheets_chunks.R
\name{group_sheets_chunks}
\alias{group_sheets_chunks}
\title{Group sheets in contiguous chunks}
\usage{
group_sheets_chunks(df_pages)
}
\arguments{
\item{df_pages}{the return value of [tidy_pdf_pages()]}
}
\value{
df_pages with the new column `chunk`
}
\description{
A chunk is a set of sheets that must be all printed in color or B&W.
}
\examples{

df_pages <- example_pdf() \%>\%
   tidy_pdf_pages(double_sided = TRUE)

df_chunks <- df_pages \%>\%
   group_sheets_chunks()

}
