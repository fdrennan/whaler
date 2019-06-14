#' @export display_image
display_image <- function(a_generator,
                          image_n = 1) {
  a_generator$reset()
  a_batch <- generator_next(a_generator)
  an_image <- a_batch[[1]][image_n,,,]
  n_label <- a_batch[[2]][image_n,]
  single_image <- as.cimg(an_image)
  a_generator$reset()
  plot(single_image,
       main = sum(n_label * 1:length(n_label)),
       axes = FALSE)
}
