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
    geom_col() +SCC_Coal <- SCC %>%
        filter(grepl('[Cc]ombustion', SCC.Level.One)) %>%
        filter(grepl("[Cc]oal", SCC.Level.Three)) %>%
        select(SCC, SCC.Level.One, SCC.Level.Three)
    
    NEI_Coal <- inner_join(NEI, SCC_Coal, by = "SCC")
    NEI_Coal_Plot <- ggplot(NEI_Coal, aes(factor(year), Emissions)) +
        geom_bar(stat = "identity", fill = "peachpuff3", width = 0.5) +
        labs(x = "Year", y = "Emissions (Tons)", title = "Total Coal Combustion Emissions From 1999 - 2008") +
        theme(plot.title = element_text(size = 14),
              axis.title.x = element_text(size = 12),
              axis.title.y = element_text(size = 12)) +
        scale_fill_brewer(direction = -1) +
        ggsave("plot4.png", width = 35, height = 35, units = "cm")
    
    
    print(NEI_Coal_Plot)
    labs(title="Total Emissions of PM2.5 by coal combustion-related sources", x = "Year", y = "PM2.5 (K.Tons)")+
    geom_text(aes(label = paste(format(Emissions/1000, nsmall = 1))),vjust = -0.5, nudge_y = 4)
    dev.off()
    
