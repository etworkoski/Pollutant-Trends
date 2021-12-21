## Title: plot4.R
## Author: Ellen Tworkoski
## Date: 12/18/2021
## Description: Produces plot displaying trends in PM2.5 emissions from
## coal-combustion related sources in the United States from 1999 to 2008

#Read in packages
library(ggplot2)
library(lattice)
library(dplyr)
library(scales)

#Read in data
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "./pm25data.zip", method = "curl")
unzip("./pm25data.zip")
pm25_data <- readRDS(file = "summarySCC_PM25.rds")
source_code_data <- readRDS(file = "Source_Classification_Code.rds")

#Create dataset which aggregates amount of emissions by year and pollutant
#Subset to coal-combustion related sources
pm25_merged <- merge(pm25_data, source_code_data, by = "SCC")
pm25_coal_bool <- grepl("(.*)(Comb)(.*)(Coal)(.*)", pm25_merged$Short.Name)
pm25_coal <- subset(pm25_merged, pm25_coal_bool)
pm25_coal_yr <- aggregate(Emissions ~ ., pm25_coal[,c("Pollutant", "Emissions", "year")], sum)

#Plot emissions by year
png(filename = "plot4.png")
ggplot(pm25_coal_yr, aes(year, Emissions)) + geom_point() + geom_line() +
    labs(x = "Year", y = "Emissions (tons)", title = "PM2.5 Emissions from coal-combustion sources in the US, 1999-2008") +
    scale_y_continuous(label = comma)
dev.off()