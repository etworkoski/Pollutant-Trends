## Title: plot6.R
## Author: Ellen Tworkoski
## Date: 12/18/2021
## Description: Produces plot displaying trends in PM2.5 emissions from
## motor vehicle related sources in Baltimore City and LA Counties from 1999 to 2008

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
#Subset to motor-vehicle related sources in Baltimore City and LA
pm25_merged <- merge(pm25_data, source_code_data, by = "SCC")
pm25_vehicle_bool <- grepl("(.*)([Vv]ehicle)(.*)", pm25_merged$Short.Name)
pm25_vehicle <- subset(pm25_merged, pm25_vehicle_bool & (fips == "24510" | fips == "06037"))
pm25_vehicle_yr <- aggregate(Emissions ~ ., pm25_vehicle[,c("Pollutant", "Emissions", "year", "fips")], sum)
pm25_vehicle_yr$county <- ifelse(pm25_vehicle_yr$fips == "06037", "Los Angeles County", "Baltimore City County")

#Calculate percent change in emissions, relative to 1999 levels, in each county
la_ref <- data.frame(county = "Los Angeles County", reference = pm25_vehicle_yr[1, 4]) #emissions value in 1999 in LA
baltimore_ref <- data.frame(county = "Baltimore City County", reference = pm25_vehicle_yr[5,4]) #emissions value in 1999 in baltimore
ref <- rbind(la_ref, baltimore_ref)
pm25_vehicle_yr_ref <- merge(pm25_vehicle_yr, ref, by = "county")
pm25_vehicle_yr_ref <- pm25_vehicle_yr_ref %>% mutate(percent_change = (Emissions - reference)/reference)

#Plot emissions by year
png(filename = "plot6.png")
ggplot(pm25_vehicle_yr_ref, aes(year, percent_change)) + geom_point() + geom_line() +
    labs(x = "Year", y = "% Change in Emissions Relative to 1999", title = "Percent Change in PM2.5 Emissions from Motor Vehicles, 1999-2008") +
    scale_y_continuous(label = scales::percent) +
    facet_grid(.~county)
dev.off()