library(tidyverse)
library(googlesheets4)

sheets_names <- sheet_names("https://docs.google.com/spreadsheets/d/1v9XWnb7DfJawpn4FOV2SxSy3nmBIG4t_7OK3OIeS6WE/edit?usp=sharing") %>% 
  str_extract("^sheet\\d+") %>% na.omit() %>% as.vector()
sheets <- list()

# read_sheet(ss = "https://docs.google.com/spreadsheets/d/1lNWFJAZ5xOgqRxNUL2CjzTp5K7ErveR9BYF7CZCUXlo/edit?usp=sharing",
#            sheet = "tags",
#            col_types = "c",
#            skip = 1) -> tags

for (sheet_name in sheets_names) {
  read_sheet(ss = "https://docs.google.com/spreadsheets/d/1v9XWnb7DfJawpn4FOV2SxSy3nmBIG4t_7OK3OIeS6WE/edit?usp=sharing",
             sheet = sheet_name,
             col_types = "c",
             skip = 2) -> sheets[[sheet_name]]
}


get_json <- function(sheet_name, 
                     sheets, tags = NULL) {
  sheets[[sheet_name]] %>% 
    select(n, level, has_autocheck, autocheck_answer) %>% 
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    mutate(has_autocheck = tolower(has_autocheck),
           autocheck_answer = str_remove_all(autocheck_answer, " ")) %>% 
    # mutate(
    #   across(matches("ques|^option\\d_label$|^feedback_\\.+correct$"),
    #          function(x) {x %>% str_replace_all(setNames(tags$replacement, tags$pattern))})
    # ) %>% 
    mutate(# text = task,
           tn = paste0("t", n)) %>% 
    # mutate(text = paste0(n, ". ", ques),
    #        qn = paste0("q", n)) %>% 
    pivot_longer(cols = -tn) %>% 
    pivot_wider(names_from = tn,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows") %>%
    paste0("sheet_json='", ., "'", 
           "\nsheet='", sheet_name, "'") %>% 
    write(paste0(
      "book/", 
      "js/", 
      sheet_name, 
      ".json"))
}

# quizzes_names %>% map(get_json, quizzes = quizzes, tags = tags)
sheets_names %>% map(get_json, sheets = sheets)
