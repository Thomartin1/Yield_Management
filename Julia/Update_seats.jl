function Update_seatinventory!(i, demandofflowid, seatinventory)
  #les demandes sont formulees 1 a 1. On decremente le nb de place restantes de 1 pour tous les vols de l'itineraire
  for leg in legfromflow[idtoflow[i][1]][idtoflow[i][2]]
    seatinventory[leg] = seatinventory[leg] -demandofflowid
  end
end
