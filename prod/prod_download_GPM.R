
# Download GPM data for the study area

.libPaths("/home/h7/ahho623a/R-Packages")
path <- "/scratch/ws/1/ahho623a-GPM_new/DATA_daily/"
user <- "AhmedHomoudi"
password <- "yRqQCvm7t5fErhg"
dates <- seq.Date(as.Date("2000-06-01"),as.Date("2021-09-30"), by="day")
product <- 'finalrun'
band<-"precipitationCal"
lonMin <- 20
lonMax <- 70
latMin <- -5
latMax <- 40
removeHDF5 <- TRUE
quiet <- TRUE

library(idps)

for (idate in 1:length(dates)){

  new.path<-paste0(path, format(dates[idate], "%Y%m%d"))
  gpm_download(path = new.path,
               user = user,
               password = password,
               dates = dates[idate],
               product,
               band= "precipitationCal",
               lonMin = lonMin,
               lonMax = lonMax,
               latMin = latMin,
               latMax = latMax,
               removeHDF5 = TRUE,
               quiet = TRUE)
}
