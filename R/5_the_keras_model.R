#' @export generate_keras_model
generate_keras_model <- function(input_shape = c(150, 150, 3),
                                 n_classes = NULL,
                                 main_dropout = .2) {

  if(is.null(n_classes)) {
    stop("Supply N Class Values")
  } else {
    message('N Classes: ', n_classes)
  }
  input_tensor <- layer_input(shape = input_shape, name = 'image_input')

  output_tensor <-
    input_tensor %>%
    layer_conv_2d(filters = 32,
                  kernel_size = c(3, 3),
                  activation = 'relu',
                  strides = c(1, 1)
    ) %>%
    layer_max_pooling_2d(pool_size = c(2, 2)) %>%
    layer_conv_2d(filters = 64,
                  kernel_size = c(3, 3),
                  activation = "relu",) %>%
    layer_max_pooling_2d(pool_size = c(2, 2)) %>%
    layer_conv_2d(filters = 128,
                  kernel_size = c(3, 3),
                  activation = "relu",) %>%
    layer_max_pooling_2d(pool_size = c(2, 2)) %>%
    layer_flatten() %>%
    layer_dropout(rate = main_dropout) %>%
    layer_dense(units = 512, activation = "relu") %>%
    layer_dense(units = n_classes, activation = "softmax")

  keras_model(input_tensor, output_tensor)

}

#' @export compile_model
compile_model <- function(model,
                          num_classes = 3,
                          optimizer = NULL,
                          metrics = c("accuracy")) {
  if(num_classes == 2) {
    loss = "binary_crossentropy"
  } else {
    loss = "categorical_crossentropy"
  }

  model %>%
    compile(
      loss = loss,
      optimizer = optimizer,
      metrics = metrics
    )

  model
}
