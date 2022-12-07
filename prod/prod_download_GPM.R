
DATE1<-"2000-06-01"
DATE2<-"2021-09-30"

# Download GPM data for the study area

.libPaths("/home/h7/user/R-Packages")
path <- "/scratch/ws/1/user-GPM_new/DATA_daily/"
user <- "user"
password <- "password"
Dates <- seq.Date(as.Date(DATE1),as.Date(DATE2), by="day")
product <- 'finalrun'
band<-"precipitationCal"
lonMin <- 20
lonMax <- 70
latMin <- -5
latMax <- 40
removeHDF5 <- TRUE
quiet <- TRUE

library(idps)

for (idate in 1:length(Dates)){

  new.path<-paste0(path, format(Dates[idate], "%Y%m%d"), "/")
  gpm_download(path = new.path,
               user = user,
               password = password,
               dates = Dates[idate],
               product,
               band= "precipitationCal",
               lonMin = lonMin,
               lonMax = lonMax,
               latMin = latMin,
               latMax = latMax,
               removeHDF5 = TRUE,
               quiet = TRUE)
}
