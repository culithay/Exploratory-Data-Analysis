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


# Sample
SCC_V <- SCC %>%
    filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
    select(SCC, SCC.Level.Two)

Tot_Emi_Locs <- NEI %>%
    filter(fips == "24510" | fips == "06037") %>%
    select(fips, SCC, Emissions, year) %>%
    inner_join(SCC_V, by = "SCC") %>%
    group_by(fips, year) %>%
    summarise(Total_Emissions = sum(Emissions, na.rm = TRUE)) %>%
    select(Total_Emissions, fips, year)

Tot_Emi_Locs$fips <- gsub("24510", "Baltimore City", Tot_Emi_Locs$fips)
Tot_Emi_Locs$fips <- gsub("06037", "Los Angeles County", Tot_Emi_Locs$fips)

Two_Locs_Plot <- ggplot(Tot_Emi_Locs, aes(x = factor(year), y = Total_Emissions, fill = fips)) +
    geom_bar(stat = "identity", width = 0.7) +
    facet_grid(.~fips) + 
    labs(x = "Year", y = "Emissions(Tons)", title = "Comparison of Motor Vehicle Related Emissions Between Baltimore City and Los Angeles From 1999 - 2008") +
    theme(plot.title = element_text(size = 14),
          axis.title.x = element_text(size = 12),
          axis.title.y = element_text(size = 12),
          strip.text.x = element_text(size = 12)) +
    theme_dark() + 
    ggsave("plot6.png", width = 35, height = 35, units = "cm")

print(Two_Locs_Plot)