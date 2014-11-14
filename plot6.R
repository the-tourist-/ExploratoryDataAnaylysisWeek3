#Q6 - Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

require(lattice)
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
#png("plot6.png")
baltimoreVsLosAngeles <- DT[(DT$fips == "24510" | fips == "06037") & DT$Data.Category=="Onroad", sum(Emissions), by="year,fips"][order(year)]
baltimoreVsLosAngeles$city <- ifelse(baltimoreVsLosAngeles$fips == "24510", "Baltimore", "Los Angeles")

chart <- xyplot(V1 ~ year | city, baltimoreVsLosAngeles, 
                main="Comparison of Total P2.5 Emissions between Baltimore and Los Angeles",
                xlab="Year", ylab="PM2.5", 
                panel = function(x, y, ...) {
                  panel.xyplot(x, y, ...) 
                  panel.lmline(x, y, col = "red") ## linear regression line
                },
                scales = list(y = list(log = 2)
         )
)
print(chart)
#dev.off()