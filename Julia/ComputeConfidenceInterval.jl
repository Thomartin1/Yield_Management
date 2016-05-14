using DataFrames
#the lower the value, the better the precision.
function ConfidenceInterval(precision,revenuelist)
  table = Any[]

  nbobservations = size(revenuelist)[1]
  print("nombre d'observations = ")
  println(nbobservations)
  append!(table,[nbobservations])

  meanval = mean(revenuelist)
  print("moyenne = ")
  println(round(Int,meanval))
  append!(table,[round(Int,meanval)])

  variance = std(revenuelist)
  print("variance = ")
  println(round(Int,variance))
  append!(table,[round(Int,variance)])

  #these are the quantiles to be computed
  right = 1 - (precision/2)
  left = (precision/2)
  quantiles =[right,left]
  #we compute the value associated to the quantiles
  qvals = quantile(Normal(0,variance),quantiles)
  print("quantiles = ")
  println(qvals)
  #and the real-life values coresponding
  confidenceleft= meanval+qvals[2]*sqrt(variance/nbobservations)
  confidenceright=meanval+qvals[1]*sqrt(variance/nbobservations)
  confidence = [round(Int,confidenceleft),round(Int,confidenceright)]
  append!(table,[round(Int,confidenceleft)])
  append!(table,[round(Int,confidenceright)])
  return confidence, table
end
