#' @export list_train_files
list_train_files <- function() {

  # Grab the csv which contains file descriptions
  train_description = read_csv(
    file.path(
      'data', 'train.csv'
    )
  ) %>%
    rename_all(str_to_lower) %>%
    select(id, image) %>%
    arrange(id, image)

  # Get list of train file images
  train_files = list.files(
    file.path(
      'data', 'train'
    )
  )

  list(train_description, train_files)

}

#' @export delete_folders
delete_folders <- function(delete = TRUE) {
  if(delete) {
    unlink('testing_folders', recursive = TRUE, force = FALSE)
    unlink('training_folders', recursive = TRUE, force = FALSE)
  }
}

#' @export create_training_folders
create_training_folders <- function(image_description, delete = TRUE) {

  if(delete) {
    delete_folders()
  }

  if(!dir.exists('training_folders')){
    dir.create('training_folders')
  }

  if(!dir.exists('testing_folders')){
    dir.create('testing_folders')
  }
  unique_whales <-
    unique(image_description$id)

  map(
    unique_whales,
    function(x) {
      dir.create(
        file.path( 'training_folders', x),
        showWarnings = FALSE
      )
      dir.create(
        file.path( 'testing_folders', x),
        showWarnings = FALSE
      )
    }
  ) %>% invisible()
}

#' @export select_image_subset
select_image_subset <- function(image_description,
                                type = 'known_and_has',
                                has_at_least = 5,
                                new_whale = FALSE,
                                only_pick_n_pairs = 10,
                                has_no_more_than  = 10,
                                row_number_max    = 1e3) {

  message('\nType choices: \n', 'known_and_has_two \nall')
  image_description <-
    image_description %>%
    group_by(id) %>%
    mutate(n = n(),
           num = row_number())

  if( type == 'known_and_has_two' ) {
    image_description <-
      image_description %>%
      group_by(id) %>%
      mutate(n = n(),
             num = row_number()) %>%
      filter(n  >= has_at_least,
             n  <= has_no_more_than)
  } else if ( type == 'all') {
    image_description
  } else {
    stop('No image type specified')
  }

  if(!new_whale) {
    message('\nRemoving new_whale')
    image_description <-
      image_description %>%
      filter(
        id != 'new_whale'
      )
  }

  make_sample_smaller <-
    image_description %>%
    pull(id) %>%
    unique %>%
    .[1:only_pick_n_pairs]

  image_description %>%
    filter(id %in% make_sample_smaller,
           num <= row_number_max)

}

#' @export copy_images_to_training_folders
copy_images_to_training_folders <- function(image_description,
                                            split = .8,
                                            random_images = FALSE,
                                            n_to_move = 1) {



  n_description_files <- nrow(image_description)

  if(random_images) {
    message("Ignoring n_to_move.")
    split_bool = sample(x = c(TRUE, FALSE),
                        size = n_description_files,
                        replace = TRUE,
                        prob = c(split, 1 - split))

  } else {
    message("\nIgnoring split ratio.")
    split_bool <-
      image_description %>%
      mutate(split_bool = !num <= n_to_move ) %>%
      pull(split_bool)

  }

  image_pathway <-
    image_description %>%
    ungroup %>%
    mutate(
      train = split_bool,
      file_origin = file.path('data', 'train', image),
      file_destination = case_when(
        train ~ file.path('training_folders', id, image),
        TRUE  ~ file.path('testing_folders', id, image)
      )
    )


  file.copy(
    image_pathway$file_origin,
    image_pathway$file_destination,
    overwrite = FALSE
  ) %>% invisible()

}

#' @export remove_empty_folders
remove_empty_folders <- function() {

  all_dirs <-
    c('training_folders', 'testing_folders') %>%
    map(
      function(x) {
        dirs = list.dirs(x)
        dirs
      }
    )

  n_files <- all_dirs %>%
    map(
      function(x) {
        map_lgl(x, function(x) 0 == n_distinct(list.files(x)))
      }
    )

  map2(
    all_dirs,
    n_files,
    function(x, y) {
      unlink(x[y], recursive=TRUE)
    }
  ) %>% invisible()
}

#' @export display_files
display_files <- function(print_first_n = 10) {

  training_folders_images <- list.files('training_folders/') %>%
    head(print_first_n) %>%
    sample

  testing_folders_images  <- list.files('testing_folders/') %>%
    head(print_first_n) %>%
    sample

  list_images <- function(x, train = TRUE) {
    if(train) {
      is_train <- 'training_folders'
    } else {
      is_train <- 'testing_folders'
    }
    x %>%
      map(function(an_image_folder) {
        file.path(is_train, an_image_folder) %>%
          list.files()
      })
  }

  message("Training Folder Images")
  training_folders_images %>%
    list_images(train = TRUE) %>%
    print

  message("Testing Folder Images")
  testing_folders_images %>%
    list_images(train = FALSE) %>%
    print

}

#' @export list_files_in_folder
list_files_in_folder <- function(folder_name) {
  map(file.path(folder_name, list.files(folder_name)), list.files)
}



