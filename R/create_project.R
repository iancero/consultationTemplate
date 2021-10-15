#' This package will create a function called create_project()
#'
#' It's callback is at: inst/rstudio/templates/project/create_project.dcf
#'
#' @export
create_project <- function(path, ...) {

  # Create the project path given the name chosen by the user:
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  # Change the working directory to the recently created folder:
  setwd(file.path(getwd(), path))

  # Collect the list of inputs in a list to be called later:
  dots <- list(...)


  # # In the project template we've added 2 choices for the user:
  # # * One allows them to select if the project will have a .gitignore file
  # # * The other will create a folder, given a select input from the user
  # # Check .gitignore argument
  # if(dots[['createGitignore']]) {
  #   git_ignores <-
  #     c(
  #       '.Rhistory',
  #       '.Rapp.history',
  #       '.RData',
  #       '.Ruserdata',
  #       '.Rproj.user/',
  #       '.Renviron'
  #     )
  #   writeLines(paste(git_ignores, sep = '\n'), '.gitignore')
  # }

  # create project file structure
  folders <- c('data', 'emails', 'meeting_notes', 'deliverables')
  for(folder in folders){
    dir.create(folder, recursive = T, showWarnings = F)
  }


  # do something with this?
  author <- dots[['author']]


  # create and open an empty template on startup
  md_template_file <- system.file(
    'extdata',
    'markdown_template.Rmd',
    package = 'consultationTemplate',
    mustWork = TRUE)

  markdown_template <- md_template_file %>%
    readLines() %>%
    glue::glue()

  writeLines(markdown_template, 'main.Rmd')

}
