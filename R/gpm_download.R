#' @title Download IMERG v06B Final, Early and Late Run
#'
#' @description Download IMERG v06B Final, Early and Late Run.
#' @param path path (character). The default corresponds to the working directory, getwd(). Missing values will be ignored.
#' @param user pmm user (character). See https://pmm.nasa.gov/data-access/downloads/gpm
#' @param password pmm password (character). See https://pmm.nasa.gov/data-access/downloads/gpm
#' @param product IMERG product (character). Currently are supported: 'finalrun', 'late' and 'early'.
#' @param dates sequences of days.
#' @param band The available bands (character) are: \cr
#' band "HQobservationTime"  \cr
#' band "HQprecipSource"  \cr
#' band "HQprecipitation"  \cr
#' band "IRkalmanFilterWeight" \cr
#' band "IRprecipitation"\cr
#' band "precipitationCal"  \cr
#' band "precipitationUncal"  \cr
#' band "probabilityLiquidPrecipitation"  \cr
#' band "randomError"  \cr
#' @param lonMin Minimum latitude of bounding box
#' @param lonMax Maximum latitude of bounding box
#' @param latMin Minimum longitude of bounding box
#' @param latMax Maximum longitude of bounding box
#' @param removeHDF5 Remove HD5 files after the conversion to NetCDF
#' @param quiet logical; suppress info of the download.
#'
#' @author Cesar Aybar
#' @source https://github.com/csaybar/gpm/
#' @note Modified by Ahmed Homoudi, November 2022.
#' @examples
#' \dontrun{
#' gpm_download(path = '.',
#'             user = 'you_user@gmail.com',
#'             password = 'you_user@gmail.com',
#'             dates = c('2018-01-01'),
#'             product = 'finalrun')
#' }
#' @export

