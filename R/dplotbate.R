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
#' e <- 0.03
#' 
#' ## Compute bias and bias-adjusted treatment effect
#' OVB <- ovbias(
#' parameters = parameters, 
#' deltalow=deltalow, 
#' deltahigh=deltahigh, Rhigh=Rhigh, 
#' e=e)
#'
#' ## Histogram and density Plot of bstar distribution
#' p3 <- dplotbate(OVB$Data)
#' print(p3)
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
      title=TeX("Distribution of $\\beta$*")
    ) +
    theme_minimal()
  
  # Return plot
  return(p)
}
