# This function gets the mean time from HDF5 file name
get_time_from_HDF5_filename <- function(hdf5.name) {
  hdf5.names <- unlist(stringr::str_split(hdf5.name, "[.]"))

  time_part <- unlist(stringr::str_split(grep(pattern = "-S", hdf5.names, value = T), "-"))

  time_bounds <- c(
    lubridate::ymd_hms(paste0(
      time_part[1],
      gsub("[^0-9.-]", "", time_part[2])
    )),
    lubridate::ymd_hms(paste0(
      time_part[1],
      gsub("[^0-9.-]", "", time_part[3])
    ))
  )

  return(mean(time_bounds))
}


# use wget to download GPM files as HDF5
wget.R <- function(url, user, password, dest_path, quiet) {
  if (Sys.info()[1] == "Windows") {
    wget_command <- "wget --load-cookies C:\\.urs_cookies C:\\.urs_cookies "
  } else {
    wget_command <- "wget --load-cookies "
  }

  if (quiet) {
    wget_command <- paste(wget_command, "--no-verbose")
  }

  # add destiantion path
  wget_command <- paste0(wget_command, " --directory-prefix=", dest_path)

  # add credentials
  wget_command <- paste(
    wget_command,
    "--user",
    user,
    "--password",
    password,
    url
  )

  system(wget_command)
}


# check the continuity of the daily downloaded files.

check_missing_days <- function(path2netcdf_files = "~/",
                               expected_start = "2000-06-01",
                               expected_end = "2021-09-30") {
  path2netcdf_files <- "/beegfs/.global1/ws/ahho623a-byebye_scratch/DATA_daily"
  expected_start <- "2000-06-01"
  expected_end <- "2021-09-30"
  # list files
  nc.files <- list.files(path2netcdf_files, pattern = ".nc$")

  Dates <- seq.Date(as.Date(expected_start), as.Date(expected_end), by = "day")

  meta.data <- lapply(nc.files, function(x) {
    y <- unlist(stringr::str_split(x, pattern = "_"))

    # 15 because yyyymmdd-hhmmss
    x.times <- y[!is.na(readr::parse_number(y)) & nchar(y) == 15]

    x.times <- y[grep(pattern = "-", y) & nchar(y) == 15]

    return(c(x, x.times))
  })

  meta.data <- as.data.frame(do.call(rbind, meta.data))

  meta.data$DATE1 <- as.Date(lubridate::ymd_hms(meta.data$V2))
  meta.data$DATE2 <- as.Date(lubridate::ymd_hms(meta.data$V3))


  if (length(Dates) != length(nc.files)) {
    message(paste0(
      "There is ",
      length(Dates) - length(nc.files)
    ))

    # missing files
    message(" Missing Dates are: ")
    print(unique(Dates[!Dates %in% meta.data$DATE1]))
  } else {
    message("No missing files. Now checking missting timesteps withing the daily files.")
  }


  # check that all hours should be 00:00:00

  wrong_starts <- meta.data$V2[!endsWith(meta.data$V2, "000000")]
  wrong_ends <- meta.data$V3[!endsWith(meta.data$V3, "000000")]

  message("These days needs to be redownloaded:")
  print(as.Date(lubridate::ymd_hms(c(
    wrong_starts,
    wrong_ends
  ))))
}
