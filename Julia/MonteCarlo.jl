include("Globalloop.jl")
include("ComputeConfidenceInterval.jl")
using DataFrames
using Distributions
using PyPlot

function MonteCarlo()
  pathtime = #write local path
  pathflow= #write local path
  pathflights= #write local path
  pathdemand= #write local path

  #on fait tourner l'algo 1000 fois et on garde en memoire tous les resultats.
  revenuelist =Int64[]
  for i in range(1,2)
    append!(revenuelist,[timeloop(PATH1,PATH2,PATH3,PATH4)])
  end
  writecsv("/home/sebastien/Documents/Yield_Management/MonteCarlo.csv",revenuelist)
  println(revenuelist)
  # on analyse la distribution des revenues obtenus(intervales de confiance).
  println("low precison intervall")
  lowprecison, tablow = ConfidenceInterval(0.50,revenuelist)
  println(lowprecison)
  println("")
  println("middle precison intervall")
  midprecison, tabmid = ConfidenceInterval(0.75,revenuelist)
  println(midprecison)
  println("")
  print("high precison intervall")
  highprecison, tabhigh = ConfidenceInterval(0.95,revenuelist)
  println(highprecison)

  string = Any[]
  append!(string,["nombre d'observations"])
  append!(string,["moyenne"])
  append!(string,["variance"])
  append!(string,["confiance left"])
  append!(string,["confiance right"])


  writecsv("/home/sebastien/Documents/Yield_Management/confidence.csv",[string tablow tabmid tabhigh])
  # (bins1,counts1)=hist(revenuelist, 10)
  # (bins2,counts2)=hist(revenuelist, 20)
  # (bins3,counts3)=hist(revenuelist, 50)
  # println(bins1)
  #ploter histogramme des gains
  # bar(bins1,counts1)
  # bar(bins2,counts2)
  # bar(bins3,counts3)

end

MonteCarlo()
