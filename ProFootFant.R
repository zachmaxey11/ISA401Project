## get seasonal fantasy data all positions
#setting a string for desired seasons of stats
seasons <- seq(from = 2013, to = 2023, by = 1)
seasons

urls=paste0("https://www.pro-football-reference.com/years/", seasons, "/fantasy.htm")
urls

# Initialize an empty list to store the data frames
dat <- list()

for (i in seq_along(urls)) {
  
  # Read the webpage
  webpage <- rvest::read_html(urls[i])
  
  # Extract the table
  table_info <- rvest::html_nodes(webpage, 'table') |> 
    rvest::html_table(header=FALSE, fill=TRUE) |> 
    purrr::pluck(1) |> 
    janitor::clean_names()
  
  # Get the first two rows
  header1 <- table_info[1, ]
  header2 <- table_info[2, ]
  
  # Combine the first and second row to create new headers
  headers <- character(length(header2))
  for (j in seq_along(header2)) {
    if (!is.na(header1[j]) && header1[j] != "") {
      headers[j] <- paste(header1[j], header2[j], sep = "_")
    } else {
      headers[j] <- header2[j]
    }
  }
  
  # Remove NA and "" in headers
  headers[is.na(headers)] <- "NA"
  headers[headers == ""] <- "empty"
  
  # Apply the new headers to the table
  colnames(table_info) <- headers
  
  # Remove the first two rows
  table_info <- table_info[-c(1,2), ]
  
  # Add the season column
  table_info$season <- seasons[i]
  
  dat[[i]] <- table_info
}

# Combine all data frames into one
dat <- dplyr::bind_rows(dat)

str(dat)

write.csv(dat, "profref_fantasy.csv")
