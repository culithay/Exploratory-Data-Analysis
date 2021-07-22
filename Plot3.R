# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

baltimore <- subset(NEI,NEI$fips == "24510")
# yearsBal <- group_by(baltimore,year)
# sumEmissionsBal <- summarize(yearsBal, Emissions = sum(Emissions, na.rm = TRUE))

# output png file
png(filename ="plot3.png")
    ggplot(data=baltimore, aes(x=year, y=Emissions/1000, fill=type))+
    geom_bar(stat="identity", position=position_dodge())+
    geom_text(aes(label=paste(format(Emissions/1000, nsmall = 1))), size=3.5,vjust = -1.5, position = position_dodge(2.5))+
    labs(title="Total Emissions of PM2.5 in Baltimore City", y="Emissions of PM2.5 (K.Tons)", x="Year")
dev.off()


total_emi_24510_type <- NEI %>%
    filter(fips == 24510) %>%
    select(fips, type, Emissions, year) %>%
    group_by(year, type) %>%
    summarise(Total_Emissions = sum(Emissions, na.rm = TRUE))
Baltimore_Type <- ggplot(total_emi_24510_type, aes(x = factor(year), y = Total_Emissions, fill = type)) +
    geom_bar(stat = "identity") +
    facet_grid(.~type) + 
    labs(x = "Year", y = "Emissions (Tons)", title = "Total Emissions By Type In Baltimore City From 1999 - 2008") +
    theme(plot.title = element_text(size = 14),
          axis.title.x = element_text(size = 12),
          axis.title.y = element_text(size = 12)) +
    scale_fill_brewer(direction = -1) + 
    ggsave("plot3.png", width = 35, height = 35, units = "cm")


print(Baltimore_Type)