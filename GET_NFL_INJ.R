# ** Testing Tables -------------------------------------------------------
url= "https://www.prosportstransactions.com/football/Search/SearchResults.php?Player=&Team=&BeginDate=2015-12-08&EndDate=2023-12-11&InjuriesChkBx=yes&submit=Search"

rvest::read_html(url) |>
  #the css selector as copied from inspector in chrome
  rvest::html_elements('table') |> 
  rvest::html_table(header=1) -> test_tbl

#converting to df
#getting the interlying structure
new_df=test_tbl[[1]] 

head(new_df)

# ** Getting all the data -------------------------------------------------
get_amount = seq(from = 25, to = 5675, by = 25)

urls=paste0("https://www.prosportstransactions.com/football/Search/SearchResults.php?Player=&Team=&BeginDate=2015-12-08&EndDate=2023-12-11&InjuriesChkBx=yes&submit=Search&start=",get_amount,".htm")
urls

# Initialize an empty list to store the data frames
dat <- list()

for (i in seq_along(urls)) {
  
  # Read the webpage
  webpage <- rvest::read_html(urls[i])
  
  # Extract the table
  table_info <- rvest::html_nodes(webpage, 'table') |> 
    rvest::html_table(header=1) |> 
    purrr::pluck(1) |> 
    janitor::clean_names()
  
  dat[[i]] <- table_info
}

# Combine all data frames into one
dat <- dplyr::bind_rows(dat)

tail(dat)

# ** Combining first obs with rest ----------------------------------------

injury_data= rbind(new_df,dat)

write.csv(injury_data, "NFL_INJ_data.csv")


