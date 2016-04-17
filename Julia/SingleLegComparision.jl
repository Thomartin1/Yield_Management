using DataFrames
using Distributions
 # Cette fonction s'occupe d'accepter, ou non, une requete sur un itineraire donné (flow) à un instant donné.

function SingleFlowSingleClassCompareBidQuery(querynum,demandlist,flowlist,bidprices,timestamp)
  flow = demandlist[1][querynum]
  timeframe = demandlist[2][querynum]
  bookingclass = demandlist[3][querynum]
  rate = demandlist[4][querynum]

  if(timeframe == timestamp)
    flights=legfromflow(flow, flowlist)
    totalbid=0
    for leg in flights
      totalbid =+ bidprices[leg][bookingclass]
    end
    revenue = Poisson(rate)
    if(revenue >= totalbid)
      print(La requete est acceptee)
      return revenue
    else return 0
    end
  else return 0
  end

end
