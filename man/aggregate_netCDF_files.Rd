% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregate_netCDF_files.R
\name{aggregate_netCDF_files}
\alias{aggregate_netCDF_files}
\title{Aggregate netCDF files to monthly files.}
\usage{
aggregate_netCDF_files(netCDF.files, output.path = "~")
}
\arguments{
\item{netCDF.files}{A character vector listing all netCDF files}

\item{output.path}{A character indicating where to place output files.}
}
\value{
netCDF file
}
\description{
A function to aggregate daily netCDF files
to monthly files that include the original temporal resolution
for the respective month
}
\author{
Ahmed Homoudi
}
