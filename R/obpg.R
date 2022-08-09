#' Craft a OBPG URL for a given date
#' 
#' @export
#' @param date character, POSIXt or Date the date to retrieve
#' @param where character ignored (for now)
#' @param root character, the root URL
#' @param level character level component of path
#' @param mission character mission component of path
#' @param instrument character instrument component of path
#' @param period character period component of path
#' @param product character, provides version and extend info, leave as default
#' @param resolution character resolution component of path
#' @return one or more URLs
obpg_url <- function(date = Sys.Date() - 2,
                     where = "opendap",
                     root =      "https://oceandata.sci.gsfc.nasa.gov/opendap",
                     level = c("L3", "L3SMI")[2],
                     mission = c("MODIS",  "S3A", "SNPP", "ADEOS", "SEASTAR")[3],
                     instrument = c("AQUA", "TERRA", "OLCI", "SEAWIFS", "VIIRS", "OCTS")[5],
                     period = c("DAY", "MONTH")[1],
                     product =   "SST.sst",
                     resolution = "9km"){
  
  if (inherits(date, "character")) date <- as.Date(date)  
  
  #src <- sprintf("%s_%s", toupper(mission[1]), toupper(instrument[1]))
  src <- switch(instrument,
                "AQUA" = "AQUA_MODIS",
                "TERRA" = "TERRA_MODIS",
                "VIIRS" = "SNPP_VIIRS")
  
  product <- sprintf("L3m.%s.%s", period, product)
  
  root_mission <- switch(instrument,
                         "AQUA" = "https://oceandata.sci.gsfc.nasa.gov/opendap/MODISA",
                         "TERRA" = "https://oceandata.sci.gsfc.nasa.gov/opendap/MODIST",
                         "VIIRS" = "https://oceandata.sci.gsfc.nasa.gov/opendap/VIIRS")
  
  name <- sprintf("%s.%s.%s.%s.nc",
                  src,
                  format(date, "%Y%m%d"),
                  product,
                  resolution)
  file.path(root_mission, level, format(date, "%Y"), format(date, "%m%d"), name)                     
}


# http://oceandata.sci.gsfc.nasa.gov/opendap/MODISA/L3SMI/2021/0713/AQUA_MODIS.20210713.L3m.DAY.CHL.chlor_a.9km.nc

#"https://oceandata.sci.gsfc.nasa.gov/opendap/MODISA/L3SMI/2021/0713/AQUA_MODIS.20210713.L3m.DAY.CHL.chlor_a.9km.nc"


# https://oceandata.sci.gsfc.nasa.gov/opendap/VIIRS/L3SMI/2022/0806/SNPP_VIIRS.20220806.L3m.DAY.SST.sst.9km.nc

