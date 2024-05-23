library(tidyverse)
library(googlesheets4)

quizzes_names <- sheet_names("https://docs.google.com/spreadsheets/d/1lNWFJAZ5xOgqRxNUL2CjzTp5K7ErveR9BYF7CZCUXlo/edit?usp=sharing") %>% 
  str_extract("^quiz\\d+") %>% na.omit() %>% as.vector()
quizzes <- list()

# read_sheet(ss = "https://docs.google.com/spreadsheets/d/1lNWFJAZ5xOgqRxNUL2CjzTp5K7ErveR9BYF7CZCUXlo/edit?usp=sharing",
#            sheet = "tags",
#            col_types = "c",
#            skip = 1) -> tags

for (quiz_name in quizzes_names) {
  read_sheet(ss = "https://docs.google.com/spreadsheets/d/1lNWFJAZ5xOgqRxNUL2CjzTp5K7ErveR9BYF7CZCUXlo/edit?usp=sharing",
             sheet = quiz_name,
             col_types = "c",
             skip = 2) -> quizzes[[quiz_name]]
}


get_json <- function(quiz_name, 
                     quizzes, tags = NULL) {
  quizzes[[quiz_name]] %>% 
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    mutate(
      across(matches("^option\\d_correct$"), tolower)
    ) %>% 
    # mutate(
    #   across(matches("ques|^option\\d_label$|^feedback_\\.+correct$"),
    #          function(x) {x %>% str_replace_all(setNames(tags$replacement, tags$pattern))})
    # ) %>% 
    mutate(# text = ques,
           qn = paste0("q", n)) %>% 
    # mutate(text = paste0(n, ". ", ques),
    #        qn = paste0("q", n)) %>% 
    pivot_longer(cols = -qn) %>% 
    pivot_wider(names_from = qn,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows") %>%
    paste0("quiz_json='", ., "'", 
           "\nquiz='", quiz_name, "'") %>% 
    write(paste0(
      "book/", 
      "js/", 
      quiz_name, 
      ".json"))
}

# quizzes_names %>% map(get_json, quizzes = quizzes, tags = tags)
quizzes_names %>% map(get_json, quizzes = quizzes)

