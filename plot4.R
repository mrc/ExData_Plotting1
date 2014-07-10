readData <- function(skip=1, nrows=-1, ...) {
        filename <- "household_power_consumption.txt"
        colNames <- names(read.csv(filename, sep=";", nrows=1))
        colClasses <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
        hpc <- read.csv(filename,
                        sep=";",
                        header=FALSE,
                        col.names=colNames,
                        colClasses=colClasses,
                        na.strings="?",
                        skip=skip,
                        nrows=nrows,
                        ...)
        
        # subset to include only 2007-02-01 and 2007-02-02
        incs <- hpc$Date %in% c("1/2/2007", "2/2/2007")
        hpc <- hpc[incs,]
        
        # extract a timestamp, then we can drop Date and Time        
        hpc$datetime <- strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")
        hpc <- within(hpc, rm(Date, Time))
        
        hpc
}

# to speed up loading, only load rows 66000-70000
hpc <- readData(skip=66000, nrows=4000)

# plot to PNG
png <- png(filename = "plot4.png", width = 480, height = 480)
par(mfcol=c(2, 2))
with(hpc, {
        plot(datetime, Global_active_power, type="l", ylab="Global Active Power", xlab="")
        
        plot(datetime, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
        lines(datetime, Sub_metering_2, col="red")
        lines(datetime, Sub_metering_3, col="blue")
        legend("topright", lty="solid", 
               col=c("black", "red", "blue"), 
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               bty="n")
        
        plot(datetime, Voltage, type="l")
        
        plot(datetime, Global_reactive_power, type="l")
        
})

dev.off()
