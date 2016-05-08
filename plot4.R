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

# Partition + Set Margins
par( mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0) )

# Generate Chart 1
with( data, plot(
        Global_active_power ~ DateTime,
        ylab = "Global Active Power",
        xlab = "",
        type = "l")
)

# Generate Chart 2
with( data, plot(
        Voltage ~ DateTime, 
        ylab = "Voltage", 
        xlab = "datetime",
        type = "l")
)

# Generate Chart 3
with( data, plot(
        Sub_metering_1 ~ DateTime,
        ylab = "Engergy sub metering",
        xlab = "",
        type="l")
)
with (data, lines(
        Sub_metering_2 ~ DateTime, 
        col = "Red")
)
with (data, lines(
        Sub_metering_3 ~ DateTime, 
        col = "Blue")
)
with (data, legend(
        "topright",
        legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
        col = c("Black","Red","Blue"),
        lty = 1,
        lwd = 2,
        box.lwd = 0,
        cex = .8,
        text.width = 63000,
        xjust = 1, 
        yjust = 2)
)

# Generate Chart 4
with (data, plot(
        Global_reactive_power ~ DateTime,
        ylab = "Global_reactive_power",
        xlab="datetime",
        type = "l")
)

# Write Chart To PNG 
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()