######packages utilises dans le code
using DataFrames
using Distributions
using JuMP  # Need to say it whenever we use JuMP
using CPLEX # Loading the CPLEX module for using its solver
######import des fonctions codées dans d'autres fichiers
include("path.jl")
include("bidpricestoch.jl")
include("BidComparision.jl")
######ecriture d'une bouvcle de tres haut niveau qui permet de voir l'architecture du bid-pricing
function timeloop(pathtime,pathdemand,pathflow,pathflights)
  # On commence par mettre les données en forme, on appelle des routines.
  # Il est bon de noter que tout va se presenter sous forme de dictionaires puisque les vols ont des designations en string
  include("/home/sebastien/Documents/Yield_Management/Julia/globalVar.jl")
  Time = readtable(pathtime)
  newDB=Time[1] #une liste des timeframes
  durationd=Time[2] # la duree de chaque time frame

  # On met à 0 les deux choses qui vont nous interesser: le bif et la liste des demandes acceptees.
  incomes = 0
  # On pour chaque timeframe, un dictionnaire qui indique pour chaque itinéraire et chaque boking class si la demande a étét accesptée
  acceptedrequests = Dict{Int64,Dict{Int64,Dict{Int64,Float64}}}()
  capacityoflegcopy = capacityofleg

  # Pour afficher les nombre de demandesb = bar(x,y,color="#0f87bf",align="center",alpha=0.4)
  # dems = readtable(pathdemand)
  # colum = dems[4]
  # nbdems = 0
  # for i = 1:size(colum)[1]
  #   nbdems = nbdems + 2*colum[i]
  # end
  #
  # places = 0
  # for i = 1:nbleg
  #   places = places +capacityofleg[idtoleg[i]]
  # end

  # Le temps est découpé en timframes; on les examine un par un
  for time in newDB
    println("")
    print("Le pas de temps est: ")
    println(time)
    # on calcule les bidprices uniquement pour ce timeframe, ils seront CONSTANTS sur la periode
    bidprices = ComputeBid(time, capacityoflegcopy) #bidprice est un dictionaire double: Dict{Int64(flowid),Dict{Int64,float}}
    # on liste toutes les demandes acceptees dans le timeframe en cour et on ressort la list avec le revenue correspondant. acceptedrequests_timeframe
    # est une liste des demandes aceptees, seatinventory represente LES SIEGES QUI RESTENT LIBRES.

    # for i = 1:nbleg
    #   if bidprices[idtoleg[i]] != 0.0
    #     print("leg ")
    #     println(idtoleg[i])
    #     print("   bidprice associé: ")
    #     println(bidprices[idtoleg[i]])
    #   end
    # end

    (acceptedrequests_time,revenuetf)  = CompareBidQuery!(bidprices, capacityoflegcopy, time)
    # On met a jour les donnees qui nous interessent.
    incomes = incomes+revenuetf
    acceptedrequests[time] = acceptedrequests_time

    # On calcul le nombre de places prises par vol a partir des demandes acceptées
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
      capacityoflegcopy[idtoleg[k]] = capacityoflegcopy[idtoleg[k]] - demparvol[idtoleg[k]]
      # on diminue le nombre de places libre pour chaque leg
    end

  end
  #Il s'agira de la liste .des sieges qui n'ont pas ete pris
  # println(capacityofleg)
  # println(incomes)

  # Pour voire les demandes rejetées
  # for i = 1:2#length(acceptedrequests)[1]
  #   for j = 1:nbOD
  #     if !(demfromflow[i][idtoflow[j][1]][idtoflow[j][2]] == acceptedrequests[i][idtoflow[j][1]][idtoflow[j][2]])
  #       println("requete refusée:")
  #       for leg in legfromflow[idtoflow[j][1]][idtoflow[j][2]]
  #         print("leg ")
  #         println(leg)
  #         print("capacité ")
  #         print(capacityofleg[leg])
  #         print(" pour ")
  #         println(acceptedrequests[i][idtoflow[j][1]][idtoflow[j][2]])
  #       end
  #       print("time ")
  #       println(i)
  #       # print("flowid ")
  #       # println(idtoflow[j][1])
  #       # print("bookingclass ")
  #       # println(idtoflow[j][2])
  #     end
  #   end
  # end

  # Pour voir les legs remplis
  # for i = 1:length(acceptedrequests)[1]
  #   for j = 1:nbleg
  #       if (capacityofleg[idtoleg[j]] == 0)
  #         println("Vol plein:")
  #         print("leg ")
  #         println(idtoleg[j])
  #         print("capacité ")
  #         println(capacityofleg[idtoleg[j]])
  #       end
  #     end
  #       print("time ")
  #       println(i)
  # end

  # Pour compter le nombre de demandes
  # compt = 0.0
  # for i = 1:length(acceptedrequests)[1]
  #   for j = 1:nbOD
  #     compt = compt + acceptedrequests[i][idtoflow[j][1]][idtoflow[j][2]]
  #   end
  # end
  # println(compt)
  # println(places)
  # println(nbdems)

  return(round(Int,incomes))
end
