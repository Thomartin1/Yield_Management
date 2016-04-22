using DataFrames

# Fonction qui renvoie les vols utilisées par un itinéraire

file = readtable("/home/sebastien/Documents/Projet_Air_France/p3.csv")

function legFromFlow()
  FlowLeg = Dict{Int64,Set{UTF8String}}()
  for i = 1:size(file[1])[1]
    if in(file[1][i],keys(FlowLeg))
      FlowLeg[file[1][i]] = union!(FlowLeg[file[1][i]],[file[7][i]])
    else
      FlowLeg[file[1][i]] = Set([file[7][i]])
    end
  end
  return FlowLeg
end
