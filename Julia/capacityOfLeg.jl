using DataFrames

# Fonction qui renvoie les vols utilisées par un itinéraire

function CapacityOfLeg(PATH)
  file = readtable(PATH)
  cap = Dict{UTF8String,Int64}()
  for i = 1:size(file[1])[1]
    cap[join([file[1][i], file[3][i]], "-")] = file[6][i]
  end
  return cap
end
