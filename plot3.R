##  plot3.R
##  050915 JAJ
##  https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
##  The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. Make sure your computer has enough memory (most modern computers should be fine).
##  We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
##  You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
##  Note that in this dataset missing values are coded as ?.
## 2,075,259    rows
##         9	columns
##         8	bytes/numeric
## 149418648	bytes
## 142.496727	MB
## 0.142496727	GB

reload <- FALSE   ## performance, FALSE to not download data file repeatedly
destZipFile <- ".\\data\\household_power_consumption.zip"  ## name of local data file
destOutputFile <- ".\\data\\tidy_household_power_consumption.txt"  ## name of local data file
##  Define data file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

##  Find/create data directory
if (!file.exists("data")) { dir.create("data") }

## Find/load local data file and only download file if reload is TRUE
if ((!file.exists(destZipFile)) || (reload = TRUE)) {
    ##  Note: since URL may be https, and dev of script is on Windows, use curl
    download.file(url = fileUrl, destfile = destZipFile, method = "auto")
    ##  Save date of download for reference
    dateDownloaded <- date()
    #unzip(localFile, overwrite=TRUE, exdir="data")
    unzip(destZipFile, overwrite=TRUE, exdir="data")
}

dataFile <- "data/household_power_consumption.txt"

initialData <- read.table("./data/household_power_consumption.txt", sep=";", header=TRUE, 
                           stringsAsFactors=FALSE, row.names=NULL, na.strings="?", nrows=50)
classes <- sapply(initialData, class)
powerData <- read.table("./data/household_power_consumption.txt", sep=";", header=TRUE, 
                        stringsAsFactors=FALSE, row.names=NULL, na.strings="?",
                        comment.char="",
                        colClasses=classes)

## Dates read 16/12/2006 as.Date(x, %e/%m/%Y) becomes 2006-12-16
## Times as 17:24:00 strptime(x, "%H:%M:%S")
# create new data frame of just the two days of interest, returns 2880 rows of 9 variables
DFdays <- powerData[(as.Date(powerData$Date, "%e/%m/%Y")) == "2007-02-01" | (as.Date(powerData$Date, "%e/%m/%Y")) == "2007-02-02",]

## Create 3rd png file
png(file = "plot3.png", width = 480, height = 480)
with(DFdays, {
    plot(strptime((paste(DFdays$Date, DFdays$Time)), format="%d/%m/%Y %H:%M:%S"),
                  DFdays$Sub_metering_1, xlab = "",
                  ylab = "Energy sub metering", col = "black",
                  main= "", type="n")
    lines(strptime((paste(DFdays$Date, DFdays$Time)), format="%d/%m/%Y %H:%M:%S"),
     DFdays$Sub_metering_1, xlab = "",
     ylab = "Energy sub metering", col = "black",
     main = "", type="l")
    lines(strptime((paste(DFdays$Date, DFdays$Time)), format="%d/%m/%Y %H:%M:%S"),
     DFdays$Sub_metering_2, xlab = "",
     ylab = "Energy sub metering", col = "red",
     main= "", type="l")
    lines(strptime((paste(DFdays$Date, DFdays$Time)), format="%d/%m/%Y %H:%M:%S"),
     DFdays$Sub_metering_3, xlab = "",
     ylab = "Energy sub metering", col = "blue",
     main= "", type="l")
    legend("topright", legend = c(names(DFdays)[7:9]), lty=1, col = c("black", "red", "blue"))
    }
)
dev.off()
