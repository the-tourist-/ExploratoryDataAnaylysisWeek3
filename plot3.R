# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008?require("ggplot2")

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
png("plot3.png")
baltimoreByType <- DT[DT$fips == "24510",sum(Emissions), by="year,type"][order(year)]
chart <- ggplot(baltimoreByType, aes(x=year, y=V1, colour=type)) + 
  geom_line(size=2) +
  xlab("Year") + ylab("PM2.5") + ggtitle("Total PM2.5 Emissions by Type for Baltimore City") +
  theme(title = element_text(face="bold")) +
  scale_colour_discrete(name="Emission Type", labels=c("Non-Road", "Non-Point", "On-Road", "Point")) +
  stat_smooth(method="lm", se=F)

print(chart)
dev.off