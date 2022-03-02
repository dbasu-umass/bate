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

# This function creates a filled contour plot
# of the magnitude of betastar over the points of
# a box in the (x=delta, y=Rmax) plane.
# "data" is the output from the "ovbias" function
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
