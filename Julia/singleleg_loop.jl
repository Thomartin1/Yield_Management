include("ComputeBP")# c'est la resolution du probleme dual avec le solveur.

#L'indicage t est pour le temps, il va de 1 à T.
T= [1:5;] #attetion en Julia on commence à 1
#Pour l'instant nous ne sommes que sur un leg
IT=[1]
cl =[1:3;]
R = readcsv(PATH) #donné sous la forme d'une double tableau R[it][t][j] cw sont les requetes.
C=[4,3,5]


#Initialisation :
bidprice=ComputeBP(x) #le bid-price depend des place restantes. bidprice[1..cl]
x=C
#Boucle :
#Pour chaque requête (d’itinéraire it  pour la classe de tarif j, notée ritj) :
for it in IT
  for t in T
       for j in cl
       B=bidprice[j] #parcequ'on a qu'un leg sinon il faut sommer les bidprice sur les leg del'it
        if(R[it][t][j]>=B)  #en vrai on devrait avoir une somme si il y a plusieurs legs
            if(x[j]>0) #pour plusieur leg il faut s'assurer d'avoir la capacité sur tous les leg
                x[j]=x[j]-1
                bidprice=ComputeBP(x)
            end
        end
     end
  end
end
#Sinon on refuse et on ne fait rien.
