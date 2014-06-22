require("data.table")

setwd("~/GitHub/ExploratoryDataAnaylysisWeek3")

if (!file.exists("NationalEmmissionsInvestoryPollutionData.zip"))
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                "exdata_data_household_power_consumption.zip")

if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds"))
  unzip("exdata_data_household_power_consumption.zip")

SCC <- readRDS("Source_Classification_Code.rds")
SCC$SCC <- as.character(SCC$SCC)
SCC <- data.table(SCC, key="SCC")
NEI <- readRDS("summarySCC_PM25.rds")
NEI <- data.table(NEI)

DT  <- merge(NEI, SCC, by="SCC", all.x=T)


