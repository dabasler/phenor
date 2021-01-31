#' Download NASA Earth Exchange Global Daily Downscaled Projections (NEX-GDDP)
#' https://nex.nasa.gov/nex/.
#'
#' When downloading data for a particular year the antecedent year will
#' be downloaded as well as the format_cmip5() routine often requires a
#' matching dataset.
#'
#' CMIP 5 models included are:
#' ACCESS1-0, CSIRO-MK3-6-0, MIROC-ESM, BCC-CSM1-1, GFDL-CM3, MIROC-ESM-CHEM,
#' BNU-ESM, GFDL-ESM2G, MIROC5, CanESM2, GFDL-ESM2M, MPI-ESM-LR, CCSM4, INM-CM4,
#' MPI-ESM-MR, CESM1-BGC, IPSL-CM5A-LR, MRI-CGCM3, CNRM-CM5,
#' IPSL-CM5A-MR, NorESM1-M
#'
#' @param path a path where to save the gridded data
#' @param year year to process (also requests year - 1)
#' @param model CMIP5 model data to download (character vector)
#' @param scenario which RCP scenario to select for (default = "rcp85")
#' @param variable which climate variables to download (tasmin, tasmax, pr)
#' (default = c("tasmin","tasmax","pr"))
#' @return nothing is returned to the R working environment, files are
#' downloaded and stored on disk
#' @keywords phenology, model, data
#' @export
#' @examples
#'
#' # donwload all gridded data for year 2011 (and 2010)
#' # and format the data correctly.
#' \dontrun{
#' pr_dl_cmip5(year = 2011,
#'                path = tempdir(),
#'                model = "MIROC5",
#'                scenario = "rcp85")
#'
#' cmip5_data <- pr_fm_cmip5(path = tempdir(),
#'                           offset = 264,
#'                           model = "MIROC5",
#'                           scenario = "rcp85",
#'                           year = 2011)
#'}

# create subset of layers to calculate phenology model output on
pr_dl_cmip5 <- function(
  path = tempdir(),
  year = 2016,
  model = "MIROC5",
  scenario = "rcp85",
  variable = c("tasmin","tasmax","pr")
  ){

  # data file list, on amazon S3 server (which is a bit more stable
  # than the GDDP ftp server)
  files = utils::read.table(
    "https://nex.nasa.gov/static/media/dataset/nex-gddp-s3-files.csv",
    sep = ',',
    header = TRUE,
    stringsAsFactors = FALSE)$s3url

  # selection
  selection = do.call("c",lapply(files, function(x){
    # grep the files for multiple selection
    # criteria
    if(all(c(grepl(paste(c(year,year - 1), collapse = "|"), x),
             grepl(paste(variable, collapse = "|"), x),
             grepl(scenario, x),
             grepl(paste(model, collapse = "|"), x)))){
        return(x)
      }else{
        return(NULL)
    }
    }))

  # trap cases where the slection of files is NULL (no matches)
  # return error
  if(is.null(selection)){
    stop("No files meet the specified criteria, please check the parameters!")
  }

  # download data
  lapply(selection, function(i){

    # set download / filename strings
    file_location = sprintf("%s/%s", path, basename(i))

    # feedback on which file is being downloaded
    cat(paste0("Downloading: ", basename(i), "\n"))

    # sleep for a bit to give the server a break
    # and not get kicked
    Sys.sleep(1)

    # try to download the data if the file does not
    # exist
    if(!file.exists(file_location)){
      error = try(
        httr::with_config(httr::config(maxconnects = 1),
          httr::GET(url = i,
                        httr::write_disk(path = file_location,
                                         overwrite = FALSE),
                        httr::progress())),
                  silent = FALSE)

      # garbage collection
      gc()

      # check if things downloaded fine
      if (inherits(error, "try-error")){
        file.remove(file_location)
        stop("failed to download the requested data, check your connection")
      }
    } else {
      cat("local file exists, skipping download \n")
    }
  })

  # feedback
  cat("Download complete! \n")
}
