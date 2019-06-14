#' @export image_generator
image_generator <- function(
  target_size = c(150, 150),
  batch_size = 220,
  shuffle = FALSE,
  rescale = 1/255,
  rotation_range = 40,
  width_shift_range = 0.2,
  height_shift_range = 0.2,
  shear_range = 0.2,
  zoom_range = 0.2,
  horizontal_flip = TRUE,
  color_mode = "rgb"
) {

  train_datagen <- image_data_generator(
    rescale            = rescale,
    rotation_range     = rotation_range,
    width_shift_range  = width_shift_range,
    height_shift_range = height_shift_range,
    shear_range        = shear_range,
    zoom_range         = zoom_range,
    horizontal_flip    = TRUE
  )

  test_datagen <-
    image_data_generator(rescale = rescale)

  message("Color Modes: grayscale & rgb.")

  message("Train Generator")
  train_generator <-
    flow_images_from_directory(
      'training_folders',
      train_datagen,
      target_size = target_size,
      batch_size  = batch_size,
      class_mode  = 'categorical',
      shuffle = shuffle,
      color_mode = color_mode
    )

  message("Testing Generator")
  testing_generator <-
    flow_images_from_directory(
      'testing_folders',
      test_datagen,
      target_size = target_size,
      batch_size  = batch_size,
      class_mode  = 'categorical',
      shuffle = shuffle,
      color_mode = color_mode
    )

  list(train_gen = train_generator,
       test_gen  = testing_generator)
}
