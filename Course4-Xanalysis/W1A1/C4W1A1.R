################ C4W1A1 - Hieu Nguyen - 2020/08/31 ############

# PLOT 1: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
library("data.table")
setwd("C:/Users/Hieu Ng/Desktop/DataScience-JHKS/Course4-Xanalysis/W1A1/data")
# Read input data
dt <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)

# Filter Dates for 2007-02-01 and 2007-02-02
dt[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]
dt <- dt[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]
dt[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

## Plot 1
png("plot1.png", width=750, height=750)
hist(dt[, Global_active_power], main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()

# PLOT 2: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Casting date time object for slicing

## Plot 2
png("plot2.png", width=750, height=750)
plot(x = dt[, dateTime] ,y = dt[, Global_active_power],
     type="l", xlab="datetime", ylab="Global Active Power (kilowatts)")
dev.off()

# PLOT 3: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Plot 3
png("plot3.png", width=750, height=750)
plot(dt[, dateTime], dt[, Sub_metering_1], type="l", xlab="",
     ylab="Energy sub metering")
lines(dt[, dateTime], dt[, Sub_metering_2],col="red")
lines(dt[, dateTime], dt[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue"),
       c("Sub_metering_1  ","Sub_metering_2  ",
         "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))
dev.off()

# PLOT 4: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Plot 4
png("plot4.png", width=750, height=750)
par(mfrow=c(2,2))

# Plot 1
hist(dt[, Global_active_power], main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")
# Plot 2
plot(x = dt[, dateTime] ,y = dt[, Voltage],
     type="l", xlab="datetime", ylab="Voltage")
# Plot 3
plot(dt[, dateTime], dt[, Sub_metering_1], type="l", xlab="",
     ylab="Energy sub metering")
lines(dt[, dateTime], dt[, Sub_metering_2],col="red")
lines(dt[, dateTime], dt[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue"),
       c("Sub_metering_1  ","Sub_metering_2  ",
         "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))

plot(dt[, dateTime], dt[,Global_reactive_power], type="l",
     xlab="datetime", ylab="Global_reactive_power")

dev.off()

