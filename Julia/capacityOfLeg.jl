using DataFrames

# Fonction qui renvoie les vols utilisées par un itinéraire

file = readtable("/home/sebastien/Documents/Projet_Air_France/p4.csv")

function capacityOfLeg()
  cap = Dict{UTF8String,Int64}()
  for i = 1:size(file[1])[1]
    cap[join([file[1][i], file[3][i]], "-")] = file[6][i]
  end
  return cap
end
