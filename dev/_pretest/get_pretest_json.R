library(tidyverse)
library(googlesheets4)

pretests_names <- sheet_names("https://docs.google.com/spreadsheets/d/1U_2m7pDCGfm8hExOSTJQ1B53-_LFAy2bYoFEIcVY-8w/edit?usp=sharing") %>% 
  str_extract("^pretest\\d+") %>% na.omit() %>% as.vector()
pretests <- list()

# read_sheet(ss = "https://docs.google.com/spreadsheets/d/1U_2m7pDCGfm8hExOSTJQ1B53-_LFAy2bYoFEIcVY-8w/edit?usp=sharing",
#            sheet = "tags",
#            col_types = "c",
#            skip = 1) -> tags

read_sheet(ss = "https://docs.google.com/spreadsheets/d/1U_2m7pDCGfm8hExOSTJQ1B53-_LFAy2bYoFEIcVY-8w/edit?usp=sharing",
           sheet = "order",
           col_types = "c") %>% 
  select(pretest, number) -> pretest_order

for (pretest_name in pretests_names) {
  read_sheet(ss = "https://docs.google.com/spreadsheets/d/1U_2m7pDCGfm8hExOSTJQ1B53-_LFAy2bYoFEIcVY-8w/edit?usp=sharing",
             sheet = pretest_name,
             col_types = "c",
             skip = 2) -> pretests[[pretest_name]]
}


get_json <- function(pretest_name, 
                     pretests, tags = NULL) {
  pretests[[pretest_name]] %>% 
    select(n, level, type, option1_correct, option2_correct, option3_correct, option4_correct) %>% 
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
    paste0("pretest_json='", ., "'", 
           "\npretest='", 
           paste0(" ", pretest_order %>% filter(pretest == pretest_name) %>% pull(number)),
           "'") %>% 
    write(paste0(
      #"book/", 
      "js/", 
      pretest_name, 
      ".json"))
}

# quizzes_names %>% map(get_json, quizzes = quizzes, tags = tags)
pretests_names %>% map(get_json, pretests = pretests)

