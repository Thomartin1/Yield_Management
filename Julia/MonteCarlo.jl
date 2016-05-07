# include("Globalloop.jl")
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
  for i in range(1,1000)
    # append!(revenuelist,timeloop(pathtime,pathflow,pathflights,pathdemand))
    append!(revenuelist,[rand(2000:4000)])
  end
  println(revenuelist)
  # on analyse la distribution des revenues obtenus(intervales de confiance).
  lowprecison = ConfidenceInterval(0.50,revenuelist)
  midprecison = ConfidenceInterval(0.75,revenuelist)
  highprecison = ConfidenceInterval(0.95,revenuelist)
  println(lowprecison)
  println(midprecison)
  println(highprecison)

  (bins1,counts1)=hist(revenuelist, 10)
  (bins2,counts2)=hist(revenuelist, 20)
  (bins3,counts3)=hist(revenuelist, 50)
  println(bins1)
  #ploter histogramme des gains
  plot(bins1,counts1)
  plot(bins2,counts2)
  plot(bins3,counts3)

  #limiter chiffres significatifs.

end

MonteCarlo()
