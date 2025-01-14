% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adorn-pvls-emr-data.R
\name{adorn_pvls_emr}
\alias{adorn_pvls_emr}
\title{Adorn PVLS and EMR indicator data with metadata.}
\usage{
adorn_pvls_emr(
  pvls_emr_raw = NULL,
  coc_metadata = NULL,
  de_metadata = NULL,
  pe_metadata = NULL
)
}
\arguments{
\item{pvls_emr_raw}{Unadorned dataframe of PVLS and EMR indicator data.}

\item{coc_metadata}{Dataframe containing category option combination
metadata.}

\item{de_metadata}{Dataframe containing data element metadata.}

\item{pe_metadata}{Dataframe containing period metadata.}
}
\value{
Dataframe containing adorned PVLS and EMR indicator data.
}
\description{
Takes in an unadorned dataframe of PVLS and EMR data in the format exported
by the \code{get_pvls_emr_table()} function and adorns it with all of the
appropriate metadata for Data Elements, Category Option Combos,
Organisation unit names and UIDs, Organisation unit hierarchy, and periods.
}
