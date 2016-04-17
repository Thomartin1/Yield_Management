using DataFrames

function readcsv(PATH)
  data = readtable(PATH)
  return data
Data = readcsv("Yield_Management/Julia/Decoupage-Temporel_DonneesAF.csv")
  display(data)
