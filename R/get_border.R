#' Identify all border points in a region
#'
#' @param region A data frame containing the x and y coordinates of the region.
#' @param e The step size of the grid in the x and y directions.
#'
#' @importFrom concaveman "concaveman"
#' 
#' @return A data frame containing the x and y coordinates of the border points of the region.
#' @export
#'
#'
get_border <- function(region,e) {
  
  # Ensure the input coordinates are within distance e/2 of the output of concaveman()
  tolerance <- e/2
  
  # Find border coordinates of region using concaveman()
  border <- as.data.frame(concaveman(points=as.matrix(region[,c("delta","Rmax")]),
                                     concavity=1,
                                     length_threshold=0))
  
  # Create an index of rownumbers containing points on the border of region
  index <- logical(nrow(region))
  for(i in 1:nrow(region)) index[i] <- any((abs(region$delta[i] - border$V1) <= tolerance) & (abs(region$Rmax[i] - border$V2) <= tolerance))
  
  #Return border points of region
  region[index,]
}

# This function takes a (delta,Rmax) region and a point, and returns a 
# dataframe containing the point, the minimum distance between the point
# and the region, and the root of the cubic of the closest point in 
# the region
getdistance <- function(region,x,y){
  
  # Calculate the distance between the point and all points in the region
  region <- region %>% mutate(distance = sqrt((delta - x)^2 + (Rmax - y)^2))
  
  # Find the cubic root of the closest point in the region
  mindist <- min(region$distance)
  closest_bias <- filter(region,distance==mindist)$bias
  
  # Create output dataframe
  output <- data.frame(delta=x,
                       Rmax=y,
                       distance=mindist,
                       closest_bias=closest_bias)
  
  return(output[1,])
}
