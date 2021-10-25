img <- example_pdf() %>%
   render_page()


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

test_that("get_total_saturation on the example pdf", {

   # Naive
   s <- expect_silent(img %>% get_total_saturation(thr_erode = 0, sat_threshold_low = 0, sat_threshold_high = 255))

   expect_equal(
      s > 0,
      c(
         TRUE,  # 1. color (vector)
         FALSE, # 2. B&W (vector)
         FALSE, # 3. (blank)
         FALSE, # 4. B&W (vector)
         TRUE,  # 5. color (image)
         TRUE,  # 6. B&W (image, color antialias)
         TRUE,  # 7. color (vector)
         TRUE,  # 8. color (vector)
         TRUE,  # 9. color (vector)
         FALSE  # 10. B&W  (image, true B&W)
      )
   )

   # Robust
   s <- expect_silent(img %>% get_total_saturation(thr_erode = 4, sat_threshold_low = 40, sat_threshold_high = 255))

   expect_equal(
      s > 0,
      c(
         TRUE,  # 1. color (vector)
         FALSE, # 2. B&W (vector)
         FALSE, # 3. (blank)
         FALSE, # 4. B&W (vector)
         TRUE,  # 5. color (image)
         TRUE,  # 6. B&W (image, color antialias)
         TRUE,  # 7. color (vector)
         TRUE,  # 8. color (vector)
         TRUE,  # 9. color (vector)
         FALSE  # 10. B&W  (image, true B&W)
      )
   )
})
