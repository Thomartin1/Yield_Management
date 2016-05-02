
using JuMP  # Need to say it whenever we use JuMP

using CPLEX # Loading the CPLEX module for using its solver

function ComputeBid(leginflow,prices,meandemand,capacities)
  #MODEL CONSTRUCTION
  #--------------------

  myModel = Model(solver=CplexSolver())

  #INPUT DATA
  #----------
  idToLeg = idToLeg(PATH4)
  legFromFlow = legFromFlow(PATH3)
  idToFlow = IdToFlow(PATH3)
  capacityOfLeg = CapacityOfLeg(PATH4)
  faresFromFlow = FaresFromFlow(PATH3)

  nbOD = size(idToFlow)
  nbleg = length(idToLeg)

  for j=1:nbOD
    r[j] = faresFromFlow[idToFlow[j][1]][idToFlow[j][2]]
    #  price for fare class j є J
  end

  for j=1:nbOD
    d[j] =
    # mean demand for fare class j є J
  end

  for k=1:nbleg
    c[k] = capacityOfLeg[idToLeg[k]]
    # capacity of each leg
  end

  for j=1:nbOD
    for k=1:nbleg
      if (idToLeg[k] in legFromFlow[idToFlow[j][1]][idToFlow[j][2]]):
        delta[j][k] =  1
        # = 1 if O&D fare class j uses leg k, 0 otherwise
      else:
        delta[j][k] = 0
      end
    end
  end

  #VARIABLES
  #---------

  @defVar(myModel, 0 <= x[j=1:nbOD] <= d[j], Int) # allocation of capacity for O&D fare class j є J

  #OBJECTIVE
  #---------

  @setObjective(myModel, Max, sum{r[j]*x[j], j=1:nbOD} ) # Sets the objective to be maximazed

  #CONSTRAINTS
  #-----------

  for k=1:nbleg
    @addConstraint(myModel, capconst[k], sum{delta[j][k]*x[j], j=1:nbOD} <= c[k]) # capacity constraint
  end

  #THE MODEL IN A HUMAN-READABLE FORMAT
  #------------------------------------
  println("The optimization problem to be solved is:")
  print(myModel) # Shows the model constructed in a human-readable form

  #SOLVE IT AND DISPLAY THE RESULTS
  #--------------------------------
  status = solve(myModel) # solves the model

  println("Objective value: ", getObjectiveValue(myModel)) # getObjectiveValue(model_name) gives the optimum objective value
  for j=1:nbOD
    println("x = ", getValue(x)) # getValue(decision_variable) will give the optimum value of the associated decision variable
  end
  for k=1:nbleg
    println("bid-price of leg k = ", getDual(capconst[k]))
  end
  return(capconst)
end
