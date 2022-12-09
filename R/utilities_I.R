# This function gets the mean time from HDF5 file name
get_time_from_HDF5_filename<-function(hdf5.name){

  hdf5.names<- unlist(stringr::str_split(hdf5.name, "[.]"))

  time_part<-unlist(stringr::str_split(grep(pattern = "-S", hdf5.names, value = T), "-"))

  time_bounds<-c(lubridate::ymd_hms(paste0(time_part[1],
                            gsub("[^0-9.-]", "", time_part[2]))),
  lubridate::ymd_hms(paste0(time_part[1],
                            gsub("[^0-9.-]", "", time_part[3]))))

  return(mean(time_bounds))
}


# use wget to download GPM files as HDF5
wget.R <- function(url,user,password, dest_path, quiet){

  if (Sys.info()[1] == 'Windows') {
    wget_command <-"wget --load-cookies C:\\.urs_cookies C:\\.urs_cookies "
  }else{
    wget_command <-"wget --load-cookies "
  }

  if (quiet) {
    wget_command <-paste(wget_command, "--no-verbose")
  }

  # add destiantion path
  wget_command <-paste0(wget_command, " --directory-prefix=", dest_path)

  # add credentials
  wget_command<-paste(wget_command,
                      "--user",
                      user,
                      "--password",
                      password,
                      url)

  system(wget_command)
}


# check the continuity of the daily downloaded files.

check_downloaded_files<-function(x, x.start, x.end){

}
