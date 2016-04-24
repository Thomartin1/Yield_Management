using DataFrames

# Fonction qui renvoie les vols utilisées par un itinéraire

file = readtable("/home/sebastien/Documents/Projet_Air_France/p4.csv")

function idToLeg()
  id = Dict{Int64,UTF8String}()
  for i = 1:size(file[1])[1]
     id[i] = join([file[1][i], file[3][i]], "-")
  end
  return id
end
