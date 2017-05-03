#' Calculates day length (in hours) and the solar elevation above the
#' ecliptic plane based upon latitude and a day of year value.
#'
#' Different cost functions can be specified if they adhere to the
#' same basic structure in their parameters. Currently only RMSE is
#' provided as a cost function, defined as rmse().
#'
#' @param par: a vector of parameter values, this is functions specific
#' @param data: a nested list of data with one location:
#' 1. the date (doy or long format)
#' 2. the temperature data
#' 3. the photoperiod data (NA when not needed)
#' 4. a vector or matrix with necessary constants (NA when not needed)
#'    - long term mean temperature
#'    - latitude
#'    - etc...
#' 5. validation data (necessary!!)
#' @param model: the model name to be used in optimizing the model
#' Most models are listed in Melaas et al. 2013, additional ones
#' will be added over time, preliminary list:
#' 1. SEQ1.3
#' @keywords phenology, model, sequential
#' @export
#' @examples
#'
#' #' \dontrun{
#' cost_value = rmse(par,data,model="TTs")
#'
#' # The cost function returns the rmse between the
#' # true values and those generated by the model given a
#' # parameterset par.
#' }

rmse = function(par, data, model) {

  # inset validity checks
  val = data$transition_dates
  out = do.call(model,list(data = data, par = par))

  if (any(is.na(out))) {
    return(9999)
  } else {
    # return the RMSE between the validation data and
    # the output of the model
    return(sqrt(mean((val - out) ^ 2, na.rm = T)))
  }
}
