using DataFrames

# Fonction qui renvoie les vols utilisées par un itinéraire POUR TOUS LES ITINeraires
function legFromFlow(PATH)
  file = readtable(PATH)
  # Dans le dictionnaire, il faut prendre en compte le flowid et la booking class, car les cabines sont mixees.
  FlowLeg = Dict{Int64,Dict{Int64,Set{ASCIIString}}}()
  for i = 1:size(file[1])[1]
    flowid = file[1][i]
    bookingclass = file[3][i]
    leg = join([file[7][i],file[9][i]],"-")
    #on check si le flow est reference
    if in(flowid,keys(FlowLeg))
      #on check si la boooking classe est referencee
      if in(bookingclass,keys(FlowLeg[flowid]))
        FlowLeg[flowid][bookingclass] = union!(FlowLeg[flowid][bookingclass],[leg])
      else
        FlowLeg[flowid][bookingclass] = Set([leg])
      end
    else
      FlowLeg[flowid] = Dict{Int64,Set{ASCIIString}}()
      FlowLeg[flowid][bookingclass]= Set([leg])
    end
  end
  return FlowLeg
end
