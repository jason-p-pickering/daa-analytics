% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/combine-data.R
\name{combine_data}
\alias{combine_data}
\title{Combine DAA datasets together.}
\usage{
combine_data(daa_indicator_data, ou_hierarchy, pvls_emr, attribute_data)
}
\arguments{
\item{daa_indicator_data}{Dataframe containing DAA indicator data.}

\item{ou_hierarchy}{Dataframe containing the Organisational hierarchy.}

\item{pvls_emr}{Dataframe of PVLS and EMR data joined with metadata.}

\item{attribute_data}{Dataframe of site attribute data.}
}
\value{
A dataframe containing the DAA indicator data, PVLS and EMR indicator
data, and the site attribute data for a single country.
}
\description{
Combines DAA Indicator, PVLS and EMR data, and Site attribute data together
and exports them as a single dataframe.
}
