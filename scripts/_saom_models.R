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



## MODEL 1 
# include effects - change evaluation function to creatorion or endowment HERE
eff <- includeEffects(eff, cycle3, type = "eval", include =TRUE)
eff <- includeEffects(eff, transTrip, type = "eval", include =TRUE)
# eff <- includeEffects(eff, transTrip, type = "creation", include =TRUE)
# eff <- includeEffects(eff, transTrip, type = "endow", include =TRUE)

eff[eff$effectName=='cog' & eff$type=='eval', 'include'] <- TRUE
# eff[eff$effectName=='cog' & eff$type=='creation', 'include'] <- TRUE
# eff[eff$effectName=='cog' & eff$type=='endow', 'include'] <- TRUE

eff[eff$effectName=='geo' & eff$type=='eval', 'include'] <- TRUE
# eff[eff$effectName=='geo' & eff$type=='creation', 'include'] <- TRUE
# eff[eff$effectName=='geo' & eff$type=='endow', 'include'] <- TRUE

eff[eff$effectName=='age alter' & eff$type=='eval', 'include'] <- TRUE
eff[eff$effectName=='age ego' & eff$type=='eval', 'include'] <- TRUE
eff[eff$effectName=='same owner' & eff$type=='eval', 'include'] <- TRUE

eff[eff$effectName=='external_ties alter' & eff$type=='eval', 'include'] <- TRUE
eff[eff$effectName=='external_ties  ego' & eff$type=='eval', 'include'] <- TRUE

eff[eff$effectName=='emp alter' & eff$type=='eval', 'include'] <- TRUE
eff[eff$effectName=='emp ego' & eff$type=='eval', 'include'] <- TRUE
eff


# basic descriptive stats again
#print01Report(data, eff, modelname="descriptive_stats_constr")

# model creation
model_1 <- sienaModelCreate(useStdInits = FALSE, projname = '../model_outputs/model01', n3 = 2000, nsub = 4)

# estimate parameters in a Siena model using siena07
# Siena_est <- siena07(model_1, data=data, effects=eff, batch=TRUE, verbose = TRUE)

# final model 1 with more detailed stats
ans1 <- siena07(model_1, data=data, effects=eff)
summary(ans1)
siena.table(ans1, type='html', file='../model_outputs/model01.html', tstat=TRUE, sig=TRUE, d=3)



## MODEL 2
# include the interaction effect
eff[eff$effectName=='transtripXcog' & eff$type=='eval', 'include'] <- TRUE
# eff[eff$effectName=='transtripXcog' & eff$type=='creation', 'include'] <- TRUE
# eff[eff$effectName=='transtripXcog' & eff$type=='endow', 'include'] <- TRUE

# check !!
eff


# model creation
model_2 <- sienaModelCreate(useStdInits = FALSE, projname = '../model_outputs/model02', n3 = 2000, nsub = 4)

# final model 2 with more detailed stats
ans <- siena07(model_2, data=data, effects=eff)
summary(ans)
siena.table(ans, type='html', file='../model_outputs/model02.html', tstat=TRUE, sig=TRUE, d=3)

