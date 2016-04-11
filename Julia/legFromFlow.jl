# Fonction qui renvoie les vols utilisées par un itinéraire
function legFromFlow(Flow)
  FlowLeg = Dict{Int64,Set{UTF8String}}()
  for i = 1:size(Flow)
    if in(file[1][i] FlowLeg),collect(values(FlowLeg)))
      FlowLeg[file[1][i]] = union!(FlowLeg[file[1][i]],file[7][i])
    else
      FlowLeg[file[1][i]] = Set(file[7][i])
    end
  end
  return FlowLeg
end
