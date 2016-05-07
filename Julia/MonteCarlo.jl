include("Globalloop.jl")
include("ConfidenceInterval.jl")
using DataFrames

function MonteCarlo()
  pathtime = #write local path
  pathflow= #write local path
  pathflights= #write local path
  pathdemand= #write local path

  #on fait tourner l'algo 1000 fois et on garde en memoire tous les resultats.
  revenuelist = []
  for i in range(1000)
    append!(revenuelist,timeloop(pathtime,pathflow,pathflights,pathdemand))
  end
  # on analyse la distribution des revenues obtenus(intervales de confiance).
  lowprecison = ConfidenceInterval(0.80,revenuelist)
  midprecison = ConfidenceInterval(0.90,revenuelist)
  highprecison = ConfidenceInterval(0.95,revenuelist)
  println(lowprecison)
  println(midprecison)
  println(highprecison)

  (bins1,counts1)=hist(revenuelist[, 10])
  (bins2,counts2)=hist(revenuelist[, 20])
  (bins3,counts3)=hist(revenuelist[, 50])
  #ploter histogramme des gains
  plot(bins1,counts1)
  plot(bins2,counts2)
  plot(bins3,counts3)
  
  #limiter chiffres significatifs.

end
