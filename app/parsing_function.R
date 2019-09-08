# Putting together the code needed to actually parse the input data
# Sample here is a single file that contains multiple documents
# We are looking to extract out the interest, color, and date within each 'file'

library(stringr)
a <- readr::read_file('app/testdata.txt')
a <- unlist(str_split(a, 'THIS IS THE END'))
b <- grep('^\\r\\n$',a) # find lines with no content
a <- a[-b] # get rid of those lines

datas <- data.frame('raw'=a)
datas$raw <- as.character(datas$raw) # b/c otherwise are factors

datas$interest <- str_extract_all(datas$raw,'interest.*\r\n')
datas$interest <- gsub('interest: *|\r\n','',datas$interest) # get the interest
datas$color <- str_extract_all(datas$raw,'color.*\r\n')      # get the color
datas$date <- str_extract_all(datas$raw,'\\d{1,2}\\/\\d{1,2}\\/\\d{2,4}') # get date
