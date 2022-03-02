#' Computes delta* according to Oster (2019)
#'
#' @param parameters A vector of parameters that is generated after estimating the short, intermediate and auxiliary regressions.
#' @param Rmax A real number that lies between Rtilde (R-squared for the intermediate regression) and 1. 
#'
#' @return A data frame with three columns:
#' 
#' \item{delstar}{The value of delta for the chosen value of Rmax}
#' \item{discontinuity}{Indicates whether the point of discontinuity is within the interval formed by Rtilde and 1}
#' \item{slope}{Slope of the function, delta=f(Rmax)}
#' 
#' @export
#'
#' 
osterdelstar <- function(parameters,Rmax){
  
  if(length(Rmax)>1 | !is.numeric(Rmax)) 
    stop("This function only takes one numeric input for Rmax")
  
  with(parameters,{
    
    A <- (betatilde*sigmay^2*(sigmax^2 - taux) +
            sigmay^2*sigmax^2*(beta0 - betatilde))
    
    B <- (betatilde^3*(sigmax^2*taux - taux^2) +
            betatilde^2*sigmax^2*taux*(beta0 - betatilde))
    
    C <- (betatilde*(sigmay^2)*taux*(Rtilde - R0) +
            betatilde*(sigmax^2)*taux*((beta0 - betatilde)^2) +
            betatilde^3*((sigmax^2)*taux - taux^2) +
            2*(betatilde^2)*(sigmax^2)*taux*(beta0 - betatilde))
    
    # Delta-star
    delstar <- C/(A*(Rmax - Rtilde) + B)
    
    # R-star (point of discontinuity)
    Rstar <- Rtilde - (B/A)
    
    # Discontinuity (1=yes,0=no)
    discont <- ifelse(
      (Rtilde <= Rstar) & (Rstar<=1),TRUE,FALSE
    )
    
    # Slope (1=negative, 0=positive)
    dydx <- ifelse(
      (sign(A)==sign(C)),"Negative","Positive"
    )
    
    # Create output dataframe
    output <- c("deltastar"=delstar,
                "discontinuity"=discont,
                "slope"=dydx)
    
    # Return
    return(output)
  })
}
