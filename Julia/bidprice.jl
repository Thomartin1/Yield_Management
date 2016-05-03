
using JuMP  # Need to say it whenever we use JuMP

using CPLEX # Loading the CPLEX module for using its solver


function ComputeBid(timeperiode)

  PATH2 = "/home/sebastien/Documents/Projet_Air_France/p2.csv"
  PATH3 = "/home/sebastien/Documents/Projet_Air_France/p3.csv"
  PATH4 = "/home/sebastien/Documents/Projet_Air_France/p4.csv"
  timeperiode = 1
  include("/home/sebastien/Documents/Yield_Management/Julia/idToLeg.jl")
  include("/home/sebastien/Documents/Yield_Management/Julia/legFromFlow.jl")
  include("/home/sebastien/Documents/Yield_Management/Julia/idToFlow.jl")
  include("/home/sebastien/Documents/Yield_Management/Julia/capacityOfLeg.jl")
  include("/home/sebastien/Documents/Yield_Management/Julia/faresFromFlows.jl")
  include("/home/sebastien/Documents/Yield_Management/Julia/demandFromFlow.jl")

  #MODEL CONSTRUCTION
  #--------------------

  myModel = Model(solver=CplexSolver())

  #INPUT DATA
  #----------
  idtoleg = idToLeg(PATH4)
  legfromflow = legFromFlow(PATH3)
  idtoflow = idToFlow(PATH3)
  capacityofleg = capacityOfLeg(PATH4)
  faresfromflows = faresFromFlows(PATH3)
  demfromflow = demFromFlow(PATH2, timeperiode)
  nbOD = length(idtoflow)
  nbleg = length(idtoleg)

  r = [0.0 for k = 1:nbOD]
  for j=1:nbOD
    r[j] = faresfromflows[idtoflow[j][1]][idtoflow[j][2]]
    #  price for fare class j є J
  end

  d = [0.0 for k = 1:nbOD]
  for j=1:nbOD
    d[j] = demfromflow[idtoflow[j][1]][idtoflow[j][2]]
    # mean demand for fare class j є J
  end

  c = [0 for k = 1:nbleg]
  for k=1:nbleg
    c[k] = capacityofleg[idtoleg[k]]
    # capacity of each leg
  end

  delta = [0 for m = 1:nbOD , n = 1:nbleg]
  for j=1:nbOD
    for k=1:nbleg
      if (idtoleg[k] in legfromflow[idtoflow[j][1]][idtoflow[j][2]])
        delta[j,k] =  1
        # = 1 if O&D fare class j uses leg k, 0 otherwise
      else
        delta[j,k] = 0
      end
    end
  end

  #VARIABLES
  #---------

  @defVar(myModel, 0 <= x[j=1:nbOD] <= d[j]) # allocation of capacity for O&D fare class j є J

  #OBJECTIVE
  #---------

  @setObjective(myModel, Max, sum{r[j]*x[j], j=1:nbOD} ) # Sets the objective to be maximazed

  #CONSTRAINTS
  #-----------

  @defConstrRef capconst[1:nbleg]

  for k=1:nbleg
    capconst[k] = @addConstraint(myModel, sum{delta[j,k]*x[j], j=1:nbOD} <= c[k]) # capacity constraint
  end


  #THE MODEL IN A HUMAN-READABLE FORMAT
  #------------------------------------
  println("The optimization problem to be solved is:")
  print(myModel) # Shows the model constructed in a human-readable form

  #SOLVE IT AND DISPLAY THE RESULTS
  #--------------------------------
  status = solve(myModel) # solves the model

  println("Objective value: ", getObjectiveValue(myModel)) # getObjectiveValue(model_name) gives the optimum objective value
  #for j=1:nbOD
  #  println("x = ", getValue(x)) # getValue(decision_variable) will give the optimum value of the associated decision variable
  #end

  for k=1:nbleg
    println("bid-price of leg ", k )
    println(getDual(capconst[k]))
  end
end
