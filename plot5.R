## Title: plot5.R
## Author: Ellen Tworkoski
## Date: 12/18/2021
## Description: Produces plot displaying trends in PM2.5 emissions from
## motor vehicle related sources in Baltimore City from 1999 to 2008

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
#Subset to motor-vehicle related sources in Baltimore City
pm25_merged <- merge(pm25_data, source_code_data, by = "SCC")
pm25_vehicle_bool <- grepl("(.*)([Vv]ehicle)(.*)", pm25_merged$Short.Name)
pm25_vehicle <- subset(pm25_merged, pm25_vehicle_bool & fips == "24510")
pm25_vehicle_yr <- aggregate(Emissions ~ ., pm25_vehicle[,c("Pollutant", "Emissions", "year")], sum)

#Plot emissions by year
png(filename = "plot5.png")
ggplot(pm25_vehicle_yr, aes(year, Emissions)) + geom_point() + geom_line() +
    labs(x = "Year", y = "Emissions (tons)", title = "PM2.5 Emissions from motor vehicles in Baltimore City, 1999-2008") +
    scale_y_continuous(label = comma)
dev.off()