#' @export
#' @title Adorn PVLS and EMR indicator data with metadata.
#'
#' @description
#' Takes in an unadorned dataframe of PVLS and EMR data in the format exported
#' by the `get_pvls_emr_table()` function and adorns it with all of the
#' appropriate metadata for Data Elements, Category Option Combos,
#' Organisation unit names and UIDs, Organisation unit hierarchy, and periods.
#'
#' @param pvls_emr_raw Unadorned dataframe of PVLS and EMR indicator data.
#' @param coc_metadata Dataframe containing category option combination
#' metadata.
#' @param de_metadata Dataframe containing data element metadata.
#' @param pe_metadata Dataframe containing period metadata.
#'
#' @return Dataframe containing adorned PVLS and EMR indicator data.
#'
adorn_pvls_emr <- function(pvls_emr_raw = NULL,
                           coc_metadata = NULL,
                           de_metadata = NULL,
                           pe_metadata = NULL) {

  pvls_emr %<>%
    # Joins to period data and cleans and filters periods
    dplyr::left_join(pe_metadata, by = "periodid") %>%

    # Filters for only Calendar Q3 / Fiscal Q4 results
    dplyr::filter(substring(.data$iso, 5, 6) == "Q3") %>%
    dplyr::mutate(period = as.numeric(substring(.data$iso, 1, 4))) %>%

    # Joins to Data Element, Category Option Combo, and Attribute Metadata
    dplyr::left_join(de_metadata, by = "dataelementid") %>%
    dplyr::left_join(coc_metadata, by = "categoryoptioncomboid") %>%
    # dplyr::left_join(coc_metadata %>%
    #                    dplyr::select(.data$categoryoptioncomboid,
    #                                  attributename =
    #                                    .data$categoryoptioncomboname),
    #                  by = c("attributeoptioncomboid" =
    #                           "categoryoptioncomboid")) %>%

    # Drops a number of columns before continuing on
    dplyr::select(-.data$iso, -.data$periodid, -.data$attributeoptioncomboid,
                  -.data$dataelementid, -.data$categoryoptioncomboid) %>%

    # Cleans indicator names and pivots data
    dplyr::mutate(indicator = dplyr::case_when(
      .data$dataelementname == "EMR_SITE (N, NoApp, Serv Del Area)" &
        .data$categoryoptioncomboname ==
        "Service Delivery Area - Care and Treatment" ~ "emr_tx",
      .data$dataelementname == "EMR_SITE (N, NoApp, Serv Del Area)" &
        .data$categoryoptioncomboname ==
        "Service Delivery Area - HIV Testing Services" ~ "emr_hts",
      .data$dataelementname == "EMR_SITE (N, NoApp, Serv Del Area)" &
        .data$categoryoptioncomboname ==
        "Service Delivery Area - ANC and/or Maternity" ~ "emr_anc",
      .data$dataelementname == "EMR_SITE (N, NoApp, Serv Del Area)" &
        .data$categoryoptioncomboname ==
        "Service Delivery Area - HIV/TB" ~ "emr_tb",
      substring(.data$dataelementname, 1, 10) == "TX_PVLS (N" ~ "tx_pvls_n",
      substring(.data$dataelementname, 1, 10) == "TX_PVLS (D" ~ "tx_pvls_d",
      TRUE ~ NA_character_
    )) %>%

    # TODO Clean and bring categoryOptionCombos into the rest of the app
    dplyr::select(-.data$dataelementname, -.data$categoryoptioncomboname) %>%
    tidyr::pivot_wider(names_from = .data$indicator,
                       values_from = .data$value,
                       values_fn = list(value = list)) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      emr_TX_CURR = any(as.logical(unlist(.data$emr_tx))),
      emr_TX_NEW = any(as.logical(unlist(.data$emr_tx))),
      emr_HTS_TST = any(as.logical(unlist(.data$emr_hts))),
      emr_PMTCT_STAT = any(as.logical(unlist(.data$emr_anc))),
      emr_PMTCT_ART = any(as.logical(unlist(.data$emr_anc))),
      emr_TB_PREV = any(as.logical(unlist(.data$emr_tb))),
      tx_pvls_n = sum(as.numeric(unlist(.data$tx_pvls_n))),
      tx_pvls_d = sum(as.numeric(unlist(.data$tx_pvls_d)))
    ) %>%
    dplyr::select(-.data$emr_tx, -.data$emr_hts,
                  -.data$emr_anc, -.data$emr_tb) %>%
    dplyr::mutate(dplyr::across(.cols = dplyr::starts_with("emr_"),
                                .fns = ~ tidyr::replace_na(.x, FALSE))) %>%

    # Pivots EMR data back to long data format and replaces NAs with FALSE
    tidyr::pivot_longer(cols = tidyr::starts_with("emr_"),
                        names_to = "indicator",
                        names_prefix = "emr_",
                        values_to = "emr_at_site_for_indicator") %>%
    dplyr::mutate(
      indicator = dplyr::case_when(
        indicator == "TB_PREV" & period < 2020 ~ "TB_PREV_LEGACY",
        indicator == "TB_PREV" & period >= 2020 ~ "TB_PREV",
        TRUE ~ indicator
      )
    ) %>%

    # Organizes columns for export
    dplyr::select(
      organisationunitid = .data$sourceid, .data$period, .data$indicator,
      .data$emr_at_site_for_indicator, .data$tx_pvls_n, .data$tx_pvls_d
    )

  return(pvls_emr)
}
