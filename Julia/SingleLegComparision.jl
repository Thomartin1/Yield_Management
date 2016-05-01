using DataFrames
using Distributions
 # Cette fonction s'occupe d'accepter, ou non, une requete sur un itineraire donné (flow) à un instant donné.

function SingleFlowSingleClassCompareBidQuery(flowid,bookingclass,rate,leginflow,bidprices)
  flights= leginflow[flowid]
  totalbid=0
  for leg in flights
    totalbid =+ bidprices[leg][bookingclass]
  end
  revenue = Poisson(rate)
  if(revenue >= totalbid)
    return revenue
  else return 0
  end
end
