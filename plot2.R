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
        hpc$ts <- strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")
        hpc <- within(hpc, rm(Date, Time))
        
        hpc
}

# to speed up loading, only load rows 66000-70000
hpc <- readData(skip=66000, nrows=4000)

# plot to PNG
png <- png(filename = "plot2.png", width = 480, height = 480)
plot(hpc$ts, hpc$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off()
