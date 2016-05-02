using DataFrames

# Fonction qui renvoie les demandes pour un itinéraire POUR TOUS LES ITINERAIRES
function demFromFlow(PATH)
  file = readtable(PATH)
  # Dans le dictionnaire, il faut prendre en compte le flowid et la booking class, car les cabines sont mixees.
  DemFlow = Dict{Int64,Dict{Int64,Int64}}()
  for i = 1:size(file[1])[1]
    #on check si le flow est reference
    flowid = file[1][i]
    bookingclass = file[3][i]
    demande =
    if in(flowid,keys(DemFlow))
      DemFlow[flowid][bookingclass] = demande
    else
      DemFlow[flowid] = Dict{Int64,Int64}()
      DemFlow[flowid][bookingclass]= demande
    end
  end
  return FlowLeg
end