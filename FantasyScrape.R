## Load Packages
library(tidyverse)
library(rvest)
library(lubridate)


# ** Testing Tables -------------------------------------------------------


#getting an idea of how to get the data

rvest::read_html("https://www.fantasypros.com/nfl/stats/qb.php?year=2019&scoring=PPR.htm") |> 
  #the css selector as copied from inspector in chrome
  rvest::html_elements('table') |> 
  #remove the html tags
  #we can see from the printout that the table header is saved in the first
  #row of output, so have change that
  rvest::html_table(header=1) -> fantast_tbl

#converting to df
#getting the interlying structure
new_df=fantast_tbl[[1]]

head(new_df)

## using this to combine headers
# Read the html
webpage <- rvest::read_html("https://www.fantasypros.com/nfl/stats/qb.php?year=2019&scoring=PPR.htm")

# Extract the table without headers
table_info <- rvest::html_elements(webpage, 'table') |> 
  rvest::html_table(header = FALSE, fill = TRUE) |> 
  pluck(1)

# Get the first two rows
header1 <- table_info[1, ]
header2 <- table_info[2, ]

# Combine the first and second row to create new headers
headers <- character(length(header2))
for (i in seq_along(header2)) {
  if (!is.na(header1[i]) && header1[i] != "") {
    headers[i] <- paste(header1[i], header2[i], sep = "_")
  } else {
    headers[i] <- header2[i]
  }
}

# Remove NA and "" in headers
headers[is.na(headers)] <- "NA"
headers[headers == ""] <- "empty"

# Apply the new headers to the table
colnames(table_info) <- headers

# Remove the first two rows
table_info <- table_info[-c(1,2), ]



# **QB_Data ---------------------------------------------------------------
#setting a string for desired seasons of stats
seasons <- seq(from = 2013, to = 2023, by = 1)
seasons

## Set up the URLs with a space for the seasons
urls = paste0("https://www.fantasypros.com/nfl/stats/qb.php?year=", seasons, "&scoring=PPR.htm")
urls

# Initialize an empty list to store the data frames
dat <- list()

# Loop over each URL
for (i in seq_along(urls)) {
  
  # Read the webpage
  webpage <- rvest::read_html(urls[i])
  
  # Extract the table
  table_info <- html_nodes(webpage, 'table') |> 
    html_table(header=FALSE, fill=TRUE) |> 
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
  
  # Append the data frame to the list
  dat[[i]] <- table_info
}

# Combine all data frames into one
dat <- dplyr::bind_rows(dat)

qb_data= dat
head(qb_data)

view(qb_data)

str(qb_data)

write_csv(qb_data, file="13-23_QB_Data.csv")



# **RB Data ---------------------------------------------------------------

## Set up the URLs with a space for the seasons
urls = paste0("https://www.fantasypros.com/nfl/stats/rb.php?year=", seasons, "&scoring=PPR.htm")
urls

# Initialize an empty list to store the data frames
dat <- list()

# Loop over each URL
for (i in seq_along(urls)) {
  
  # Read the webpage
  webpage <- rvest::read_html(urls[i])
  
  # Extract the table
  table_info <- html_nodes(webpage, 'table') |> 
    html_table(header=FALSE, fill=TRUE) |> 
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
  
  # Append the data frame to the list
  dat[[i]] <- table_info
}

# Combine all data frames into one
dat <- dplyr::bind_rows(dat)

rb_data= dat
head(rb_data)

view(rb_data)

str(rb_data)

write_csv(rb_data, file="13-23_RB_Data.csv")



# ** WR Data --------------------------------------------------------------

## Set up the URLs with a space for the seasons
urls = paste0("https://www.fantasypros.com/nfl/stats/wr.php?year=", seasons, "&scoring=PPR.htm")
urls

# Initialize an empty list to store the data frames
dat <- list()

# Loop over each URL
for (i in seq_along(urls)) {
  
  # Read the webpage
  webpage <- rvest::read_html(urls[i])
  
  # Extract the table
  table_info <- html_nodes(webpage, 'table') |> 
    html_table(header=FALSE, fill=TRUE) |> 
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
  
  # Append the data frame to the list
  dat[[i]] <- table_info
}

# Combine all data frames into one
dat <- dplyr::bind_rows(dat)

WR_data= dat
head(WR_data)

view(WR_data)

str(WR_data)

write_csv(WR_data, file="13-23_WR_Data.csv")



# ** TE Data --------------------------------------------------------------

## Set up the URLs with a space for the seasons
urls = paste0("https://www.fantasypros.com/nfl/stats/te.php?year=", seasons, "&scoring=PPR.htm")
urls

# Initialize an empty list to store the data frames
dat <- list()

# Loop over each URL
for (i in seq_along(urls)) {
  
  # Read the webpage
  webpage <- rvest::read_html(urls[i])
  
  # Extract the table
  table_info <- html_nodes(webpage, 'table') |> 
    html_table(header=FALSE, fill=TRUE) |> 
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
  
  # Append the data frame to the list
  dat[[i]] <- table_info
}

# Combine all data frames into one
dat <- dplyr::bind_rows(dat)

TE_data= dat
head(TE_data)

view(TE_data)

str(TE_data)

write_csv(TE_data, file="13-23_TE_Data.csv")


# **Running Reports -------------------------------------------------------

# For QB data
create_report(qb_data)

# For RB data
create_report(rb_data)

# For WR data
create_report(WR_data)

# For TE data
create_report(TE_data)

