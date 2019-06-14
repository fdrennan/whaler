
library(whaler)

FLAGS <- flags(
  flag_numeric("n_photo_min", 10),
  flag_numeric("n_photo_max", 40),
  flag_numeric('row_number_max', 20),
  flag_numeric("n_to_move",    3),
  flag_numeric("batch_size",   2),
  flag_numeric("epochs",       5),
  flag_numeric('main_dropout', .2),
  flag_numeric('learning_rate', 1e-4),
  flag_numeric('only_pick_n_pairs', 5),
  flag_numeric('patience', 5),
  flag_string('monitor', 'val_loss'),
  flag_string('mode', 'auto'),
  flag_boolean('reaggregate_data', TRUE),
  flag_boolean('display_image', TRUE),
  flag_boolean('run_model', TRUE),
  flag_numeric('rescale', 1/255),
  flag_numeric('rotation_range', 0),
  flag_numeric('width_shift_range', 0),
  flag_numeric('height_shift_range', 0),
  flag_numeric('shear_range', 0),
  flag_numeric('zoom_range', 0),
  flag_boolean('horizontal_flip', TRUE),
  flag_string('color_mode', "rgb"),
  flag_numeric('image_nrow', 150)
)

# system('top -l 1 -s 0 | grep PhysMem')

if(FLAGS$reaggregate_data) {
  message('Aggregating data\n')
  data_processor(how_subset = 'known_and_has_two',
                 seed = 1,
                 delete = TRUE,
                 new_whale = FALSE,
                 random_images = FALSE,
                 n_to_move = FLAGS$n_to_move,    # If random_images = FALSE
                 split_ratio = .5, # else random_images = TRUE
                 print_first_n = 5,
                 only_pick_n_pairs = FLAGS$only_pick_n_pairs,
                 has_at_least = FLAGS$n_photo_min,
                 has_no_more_than = FLAGS$n_photo_max,
                 row_number_max = FLAGS$row_number_max)

}

if(FLAGS$run_model) {
  image_nrow = FLAGS$image_nrow
  target_image_shape = c(image_nrow, image_nrow, 3)

  c(train_gen, test_gen) %<-%
    image_generator(

      # COMMON CHANGES
      batch_size     = FLAGS$batch_size,


      # Image Meta
      target_size        =  c(image_nrow, image_nrow),
      shuffle            = FALSE,
      # Image Augmentation
      rescale            = FLAGS$rescale,
      rotation_range     = FLAGS$rotation_range,
      width_shift_range  = FLAGS$width_shift_range,
      height_shift_range = FLAGS$height_shift_range,
      shear_range        = FLAGS$shear_range,
      zoom_range         = FLAGS$zoom_range,
      horizontal_flip    = FLAGS$horizontal_flip,
      color_mode         = FLAGS$color_mode
    )

  if(FLAGS$display_image) {
    display_image(train_gen,
                  image_n = 1)
  }

  model <-
    generate_keras_model(
      input_shape  = target_image_shape,
      n_classes    = train_gen$num_classes,
      main_dropout = FLAGS$main_dropout
    )


  callbacks <-
    list(
      callback_early_stopping(monitor = FLAGS$monitor,
                              min_delta = 0,
                              patience = FLAGS$patience,
                              verbose = 1,
                              mode = FLAGS$mode,
                              restore_best_weights = FALSE)
    )
  # ReduceLROnPlateau())

  compiled_model <-
    compile_model(model,
                  num_classes = train_gen$num_classes,
                  optimizer = optimizer_adam(lr = FLAGS$learning_rate),
                  metrics = c("accuracy"))

  system('top -l 1 -s 0 | grep PhysMem')

  history <-
    compiled_model %>%
    fit_generator(
      generator = train_gen,
      steps_per_epoch = trunc(train_gen$samples/train_gen$batch_size),
      epochs = FLAGS$epochs,
      validation_data = test_gen,
      validation_steps = trunc(test_gen$samples/test_gen$batch_size),
      max_queue_size = 10,
      workers = 1,
      initial_epoch = 0,
      callbacks = callbacks
    )

}
system('top -l 1 -s 0 | grep PhysMem')




