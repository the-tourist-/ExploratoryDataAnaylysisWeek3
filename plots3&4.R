require("ggplot2")
baltimoreByType <- DT[DT$fips == "24510",sum(Emissions), by="year,type"][order(year)]
ggplot(baltimoreByType, aes(x=year, y=V1, colour=type)) + 
  geom_line(size=2) +
  xlab("Year") + ylab("PM2.5") + ggtitle("Total PM2.5 Emissions by Type for Baltimore City") +
  theme(title = element_text(face="bold")) +
  scale_colour_discrete(name="Emission Type", labels=c("Non-Road", "Non-Point", "On-Road", "Point"))

coal <- DT[grep("Coal", DT$SCC.Level.Three), sum(Emissions), by="year"][order(year)]
barplot(coal$V1, names=coal$year, xlab="Year", ylab="PM2.5", main="Total PM2.5 Emissions from Coal Combustion")
