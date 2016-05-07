######packages utilises dans le code
using DataFrames

######import des fonctions codées dans d'autres fichiers
include("bidprice.jl")
include("BidComparision.jl")
# include("legFromFlow")
# include("FaresfromFlow")
# include("capacityOfLeg")

######ecriture d'une bouvcle de tres haut niveau qui permet de voir l'architecture du bid-pricing
function timeloop(pathtime,pathdemand,pathflow,pathflights)
  # On commence par mettre les données en forme, on appelle des routines.
  # Il est bon de noter que tout va se presenter sous forme de dictionaires puisque les vols ont des designations en string

  Time = readtable(pathtime)
  newDB=Time[1] #une liste des timeframes
  durationd=Time[2] # la duree de chaque time frame

  #on cree un dictionaire: la clef est l'id du flow, de l'autre cote on trouve une liste des id des leg utilises.
  leginflow = legFromFlow(pathflow)
  #on crée le tenseur des fares de chaque vol.
  #prices est un dictionaire triple: Dict{Int64,Dict{Int64,Dict{ASCIIString,float}}}.
  prices = faresFromFlows(pathflow)
  #seatinventory est un dictionaire double: Dict{Int64(flowid),Dict{Int64,float}}.
  seatinventory = capacityOfLeg(pathflights)

  #On lit la demande de maniere assez basique, pas besoin de la mettre en forme comme pour le reste.
  demandlist = readtable(pathdemand)


  # On met à 0 les deux choses qui vont nous interesser: le bif et la liste des demandes acceptees.
  incomes = 0
  # On pour chaque timeframe, un dictionnaire qui indique pour chaque itinéraire et chaque boking class si la demande a étét accesptée
  accepetedrequests = Dict{Int64,Dict{Int64,Dict{Int64,Bool}}}()

  Capdico = [0.0 for k = 1:nbleg]
  for k=1:nbleg
    Capdico[k] = seatinventory[idtoleg[k]]
    # capacity of each leg
  end

  # Le temps est découpé en timframes; on les examine un par un
  for time in timeframes
    # on calcule les bidprices uniquement pour ce timeframe, ils seront CONSTANTS sur la periode
    bidprices = ComputeBid(time, Capdico) #bidprice est un dictionaire double: Dict{Int64(flowid),Dict{Int64,float}}
    # on liste toutes les demandes acceptees dans le timeframe en cour et on ressort la list avec le revenue correspondant. acceptedrequests_timeframe est une liste des demandes aceptees, seatinventory represente LES SIEGES QUI RESTENT LIBRES.
    (acceptedrequests[time]],revenuetf)  = CompareBidQuery!(bidprices,leginflow,seatinventory,demandlist, timestamp)
    # On met a jour les donnees qui nous interessent.
    incomes = incomes+revenuetf
    accepetedrequests += acceptedrequests_timeframe

    for k=1:nbleg
      Capdico[k] = Capdico[k] - acceptedrequests[k]
      # on diminue le nombre de places libre pour chaque leg
    end

  end
  #Il s'agira de la liste des sieges qui n'ont pas ete pris
  println(seatinventory)
  print(incomes)
  println(accepetedrequests)

  return(incomes)
end
