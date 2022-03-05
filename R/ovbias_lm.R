#' Compute bias adjusted treatment effect taking three lm objects as input.
#'
#' @param lm_shrt lm object corresponding to the short regression
#' @param lm_int lm object corresponding to the intermediate regression
#' @param lm_aux lm object corresponding to the auxiliary regression
#' @param deltalow The lower limit of delta
#' @param deltahigh The upper limit of delta
#' @param Rhigh The upper limit of Rmax
#' @param e The step size
#'
#' @return List with three elements:
#' 
#' \item{Data}{Data frame containing the bias and bias-adjusted treatment effect for each point on the grid}
#' \item{bias_Distribution}{Quantiles (2.5,5.0,50,95,97.5) of the empirical distribution of bias}
#' \item{bstar_Distribution}{Quantiles (2.5,5.0,50,95,97.5) of the empirical distribution of the bias-adjusted treatment effect}
#' 
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
#' ## Short regression
#' reg_s <- lm(iq_std ~ BF_months + factor(age) + sex, data = NLSY_IQ)
#'
#' ## Intermediate regression
#' reg_i <- lm(iq_std ~ BF_months + 
#' factor(age) + sex + income + motherAge + 
#' motherEDU + mom_married + factor(race),
#' data = NLSY_IQ)
#'
#' ## Auxiliary regression
#' reg_a <- lm(BF_months ~ factor(age) + 
#' sex + income + motherAge + motherEDU + 
#' mom_married + factor(race), data = NLSY_IQ)
#' 
#' ## Set limits for the bounded box
#' Rlow <- summary(reg_i)$r.squared
#' Rhigh <- 0.61
#' deltalow <- 0.01
#' deltahigh <- 0.99
#' e <- 0.01
#' 
#' ## Compute bias and bias-adjusted treatment effect
#' ovb_lm <- ovbias_lm(lm_shrt = reg_s,lm_int = reg_i, 
#' lm_aux = reg_a, deltalow=deltalow, deltahigh=deltahigh, 
#' Rhigh=Rhigh, e=e)
#'
#' ## Default quantiles of bias
#' ovb_lm$bias_Distribution
#' 
#' # Default quantiles of bias-adjusted treatment effect
#' ovb_lm$bstar_Distribution
#' 
#' 
ovbias_lm <- function(lm_shrt,lm_int,lm_aux,deltalow,deltahigh,Rhigh,e){
  
  # Collect parameters from regressions
  beta0 <- lm_shrt$coefficients[2]
  R0 <- summary(lm_shrt)$r.squared
  sigmay <- sd(lm_shrt$model[,1],na.rm = TRUE)
  sigmax <- sd(lm_shrt$model[,2],na.rm = TRUE)
  betatilde <- lm_int$coefficients[2]
  Rtilde <- summary(lm_int)$r.squared
  taux <- var(lm_aux$residuals, na.rm = TRUE)
  
  # Define data frame of parameters
  parameters <- data.frame(
    beta0=beta0, 
    R0=R0, 
    betatilde=betatilde, 
    Rtilde=Rtilde,
    sigmay=sigmay, 
    sigmax=sigmax, 
    taux=taux
  )
  
  # Call ovbias and return
  return(ovbias(parameters,deltalow,deltahigh,Rhigh,e))
}
