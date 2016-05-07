
using JuMP  # Need to say it whenever we use JuMP

using CPLEX # Loading the CPLEX module for using its solver

include("globalVar.jl")

function ComputeBid(timeperiode,
                    c = Capdico)

  #MODEL CONSTRUCTION
  #--------------------

  myModel = Model(solver=CplexSolver())

  filetest = readtable(PATH2)

  r = [0.0 for k = 1:nbOD]
  for j=1:nbOD
    r[j] = faresfromflows[idtoflow[j][1]][idtoflow[j][2]]
    #  price for fare class j є J
  end

  d = [0.0 for k = 1:nbOD]
  for j=1:nbOD
    d[j] = demfromflow[timeperiode][idtoflow[j][1]][idtoflow[j][2]]
    # mean demand for fare class j є J
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

  # print(idtoflow[1])
  # println(d[1])
  # print(idtoflow[2])
  # println(d[2])
  # print(idtoflow[3])
  # println(d[3])
  # print(idtoflow[4])
  # println(d[4])
  # print(idtoflow[5])
  # println(d[5])
  # print(idtoflow[6])
  # println(d[6])
  # print(idtoflow[1480])
  # println(d[1480])

  #VARIABLES
  #---------

  @variable(myModel, 0 <= x[j=1:nbOD] <= d[j]) # allocation of capacity for O&D fare class j є J

  #OBJECTIVE
  #---------

  @objective(myModel, Max, sum{r[j]*x[j], j=1:nbOD} ) # Sets the objective to be maximazed

  #CONSTRAINTS
  #-----------

  @constraintref capconst[1:nbleg]

  for k=1:nbleg
    capconst[k] = @constraint(myModel, sum{delta[j,k]*x[j], j=1:nbOD} <= c[k]) # capacity constraint
  end


  #THE MODEL IN A HUMAN-READABLE FORMAT
  #------------------------------------
  println("The optimization problem to be solved is:")
  #print(myModel) # Shows the model constructed in a human-readable form

  #SOLVE IT AND DISPLAY THE RESULTS
  #--------------------------------
  status = solve(myModel) # solves the model

  # println("Objective value: ", getObjectiveValue(myModel)) # getObjectiveValue(model_name) gives the optimum objective value
  #for j=1:nbOD
  #  println("x = ", getValue(x)) # getValue(decision_variable) will give the optimum value of the associated decision variable
  #end
  #

  bid = Dict{UTF8String,Float64}()
  for k=1:nbleg
    bid[idtoleg[k]] = getdual(capconst[k])
  end
  return bid
end
