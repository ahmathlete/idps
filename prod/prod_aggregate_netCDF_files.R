

.libPaths("/home/h7/user/R-Packages")
path <- "/scratch/ws/1/user-GPM_new/DATA_daily/"
path <-"/media/ahmed/Volume/PhD/Codes/R_Packages/testing/"
output.path<- "/media/ahmed/Volume/PhD/Codes/R_Packages/testing"

netCDF.files<-list.files(path = path,
                         full.names = T,
                         pattern = ".nc$")

aggregate_netCDF_files(netCDF.files,
                       output.path)
