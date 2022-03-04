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
#' @examples 
#' ## Load data set
#' data("NLSY_IQ")
#'  
#' ## Set age and race as factor variables
#' NLSY_IQ$age <- factor(NLSY_IQ$age)
#' NLSY_IQ$race <- factor(NLSY_IQ$race)
#'    
#' ## Collect parameters from the short, intermediate and auxiliary regressions
#' parameters <- collect_par(
#' data = NLSY_IQ, outcome = "iq_std", 
#' treatment = "BF_months", 
#' control = c("age","sex","income","motherAge","motherEDU","mom_married","race"),
#' other_regressors = c("sex","age"))
#' 
#' ## Set limits for the bounded box
#' Rlow <- parameters$Rtilde
#' Rhigh <- 0.61
#' deltalow <- 0.01
#' deltahigh <- 0.99
#' e <- 0.01
#' 
#' ## Compute bias and bias-adjusted treatment effect
#' OVB <- ovbias(
#' parameters = parameters, 
#' deltalow=deltalow, 
#' deltahigh=deltahigh, Rhigh=Rhigh, 
#' e=e)
#' 
#' ## Contour Plot of bias over the bounded box
#' p2 <- cplotbias(OVB$Data)
#' print(p2)
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
