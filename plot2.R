## Title: plot2.R
## Author: Ellen Tworkoski
## Date: 12/18/2021
## Description: Produces plot displaying trends in total emissions
## from PM2.5 in Baltimore City, MD from 1999 to 2008

#Read in packages
library(ggplot2)
library(lattice)
library(dplyr)

#Read in data
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "./pm25data.zip", method = "curl")
unzip("./pm25data.zip")
pm25_data <- readRDS(file = "summarySCC_PM25.rds")
source_code_data <- readRDS(file = "Source_Classification_Code.rds")

#Create dataset which aggregates amount of emissions by year and pollutant, subset to Baltimore City, MD
pm25_baltimore <- subset(pm25_data, fips == "24510")
pm25_yr <- aggregate(Emissions ~ ., pm25_baltimore[,c("Pollutant", "Emissions", "year")], sum)

#Plot emissions by year
png(filename = "plot2.png")
with(pm25_yr, plot(year, Emissions, type = "b", cex = 2, xlab = "Year", ylab = "PM2.5 Emissions (in tons)", main = "Total PM2.5 Emissions in Baltimore City, MD from 1999 to 2008"))
dev.off()