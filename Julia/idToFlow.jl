using DataFrames

# Fonction qui renvoie des id pour chaques itinéraire.
function idToFlow(PATH)
  file = readtable(PATH)
  id = Dict{Int64,Tuple{Int64,Int64}}()
  compt = 1
  for i = 1:size(file[1])[1]
    if !((file[1][i],file[3][i]) in (values(id)))
      id[compt] = (file[1][i],file[3][i])
      compt = compt + 1
    end
  end
  return id
end
