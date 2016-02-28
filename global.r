library(data.table)
library(dplyr)
library(rgdal)


url <- "http://www.aemet.es/documentos/es/conocermas/recursos_en_linea/publicaciones_y_estudios/publicaciones/Valores_mensuales_1981_2010/Normales_mensuales_1981_2010.zip"
dirData <- "./data"
nameZip <- "download.zip"
nameUnzipped <- "Normales Precipitacion 1981_2010/Normales Precipitacion mensual 1981_2010.txt"

download.file(url=url,destfile = paste0(dirData,"/",nameZip))
unzip(paste0(dirData,"/",nameZip),exdir=dirData)
rawData<- fread(paste0(dirData,"/",nameUnzipped),data.table = FALSE)

rawData <- rawData %>%
              na.omit() %>%
              mutate (sumrain=Ene+Feb+Mar+Abr+May+Jun+Jul+Ago+Sep+Oct+Nov+Dic)

utms <- SpatialPoints(rawData[, c("x (Uso 30)", "y (Uso 30)")],
                      proj4string=CRS("+proj=utm +zone=30"))
longlats <- spTransform(utms, CRS("+proj=longlat"))
coord <- coordinates(longlats)


rawData <- rawData %>%
  na.omit() %>%
  mutate (long=coord[,1], lat=coord[,2])


rainData<- rawData %>%
  select(    
    Ind = Ind,
    Watershed = Cuenca,
    Station = starts_with("Nombre"),
    Province = Provincia,
    Yearrain = sumrain,
    Jan = Ene,
    Feb = Feb,
    Mar = Mar,
    Apr = Abr,
    May = May,
    Jun = Jun,
    Jul = Jul,
    Aug = Ago,
    Sep = Sep,
    Oct = Oct,
    Nov = Nov,
    Dec = Dic,
    Latitude = lat,
    Longitude = long)

provinces<-unique(rainData$Province)
watersheds <- unique(rainData$Watershed)
