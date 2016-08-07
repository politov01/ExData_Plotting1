
# Check if the data is downloaded and download when applicable
if(!file.exists("data.zip")) { 
    download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                  destfile="data.zip", mode = "wb") 
    unzip("data.zip")   
  } 

# Reading the file
library(data.table)

DT <- fread("household_power_consumption.txt", 
            sep = ";", 
            header = TRUE, 
            colClasses = rep("character",9)) 
# Convert "?" in NAs 
DT[DT == "?"] <- NA 

# Selecting adequate lines 
DT$Date <- as.Date(DT$Date, format = "%d/%m/%Y") 
DT <- DT[DT$Date >= as.Date("2007-02-01") & DT$Date <= as.Date("2007-02-02"),] 
 
# Convert column that we will use to correct class 
DT$Global_active_power <- as.numeric(DT$Global_active_power) 

# Joining day and time to create a new posix date
DT$DateTime <- as.POSIXct(strptime(paste(DT$Date, DT$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")) 


# Do the graph 
png(file = "plot4.png", width = 480, height = 480, units = "px")

## Setting 4 graphs 
par(mfrow = c(2, 2)) 


## 1 ###################
plot(DT$DateTime, 
     DT$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power")
## 2 ###################
plot(DT$DateTime, 
     DT$Voltage, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Voltage")
## 3 ###################
plot(DT$DateTime, 
     DT$Sub_metering_1, 
     type = "l", 
     xlab = "", 
     ylab = "Energy sub metering")
lines(DT$DateTime, DT$Sub_metering_2, col = "red") 
lines(DT$DateTime, DT$Sub_metering_3, col = "blue") 

legend("topright", col = c("black", "blue", "red"), 
        legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty = 1) 

## 4 ###################
plot(DT$DateTime, 
     DT$Global_reactive_power, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Global_reactive_power")
dev.off()  # Close the png file device 

