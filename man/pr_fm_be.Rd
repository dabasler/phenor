% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pr_fm_be.R
\name{pr_fm_be}
\alias{pr_fm_be}
\title{Formatting of Berkeley Earth Gridded temperature data}
\usage{
pr_fm_be(
  path = tempdir(),
  year = 2011,
  offset = 264,
  extent = c(-126, -66, 23, 54),
  internal = TRUE
)
}
\arguments{
\item{path}{a path to the gridded data, only average temperature
data will be considered}

\item{year}{year to process (requires year - 1 to be present)}

\item{offset}{offset of the time series in DOY (default = 264, sept 21)}

\item{extent}{geographic coordinates constraining the output, defined
as bottom left, top right c(lon1, lat1, lon2, lat2) (default =
c(-126, -66, 23, 54))}

\item{internal}{return results as an R variable or save as an RDS file}
}
\description{
Formatting of Berkeley Earth Gridded temperature data
}
\examples{

\dontrun{
# run with default settings
# extracts values of the referenced publication
# see github README
be_data <- pr_fm_be()
}
}
\keyword{model,}
\keyword{phenology,}
\keyword{preprocessing}
