#' @title Aggregate netCDF files to monthly files.
#' @description A function to split the monthly netCDF files to precipitation
#' systems files, the splitting will search for time steps with precipitation less
#' than the provided threshold. Afterwards, this time step will be remove and
#' data after and before will be split to tmp netCDF files.
#'
#' @param netCDF.files A character vector listing all netCDF files
#' @param threshold A numeric value representing the minimum precipitation rate
#' that will be considered to delineate the precipitation objects, e.g. 5 mm/hr
#'
#' @param output.path A character indicating where to place output files.
#'
#' @return netCDF file
#' @author Ahmed Homoudi
#' @export

separate_netCDF_files <- function(netCDF.files,
                                  threshold,
                                  output.path = "~") {

  # stop if not a list
  stopifnot(!is.na(netCDF.files))

  meta.data <- lapply(netCDF.files, function(x) {
    y <- unlist(stringr::str_split(x, pattern = "_"))

    # 15 becaue yyyymmdd-hhmmss
    x.times <- y[grep(pattern = "-", y) & nchar(y) == 15]

    return(c(x, x.times))
  })

  meta.data <- as.data.frame(do.call(rbind, meta.data))

  names(meta.data) <- c("file", "start", "end")


  # estimate month-year
  meta.data$MON <- lubridate::month(as.Date(meta.data$start, format = "%Y%m%d-%H%M%S"))
  meta.data$YEAR <- lubridate::year(as.Date(meta.data$start, format = "%Y%m%d-%H%M%S"))
  meta.data$unique_month <- paste0(
    meta.data$MON,
    "-",
    meta.data$YEAR
  )

  unique_month <- unique(meta.data$unique_month)

  for (iunique in 1:length(unique_month)) {
    sub.meta <- meta.data[meta.data$unique_month == unique_month[iunique], ]


    # read the files
    r <- terra::rast(sub.meta$file)

    r.time <- terra::time(r)

    band <- unique(terra::varnames(r))
    # Writing netCDF file  ------------

    TIME1 <- format(r.time[1] - 15 * 60 + 1, format = "%Y%m%d-%H%M%S")
    TIME2 <- format(r.time[terra::nlyr(r)] + 15 * 60 + 1,
      format = "%Y%m%d-%H%M%S"
    )


    ncname <- paste0(
      "3B-HHR.MS.MRG.3IMERG.", "_", TIME1, "_", TIME2,
      "_", band, "_.nc"
    )
    # netCDF file location

    ncfname <- paste0(output.path, ncname)

    terra::writeCDF(
      x = r,
      filename = ncfname,
      zname = "time",
      varname = band,
      compression = 9,
      missval = 1e32,
      overwrite = TRUE
    )
  }

  message("Finishsed producing tmp files;-)")
}
