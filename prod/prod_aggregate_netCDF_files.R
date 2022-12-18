

.libPaths("/home/h7/user/R-Packages")
path <- "/beegfs/.global1/ws/ahho623a-byebye_scratch/DATA_daily"
output.path<- "/beegfs/.global1/ws/ahho623a-byebye_scratch/DATA_monthly"

netCDF.files<-list.files(path = path,
                         full.names = T,
                         pattern = ".nc$")

aggregate_netCDF_files(netCDF.files,
                       output.path)
