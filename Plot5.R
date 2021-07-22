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
        
        SCC_V <- SCC %>%
            filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
            select(SCC, SCC.Level.Two)
        
        Tot_Emi_24510_V <- NEI %>%
            filter(fips == "24510") %>%
            select(SCC, fips, Emissions, year) %>%
            inner_join(SCC_V, by = "SCC") %>%
            group_by(year) %>%
            summarise(Total_Emissions = sum(Emissions, na.rm = TRUE)) %>%
            select(Total_Emissions, year)
        
        Baltimore_Vehicles_Plot <- ggplot(Tot_Emi_24510_V, aes(factor(year), Total_Emissions)) +
            geom_bar(stat = "identity", fill = "sienna3", width = 0.5) +
            labs(x = "Year", y = "Emissions (Tons)", title = "Total Motor Vehicle Related Emissions In Baltimore City From 1999 - 2008") +
            theme(plot.title = element_text(size = 14),
                  axis.title.x = element_text(size = 12),
                  axis.title.y = element_text(size = 12)) +
            ggsave("plot5.png", width = 35, height = 35, units = "cm")
        
        print(Baltimore_Vehicles_Plot)