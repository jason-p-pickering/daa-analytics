% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create-hiearchy.R
\name{create_hierarchy}
\alias{create_hierarchy}
\title{Generates Organisation Unit Hierarchy}
\usage{
create_hierarchy(ou_metadata)
}
\arguments{
\item{ou_metadata}{Dataframe containing organisation unit metadata.}
}
\value{
Dataframe containing wide format organisation unit hierarchy from
Level 3 to Level 7.
}
\description{
Uses the Organisation unit metadata file to generate a wide datatable of the
organisation unit hierarchy from Level 3 to Level 7.
}
