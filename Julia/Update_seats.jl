

function Update_seatinventory!(acceptedrequests_timeframe, seatinventory)
  #les demandes sont formulees 1 a 1. On decremente le nb de place restantes de 1 pour tous les vols de l'itineraire
  for i = 1:length(acceptedrequests_timeframe)
    for leg in legfromflow[idtoflow[i][1]][idtoflow[i][2]]
        seatinventory[leg] = seatinventory[leg] - acceptedrequests_timeframe[idtoflow[i][1]][idtoflow[i][2]]
    end
end
