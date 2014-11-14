#Q5 - How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

require("data.table")

#Load Data
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
png("plot5.png")
onroad <- DT[DT$fips == "24510" & DT$Data.Category=="Onroad", sum(Emissions), by="year"][order(year)]
barplot(onroad$V1, names=onroad$year, xlab="Year", ylab="PM2.5", main="Total PM2.5 Emissions for On-Road Vehicles in Baltimore")
lines(bp, predict(lm(V1 ~ year, data=onroad)), col="blue")
dev.off()
