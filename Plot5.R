# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

NEI_SCC <- merge(NEI,SCC,by="SCC")
subMotorBal <- subset(NEI_SCC, grepl("Mobile",NEI_SCC$SCC.Level.One))
subMotorBal <- subset(subMotorBal,subMotorBal$fips== "24510")
yearsMotorBal <- group_by(subMotorBal,year)
sumEmissionsCoalBal <- summarize(yearsMotorBal, Emissions = sum(Emissions, na.rm = TRUE))

library(dplyr)
library(ggplot2)

# output png file
png(filename ="plot5.png")
    ggplot(data=sumEmissionsCoalBal,aes(year,Emissions))+
    geom_col() +
    labs(title="PM2.5 by motor vehicle in Baltimore 1998-2008", x = "Year", y = "PM2.5 (Tons)")+
    geom_text(aes(label = paste(format(Emissions, nsmall = 1))),vjust=-1,nudge_y = 4)
dev.off()