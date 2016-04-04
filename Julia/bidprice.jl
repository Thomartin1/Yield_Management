
using JuMP  # Need to say it whenever we use JuMP

using CPLEX # Loading the CPLEX module for using its solver


#MODEL CONSTRUCTION
#--------------------

myModel = Model(solver=CplexSolver())

#INPUT DATA
#----------

nbOD = size()
nbleg = size()
for j=1:nbOD
  r[j] = #  price for fare class j є J
end
for j=1:nbOD
  d[j] =  # mean demand for fare class j є J
end
for k=1:nbleg
  c[k] = # capacity of leg k є K
end
for j=1:nbOD
  for k=1:nbleg
    delta[j][k] = # = 1 if O&D fare class j uses leg k, 0 otherwise
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
