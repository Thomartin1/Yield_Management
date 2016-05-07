# Liste des Paths à modifier pour avoir acces aux données

PATH1 = "/home/sebastien/Documents/Projet_Air_France/p1.csv"
PATH2 = "/home/sebastien/Documents/Projet_Air_France/p2.csv"
PATH3 = "/home/sebastien/Documents/Projet_Air_France/p3.csv"
PATH4 = "/home/sebastien/Documents/Projet_Air_France/p4.csv"

# Liste des includes nécessaires à la définitions des diccionnaires

include("/home/sebastien/Documents/Yield_Management/Julia/idToLeg.jl")
include("/home/sebastien/Documents/Yield_Management/Julia/legFromFlow.jl")
include("/home/sebastien/Documents/Yield_Management/Julia/idToFlow.jl")
include("/home/sebastien/Documents/Yield_Management/Julia/capacityOfLeg.jl")
include("/home/sebastien/Documents/Yield_Management/Julia/faresFromFlows.jl")
include("/home/sebastien/Documents/Yield_Management/Julia/demandFromFlow.jl")

# Variables globales

# Lien entre Id et legs/Flow
idtoleg = idToLeg(PATH4)
idtoflow = idToFlow(PATH3)

# Diccionnaires d'acces aux données
legfromflow = legFromFlow(PATH3)
capacityofleg = capacityOfLeg(PATH4)
faresfromflows = faresFromFlows(PATH3)
demfromflow = demFromFlow(PATH2)

# Nomble de legs et de Flow totaux
nbOD = length(idtoflow)
nbleg = length(idtoleg)
