using DataFrames
include("ComputeBid")# c'est la resolution du probleme dual avec le solveur.
include("BidComparision")
function timeloop()

  Time = readtable("Yield_Management/Julia/Decoupage-Temporel_DonneesAF.csv")
  demandlist = readtable("Yield_Management/Julia/Demand_DonneesAF.csv")
  flowlist = readtable("Yield_Management/Julia/Flux_DonneesAF.csv")
  Flight = readtable("Yield_Management/Julia/Vols-Cabines_DonneesAF.csv")

  ##pas forcement utile
  # newDB=Time[1]
  # durationd=Time[2]
  # flowIDdemand=Demand[1]
  # tfNB=Demand[2]
  # bookingclass=Demand[3]
  # variance=Demand[4]
  # flightnumber=Flight[1]
  # departure=Flight[2]
  # cabin=Flight[3]
  # originairport=Flight[4]
  # destinationairport=Flight[5]
  # capacity=Flight[6]
  # flowidflow=Flow[1]
  # flowname=Flow[2]
  # bookingclass=Flow[3]
  # flowdepdate=Flow[4]
  # fare=Flow[5]
  # legindex=Flow[6]
  # flightnumber=Flow[7]
  # flightdepdate=Flow[8]
  # cabin=Flow[9]

  incomes = 0
  accepetedrequests = NULL

  for timestamp in newDB
    bidprices = ComputeBid()
    (acceptedrequests_timeframe,seatinventory,revenuetf)  = CompareBidQuery(timestamp,demandlist,flowlist,bidprices) #incorporer le check des places disponibles et la comparaison des bidprices.
    #Penser à mettre à jour les nombres de sieges dispo dans les avions.
    incomes = incomes+revenuetf
    accepetedrequests += acceptedrequests_timeframe
  end
  println(incomes)
  println(accepetedrequests)
end
