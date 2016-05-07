using DataFrames
include("SingleLegComparision.jl")
include("Update_seats.jl")


#A un instant donne on etudie toutes les demandes pour le reseau.
function CompareBidQuery!(bidprices,leginflow,seatinventory,demandlist, timestamp)
  #une routine qui renvoie les indices des demandes à l'instant timestamp
  indexes = DemandAtTime(timestamp, demandlist)
  #On initialise les valeurs de retour
  acceptedquery=NULL
  totalrevenueperiod=0

  for querynum in indexes
    flowid = demandlist[1][querynum]
    bookingclass = demandlist[3][querynum]
    rate = demandlist[4][querynum]

    revenue = SingleFlowSingleClassCompareBidQuery(flowid,bookingclass,rate,leginflow,bidprices)
    println("la demande ",i," est acceptee" )
    #mise à jour des places dispo.
    fullflight = Update_seatinventory!(bookingclass,flowid,leginflow,seatinventory)

    if(revenue && fullflight==false)
      println("la demande ",i," est acceptee" )
      #enregistrment de la demande dans une liste.
      append!(acceptedquery,[demandlist[1][querynum],demandlist[2][querynum],demandlist[3][querynum],demandlist[4][querynum],demandlist[5][querynum]])
      #mise à jour du revenue sur total sur le tiemframe considere.
      totalrevenueperiod +=revenue
    end
  end
  return(acceptedquery,seatinventory,totalrevenueperiod)
end
