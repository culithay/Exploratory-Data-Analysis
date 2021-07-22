## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

library(dplyr)
years <- group_by(NEI,year)
sumEmissions <- summarize(years, Emissions = sum(Emissions, na.rm = TRUE))

library(ggplot2)
# output png file
png(filename ="plot1.png")
options(digits=2)
    ggplot(data=sumEmissions,aes(year,Emissions/1000))+
    geom_col() +
    labs(title="Total Emissions of PM2.5", x = "Year", y = "PM2.5 (K.Tons)")+
    geom_text(aes(label = paste(format(Emissions/1000, nsmall = 1))),vjust = -0.5, nudge_y = 4)
dev.off()
