######packages utilises dans le code
using DataFrames
using Distributions
using JuMP  # Need to say it whenever we use JuMP
using CPLEX # Loading the CPLEX module for using its solver
######import des fonctions codées dans d'autres fichiers
include("globalVar.jl")
include("bidprice.jl")
include("BidComparision.jl")
######ecriture d'une bouvcle de tres haut niveau qui permet de voir l'architecture du bid-pricing
function timeloop(pathtime,pathdemand,pathflow,pathflights)
  # On commence par mettre les données en forme, on appelle des routines.
  # Il est bon de noter que tout va se presenter sous forme de dictionaires puisque les vols ont des designations en string

  Time = readtable(pathtime)
  newDB=Time[1] #une liste des timeframes
  durationd=Time[2] # la duree de chaque time frame

  # On met à 0 les deux choses qui vont nous interesser: le bif et la liste des demandes acceptees.
  incomes = 0
  # On pour chaque timeframe, un dictionnaire qui indique pour chaque itinéraire et chaque boking class si la demande a étét accesptée
  acceptedrequests = Dict{Int64,Dict{Int64,Dict{Int64,Float64}}}()

  # Le temps est découpé en timframes; on les examine un par un
  for time in newDB
    println("")
    print("Le pas de temps est: ")
    println(time)
    # on calcule les bidprices uniquement pour ce timeframe, ils seront CONSTANTS sur la periode
    bidprices = ComputeBid(time, capacityofleg) #bidprice est un dictionaire double: Dict{Int64(flowid),Dict{Int64,float}}
    # on liste toutes les demandes acceptees dans le timeframe en cour et on ressort la list avec le revenue correspondant. acceptedrequests_timeframe
    # est une liste des demandes aceptees, seatinventory represente LES SIEGES QUI RESTENT LIBRES.
    (acceptedrequests_time,revenuetf)  = CompareBidQuery!(bidprices, capacityofleg, time)
    # On met a jour les donnees qui nous interessent.
    incomes = incomes+revenuetf
    acceptedrequests[time] = acceptedrequests_time

    # On calcul le nombre de places prises par vol a parttir des demandes acceptées
    demparvol = Dict{UTF8String,Float64}()
    for i = 1:length(acceptedrequests[time])[1]
      for a in 1:nbleg
      demparvol[idtoleg[a]] = 0.0
      end
      for l in legfromflow[idtoflow[i][1]][idtoflow[i][2]]
      demparvol[l] = demparvol[l] + acceptedrequests[time][idtoflow[i][1]][idtoflow[i][2]]
      end
    end

    for k=1:nbleg
      # print("Le vol numero ")
      # print(k)
      # println(" a:")
      # println("une capacité de")
      # println(capacityofleg[idtoleg[k]])
      # println("après une modification de")
      # println(demparvol[idtoleg[k]])
      capacityofleg[idtoleg[k]] = capacityofleg[idtoleg[k]] - demparvol[idtoleg[k]]
      # on diminue le nombre de places libre pour chaque leg
    end

  end
  #Il s'agira de la liste .des sieges qui n'ont pas ete pris
  # println(capacityofleg)
  # println(incomes)
  for i = 1:length(acceptedrequests)[1]
    for j = 1:nbOD
      if !(demfromflow[i][idtoflow[j][1]][idtoflow[j][2]] == acceptedrequests[i][idtoflow[j][1]][idtoflow[j][2]])
        println("requete refusée:")
        print("time ")
        println(i)
        print("flowid ")
        println(idtoflow[j][1])
        print("bookingclass ")
        println(idtoflow[j][2])
      end
    end
  end

  return(round(Int,incomes))
end
