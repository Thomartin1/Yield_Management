######packages utilises dans le code
using DataFrames
using Distributions
using JuMP  # Need to say it whenever we use JuMP
using CPLEX # Loading the CPLEX module for using its solver
######import des fonctions codées dans d'autres fichiers
include("path.jl")
include("bidprice.jl")
include("BidComparision.jl")
include("plot.jl")
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
  bidpricememory = Dict{Int64,Dict{UTF8String,Float64}}()
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
    bidpricememory[time] = Dict{UTF8String,Float64}()
    bidpricememory[time] = bidprices

    # On calcul le nombre de places prises par vol a partir des demandes acceptées
    demparvol = Dict{UTF8String,Float64}()
    for a in 1:nbleg
      demparvol[idtoleg[a]] = 0.0
    end
    for i = 1:nbOD
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
      # on diminue le nombre de places libre pour chaque leg
    end

  end
  #Il s'agira de la liste .des sieges qui n'ont pas ete pris
  # println(capacityofleg)
  # println(incomes)

  # Pour voire les demandes rejetées
  # for i = 1:1#length(acceptedrequests)[1]
  #   for j = 1:nbOD
  #     if !(demfromflow[i][idtoflow[j][1]][idtoflow[j][2]] == acceptedrequests[i][idtoflow[j][1]][idtoflow[j][2]])
  #       println("requete refusée:")
  #       for leg in legfromflow[idtoflow[j][1]][idtoflow[j][2]]
  #         print("leg ")
  #         println(leg)
  #         print("capacité ")
  #         print(capacityofleg[leg])
  #         print(" pour ")
  #         println(demfromflow[i][idtoflow[j][1]][idtoflow[j][2]])
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

  # Créer des plots
  x1 = []
  cap1 = []
  y1 = Dict{Int64,Array{Any,1}}()
  for i = 1:nbleg
    append!(x1,[idtoleg[i]])
    append!(cap1,[capacityoflegcopy[idtoleg[i]]])
  end
  demparvolplot = Dict{UTF8String,Float64}()
  for j = 1:17
    for a in 1:nbleg
      demparvolplot[idtoleg[a]] = 0.0
    end
    for m = 1:nbOD
      for l in legfromflow[idtoflow[m][1]][idtoflow[m][2]]
      demparvolplot[l] = demparvolplot[l] + acceptedrequests[j][idtoflow[m][1]][idtoflow[m][2]]
      end
    end
    y1[j] = []
    for k = 1:nbleg
      append!(y1[j],[demparvolplot[idtoleg[k]]])
    end
  end

  #plotCapacity(x1,y1,cap1)

  numvol = 42
  #21, 24, 27, 31, 34, 35, 42, 51, 52, 59, 62, 64, 67, 70, 72, 76, 77, 78, 84, 86, 90, 91, 92, 95, 101, 103, 109, 111, 120, 126, 148, 149, 151, 153, 155, 181, 183, 185, 186, 187, 189,
  bidaploter = []
  for j = 1:17
    append!(bidaploter, [bidpricememory[j][idtoleg[numvol]]])
  end
  println(bidaploter)

  #plotBidprice(bidaploter)

  return(round(Int,incomes))
end
