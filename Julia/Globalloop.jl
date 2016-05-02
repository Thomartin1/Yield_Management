######packages utilises dans le code
using DataFrames

######import des fonctions codées dans d'autres fichiers
include("bidprice")
include("BidComparision")
include("legFromFlow")
include("FaresfromFlow")
include("capacityOfLeg")

######ecriture d'une bouvcle de tres haut niveau qui permet de voir l'architecture du bid-pricing
function timeloop(pathtime,pathflow,pathflights,pathdemand)
  # On commence par mettre les données en forme, on appelle des routines.
  # Il est bon de noter que tout va se presenter sous forme de dictionaires puisque les vols ont des designations en string

  Time = readtable(pathtime)
  newDB=Time[1] #une liste des timeframes
  durationd=Time[2] # la duree de chaque time frame

  #on cree un dictionaire: la clef est l'id du flow, de l'autre cote on trouve une liste des id des leg utilises.
  leginflow = LegFromFlow(pathflow)
  #on crée le tenseur des fares de chaque vol.
  #prices est un dictionaire triple: Dict{Int64,Dict{Int64,Dict{ASCIIString,float}}}.
  prices = FaresFromFlow(pathflow)
  #seatinventory est un dictionaire double: Dict{Int64(flowid),Dict{Int64,float}}.
  seatinventory = CapacityOfLeg(pathflights)

  #On lit la demande de maniere assez basique, pas besoin de la mettre en forme comme pour le reste.
  demandlist = readtable(pathdemand)


  # On met à 0 les deux choses qui vont nous interesser: le bif et la liste des demandes acceptees.
  incomes = 0
  accepetedrequests = NULL

  # Le temps est découpé en timframes; on les examine un par un
  for time in timeframes
    # on calcule les bidprices uniquement pour ce timeframe, ils seront CONSTANTS sur la periode
    bidprices = ComputeBid(prices,meandemand,capacities) #bidprice est un dictionaire double: Dict{Int64(flowid),Dict{Int64,float}}
    # on liste toutes les demandes acceptees dans le timeframe en cour et on ressort la list avec le revenue correspondant. acceptedrequests_timeframe est une liste des demandes aceptees, seatinventory represente LES SIEGES QUI RESTENT LIBRES.
    (acceptedrequests_timeframe,revenuetf)  = CompareBidQuery!(bidprices,leginflow,seatinventory,demandlist, timestamp)
    # On met a jour les donnees qui nous interessent.
    incomes = incomes+revenuetf
    accepetedrequests += acceptedrequests_timeframe
  end
  #Il s'agira de la liste des sieges qui n'ont pas ete pris
  println(seatinventory)
  print(incomes)
  println(accepetedrequests)

  return(incomes)
end
