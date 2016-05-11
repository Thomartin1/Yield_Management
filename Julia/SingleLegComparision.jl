 # Cette fonction s'occupe d'accepter, ou non, une requete sur un itineraire donné (flow) à un instant donné.

function SingleFlowSingleClassCompareBidQuery(flowid,bookingclass,bidprices)
  accepted = true
  revenue = faresfromflows[flowid][bookingclass]
  sum = 0
  for leg in legfromflow[flowid][bookingclass]
    sum = sum + bidprices[leg]
  end
  if sum > revenue
    accepted = false
  end
  if accepted
    return revenue
  else
    return 0.0
  end
end
