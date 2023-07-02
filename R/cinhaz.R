
#' Conduct partial and total R2-based sensitivity analysis
#'
#' @param kd relative strength of the confounder in explaining variation in treatment as compared to benchmark covariate(s)
#' @param ky relative strength of confounder in explaining variation in outcome as compared to benchmerk covariate(s)
#' @param data data frame 
#' @param outcome outcome variable
#' @param treatment treatment variable
#' @param bnch_reg benchmark covariate(s)
#' @param other_reg other covariates in the model (other than treatment and benchmark covariates)
#' @param alpha significance level for hypothesis test (H0: true effect = 0)
#'
#' @importFrom stats "qt"
#' @importFrom stats "vcov"
#'
#' @return A data frame with results
#' @export
#'
#' @examples
#' ## Load library
#' library(sensemakr)
#' ## Conduct analysis
#' cinhaz(kd=1,ky=1,data=darfur,outcome = "peacefactor",
#' treatment = "directlyharmed", bnch_reg = "female",
#' other_reg = c("village","age","farmer_dar","herder_dar","pastvoted","hhsize_darfur"),
#' alpha=0.05)
cinhaz <- function(kd,ky,data,outcome,treatment,bnch_reg,other_reg,alpha){
  
  # ------------------------------------------------------- #
  # --------- Create data set, run regression ------------- #
  d1 <- as.data.frame(data)
  
  myreg <- as.formula(
    paste(outcome, paste(c(treatment, bnch_reg, other_reg), collapse= "+"), sep = "~")
  )
  
  myres <- stats::lm(myreg, data = d1)
  
  # Treatement effect and SE
  est_eff <- myres$coefficients[paste(treatment)]
  se_eff <- sqrt(vcov(myres)[paste(treatment),paste(treatment)])
  
  # Degrees of freedom
  mydf <- myres$df.residual
  
  
  
  # ----------------------------------------------------------- #
  # ----------- Total R-Squared Based Analysis ---------------- #
  
  # --------- Step 1 ----------- #
  # --- r2dxj
  dxj <- as.formula(paste(treatment, paste(bnch_reg, collapse= "+"), sep = "~"))
  
  r2dxj <- summary(stats::lm(dxj, data = d1))$r.squared
  rdxj <- sqrt(r2dxj)
  
  # ---- r2dx
  dx <- as.formula(paste(treatment, paste(c(bnch_reg, other_reg), collapse= "+"), sep = "~"))
  
  r2dx <- summary(stats::lm(dx,data = d1))$r.squared
  rdx <- sqrt(r2dx)
  
  # ---- r2dz_x
  r2dz_x <- kd*(r2dxj/(1-r2dx))
  rdz_x <- sqrt(r2dz_x)
  
  if(kd>((1-r2dx)/r2dxj))
    stop("Chosen value of kd is not permissible. Reduce kd.")
  
  # ---- r2yxj
  yxj <- as.formula(paste(outcome, paste(bnch_reg, collapse= "+"), sep = "~"))
  
  r2yxj <- summary(stats::lm(yxj, data = d1))$r.squared
  ryxj <- sqrt(r2yxj)
  
  # ----- r2yx
  yx <- as.formula(paste(outcome, paste(c(bnch_reg, other_reg), collapse= "+"), sep = "~"))
  
  r2yx <- summary(stats::lm(yx,data = d1))$r.squared
  ryx <- sqrt(r2yx)
  
  # ---- r2yz_x
  r2yz_x <- ky*(r2yxj/(1-r2yx))
  ryz_x <- sqrt(r2yz_x)
  
  if(ky>((1-r2yx)/r2yxj))
    stop("Chosen value of ky is not permissible. Reduce ky")
  
  # --------- Step 2 ----------- #
  
  # ---- r2yd_x
  # First residual: yd_x
  u1 <- stats::lm(yx, data = d1)$residuals
  
  # Second residual: dx
  u2 <- stats::lm(dx, data = d1)$residuals
  
  # Select non missing rows
  N <- max(length(u1),length(u2))
  r2yd_x <- summary(stats::lm(u1[1:N]~u2[1:N]))$r.squared
  ryd_x <- sqrt(r2yd_x)
  
  # r2yz_dx
  ryz_dx <- (abs(ryz_x) - abs(ryd_x*rdz_x))/(sqrt(1-r2yd_x)*sqrt(1-r2dz_x))
  r2yz_dx <- ryz_dx^2
  
  # ------- Testing null hypothesis: true effect = 0 -------------- #
  
  # ------- Compute confidence interval
  # bias
  bias_temp <- (sqrt((r2yz_dx*r2dz_x*mydf)/(1-r2dz_x)))*se_eff
  bias_tot <- ifelse(est_eff>0,bias_temp,(-1*bias_temp))
  
  # CI: Upper limit  
  ul_tot <- (est_eff - bias_tot) + qt(alpha/2,df=mydf,lower.tail = FALSE)*se_eff
  
  # CI: Upper limit  
  ll_tot <- (est_eff - bias_tot) - qt(alpha/2,df=mydf,lower.tail = FALSE)*se_eff
  
  # ------------------------------------------------------------- #
  # ----------- Partial R-Squared Based Analysis ---------------- #
  
  # --------- Step 1: Compute r2dz.x, r2yz.x ----------- #
  
  # ----- Compute r2dz.x
  
  reg1 <- as.formula(
    paste(treatment, paste(c(bnch_reg, other_reg), collapse= "+"), sep = "~")
  )
  
  reg2 <- as.formula(
    paste(treatment, paste(other_reg, collapse= "+"), sep = "~")
  )
  
  r1_d <- summary(stats::lm(reg1, data=d1))$r.squared
  r2_d <- summary(stats::lm(reg2, data=d1))$r.squared
  
  r2dxj.xmj <- (r1_d - r2_d)/(1-r2_d) 
  r2dz.x <- kd*((r2dxj.xmj)/(1-r2dxj.xmj))
  rdz.x <- sqrt(r2dz.x)
  
  if(kd>((1-r2dxj.xmj)/(r2dxj.xmj)))
    stop("Chosen value of kd is not permissible. Reduce kd")
  
  # ------ Compute r2yz.x
  
  reg1 <- as.formula(
    paste(outcome, paste(c(bnch_reg, other_reg), collapse= "+"), sep = "~")
  )
  
  reg2 <- as.formula(
    paste(outcome, paste(other_reg, collapse= "+"), sep = "~")
  )
  
  r1_y <- summary(stats::lm(reg1, data=d1))$r.squared
  r2_y <- summary(stats::lm(reg2, data=d1))$r.squared
  
  r2yxj.xmj <- (r1_y - r2_y)/(1-r2_y) 
  r2yz.x <- ky*((r2yxj.xmj)/(1-r2yxj.xmj))
  ryz.x <- sqrt(r2yz.x)
  
  if(ky>((1-r2yxj.xmj)/(r2yxj.xmj)))
    stop("Chosen value of ky is not permissible. Reduce ky")
  
  # --------- Step 2: Compute r2yz.dx ----------- #
  
  # -- Compute ryd.x
  reg1 <- as.formula(
    paste(outcome, paste(c(treatment, bnch_reg, other_reg), collapse= "+"), sep = "~")
  )
  
  reg2 <- as.formula(
    paste(outcome, paste(c(bnch_reg, other_reg), collapse= "+"), sep = "~")
  )
  
  r1 <- summary(stats::lm(reg1, data=d1))$r.squared
  r2 <- summary(stats::lm(reg2, data=d1))$r.squared
  
  r2yd.x <- (r1 - r2)/(1-r2) 
  ryd.x <- sqrt(r2yd.x)
  
  # -- Compute r2yz.dx
  ryz.dx <- (abs(ryz.x) - abs(ryd.x*rdz.x))/(sqrt(1-r2yd.x)*sqrt(1-r2dz.x))
  r2yz.dx <- (ryz.dx)^2
  
  
  # ------- Testing null hypothesis: true effect = 0 -------------- #
  
  # ------- Compute confidence interval
  # bias
  bias_temp <- (sqrt((r2yz.dx*r2dz.x*mydf)/(1-r2dz.x)))*se_eff
  bias_par <- ifelse(est_eff>0,bias_temp,(-1*bias_temp))
  
  # CI: Upper limit  
  ul_par <- (est_eff - bias_par) + qt(alpha/2,df=mydf,lower.tail = FALSE)*se_eff
  
  # CI: Upper limit  
  ll_par <- (est_eff - bias_par) - qt(alpha/2,df=mydf,lower.tail = FALSE)*se_eff
  
  
  # ---------- Use sensemakr to get robustness values ------------- #
  mymodel <- sensemakr::sensemakr(
    model = myres, treatment = treatment, 
    benchmark_covariates = bnch_reg, kd = kd, ky = ky, q = 1, 
    alpha = 0.05, reduce = TRUE)
  
  rvq <- 100*(mymodel$sensitivity_stats["rv_q"]$rv_q)
  rvqa <- 100*(mymodel$sensitivity_stats["rv_qa"]$rv_qa)
  
  
  # ------------------------------------------------------ #
  # ------------------ Return Results -------------------- #
  myresults <- data.frame(
    estimate=rep(est_eff,2),
    serr=rep(se_eff,2),
    r2yd_x=100*c(r2yd_x,r2yd.x),
    rv_q=rep(rvq,2),
    rv_qa=rep(rvqa,2),
    r2yz_dx=100*c(r2yz_dx,r2yz.dx), 
    r2dz_x=100*c(r2dz_x,r2dz.x),
    lower_lim_old=c(ll_tot,ll_par),
    upper_lim_old=c(ul_tot,ul_par)
  )
  rownames(myresults) <- c("Total R2-Based","Partial R2-Based")
  colnames(myresults) <- c(
    "Estimate", "Std Error","R2YD|X","RV_q", "RV_qa","R2YZ|DX", "R2DZ|X",
    "CI:Lower Limit", "CI:Upper Limit"
  )
  return(
    t(myresults)  
  )
}
