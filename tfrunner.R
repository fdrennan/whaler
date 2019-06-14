library(whaler)

list_files_in_folder('training_folders')

# flags <-
#   list(
#     run_model = TRUE,
#
#     # Data Parameters
#     reaggregate_data = FALSE,
#     n_photo_min  = 15,
#     n_photo_max  = 100,
#     row_number_max = 20,
#     only_pick_n_pairs = 20,
#     n_to_move    =  5,
#
#     display_image = FALSE,
#
#     # Image Generator Data
#     batch_size   =  5,
#     image_nrow   = 150,
#     rescale      = 1/255,
#     rotation_range     = 0,
#     width_shift_range  = 0,
#     height_shift_range = 0,
#     shear_range = 0,
#     zoom_range  = 0,
#     horizontal_flip = FALSE,
#     color_mode  = "rgb",
#
#     # Callback Paramters
#     patience = 5,
#     monitor = 'val_loss',
#     mode = 'auto',
#
#     # Model Paramters
#     epochs       =  25,
#     main_dropout = 0,
#     learning_rate = 1e-4
#   )

# training_run(
#   file ="data_script.R",
#   flags = flags
# )
system('top -l 1 -s 0 | grep PhysMem')
runs <- tuning_run(
  file = "data_script.R",
  flags =
    list(
      run_model = TRUE,

      # Data Parameters
      reaggregate_data = TRUE,
      n_photo_min  = 10,
      n_photo_max  = 100,
      row_number_max = 10,
      only_pick_n_pairs = 10,
      n_to_move    =  5,

      display_image = FALSE,

      # Image Generator Data
      batch_size   =  5,
      image_nrow   = 200, # analyses
      rescale      = 1/255,
      rotation_range     = 0.2,
      width_shift_range  = 0,
      height_shift_range =  .1,
      shear_range =  0,
      zoom_range  =  0,
      horizontal_flip = TRUE, # .72 to .76
      color_mode  = "rgb",

      # Callback Paramters
      patience = 10,
      monitor = 'val_loss',
      mode = 'auto',

      # Model Paramters
      epochs       =  40,
      main_dropout = 0,
      learning_rate = c(1e-4)
    )
)

# system('top -l 1 -s 0 | grep PhysMem')
# k_clear_session()
# compare_runs()
# clean_runs(ls_runs(completed == TRUE))
