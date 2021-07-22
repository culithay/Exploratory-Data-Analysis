# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

NEI_SCC <- merge(NEI,SCC,by="SCC")
subMotor <- subset(NEI_SCC, grepl("Mobile",NEI_SCC$SCC.Level.One))
subMotorBalCal <- subset(subMotor,subMotor$fips== "24510" | subMotor$fips== "06037")
# yearsMotorBal <- group_by(subMotorBalCal,year)
# sumEmissionsCoalBal <- summarize(yearsMotorBal, Emissions = sum(Emissions, na.rm = TRUE))

library(dplyr)
library(ggplot2)

# output png file
png(filename ="plot6.png")
ggplot(data=subMotorBalCal, aes(x=year, y=Emissions, fill=fips))+
    geom_bar(stat="identity", position=position_dodge())+
    labs(title="PM2.5 of motor in Baltimore vs Los Angeles 1998-2008", y="Emissions of PM2.5 (Tons)", x="Year", color = "City")+
    scale_fill_discrete(name = "City", labels = c("Los Angeles", "Baltimore"))
    # geom_text(aes(label=paste(format(Emissions, nsmall = 1))), size=3.5,vjust = -1.5, position = position_dodge(2.5))+
    # scale_color_manual(labels = c("Los Angeles", "Baltimore"), values = c("blue", "red")) +

dev.off()