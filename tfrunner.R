library(whaler)

list_files_in_folder('training_folders')

flags <-
  list(
    run_model = TRUE,

    # Data Parameters
    reaggregate_data = FALSE,
    n_photo_min  = 15,
    n_photo_max  = 100,
    row_number_max = 20,
    only_pick_n_pairs = 20,
    n_to_move    =  5,

    display_image = FALSE,

    # Image Generator Data
    batch_size   =  5,
    image_nrow   = 150,
    rescale      = 1/255,
    rotation_range     = 0,
    width_shift_range  = 0,
    height_shift_range = 0,
    shear_range = 0,
    zoom_range  = 0,
    horizontal_flip = FALSE,
    color_mode  = "rgb",

    # Callback Paramters
    patience = 5,
    monitor = 'val_loss',
    mode = 'auto',

    # Model Paramters
    epochs       =  25,
    main_dropout = 0,
    learning_rate = 1e-4
  )

# training_run(
#   file ="data_script.R",
#   flags = flags
# )
system('top -l 1 -s 0 | grep PhysMem')
tuning_run(
  file = "data_script.R",
  flags =
    list(
      run_model = TRUE,

      # Data Parameters
      reaggregate_data = FALSE,
      n_photo_min  = 15,
      n_photo_max  = 100,
      row_number_max = 20,
      only_pick_n_pairs = 20,
      n_to_move    =  5,

      display_image = FALSE,

      # Image Generator Data
      batch_size   =  5,
      image_nrow   = c(400),
      rescale      = 1/255,
      rotation_range     = 0,
      width_shift_range  = 0,
      height_shift_range = 0,
      shear_range = 0,
      zoom_range  = 0,
      horizontal_flip = FALSE,
      color_mode  = "rgb",

      # Callback Paramters
      patience = 30,
      monitor = 'val_loss',
      mode = 'auto',

      # Model Paramters
      epochs       =  50,
      main_dropout = 0,
      learning_rate = c(1e-3)
    )
)

# system('top -l 1 -s 0 | grep PhysMem')
# k_clear_session()
# compare_runs()
# clean_runs(ls_runs(completed == TRUE))
