#' Craft a OBPG URL for a given date
#' 
#' @export
#' @param date character, POSIXt or Date the date to retrieve
#' @param where character ignored (for now)
#' @param root character, the root URL
#' @param product character, provides version and extend info, leave as default
#' @return one or more URLs
obpg_url <- function(date = Sys.Date() - 2,
                     where = "opendap",
                     root = file.path("https://oceandata.sci.gsfc.nasa.gov",
                                      "opendap/VIIRS/L3SMI/"),
                     #platform = ,
                     product = "L3m_DAY_SNPP_CHL_chl_ocx_4km.nc",
                     #resolution = ){
  
  if (inherits(date, "character")) date <- as.Date(date)                    
  name <- sprintf("%s/%s/V%s%s.%s",
                  format(date, "%Y"), 
                  format(date, "%j"), 
                  format(date, "%Y"),
                  format(date, "%j"),
                  product)
  file.path(root, name)                     
}

