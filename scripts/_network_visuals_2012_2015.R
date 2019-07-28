### visualization of the knowledge network between firms in 2012 and 2015 ###


# packages
library(data.table)
library(dplyr)
library(igraph)

# for reproduction
set.seed(16)



##__  PLOT - highlight the core of the network and entries/exits __##

## DATA PREP ## 

# graph from matrix
mat1 <-as.matrix(read.csv("../data/KNetwork1.csv", sep=";", header=TRUE, row.names = 1))
graph1 <- graph.adjacency(mat1)

mat2 <-as.matrix(read.csv("../data/KNetwork2.csv", sep=";", header=TRUE, row.names = 1))
graph2 <- graph.adjacency(mat2)

# core/periphery characteristics of nodes
cp_df <- data.frame(fread("../data/core_periphery.csv", sep=";"), row.names = 1)

# add core/periphery attribute
V(graph1)$core <- cp_df$core2012
V(graph2)$core <- cp_df$core2015


# assign colors
V(graph1)[V(graph1)$core == 0]$color <- "white"
V(graph1)[V(graph1)$core == 1]$color <- "red"

V(graph2)[V(graph2)$core == 0]$color <- "white"
V(graph2)[V(graph2)$core == 1]$color <- "red"

# network layout
set.seed(45)
la <- layout_with_graphopt(graph1, niter=500, mass=2500)*1000


## PLOT 1
title <- "core_periphery_2012"
file_name <- paste("../figures/", title, ".png", sep="")
png(file_name, width=1200, height=900, units = 'px')

par(mar=c(0,0,2.2,0) + 0.1, mgp=c(3,1,0))

plot(graph1, layout=la*1000,
	vertex.size=5+4*log(degree(graph1)),
	vertex.label.color="black",
	vertex.label.cex=1.65,
	edge.color="black",
	edge.arrow.size=0.35,
	caption="")
title(main="2012", cex.main=3.5)
dev.off()


## PLOT 2
title <- "core_periphery_2015"
file_name <- paste("../figures/", title, ".png", sep="")
png(file_name, width=1200, height=900, units = 'px')

par(mar=c(0,0,2.2,0) + 0.1, mgp=c(3,1,0))

plot(graph2, layout=la*1000,
     vertex.size=5+4*log(degree(graph2)),
     vertex.label.color="black",
     vertex.label.cex=1.65,
     edge.color="black",
     edge.arrow.size=0.35,
     caption="")
title(main="2015", cex.main=3.5)
dev.off()



