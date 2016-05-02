using DataFrames

# Fonction qui renvoie des id pour chaques vol.
function idToLeg(PATH)
  file = readtable(PATH)
  id = Dict{Int64,UTF8String}()
  for i = 1:size(file[1])[1]
     id[i] = join([file[1][i], file[3][i]], "-")
  end
  return id
end
