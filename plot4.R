#Q4 - Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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
png("plot4.png")
coal <- DT[grep("Coal", DT$SCC.Level.Three), sum(Emissions), by="year"][order(year)]
bp <- barplot(coal$V1, names=coal$year, xlab="Year", ylim=c(0,max(coal$V1)*1.2), ylab="PM2.5", main="Total PM2.5 Emissions from Coal Combustion")
lines(bp, predict(lm(V1 ~ year, data=coal)), col="blue")
dev.off()