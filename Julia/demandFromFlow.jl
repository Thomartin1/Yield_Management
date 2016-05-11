using DataFrames

# Fonction qui renvoie les demandes pour un itinéraire POUR TOUS LES ITINERAIRES à une timeframe donnée
function demFromFlow(PATH)
  file = readtable(PATH)
  # Dans le dictionnaire, il faut prendre en compte le flowid et la booking class, car les cabines sont mixees.
  DemFlow = Dict{Int64,Dict{Int64,Dict{Int64,Float64}}}()
  for i = 1:size(file[1])[1]
    #on check si la timeframe est reference
    time = file[2][i]
    flowid = file[1][i]
    bookingclass = file[3][i]
    demande = file[4][i]
    if in(time,keys(DemFlow))
      # On check si le flow est référence
      if in(flowid,keys(DemFlow[time]))
        DemFlow[time][flowid][bookingclass] = 2*demande
      else
        DemFlow[time][flowid] = Dict{Int64,Int64}()
        DemFlow[time][flowid][bookingclass]= 2*demande
      end
    else
      DemFlow[time] = Dict{Int64,Dict{Int64,Float64}}()
      if in(flowid,keys(DemFlow[time]))
        DemFlow[time][flowid][bookingclass] = 2*demande
      else
        DemFlow[time][flowid] = Dict{Int64,Int64}()
        DemFlow[time][flowid][bookingclass]= 2*demande
      end
    end
  end
  return DemFlow
end
