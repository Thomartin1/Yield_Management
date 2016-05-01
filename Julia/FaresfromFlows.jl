using DataFrames

# Fonction qui renvoie les fares pour chaque itineraire, chaque bookingclasse,chaque vol. Triple dico imbrique
function FaresFromFlow(PATH)
  file = readtable(PATH)
  # Dans le dictionnaire, il faut prendre en compte le flowid et la booking class, car les cabines sont mixees.
  FlowLeg = Dict{Int64,Dict{Int64,Dict{ASCIIString,float}}}() Triple dico imbrique
  for i = 1:size(file[1])[1]
    #on check si le flow est reference
    flowid = file[1][i]
    if in(flowid,keys(FlowLeg))
      #on check si la boooking classe est referencee
      bookingclass = file[3][i]
      if in(bookingclass,keys(FlowLeg[flowid]))
        FlowLeg[flowid][bookingclass][join([file[7][i],file[9][i]],"-")]= file[5][i]
        #sinon on cree le dico associe a la bookinclass
      else
        FlowLeg[flowid][bookingclass] = Dict{ASCIIString,float}()
        FlowLeg[flowid][bookingclass][join([file[7][i],file[9][i]],"-")]= file[5][i]
      end
      #sinon on cree le dico associe au flow
    else
      FlowLeg[flowid] = {}
      FlowLeg[flowid][bookingclass]= {}
      FlowLeg[flowid][bookingclass][join([file[7][i],file[9][i]],"-")]= file[5][i]
    end
  end
  return FlowLeg
end

print(legFromFlow("/home/sebastien/Documents/Projet_Air_France/p3.csv"))
