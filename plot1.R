## plot1.R - This script creates a histogram using test data
## from the UCI Machine Learning Repository on household power consumption data
## for the days February 1-2, 2007
## raw data should be downloaded and unzipped into your working direcotry from here: 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

library(sqldf)

## load in the data for the first two days in February 2007
connection <- read.csv.sql("household_power_consumption.txt", sql="select * from file where Date in ('1/2/2007','2/2/2007')", header=TRUE, sep=';')

## close the file connection, otherwise you'll get a warning the next time you run the script.
on.exit(close(connection))

## transform the column datatypes from character to what is needed.
house_power <- transform(connection, 
                          Date = as.Date(Date, format="%m/%d/%Y"),
                          Time = as.POSIXct(strptime(Time, format="%H:%M:%S")),
                          Global_active_power = as.numeric(Global_active_power),
                          Global_reactive_power = as.numeric(Global_reactive_power),
                          Voltage = as.numeric(Voltage),
                          Global_intensity = as.numeric(Global_intensity),
                          Sub_metering_1 = as.numeric(Sub_metering_1),
                          Sub_metering_2 = as.numeric(Sub_metering_2),
                          Sub_metering_3 = as.numeric(Sub_metering_3))

## this plot is going directly into a png file
png('plot1.png', width=480, height=480, units="px", pointsize=12, bg="white")

## create the histogram
with(house_power, hist(Global_active_power, col="red",
                       main="Global Active Power",
                       xlab="Global Active Power (kilowatts)",
                       axes=FALSE))

# adjust the axes labels
axis(side=1, at=c(0,2,4,6), labels=c("0","2","4","6"))
axis(side=2, at=c(0,200,400,600,800,1000, 1200), labels=c("0","200","400","600","800","1000","1200"))

# close the png file so you can view it
dev.off()

# clean up temporary data
rm(house_power)
rm(connection)
