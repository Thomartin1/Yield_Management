using DataFrames

# Fonction qui renvoie les fares pour chaque itineraire, chaque bookingclasse,chaque vol. Triple dico imbrique
function FaresFromFlow(PATH)
  file = readtable(PATH)
  # Dans le dictionnaire, il faut prendre en compte le flowid et la booking class, car les cabines sont mixees.
  FlowLeg = Dict{Int64,Dict{Int64,Float64}}() #Double dico imbrique
  for i = 1:size(file[1])[1]
    #on check si le flow est reference
    flowid = file[1][i]
    bookingclass = file[3][i]
    if in(flowid,keys(FlowLeg))
      #on check si la boooking classe est referencee
      FlowLeg[flowid][bookingclass]= file[5][i]
      #sinon on cree le dico associe au flow
    else
      FlowLeg[flowid] = Dict{Int64,Float64}()
      FlowLeg[flowid][bookingclass] = file[5][i]
    end
  end
  return FlowLeg
end
