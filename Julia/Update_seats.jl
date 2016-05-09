

function Update_seatinventory!(bookingclass,flowid,leginflow,seatinventory)
  flights=leginflow[flowid]
  #les demandes sont formulees 1 a 1. On decremente le nb de place restantes de 1 pour tous les vols de l'itineraire
  for leg in flights
    if(seatinventory[leg][bookingclass]>0)
      seatinventory[leg][bookingclass]-=1
      #si sur l'itineraire, un vol est plein, je renvoie false
    else
      return false
    end
  end
  #je renvoie true si j'ai pu trouver un siege dans chaque vol
  return true
end
