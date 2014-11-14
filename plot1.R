#Q1 - Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

#Load Data
require("data.table")

if (!file.exists("exdata_data_household_power_consumption.zip"))
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                "exdata_data_household_power_consumption.zip")

if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds"))
  unzip("exdata_data_household_power_consumption.zip")

if (sum(ls()=="SCC")==0 || sum(class(SCC) == "data.table")==0) {
  SCC <- readRDS("Source_Classification_Code.rds")
  SCC$SCC <- as.character(SCC$SCC)
  SCC <- data.table(SCC, key="SCC")
}

if (sum(ls()=="NEI")==0 || sum(class(NEI) == "data.table")==0) {
  NEI <- readRDS("summarySCC_PM25.rds")
  NEI <- data.table(NEI)
}
if (sum(ls()=="DT")==0 || sum(class(DT) == "data.table")==0)
  DT  <- merge(NEI, SCC, by="SCC", all.x=T)

# Create Plot
png("plot1.png")
emissionsByYear <- DT[,sum(Emissions), by=year]
bp <- barplot(emissionsByYear$V1, names=emissionsByYear$year, xlab="Year", ylab="PM2.5", main="Total PM2.5 emission from all sources")
lines(bp, predict(lm(V1 ~ year, data=emissionsByYear)), col="blue")
dev.off()

