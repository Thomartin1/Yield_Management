using DataFrames
#the lower the value, the better the precision.
function ConfidenceInterval(precision,revenuelist):
  nbobservations = size(revenuelist)

  mean = mean(revenuelist)
  variance = std(revenuelist)
  #these are the quantiles to be computed
  right = 1-precision/2
  left = precision/2
  quantiles =[right,left]
  #we compute the value associated to the quantiles
  qvals = quantile(Normal(0,variance),quantiles)
  #and the real-life values coresponding
  confidenceleft= mean+sqrt(qvals[1]/nbobservations)
  confidenceright=mean+sign(qvals[2])*sqrt(abs(qvals[2])/nbobservations)
  confidence = [confidenceleft,confidenceright]
  return confidence
end
