% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{weighted_concordance}
\alias{weighted_concordance}
\title{Calculate Weighted Concordance.}
\usage{
weighted_concordance(moh, pepfar, weighting)
}
\arguments{
\item{moh}{The number of patients reported by the MOH at the site.}

\item{pepfar}{The number of patients reported by PEPFAR at the site.}

\item{weighting}{The weighting factor given to the site.}
}
\value{
A single value for the weighted concordance of the site.
}
\description{
Calculates the weighted concordance for a given site using the total
number of patients reported by the MOH and PEPFAR as well as the
weighting factor.
}
