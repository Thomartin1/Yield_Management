using DataFrames

# Fonction qui renvoie les vols utilisées par un itinéraire

file = readtable("/home/sebastien/Documents/Projet_Air_France/p3.csv")

function legFromFlow()
  FlowLeg = Dict{Int64,Set{ASCIIString}}()
  for i = 1:size(file[1])[1]
    if in(file[1][i],keys(FlowLeg))
      FlowLeg[file[1][i]] = union!(FlowLeg[file[1][i]],join([file[7][i],file[9][i]],"-"))
    else
      FlowLeg[file[1][i]] = Set([join([file[7][i],file[9][i]],"-")])
    end
  end
  return FlowLeg
end

print(legFromFlow())
