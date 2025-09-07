

link_repo <- "https://github.com/afsc-gap-products/UW-FISH572"

pretty_date <- format(Sys.Date(), "%B %d, %Y")
crs_out <- crs.out <- "EPSG:3338"

# Download citations -----------------------------------------------------------

# library(RCurl)
write.table(x = readLines(con = "https://raw.githubusercontent.com/citation-style-language/styles/master/apa-no-ampersand.csl"),
            file = here::here("content/references.csl"),
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE)

write.table(x = readLines(con = "https://raw.githubusercontent.com/afsc-gap-products/citations/main/cite/bibliography.bib"),
            file = here::here("content/references.bib"),
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE)


