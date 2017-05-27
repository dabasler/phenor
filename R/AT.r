#' Alternating model as defined in
#' Basler et al. 2016 (Agr. For. Meteorlogy)
#'
#' @param data: a nested list of data
#' @param par: a vector of parameter values, this is functions specific
#' @keywords phenology, model
#' @export
#' @examples
#'
#' \dontrun{
#' estimate = AT(data = data, par = par)
#'}

AT = function(par, data, plot = TRUE){

  # exit the routine as some parameters are missing
  if (length(par) != 5){
    stop("model parameter(s) out of range (too many, too few)")
  }

  # extract the parameter values from the
  # par argument for readability
  t0 = round(par[1])
  T_base = par[2]
  a = par[3]
  b = par[4]
  c = par[5]

  # chilling
  Rc = data$Ti - T_base
  Rc[Rc < 0] = 1
  Rc[Rc >= 0] = 0
  Rc[1:t0,] = 0
  Sc = apply(Rc, 2, cumsum)

  # forcing
  Rf = data$Ti - T_base
  Rf[Rf <= 0] = 0
  Rf[1:t0,] = 0
  Sf = apply(Rf, 2, cumsum)

  Sfc = Sf - (a + b * exp(c * Sc))

  doy = apply(Sfc, 2, function(x){
    doy = data$doy[which(x > 0)[1]]
    doy[is.na(doy)] = 9999
    return(doy)
    })

  # set export format, either a rasterLayer
  # or a vector
  if(is.null(data$site)){
    r = raster(nrows = data$georeferencing$size[1],
               ncols = data$georeferencing$size[2])
    extent(r) = data$georeferencing$extent
    proj4string(r) = CRS(data$georeferencing$projection)
    r[] = doy
    r[r==9999] = NA
    return(r)
  } else {
    return(doy)
  }

}