gpm_download <- function(path,
                         user,
                         password,
                         dates,
                         product,
                         band="precipitationCal",
                         lonMin = -86,
                         lonMax = -66,
                         latMin = -19.25,
                         latMax = 1.25,
                         removeHDF5 = TRUE,
                         quiet = TRUE
) {


# Create a list with the files to download --------------------------------

  message('Searching the IMERG-HDF5 files ... please wait')
  userpwd <- sprintf("%s:%s",user,password)

  # calculate Julian day
  J.day<-format(as.Date(dates), "%j")

  if (product == 'early'){
    url<-"https://gpm1.gesdisc.eosdis.nasa.gov/data/GPM_L3/GPM_3IMERGHHE.06"

    #get sub directory
    url_d <- paste0(url,
                    "/",
                    lubridate::year(dates),
                    "/",
                    J.day,
                    "/")

    # Scrapping the http
    imerg_byday <- RCurl::getURL(url = url_d,
                                 ftplistonly = TRUE,
                                 userpwd = userpwd)

    # list split
    imerg_byday <-unlist(stringr::str_split(imerg_byday,'\r*\n'))


    imerg_byday <-lapply(imerg_byday, FUN = function(x){
      stringr::str_extract(string = x,
                           pattern = "(?<=3B).*(?=HDF5\"><img)")
    })

    # remove NA
    imerg_byday<- imerg_byday[!is.na(imerg_byday)]%>%
      unlist()


    # fix files names
    imerg_byday<-paste0("3B",
                        imerg_byday,
                        "HDF5")

    # make download links
    imerg_links<-paste0(url_d,
                        imerg_byday)

    #test
    # writeLines(imerg_byday, con = "index.html")
    # # (code to write some content to the file)
    # rstudioapi::viewer("index.html")

  } else if (product == 'late'){
    url<-"https://gpm1.gesdisc.eosdis.nasa.gov/data/GPM_L3/GPM_3IMERGHHL.06"

    #get sub directory
    url_d <- paste0(url,
                    "/",
                    lubridate::year(dates),
                    "/",
                    J.day,
                    "/")

    # Scrapping the http
    imerg_byday <- RCurl::getURL(url = url_d,
                                 ftplistonly = TRUE,
                                 userpwd = userpwd)

    # list split
    imerg_byday <-unlist(stringr::str_split(imerg_byday,'\r*\n'))


    imerg_byday <-lapply(imerg_byday, FUN = function(x){
      stringr::str_extract(string = x,
                           pattern = "(?<=3B).*(?=HDF5\"><img)")
    })

    # remove NA
    imerg_byday<- imerg_byday[!is.na(imerg_byday)]%>%
      unlist()


    # fix files names
    imerg_byday<-paste0("3B",
                        imerg_byday,
                        "HDF5")

    # make download links
    imerg_links<-paste0(url_d,
                        imerg_byday)


  } else if (product == 'finalrun'){
    url<-"https://gpm1.gesdisc.eosdis.nasa.gov/data/GPM_L3/GPM_3IMERGHH.06"

    #get sub directory
    url_d <- paste0(url,
                    "/",
                    lubridate::year(dates),
                    "/",
                    J.day,
                    "/")

    # Scrapping the http
    imerg_byday <- RCurl::getURL(url = url_d,
                                 ftplistonly = TRUE,
                                 userpwd = userpwd)

    # list split
    imerg_byday <-unlist(stringr::str_split(imerg_byday,'\r*\n'))


    imerg_byday <-lapply(imerg_byday, FUN = function(x){
      stringr::str_extract(string = x,
                           pattern = "(?<=3B).*(?=HDF5\"><img)")
    })

    # remove NA
    imerg_byday<- imerg_byday[!is.na(imerg_byday)]%>%
      unlist()


    # fix files names
    imerg_byday<-paste0("3B",
                        imerg_byday,
                        "HDF5")

    # make download links
    imerg_links<-paste0(url_d,
                        imerg_byday)

  } else {
    stop('The "product" argument only can be: "finalrun", "late" or "early".')
  }

  # Downloading one by one the IMERG files ----------------------------------


  # sort files/links
  imerg_byday<-sort(imerg_byday)
  imerg_links<-sort(imerg_links)

  # donload HDF5 files
  lapply(imerg_links, function(x){

    wget.R(url = x,
           user,
           userpwd,
           dest_path = path,
           quiet)

  })

  HDF5.files<-list.files(path = path,
                         pattern = ".HDF5$",
                         full.names = T)

  # loop over HDF5 files to convert to netcdf

  for ( ifile in 1:length(HDF5.files)){

    # get data
    r<-terra::rast(HDF5.files[ifile])[band]

    #transpose the SpatRaster
    r <- terra::t(r)

    #flip the SpatRaster
    r <- terra::flip(r, "v")

    # define the extent of the SpatRaster
    terra::ext(r) <- c(-180, 180,-90, 90)

    study_ext<-terra::ext(lonMin, lonMax, latMin, latMax)

    #crop the SpatRaster
    r<-terra::crop(r,study_ext)

    #assign CRS
    terra::crs(r)<-"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

    # get time
    Mittel_time<-get_time_from_HDF5_filename(HDF5.files[ifile])

    # assign time
    terra::time(r)<-Mittel_time

    #assign units
    terra::units(r)<-"mm hr -1"

    #assign short name
    terra::varnames(r)<-band

    #assign long name
    terra::longnames(r)<-band

    # combine files
    if(ifile==1){
      r.final<-r
    }else{
      r.final<-c(r.final,r)
    }
    #terra::plot(r)
  }

  # remove
  rm(r);gc(verbose = FALSE)


# Writing netCDF file  ----------------------------------------------------



  TIME1<- format(terra::time(r.final)[1]-15*60+1, format = "%Y%m%d-%H%M%S")
  TIME2<- format(terra::time(r.final)[terra::nlyr(r.final)]+15*60+1,
                 format = "%Y%m%d-%H%M%S")


  ncname<-paste0("3B-HHR.MS.MRG.3IMERG.","_",TIME1,"_",TIME2,
                 "_",band,"_.nc")
  #netCDF file location

  ncfname <- paste0(path, ncname)

  terra::writeCDF(x = r.final,
           filename = ncfname,
           zname = "time",
           varname = band,
           compression = 9,
           missval=1e32,
           overwrite=TRUE)

  rm(r.final);gc(verbose = F)

  # clean
  if(removeHDF5){
    file.remove(HDF5.files)
  }

  message('Finisnsed downloading the requested data ;-)')

  }
