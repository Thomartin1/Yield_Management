using DataFrames
include("SingleLegComparision.jl")
include("Update_seats.jl")


#A un instant donne on etudie toutes les demandes pour le reseau.
function CompareBidQuery!(bidprices, seatinventory, timestamp)
  #On initialise les valeurs de retour
  acceptedquery[timestamp]= Dict{Int64,Dict{Int64, Float64}}()
  totalrevenueperiod = 0

  for i = 1:nbOD

    # On regarde la demande
    demflowid = demfromflow[timestamp][idtoflow[i][1]][idtoflow[i][2]]
    placesuffisante = True

    # On regarde avec le revenue si on peut ou non accepter la requete
    revenue = SingleFlowSingleClassCompareBidQuery(idtoflow[i][1],idtoflow[i][2],bidprices)

    # On regarde s'il y a la place suffisante sur les vols
    for j in legfromflow[idtoflow[i][1]][idtoflow[i][2]]
      if demflowid > seatinventory[idtoleg[j]]
        placesuffisante = False
      end
    end

    # S'il y a assez de place, et que le revenue est suffisant on remplie acceptedquery
    if placesuffisante
      totalrevenueperiod +=revenue
      acceptedquery[timestamp][idtoflow[i][1]][idtoflow[i][2]] = demfromflow[timestamp][idtoflow[i][1]][idtoflow[i][2]]
    else
      acceptedquery[timestamp][idtoflow[i][1]][idtoflow[i][2]] = 0.0
    end

  end

  # On met à jour les places disponibles
  Update_seatinventory!(acceptedquery[timestamp], seatinventory)

  return(acceptedquery,seatinventory,totalrevenueperiod)
end
