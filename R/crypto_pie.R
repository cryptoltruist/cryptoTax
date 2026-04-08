.validate_crypto_pie_by <- function(by) {
  if (!by %in% c("exchange", "revenue.type")) {
    stop("`by` must be either 'exchange' or 'revenue.type'.")
  }
}

.crypto_pie_colors <- function(n) {
  grDevices::colorRampPalette(RColorBrewer::brewer.pal(8, "Pastel1"))(n)
}

.prepare_exchange_pie_data <- function(table.revenues) {
  pie.data <- table.revenues %>%
    filter(.data$exchange != "total") %>%
    arrange(desc(.data$exchange)) %>%
    mutate(position = cumsum(.data$total.revenues) - 0.5 * .data$total.revenues)

  pie.data %>%
    mutate(my.label = paste0("$", .data$total.revenues, "\n", .data$exchange))
}

.prepare_revenue_type_pie_data <- function(table.revenues) {
  table.revenues %>%
    filter(.data$exchange != "total") %>%
    select("airdrops":"mining") %>%
    summarize(across(tidyselect::where(is.numeric), \(x) sum(x, na.rm = TRUE))) %>%
    round(2) %>%
    t() %>%
    as.data.frame() %>%
    filter(.data$V1 != 0) %>%
    dplyr::mutate(revenue.type = rownames(.)) %>%
    dplyr::rename(total.revenues = "V1") %>%
    select("total.revenues":"revenue.type") %>%
    arrange(desc(.data$revenue.type)) %>%
    mutate(
      position = cumsum(.data$total.revenues) - 0.5 * .data$total.revenues,
      my.label = paste0("$", .data$total.revenues, "\n", .data$revenue.type)
    )
}

#' @title Make a pie chart of your crypto revenues
#'
#' @description Make a pie chart of your crypto revenues.
#' @param table.revenues The revenue table to plot
#' @param by To plot by which element, one of `c("exchange", "revenue.type")`.
#' @return A ggplot2 object in the form of a pie chart.
#' @export
#' @examples
#' all.data <- format_exchanges(list(data_shakepay, data_newton))
#' formatted.ACB <- format_ACB(all.data, verbose = FALSE)
#' table.revenues <- report_revenues(formatted.ACB)
#' crypto_pie(table.revenues)
#' crypto_pie(table.revenues, by = "revenue.type")
#' @importFrom dplyr %>% filter arrange mutate select summarize desc
#' @importFrom rlang .data
crypto_pie <- function(table.revenues, by = "exchange") {
  .validate_crypto_pie_by(by)
  pie.data <- if (by == "exchange") {
    .prepare_exchange_pie_data(table.revenues)
  } else {
    .prepare_revenue_type_pie_data(table.revenues)
  }
  mycolors <- .crypto_pie_colors(nrow(pie.data))

  # Make the actual pie chart!
  pie <- pie.data %>%
    ggplot2::ggplot(ggplot2::aes(x = "", y = .data$total.revenues, fill = .data[[by]])) +
    ggplot2::geom_col(width = 2.5, colour = "black", linewidth = 1.5) +
    ggplot2::scale_fill_manual(values = mycolors) +
    ggplot2::coord_polar("y") +
    ggrepel::geom_label_repel(ggplot2::aes(y = .data$position, label = .data$my.label),
      size = 5, nudge_x = 1.5, show.legend = FALSE,
      label.padding = 0.5, box.padding = 0.5
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = "none")
  pie
}
