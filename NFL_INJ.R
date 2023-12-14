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


# **Cleaning/Transforming the Data ----------------------------------------

# loading the required packages
library(dplyr)
library(lubridate)
library(stringr)

#getting the data
nfl_inj= read.csv("NFL_INJ_data.csv")

names(nfl_inj)
head(nfl_inj)
str(nfl_inj)

#converting to month/day/year object
nfl_inj$date=lubridate::mdy(nfl_inj$date)

View(nfl_inj)


#body_part is overall body part (surgery, fracture or injury)
#second is separated into surgery or fracture
#combined is set by body part, surgery and fracture. No description besides body part means injury. 
#combined just is everything combined together
#easier to do analysis that way
#example: hip (means just injury), hip fracture, or hip surgery
#be careful of spellings, capitalization, and 


Extract = c("toe", "foot", "heel", "ankle", "Achilles", "shin", "fibula", "calf", "knee", "patella", 
            "hamstring", "quadricep", "thigh", "groin", "abductor", "adductor", "hernia", "hip", "gluteus", "leg", 
            "abdominal", "oblique", "side", "rib", "intercostal", "back", 
            "arm",  "chest", "pectoral", "shoulder", "rotator cuff", "bicep", "tricep", "elbow", 
            "flexor tendon", "forearm", "wrist", "hand", "finger","thumb", 
            "neck", "cervical", "eye", "face", "facial", "cheekbones", "jaw", "concussion", "collar bone", 
            "head", "collarbone", "skull")

Extract_2 = c("broken", "fracture", "fractured", "surgery", "arthroscopy", "Tommy John")

Extract_3 = c("meniscus", "Meniscus")

Extract_4 = c("ACL", "acl", "patella", "MCL", "mcl", "PCL", "pcl")


nfl_inj$body_part <- str_extract(nfl_inj$notes, paste(Extract, collapse="|"))
nfl_inj$body_part

nfl_inj$second <- str_extract(nfl_inj$notes, paste(Extract_2, collapse="|"))
nfl_inj$second

#Making a knee specific VAR 
nfl_inj$knee_m <- str_extract(nfl_inj$notes, paste(Extract_3, collapse = "|"))
nfl_inj$knee_c <- str_extract(nfl_inj$notes, paste(Extract_4, collapse = "|"))

#Combining knee_m and knee_c to make knee specific 
nfl_inj$knee_specific <- paste(nfl_inj$knee_m, nfl_inj$knee_c, sep=" ")

nfl_inj$knee_specific<- str_remove(nfl_inj$knee_specific, "NA")

nfl_inj$knee_specific<- str_remove(nfl_inj$knee_specific, " NA")


#Fixing broke, fracture and fractured with just fracture 
nfl_inj$extra <- str_replace(nfl_inj$second, "fractured", "fracture")
nfl_inj$extra <- str_replace(nfl_inj$extra, "broken", "fracture")
nfl_inj$extra <- str_replace(nfl_inj$extra, "arthroscopy", "surgery")

head(nfl_inj)
View(nfl_inj)

nfl_inj |> 
  filter(second == "broken") |> 
  select(second, extra)

nfl_inj |> 
  filter(second == "arthroscopy") |> 
  select(second, extra)

#Amalgating body part names that are the body part but with different name
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part, "side", "oblique")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "cervical", "neck")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "collar bone", "collarbone")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "groin", "adductor")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "cervical", "neck")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "skull", "head")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "facial", "face")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "rotator cuff", "shoulder")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "pectoral", "chest")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "flexor tendon", "forearm")
nfl_inj$body_part_2 <- str_replace(nfl_inj$body_part_2, "cheekbones", "face")


nfl_inj$combine <- paste(nfl_inj$body_part, nfl_inj$extra, sep=" ")

nfl_inj$combine<- str_remove(nfl_inj$combine, "NA")

View(nfl_inj)


# **Creating a Report -----------------------------------------------------
DataExplorer::create_report(nfl_inj)




