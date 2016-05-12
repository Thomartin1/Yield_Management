include("SingleLegComparision.jl")
include("Update_seats.jl")

#A un instant donne on etudie toutes les demandes pour le reseau.
function CompareBidQuery!(bidprices, seats, timestamp)
  #On initialise les valeurs de retour
  acceptedquery_timestamp= Dict{Int64,Dict{Int64, Float64}}()
  for m =1:nbOD
    acceptedquery_timestamp[idtoflow[m][1]] = Dict{Int64, Float64}()
  end
  totalrevenueperiod = 0

  for i = 1:nbOD

    # On regarde la demande
    demandofflowid = demfromflow[timestamp][idtoflow[i][1]][idtoflow[i][2]]
    placesuffisante = true

    # On regarde avec le revenue si on peut ou non accepter la requete
    revenue = SingleFlowSingleClassCompareBidQuery(idtoflow[i][1],idtoflow[i][2],bidprices)

    # On regarde s'il y a la place suffisante sur les vols
    for j in legfromflow[idtoflow[i][1]][idtoflow[i][2]]
      if demandofflowid > seats[j]
        placesuffisante = false
      end
    end

    # S'il y a assez de place, et que le revenue est suffisant on remplie acceptedquery
    if placesuffisante
      totalrevenueperiod += revenue*demandofflowid
      acceptedquery_timestamp[idtoflow[i][1]][idtoflow[i][2]] = demandofflowid
      Update_seatinventory!(i,demandofflowid, seats)
    else
      acceptedquery_timestamp[idtoflow[i][1]][idtoflow[i][2]] = 0.0
    end

    # On met à jour les places disponibles

  end
  return(acceptedquery_timestamp, totalrevenueperiod)
end
