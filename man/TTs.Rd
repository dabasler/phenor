% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phenology_models.R
\name{TTs}
\alias{TTs}
\title{Thermal Time model}
\usage{
TTs(par, data)
}
\arguments{
\item{par}{a vector of parameter values, this is functions specific}

\item{data}{input data (see reference for detailed description),
data should be formatted using flat_format()}
}
\value{
raster or vector with estimated phenophase timing (in DOY)
}
\description{
as defined in
Basler et al. 2016 (Agr. For. Meteorlogy)
with a sigmoidal temperature response (Kramer 1994)
}
\examples{

\dontrun{
estimate <- TTs(data = data, par = par)
}
}
\keyword{model}
\keyword{phenology,}
