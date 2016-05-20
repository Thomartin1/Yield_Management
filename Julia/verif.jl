######packages utilises dans le code
using DataFrames
using Distributions
using JuMP  # Need to say it whenever we use JuMP
using CPLEX # Loading the CPLEX module for using its solver
using Plotly # For plotting
######import des fonctions codées dans d'autres fichiers
include("path.jl")
include("bidpricestoch.jl")
include("BidComparision.jl")
include("plot.jl")

# Fonction qui calcule l'écart relatif entre deux vecteurs de taille nbleg selon la norme 2
function norm2(vect1, vect2)
  vectdiff = Dict{UTF8String,Float64}()
  vectsum = Dict{UTF8String,Float64}()
  for i = 1:nbleg
    vectdiff[idtoleg[i]] = (vect1[idtoleg[i]] - vect2[idtoleg[i]])^2
    vectsum[idtoleg[i]] = (vect1[idtoleg[i]] + vect2[idtoleg[i]])^2
  end
  totaldiff = 0
  totalsum = 0
  for i = 1:nbleg
    totaldiff = totaldiff + vectdiff[idtoleg[i]]
    totalsum = totalsum + vectsum[idtoleg[i]]
  end
  totalnorm = 2*(sqrt(totaldiff))/(sqrt(totalsum))
  return totalnorm
end

function plotMonteCarlo(liste)
  echelle = [0 + k for k = 1:100]
  results = [0 for k = 1:100]
  for i = 1:length(liste)
    results[round(Int,100*liste[i])+1] += 1
  end
  trace1 = [
    "x" => echelle,
    "y" => results,
    "marker" => ["color" => "rgb(223, 12, 28)"],
    "type" => "bar"
  ]
  data = [trace1]
  layout = ["barmode" => "stack",
            "title" => "Variation of value between bidprices with stochastic method",
            "xaxis" => ["tickfont" => [
                "size" => 14,
                "color" => "rgb(107, 107, 107)"
              ]],
            "yaxis" => [
              "title" => "number of occurences",
              "titlefont" => [
                "size" => 16,
                "color" => "rgb(107, 107, 107)"
              ]],
              "xaxis" => [
                "title" => "distance between two draws of bid prices",
                "titlefont" => [
                  "size" => 16,
                  "color" => "rgb(107, 107, 107)"
                ]]]
  response = Plotly.plot(data, ["layout" => layout, "filename" => "stacked-bar", "fileopt" => "overwrite"])
  plot_url = response["url"]
end

# Fonction qui calcule nbverif fois les bidprices stochastique, et qui renvoie l'analyse comparative de ceux-ci
function tauxvarbid(nbverif)
  time = 17
  bidpricememory = Dict{Int64,Dict{UTF8String,Float64}}()

  for i  = 1:nbverif
    include("/home/sebastien/Documents/Yield_Management/Julia/globalVar.jl")
    capacityoflegcopy = capacityofleg
    println("")
    print("verif numero ")
    println(i)

    bidprices = ComputeBid(time, capacityoflegcopy)

    CompareBidQuery!(bidprices, capacityoflegcopy, time)

    bidpricememory[i] = Dict{UTF8String,Float64}()
    bidpricememory[i] = bidprices
  end

  bidpricecompare = Dict{UTF8String,Array{Any,1}}()
  listcompare = []
  bidpricemoyenne = Dict{UTF8String,Float64}()
  for j = 1:nbverif
    for l = (j+1):nbverif
      append!(listcompare, [norm2(bidpricememory[j], bidpricememory[l])])
    end
  end
  for k = 1:nbleg
    bidpricecompare[idtoleg[k]] = []
    bidpricemoyenne[idtoleg[k]] = 0
    for i = 1:nbverif
      bidpricemoyenne[idtoleg[k]] = bidpricemoyenne[idtoleg[k]] + bidpricememory[i][idtoleg[k]]
      append!(bidpricecompare[idtoleg[k]], [bidpricememory[i][idtoleg[k]]])
    end
    bidpricemoyenne[idtoleg[k]] = bidpricemoyenne[idtoleg[k]]/nbverif
  end

  plotMonteCarlo(listcompare)

  listfile = [bidpricecompare[idtoleg[i]] for i in  1:nbleg]

  listmoyenne = []
  for l = 1:nbleg
    append!(listmoyenne, [bidpricemoyenne[idtoleg[l]]])
  end
  writecsv("/home/sebastien/Documents/Yield_Management/bidpricesvals.csv",listfile)
  writecsv("/home/sebastien/Documents/Yield_Management/bidpricemoyenne.csv",listmoyenne)
end
