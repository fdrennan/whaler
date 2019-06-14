#' @export data_processor
data_processor <- function(how_subset = 'known_and_has_two',
                           seed = 1,
                           delete = TRUE,
                           split_ratio = .8,
                           random_images = FALSE,
                           print_first_n = 5,
                           n_to_move = 3,
                           new_whale = FALSE,
                           only_pick_n_pairs = 5,
                           has_at_least = 10,
                           has_no_more_than = 10,
                           row_number_max = 1e3) {
  set.seed(seed)

  c(image_description, image_files) %<-% list_train_files()

  image_description <-
    select_image_subset(image_description,
                        type = how_subset,
                        new_whale = new_whale,
                        only_pick_n_pairs = only_pick_n_pairs,
                        has_at_least = has_at_least,
                        has_no_more_than = has_no_more_than,
                        row_number_max = row_number_max)

  create_training_folders(image_description,
                          delete = delete)

  copy_images_to_training_folders(image_description = image_description,
                                  split = split_ratio,
                                  random_images = random_images,
                                  n_to_move = n_to_move)

  display_files(print_first_n = print_first_n)


  message("Removing empty folders.")

  remove_empty_folders()


}
