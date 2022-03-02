#' Create contour plot of bias
#'
#' @param data A data frame that is the output from the "ovbias" function.
#'
#' @return A plot object created with ggplot
#' @export
#'
#' 
cplotbias <- function(data){
  # data frame
  d1 <- data
  # create plot
  p <- ggplot(d1, aes(x=delta,y=Rmax,z=bias)) +
    stat_contour_filled() +
    theme_minimal() +
    labs(
      x=TeX("$\\delta$"),
      y=TeX("$R_{max}$")
    ) +
    guides(fill=guide_legend(title="Bias"))
  # return plot
  return(p)
}
