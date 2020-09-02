################ C4W4A2 - Hieu Nguyen - 2020/08/31 ############
# FINAL ASSIGnMENT

# PLOT 1: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
library("data.table")
library("ggplot2")

setwd("C:/Users/Hieu Ng/Desktop/DataScience-JHKS/Course4-Xanalysis/W4A2")

unzip(zipfile = "exdata_data_NEI_data.zip")

NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")

# Convert rds into data.table
NEI = as.data.table(NEI)
SCC = as.data.table(SCC)

# Cast Emissions as numeric
NEI[, Emissions := lapply(.SD, as.numeric),
    .SDcols = c("Emissions")]

# Take the sum of emission of by year
NEI.sum = NEI[, lapply(.SD, sum, na.rm = TRUE),
              .SDcols = c("Emissions"), by = year]
# PLOT 1
png("plot1.png", width=480, height=480)

barplot(NEI.sum[, Emissions]
        , names = NEI.sum[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")
dev.off()

# QUESTION 1: ????????????
# Have total emissions from PM2.5 decreased in the United States from 
# 1999 to 2008? Using the base plotting system, make a plot showing 
# the total PM2.5 emission from all sources for each of the years 
# 1999, 2002, 2005, and 2008? 

# ==> ANSWER: Yes based on plot 1

# PLOT 2: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# take the sum of the emission by year in the Baltimore City, Maryland
NEI.sum.24510 = NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE)
                     ,.SDcols = c("Emissions"), by = year]

png(filename='plot2.png', width=480, height=480)

barplot(NEI.sum.24510[, Emissions]
        , names = NEI.sum.24510[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")

dev.off()

# QUESTION 2: ????????????
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# from 1999 to 2008?

# ==> ANSWER: it did not consistently decrease but the overall trend was 
# decreasing as shown in plot 2

# PLOT 3: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Filter fips = 24510
NEI.24510 = NEI[fips=="24510",]

png(filename='plot3.png', width=750, height=750)

ggplot(NEI.24510,aes(factor(year),Emissions,fill=type)) +
    geom_bar(stat="identity") +
    theme_bw() + guides(fill=F)+
    facet_grid(.~type) + 
    labs(x="year", y=expression("Total Emission")) + 
    labs(title=expression("PM Emissions, Baltimore 1999-2008 by Type"))

dev.off()

# QUESTION 3: ????????????
# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in 
# emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 

# ==> ANSWER: All type shows decreasing trend in total emission from 1999-2008
# `NONPOINT` type has the highest total emission overall

# PLOT 4: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Matching combustion and coal related emission
combustion = grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
coal = grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
# get coal combustion codes
coal.combustion.factors = SCC[coal & combustion, SCC]
coal.combustion.NEI = NEI[NEI[,SCC] %in% coal.combustion.factors]

png(filename='plot4.png', width=750, height=750)

ggplot(coal.combustion.NEI,aes(x = factor(year),y = Emissions)) +
    geom_bar(stat="identity") +
    labs(x="year", y=expression("Total Emission")) + 
    labs(title=expression("Coal Combustion Source Emissions Across US  1999-2008"))

dev.off()

# QUESTION 4: ????????????
# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999-2008?

# ==> ANSWER: Yes the emission from coal combustion decreased noticeably from 
# 1999 - 2008


# PLOT 5: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Matching vehicle source from Baltimore City
NEI.24510 = NEI[fips=="24510",]
# get factors for vehicle
vehi.condition = grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehi.factor = SCC[vehi.condition, SCC]
vehi.NEI.24510 <- NEI.24510[NEI.24510[, SCC] %in% vehi.factor,]

png(filename='plot5.png', width=750, height=750)

ggplot(vehi.NEI.24510,aes(factor(year),Emissions)) +
    geom_bar(stat="identity") +
    labs(x="year", y=expression("Total Emission")) + 
    labs(title=expression("PM Motor Vehicle Source Emissions in Baltimore 1999-2008"))

dev.off()
# QUESTION 5: ????????????
# How have emissions from motor vehicle sources changed from 1999-2008 
# in Baltimore City?
# ==> ANSWER: Yeah it drastically dropped from 1999 to 2008

# PLOT 6: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Rename city col into city name
vehi.NEI.24510[, city := c("Baltimore City")]

# Filter LA
NEI.06037 = NEI[fips=="06037",]
# get vehicle source
vehi.NEI.06037 = NEI.06037[NEI.06037[, SCC] %in% vehi.factor,]
vehi.NEI.06037[, city := c("LA")]

# combine the 2 data tables
baltimore.la = rbind(vehi.NEI.24510,vehi.NEI.06037)

png(filename='plot6.png', width=750, height=750)

ggplot(baltimore.la, aes(x=factor(year), y=Emissions, fill=city)) +
    geom_bar(stat="identity") +
    facet_grid(.~city) +
    labs(x="year", y=expression("Total Emission")) + 
    labs(title=expression("PM Motor Vehicle Source Emissions in Baltimore & LA 1999-2008"))

dev.off()
# QUESTION 6: ????????????
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California

# ==> ANSWER: LA total emission from motor vehicle source is way higher than
# Baltimore. Baltimore shows consistent decreasing trend in motor emission over
# the years whereas LA fluctuates with higher variance from 1999-2008
