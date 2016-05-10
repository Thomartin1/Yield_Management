
function ComputeBid(timeperiode,
                    cap)

  #MODEL CONSTRUCTION
  #--------------------

  myModel = Model(solver=CplexSolver())

  filetest = readtable(PATH2)

  r = [0.0 for k = 1:nbOD]
  for j=1:nbOD
    r[j] = faresfromflows[idtoflow[j][1]][idtoflow[j][2]]
    #  price for fare class j є J
  end

  d = [0.0 for k = 1:nbOD, s=1:1000]
  for s = 1:1000
    ///////////////////////
    for j=1:nbOD
      d[j] = demfromflow[timeperiode][idtoflow[j][1]][idtoflow[j][2]]
      # mean demand for fare class j є J
    end
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

  Capdico = [0.0 for k = 1:nbleg]
  for k=1:nbleg
    Capdico[k] = cap[idtoleg[k]]
    # capacity of each leg
  end

  #VARIABLES
  #---------

  @variable(myModel, 0 <= x[j=1:nbOD, s=1:1000] <= d[j,s]) # allocation of capacity for O&D fare class j є J

  #OBJECTIVE
  #---------

  @objective(myModel, Max, (1/1000)*sum{sum{r[j]*x[j, s], j=1:nbOD}, s = 1:1000}) # Sets the objective to be maximazed

  #CONSTRAINTS
  #-----------

  @constraintref capconst[1:nbleg]

  for k=1:nbleg
    capconst[k] = @constraint(myModel, sum{delta[j,k]*x[j], j=1:nbOD} <= Capdico[k]) # capacity constraint
  end


  #THE MODEL IN A HUMAN-READABLE FORMAT
  #------------------------------------
  #println("The optimization problem to be solved is:")
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
