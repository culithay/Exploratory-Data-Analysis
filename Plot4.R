# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

NEI_SCC <- merge(NEI,SCC,by="SCC")
subCoal <- subset(NEI_SCC, grepl("Coal",NEI_SCC$EI.Sector))
yearsCoal <- group_by(subCoal,year)
sumEmissionsCoal <- summarize(yearsCoal, Emissions = sum(Emissions, na.rm = TRUE))

library(dplyr)
library(ggplot2)

# output png file
png(filename ="plot4.png")
    ggplot(data=sumEmissionsCoal,aes(year,Emissions/1000))+
    geom_col() +
    labs(title="Total Emissions of PM2.5 by coal combustion-related sources", x = "Year", y = "PM2.5 (K.Tons)")+
    geom_text(aes(label = paste(format(Emissions/1000, nsmall = 1))),vjust = -0.5, nudge_y = 4)
dev.off()