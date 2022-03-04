#' Histogram of bias adjusted treatment effect
#'
#' @param data A data frame that is the output from the "ovbias" function.
#'
#' @importFrom magrittr "%>%"
#' @importFrom stats "lm"
#' @importFrom stats "sd"
#' @importFrom stats "var"
#' @importFrom stats "as.formula"
#' @importFrom tidyselect "all_of"
#' 
#' @importFrom ggplot2 "geom_density"
#' @importFrom ggplot2 "geom_histogram"
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
#' @return A plot object created with ggplot
#' @export
#'
#' 
dplotbate <- function(data){
  
  # Bin width for histogram
  mybwd <- (max(data$bstar)-min(data$bstar))/50
  
  # Bin width for histogram
  mybwd <- (max(data$bstar)-min(data$bstar))/50
  
  # Create histogram with density
  p <- ggplot(data = data.frame(bstar=data$bstar), aes(x=bstar)) +
    geom_histogram(aes(y=..density..),binwidth = mybwd,
                   color="grey", fill="grey") +
    geom_density(color="red", size=1) +
    labs(
      x=TeX("$\\beta$*"),
      y="",
      title=TeX("Distribution of Bias Adjusted Treatment Effect $\\beta$*")
    ) +
    theme_minimal()
  
  # Return plot
  return(p)
}
