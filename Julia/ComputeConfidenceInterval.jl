using DataFrames
#the lower the value, the better the precision.
function ConfidenceInterval(precision,revenuelist)
  nbobservations = size(revenuelist)[1]
  println(nbobservations)

  meanval = mean(revenuelist)
  println(meanval)
  variance = std(revenuelist)
  println(variance)
  #these are the quantiles to be computed
  right = 1- (precision/2)
  left = (precision/2)
  quantiles =[right,left]
  #we compute the value associated to the quantiles
  qvals = quantile(Normal(0,variance),quantiles)
  println(qvals)
  #and the real-life values coresponding
  confidenceleft= meanval+qvals[2]*sqrt(variance/nbobservations)
  confidenceright=meanval+qvals[1]*sqrt(variance/nbobservations)
  confidence = [confidenceleft,confidenceright]
  return confidence
end
