
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pdfcolorsplit

<!-- badges: start -->
<!-- badges: end -->

{pdfcolorsplit} is an utility to split a PDF file into a file containing
color sheets, and a file containing B&W sheets.

This is useful when one must print a document, but the printer does not
automatically choose the ink based on the content.

## Features

-   Color detection using
    {[magick](https://cran.r-project.org/web/packages/magick/index.html)}
-   Can deal with single- and double-sided PDFs

## Installation

The package is not in CRAN yet.  
You can simply install it from this repository:

``` r
remotes::install_github("lgaborini/pdfcolorsplit")
```

## Example

Let’s prepare the [R Markdown
Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/) for printing!

``` r
## library(pdfcolorsplit)

f_pdf_local <- "assets/rmarkdown-cookbook.pdf"

df_pages <- tidy_pdf_pages(
   pdf = f_pdf_local,
   double_sided = TRUE
)
```

How many pages must be printed in color?

``` r
df_pages %>% 
   dplyr::count(is_color_page)
#> # A tibble: 2 x 2
#>   is_color_page     n
#>   <lgl>         <int>
#> 1 FALSE            76
#> 2 TRUE             13
```

How many SHEETS must be printed in color? (this is the actual printing
cost)

``` r
df_pages %>% 
   dplyr::count(is_color_sheet)
#> # A tibble: 2 x 2
#>   is_color_sheet     n
#>   <lgl>          <int>
#> 1 FALSE             73
#> 2 TRUE              16
```

Show one random color page:

``` r
df_pages %>% 
   dplyr::filter(is_color_page) %>% 
   dplyr::slice_head(n = 1) %>% 
   dplyr::pull(img)
#> [[1]]
#> # A tibble: 1 x 7
#>   format width height colorspace matte filesize density
#>   <chr>  <int>  <int> <chr>      <lgl>    <int> <chr>  
#> 1 PNG      612    792 sRGB       TRUE         0 72x72
```

Split in two parts:

``` r
# The directory that will contain the files
output_dir <- tempdir()

df_pages %>% 
   split_pdf_chunks(
      pdf = f_pdf_local,
      output_dir = output_dir
   )
```
