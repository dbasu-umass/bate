#' Create contour plot of bias
#'
#' @param data A data frame that is the output from the "ovbias" function.
#'
#' @importFrom latex2exp "TeX"
#' @importFrom ggplot2 "aes"
#' @importFrom ggplot2 "ggplot"
#' @importFrom ggplot2 "guide_legend"
#' @importFrom ggplot2 "stat_contour_filled"
#' @importFrom ggplot2 "theme_minimal"
#' @importFrom ggplot2 "labs"
#' @importFrom ggplot2 "guides"
#' 
#' 
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
