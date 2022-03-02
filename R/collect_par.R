#' Collect parameters from the short, intermediate and auxiliary regressions
#'
#' @param data A data frame.
#' @param outcome The name of the outcome variable (must be present in the data frame).
#' @param treatment The name of the treatment variable (must be present in the data frame).
#' @param control Control variables to be added to the intermediate regression.
#' @param other_regressors Control variables to be added in the short regression (default is NULL).
#'
#' @return A data frame with the following columns:
#' \item{beta0}{Treatment effect in the short regression}
#' \item{R0}{R-squared in the short regression}
#' \item{betatilde}{Treatment effect in the intermediate regression}
#' \item{Rtilde}{R-squared in the intermediate regression}
#' \item{sigmay}{Standard deviation of outcome variable}
#' \item{sigmax}{Standard deviation of treatment variable}
#' \item{taux}{Standard deviation of residual in auxiliary regression}
#' 
#' @export
#'
#' 
collect_par <- function(data,outcome,treatment,control,other_regressors=NULL){
  
  # data = data set
  # outcome = outcome variable
  # treatment = treatment variable
  # control = control variables
  # other_regressors = control variables to be included in the short regression
  
  # Create data set
  d1 <- data %>%
    dplyr::select(all_of(outcome),all_of(treatment),all_of(control)) %>%
    as.data.frame()
  
  # --- Run short regression
  # create formula
  fs <- paste(
    paste(
      outcome,treatment,sep = "~"
    ),
    do.call(paste,
            c(append(list(""),as.list(other_regressors)),sep="+"))
  ) %>%
    as.formula()
  
  reg_s <- lm(fs, data = d1)
  beta0 <- reg_s$coefficients[2]
  R0 <- summary(reg_s)$r.squared
  
  # --- Run intermediate regression
  # intermediate regression control variables
  ff <- paste(
    outcome,
    do.call(paste,
            c(append(list(treatment),as.list(control)),sep="+")),
    sep = "~"
  ) %>%
    as.formula()
  
  # run regression and store parameters
  reg_intr <- lm(ff, data=d1)
  betatilde <- reg_intr$coefficients[2]
  Rtilde <- summary(reg_intr)$r.squared
  
  # Std Dev of outcome variable
  sigmay <- sd(d1[,outcome],na.rm = TRUE)
  
  # Std Dev of treatment variable
  sigmax <- sd(d1[,treatment],na.rm = TRUE)
  
  # Run auxiliary regression and collect variance of residuals
  f_aux <- paste(
    treatment,
    do.call(paste,c(as.list(control),sep="+")),
    sep="~"
  ) %>%
    as.formula()
  
  reg_aux <- lm(f_aux,data=d1)
  taux <- var(reg_aux$residuals, na.rm = TRUE)
  
  # Return parameters
  return(
    data.frame(
      beta0=beta0, 
      R0=R0,
      betatilde=betatilde,
      Rtilde=Rtilde,
      sigmay=sigmay,
      sigmax=sigmax,
      taux=taux
    )
  )
}
