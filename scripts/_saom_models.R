## SAOMs to understand network dynamics in a printing and paper product cluster ##


# packages
library(RSiena)



# set WD - prepair the data - install package
setwd("/Users/juhaszsandor/Desktop/R folder/KC_SAOM/model7_")
getwd()


## DATA PREP ##

# networks in 2012 and 2015
KNetwork1 <- as.matrix(read.csv("../data/KNetwork1.csv", header=T, sep = ";", row.names = 1))
KNetwork2 <- as.matrix(read.csv("../data/KNetwork2.csv", header=T, sep = ";", row.names = 1))

# create the RSiena network object
network <- sienaNet(array(c(KNetwork1,KNetwork2), dim=c(28,28,2)))


# import the variable matricies
cog_data <- as.matrix(read.csv("../data/cog_prox_matrix.csv", header=T, sep =";", row.names = 1))
geo_data <- as.matrix(read.csv("../data/geo_prox_matrix.csv", header=T, sep =";", row.names = 1))
transtripXcog_data <- as.matrix(read.csv("../data/transtripXcog.csv", header=T, sep =";", row.names = 1))

owner_data <- as.matrix(read.csv("../data/ownership.csv", header=T, sep =";", row.names = 1))
age_data <- as.matrix(read.csv("../data/age.csv", header=T, sep =";", row.names = 1)) 
external_ties_data <-  as.matrix(read.csv("../data/external_ties.csv", header=T, sep =";", row.names = 1))
emp_data <- as.matrix(read.csv("../data/emp.csv", header=T, sep =";", row.names = 1))

# add dyadic variables
cog <- coDyadCovar(cog_data)
geo <- coDyadCovar(geo_data)
transtripXcog <- coDyadCovar(transtripXcog_data)

# add individual characteristics
age <- coCovar (age_data[,1])
external_ties <- coCovar(external_ties_data[,1])
emp <- coCovar(emp_data[,1])
owner <- coCovar(owner_data[,1])


# create a Siena data object from input networks
data <- sienaDataCreate(network, cog, geo, age, owner, external_ties, emp, transtripXcog)

# set the effects to be included
eff <- getEffects(data)

## THIS IS WHERE I AM



#model001
eff <- includeEffects(eff, cycle3, type = "eval", include =TRUE)
#eff2 <- includeEffects(eff2, transTrip, type = "creation", include =TRUE)
#eff2 <- includeEffects(eff2, transTrip, type = "endow", include =TRUE)
eff2 <- includeEffects(eff2, transTrip, type = "eval", include =TRUE)

eff2[eff2$effectName=='cog' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='cog' & eff2$type=='creation', 'include'] <- TRUE
eff2[eff2$effectName=='cog' & eff2$type=='endow', 'include'] <- TRUE

eff2[eff2$effectName=='geo' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='geo' & eff2$type=='creation', 'include'] <- TRUE
eff2[eff2$effectName=='geo' & eff2$type=='endow', 'include'] <- TRUE

eff2[eff2$effectName=='age alter' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='age ego' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='same owner' & eff2$type=='eval', 'include'] <- TRUE

eff2[eff2$effectName=='pipelines alter' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='pipelines ego' & eff2$type=='eval', 'include'] <- TRUE

eff2[eff2$effectName=='emp alter' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='emp ego' & eff2$type=='eval', 'include'] <- TRUE
eff2


#model002
eff2[eff2$effectName=='transtripXcog' & eff2$type=='eval', 'include'] <- TRUE
eff2[eff2$effectName=='transtripXcog' & eff2$type=='creation', 'include'] <- TRUE
eff2[eff2$effectName=='transtripXcog' & eff2$type=='endow', 'include'] <- TRUE

#model003 - different version



# check !!
eff2

# basic descriptive stats again
#print01Report(data2,eff2,modelname="descriptive_stats_constr")

# fitting a basic SAOM (only structural variables)
model2 <- sienaModelCreate(useStdInits = FALSE, projname = 'model05_0.2', n3 = 2000, nsub = 4)

# estimate parameters in a Siena model using siena07
#Siena_est2 <- siena07(model2, data=data2, effects=eff2, batch=TRUE, verbose = TRUE)

# more detailed stats +
ans <- siena07(model2, data=data2, effects=eff2)
summary(ans)
siena.table(ans, type='html', file='model05_0.2.html', tstat=TRUE, sig=TRUE, d=3)

#to try another model clear memory and rerun the script
rm(list=ls())