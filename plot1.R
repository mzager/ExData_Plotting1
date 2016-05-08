# Clear Workspace
rm(list=ls())

# Reset Chart Styles
dev.off()

# Import Libraries
library(sqldf)

# Declare Constants
data.file <- "household_power_consumption.txt"

# Download + Unzip File
if (!file.exists(data.file)){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "data.zip", method="curl")
        unzip("data.zip")
        file.remove("data.zip")
}

# Read Data From Two Dates
data <- read.csv.sql(
        data.file, 
        sql = "SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007' ORDER BY DATE, TIME", 
        colClasses= c(rep("character",2), rep("double", 7)),
        sep=';',
        header=T)

# Convert NAs + Create DateTime Column + Cast Dates + Times
data[data == "?"] <- NA
data$DateTime <- as.POSIXct(paste(data$Date, data$Time, sep=' '), format="%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Create Chart
with( data, hist(
        Global_active_power,
        main = "Global Active Power",
        xlab = "Global Active Power (kilowatts)",
        col = "red")
)

# Write Chart To PNG 
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()