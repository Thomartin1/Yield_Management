# Liste des Paths à modifier pour avoir acces aux données

PATH1 = "/Users/Thomartin/Documents/Ponts_2A/Projet_AF/CSV/p1.csv"
PATH2 = "/Users/Thomartin/Documents/Ponts_2A/Projet_AF/CSV/p2.csv"
PATH3 = "/Users/Thomartin/Documents/Ponts_2A/Projet_AF/CSV/p3.csv"
PATH4 = "/Users/Thomartin/Documents/Ponts_2A/Projet_AF/CSV/p4.csv"

# Liste des includes nécessaires à la définitions des diccionnaires

include("/Users/Thomartin/Yield_Management/Julia/idToLeg.jl")
include("/Users/Thomartin/Yield_Management/Julia/legFromFlow.jl")
include("/Users/Thomartin/Yield_Management/Julia/idToFlow.jl")
include("/Users/Thomartin/Yield_Management/Julia/capacityOfLeg.jl")
include("/Users/Thomartin/Yield_Management/Julia/faresFromFlows.jl")
include("/Users/Thomartin/Yield_Management/Julia/demandFromFlow.jl")

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
