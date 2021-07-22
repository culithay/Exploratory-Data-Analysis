## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

library(dplyr)
baltimore <- subset(NEI,NEI$fips == "24510")
yearsBal <- group_by(baltimore,year)
sumEmissionsBal <- summarize(yearsBal, Emissions = sum(Emissions, na.rm = TRUE))

library(ggplot2)
# output png file
png(filename = "plot2.png")
options(digits=2)
ggplot(data= sumEmissionsBal,aes(year,Emissions/1000))+
    geom_col() +
    labs(title="Total Emissions of PM2.5 in Baltimore City", x = "Year", y = "Emissions of PM2.5 (K.Tons)")+
    geom_text(aes(label = paste(format(Emissions/1000, nsmall = 1))),vjust = -0.5)
dev.off()

total_emi_24510 <- NEI %>%
    filter(fips == 24510) %>%
    select(fips, Emissions, year) %>%
    group_by(year) %>%
    summarise(Total_Emissions = sum(Emissions, na.rm = TRUE))
png("plot2.png")
plot(x = total_emi_24510$year, y = total_emi_24510$Total_Emissions, type = "l", col = "red", xlab = "Year", ylab = "Emissions (Ton)", main = "Total Emissions From All Sources in Baltimore City, Maryland" )
dev.off()