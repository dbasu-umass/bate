#' Computes identified set according to Oster (2019)
#'
#' @param parameters A vector of parameters that is generated after estimating the short, intermediate and auxiliary regressions. 
#' @param Rmax A real number which lies between Rtilde (R-squared for the intermediate regression) and 1. 
#'
#' @return A list with three elements:
#' \item{Discriminant}{The value of the discriminant of the quadratic equation that is solved to generate the identified set}
#' \item{Interval1}{The interval formed with the first root of the quadratic equation}
#' \item{Interval2}{The interval formed with the first root of the quadratic equation}
#' 
#' @export
#'
#' 
osterbds <- function(parameters,Rmax){
  
  if(length(Rmax)>1 | !is.numeric(Rmax)) 
    stop("This function only takes one numeric input for Rmax")
  
  with(parameters,{
    # Coefficients
    a <- taux*(beta0 - betatilde)*(sigmax^2)*(1-2)
    b <- (1)*(Rmax - Rtilde)*(sigmay^2)*(sigmax^2 - taux) -
      (Rtilde - R0)*(sigmay^2)*taux - ((beta0- betatilde)^2)*taux*(sigmax^2)
    c <-  (1)*(Rmax - Rtilde)*(sigmay^2)*(beta0- betatilde)*(sigmax^2)
    # Discriminant
    D <- (b^2)-(4*a*c)
    
    # Check cases
    if(D > 0){ # first case D>0
      x_1 <- (-b+sqrt(D))/(2*a)
      x_2 <- (-b-sqrt(D))/(2*a)
    }
    else if(D == 0){ # second case D=0
      x_1 <- -b/(2*a)
      x_2 <- x_1
    }
    else { # third case D<0
      x_1 <- complex(real=-b/(2*a), imaginary = sqrt(-D)/(2*a))
      x_2 <- complex(real=-b/(2*a), imaginary = -sqrt(-D)/(2*a))
    }
    
    b1 <- round(parameters$betatilde,4)
    b2 <- round(parameters$betatilde-x_1,4)
    b3 <- round(parameters$betatilde-x_2,4)
    
    myquad = c(Discriminant = D,
               Interval1 = paste0("[",
                                  min(b1,b2),
                                  ",",
                                  max(b1,b2),
                                  "]"),
               Interval2 = paste0("[",
                                  min(b1,b3),
                                  ",",
                                  max(b1,b3),
                                  "]"))
    
    # Result
    return(myquad)
  })
}
