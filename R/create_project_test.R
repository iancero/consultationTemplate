create_empty_project <- function(client, shortname,
                                 year = format(Sys.Date(), format = '%Y'),
                                 qcore_project = T){

  proj_prefix <- if (qcore_project == T) 'qcore' else NULL
  proj_name <- paste(proj_prefix, client, shortname, year, sep = '_') %>%
    stringr::str_replace_all('\\s+', '_')

  rstudioapi::initializeProject(proj_name)

  proj_name
}


create_file_structure <- function(){
  folders <- c('data', 'emails', 'meeting_notes', 'deliverables')

  for(folder in folders){
    dir.create(folder, showWarnings = T)
  }
}


create_main_rmd <- function(filename = 'main.Rmd', ...) {

  dots <- list(...)

  md_template_file <- system.file(
    'extdata',
    'markdown_template.Rmd',
    package = 'consultationTemplate',
    mustWork = TRUE)

  markdown_template <- md_template_file %>%
      readLines() %>%
      purrr::map_chr(
        .f = ~ glue::glue(.x, .envir = dots, .open = '{{{', .close = '}}}'))

  writeLines(markdown_template, filename)
}

initialize_git <- function(new_branch = NULL){
  gert::git_init()
  gert::git_add(list.files())
  gert::git_add('.gitignore')
  gert::git_commit_all('Initial Commit')

  gert::git_branch_create('main', checkout = TRUE)
  gert::git_branch_delete('master')

  if(!is.null(new_branch)){
    gert::git_branch_create(new_branch, checkout = TRUE)
  }

}

create_project_test <- function(path, client, shortname,
                                year = format(Sys.Date(), format = '%Y'),
                                qcore_project = T){

  old_wd <- getwd()
  setwd(path)
  proj_path <- create_empty_project(client, shortname, year, qcore_project)

  setwd(proj_path)
  create_file_structure()
  create_main_rmd(client = client, shortname = shortname)
  initialize_git(new_branch = 'after_meeting_1')
  renv::init() # installs tidyverse too because that's in the .Rmd template

  setwd(old_wd)
}
