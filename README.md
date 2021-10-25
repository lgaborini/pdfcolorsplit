# pdfcolorsplit

<!-- badges: start -->
<!-- badges: end -->

{pdfcolorsplit} is an utility to split a PDF file into a file containing color sheets, and a file containing B&W sheets.

This is useful when one must print a document, but the printer does not automatically choose the ink based on the content.

## Features

- Color detection using {magick}
- Split a .
- Can deal with single- and double-sided PDFs

## Installation

The package is not in CRAN yet.
You can simply install it from this repository:

```r
remotes::install_github("lgaborini/pdfcolorsplit")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(pdfcolorsplit)
## basic example code
```

