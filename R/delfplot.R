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
#' @importFrom ggplot2 "geom_function"
#' @importFrom ggplot2 "geom_hline"
#' @importFrom ggplot2 "geom_vline"
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
#' ## Oster's method: Plot of delta = f(Rmax)
#' p4 <- delfplot(parameters = parameters)
#' print(p4)
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
        title=TeX("Graph of $\\delta$ = f($R_{max}$), $\\beta = 0"),
        subtitle = paste("Dashed red vertical line (Rmax when delta=1) at", round(Rstar, digits = 2))
        #subtitle=TeX("Dashed red vertical line: value of Rmax when $\\delta$=1")
      ) +
      geom_hline(yintercept = 1, linetype="dashed") +
      geom_vline(xintercept = Rstar, linetype="dashed", color="red") +
      geom_vline(xintercept = Rtilde)
    
    # Return
    return(p)
  })
}
