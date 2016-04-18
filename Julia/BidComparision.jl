using DataFrames
include("SingleLegComparision")
include("Update_seats")


#A un instant donne on etudie toutes les demandes pour le reseau.
function CompareBidQuery(timestamp,demandlist,flowlist,bidprices)
  indexes = #methode qui retourne la liste des indices correspondant a des demandes au momment stimestamp.
  acceptedquery=NULL
  totalrevenueperiod=0

  for querynum in indexes
    flowid=demandlist[1][querynum]
    bookingclass=demandlist[3][querynum]

    revenue = SingleFlowSingleClassCompareBidQuery(querynum,demandlist,flowlist,bidprices,timestamp)
    if (revenue >= 0)
      println("la demande ",i," est acceptee" )
      #mise à jour des places dispo.

      fullflight = Update_seatinventory!(bookingclass,flowid,flowlist,seatinventory)
      if(fullflight)
        skip
      end
      #enregistrment de la demande dans une liste.
      append!(acceptedquery,[demandlist[1][querynum],demandlist[2][querynum],demandlist[3][querynum],demandlist[4][querynum],demandlist[5][querynum]])
      #mise à jour du revenue sur total sur le tiemframe considere.
      totalrevenueperiod +=revenue
    end
  end
  return(acceptedquery,seatinventory,revenue)
end
