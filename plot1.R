
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


# Do the graph 
png(file = "plot1.png", width = 480, height = 480, units = "px") 

hist(DT$Global_active_power, 
     col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)") 
dev.off()  # Close the png file device 

