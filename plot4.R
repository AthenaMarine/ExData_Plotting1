# plot3.R - This script creates a plot of submetering values by days of the week
## using test data from the UCI Machine Learning Repository on household power consumption data
## for the days February 1-2, 2007
## raw data should be downloaded and unzipped into your working directory from here: 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

library(sqldf)

## load in the data for the first two days in February 2007
connection <- read.csv.sql("household_power_consumption.txt", sql="select * from file where Date in ('1/2/2007','2/2/2007')", header=TRUE, sep=';')

## close the file connection, otherwise you'll get a warning the next time you run the script.
on.exit(close(connection))

## create a combined date/time column.
connection$Datetime <- paste(connection$Date, connection$Time, sep=" ")

## transform the column datatypes from character to what is needed.
house_power <- transform(connection, 
                         Datetime = as.POSIXct(Datetime,
                                               format="%d/%m/%Y %H:%M:%S"),          
                         Global_active_power = as.numeric(Global_active_power),
                         Global_reactive_power = as.numeric(Global_reactive_power),
                         Voltage = as.numeric(Voltage),
                         Global_intensity = as.numeric(Global_intensity),
                         Sub_metering_1 = as.numeric(Sub_metering_1),
                         Sub_metering_2 = as.numeric(Sub_metering_2),
                         Sub_metering_3 = as.numeric(Sub_metering_3))

## this plot is going directly into a png file
png('plot4.png', width=480, height=480, units="px", pointsize=12, bg="white")

# create a two by two grid on which to place the plots.
par(mfrow = c(2,2))

## create the plot for Global Active Power
with(house_power, plot(Datetime, Global_active_power,
                       main="",
                       type="l",
                       xlab="",
                       ylab="Global Active Power (kilowatts)",
                       yaxt="n"))

axis(side=2, at=c(0,2,4,6), labels=c("0","2","4","6"))

## create the Voltage plot
with(house_power, plot(Datetime, Voltage,
                       main="",
                       type="l",
                       xlab="datetime",
                       ylab="Voltage",
                       yaxt="n"))

axis(side=2, at=c(234,238,242,246), labels=c("234","238","242","246"))

## create the Submetering plot
with(house_power, plot(Datetime, Sub_metering_1, 
                       col="black",
                       type="l",
                       xlab="",
                       ylab="Energy sub metering",
                       yaxt="n"))

## create the 2nd line on the plot
with(house_power, lines(Datetime, Sub_metering_2,
                        col="red"))

## create the 3rd line on the plot
with(house_power, lines(Datetime, Sub_metering_3,
                        col="blue"))

axis(side=2, at=c(0,10,20,30), labels=c("0","10","20","30"))

## add a legend
legend("topright",col = c("black", "red", "blue"),
       lty=1,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       cex=0.8, xjust=1)

## create the reactive power plot
with(house_power, plot(Datetime, Global_reactive_power,
                       main="",
                       type="l",
                       xlab="datetime",
                       yaxt="n"))

axis(side=2, at=c(0.0,0.1,0.2,0.3,0.4,0.5), labels=c("0.0","0.1","0.2","0.3","0.4","0.5"))

# close the png file so you can view it
dev.off()

# clean up temporary data
rm(house_power)
rm(connection)