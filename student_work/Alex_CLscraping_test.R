#### Testing Craigslist webscrapers in R to see what works

### CraigslistWebscrapping code from nugowe on github
# library(polite)
# library(magrittr)
# library(dplyr)
# library(rvest)
# library(readr)
# 
# Craigslist <- function(url){
#   
#   session = bow(url, user_agent =  "Linkedin Post | Webscrapping Tutorial")
#   Description_items <- scrape(session) %>% html_nodes("#search-results") %>% html_elements(".result-heading") %>% html_text2()
#   Description_items <- as.data.frame(Description_items)
#   Prices <- scrape(session) %>% html_nodes("#search-results") %>% html_elements(".result-meta")%>% html_text2()
#   Prices <- as.data.frame(Prices)
#   Links <- scrape(session) %>% html_nodes(".rows") %>% html_elements("a") %>% html_attr("href") %>% unique()
#   Links <- as.data.frame(Links) %>% slice(1,3:121)
#   Comprehensive_list <- cbind(Description_items, Prices, Links )
#   Comprehensive_list$Prices <- gsub("pic hide this posting restore restore this posting", "", Comprehensive_list$Prices)
#   Comprehensive_list$Prices <- gsub("hide this posting restore restore this posting", "", Comprehensive_list$Prices)
#   names(Comprehensive_list)[2] <- "Prices & their locations"
#   Comprehensive_list <- Comprehensive_list %>% select(c(1:3))
#   write_csv2(Comprehensive_list, file = "Comprehensive_list.csv", col_names = T, append = T)
#   #write.xlsx(Comprehensive_list, append = FALSE, file = '/home/nosa2k/CraigslistExample.xlsx')wb = createWorkbook()
#  
# }
# 
# #Craigslist()
# 
# url1 <- "https://dallas.craigslist.org/d/computers/search/sya?query=dell"
# url2 <- "https://dallas.craigslist.org/d/computers/search/sya?s=120&query=dell"
# url3 <- "https://dallas.craigslist.org/d/computers/search/sya?s=240&query=dell"
# 
# urls = list(url1, url2, url3)
# 
# 
# for(url in urls){
#   
#   Craigslist(url)
# }  

### Apt CL scraping code from https://proxiesapi.com/articles/scraping-craigslist-listings-with-r

## Install and loas rvest, a package that helps parse and scrape html
install.packages("rvest")
library(rvest)

## Set the urls to scrape to LA apartments
url <- "<https://losangeles.craigslist.org/search/apa>"

## Use read_html() to gate page content
page <- read_html(url)

## pulled from tutorial, I dont understand this part of the code but running just to see if it works before revisiong
# listings <- html_nodes(page, "li.cl-static-search-result")
# 
# for (listing in listings) {
#   
#   title <- html_node(listing, ".title") %>%
#     html_text()
#   
#   price <- html_node(listing, ".price") %>%
#     html_text()
#   
#   location <- html_node(listing, ".location") %>%
#     html_text()
#   
#   link <- html_node(listing, "a") %>%
#     html_attr("href")
#   
#   print(paste(title, price, location, link))

## trying again but with using current LA base code
listings <- html_nodes(page, "cl-static-hub-links")

for (listing in listings) {
  
  title <- html_node(listing, ".title") %>%
    html_text()
  
  price <- html_node(listing, ".price") %>%
    html_text()
  
  location <- html_node(listing, ".location") %>%
    html_text()
  
  link <- html_node(listing, "a") %>%
    html_attr("href")
  
  print(paste(title, price, location, link))
  
}
  
}

