#' Plot graph of function delta=f(Rmax)
#'
#' @param parameters A vector of parameters that is generated after estimating the short, intermediate and auxiliary regressions.
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
#' @return A plot object created with ggplot
#' @export
#'
#' 
delfplot <- function(parameters){
  
  with(parameters, {
    # Parameters  
    A <- (betatilde*sigmay^2*(sigmax^2 - taux) +
            sigmay^2*sigmax^2*(beta0 - betatilde))
    
    B <- (betatilde^3*(sigmax^2*taux - taux^2) +
            betatilde^2*sigmax^2*taux*(beta0 - betatilde))
    
    C <- (betatilde*(sigmay^2)*taux*(Rtilde - R0) +
            betatilde*(sigmax^2)*taux*((beta0 - betatilde)^2) +
            betatilde^3*((sigmax^2)*taux - taux^2) +
            2*(betatilde^2)*(sigmax^2)*taux*(beta0 - betatilde))
    
    # R** (value of Rmax when delta = 1)
    Rstar <- Rtilde + (C-B)/A
    
    # Plot
    delfunc <- function(x) C/(A*x- A*Rtilde + B)
    #p <- plot(delfunc, from=(Rtilde+0.01), to=1, n=101)
    
    p <- ggplot(
      data=data.frame(x=seq(from=(Rtilde+0.1), to=1, length.out=101)), aes(x)
    ) +
      geom_function(fun=delfunc, color="blue", size=1) +
      theme_minimal() +
      labs(
        y=TeX("$\\delta$"),
        x=TeX("$R_{max}$"),
        title=TeX("$\\delta$ = f($R_{max}$), $\\beta = 0"),
        subtitle=TeX("Dashed red vertical line: R**= (value of Rmax) when delta=1")
      ) +
      geom_hline(yintercept = 1, linetype="dashed") +
      geom_vline(xintercept = Rstar, linetype="dashed", color="red") +
      geom_vline(xintercept = Rtilde)
    
    # Return
    return(p)
  })
}
