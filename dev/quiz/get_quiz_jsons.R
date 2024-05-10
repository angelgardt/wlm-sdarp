library(tidyverse)
library(googlesheets4)

quizes_names <- sheet_names("https://docs.google.com/spreadsheets/d/1lNWFJAZ5xOgqRxNUL2CjzTp5K7ErveR9BYF7CZCUXlo/edit?usp=sharing")
quizes <- list()

for (quiz_name in quizes_names) {
  read_sheet(ss = "https://docs.google.com/spreadsheets/d/1lNWFJAZ5xOgqRxNUL2CjzTp5K7ErveR9BYF7CZCUXlo/edit?usp=sharing",
             sheet = quiz_name,
             col_types = "c",
             skip = 2) -> quizes[[quiz_name]]
}


quizes[[1]] %>% 
  mutate(
    across(everything(), ~replace_na(.x, ""))
  ) %>% 
  mutate(
    across(matches("^option\\d_correct$"), tolower)
  ) %>% 
  mutate(text = paste0(n, ". ", ques),
         qn = paste0("q", n)) %>% 
  pivot_longer(cols = -qn) %>% 
  pivot_wider(names_from = qn,
              values_from = value) %>% 
  jsonlite::toJSON(dataframe = "rows") %>%
  paste0("quiz_json='", ., "'", 
         "\nquiz='quiz1'") %>% 
  write(paste0("js/", "quiz1", ".json"))




get_json <- function(hwn, hws_table) {
  hws_table %>% 
    filter(hw == hwn) %>%
    mutate(
      across(everything(), ~replace_na(.x, ""))
    ) %>% 
    select(-hw, -n) %>%
    pivot_longer(cols = -task) %>% 
    pivot_wider(names_from = task,
                values_from = value) %>% 
    jsonlite::toJSON(dataframe = "rows") %>%
    paste0("hw_json='", ., "'", 
           "\nN_TASKS=15",
           "\nID='", hwn, "'") %>% 
    write(paste0("js/", hwn, ".json"))
}

unique(hws_table$hw) %>% map(get_json, hws_table = hws_table)