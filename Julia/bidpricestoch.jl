
function ComputeBid(timeperiode,
                    cap)

  #MODEL CONSTRUCTION
  #--------------------

  myModel = Model(solver=CplexSolver())

  filetest = readtable(PATH2)
  nbsenario = 10

  r = [0.0 for k = 1:nbOD]
  for j=1:nbOD
    r[j] = faresfromflows[idtoflow[j][1]][idtoflow[j][2]]
    #  price for fare class j є J
  end

  d = [0.0 for k = 1:nbOD, s=1:nbsenario]
  for s = 1:nbsenario
    for j=1:nbOD
      for temps = 1:timeperiode
        p = Poisson(demfromflow[temps][idtoflow[j][1]][idtoflow[j][2]])
        d[j,s] = d[j,s] + rand(p,1)[1]
        # mean demand for fare class j є J
      end
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

  @variable(myModel, 0 <= x[j=1:nbOD, s=1:nbsenario] <= d[j,s]) # allocation of capacity for O&D fare class j є J

  @variable(myModel, y[k = 1:nbleg])

  #OBJECTIVE
  #---------

  @objective(myModel, Max, (1/nbsenario)*sum{sum{r[j]*x[j, s], j=1:nbOD}, s = 1:nbsenario}) # Sets the objective to be maximazed

  #CONSTRAINTS
  #-----------

  @constraintref capconststoch[1:nbleg, 1:nbsenario]

  for s =1:nbsenario
    for k=1:nbleg
      capconststoch[k,s] = @constraint(myModel, sum{delta[j,k]*x[j,s], j=1:nbOD} <= capacityofleg[idtoleg[k]] - y[k]) # capacity constraint
    end
  end

  @constraintref capconstglobal[1:nbleg]

  for k=1:nbleg
    capconstglobal[k] = @constraint(myModel, y[k] == capacityofleg[idtoleg[k]] - Capdico[k]) # capacity constraint
  end


  #THE MODEL IN A HUMAN-READABLE FORMAT
  #------------------------------------
  #println("The optimization problem to be solved is:")
  #print(myModel) # Shows the model constructed in a human-readable form

  #SOLVE IT AND DISPLAY THE RESULTS
  #--------------------------------
  status = solve(myModel) # solves the model

  # println("Objective value: ", getObjectiveValue(myModel)) # getObjectiveValue(model_name) gives the optimum objective value
  # for j=1:nbOD
  #  println("y = ", getValue(y)) # getValue(decision_variable) will give the optimum value of the associated decision variable
  # end

  bid = Dict{UTF8String,Float64}()
  for k=1:nbleg
    bid[idtoleg[k]] = - getdual(capconstglobal[k])
    if  capacityofleg[idtoleg[k]] != 0
      println(capacityofleg[idtoleg[k]])
    end
  end
  return bid
end
