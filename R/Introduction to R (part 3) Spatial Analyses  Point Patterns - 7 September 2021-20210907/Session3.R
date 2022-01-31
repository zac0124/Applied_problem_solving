## Spatial data analyses in R
## Frédérik Saltré & CJA Bradshaw
## Session 4

library(spatstat)
library(gstat)
library(maps)
library(sp)
library(ape)
library(permute)
library(ggplot2)
library(dplyr)
library(sf)
library(readr)
library(rgdal)
library(maptools)
library(raster)

#########################################################################
#####     BASIC PLOTS AND AUTOCORRELATION           ####################
#########################################################################
##======================================================
## EXAMPLE 1: RANDOM DATASET
##======================================================
x <- runif(100, 1, 10)
y <- runif(100, 20, 30)
z <- runif(100, 1, 50)
xyz <- data.frame(x,y,z)
colnames(xyz) <- c("Lat","Lon","Values")

colpal1<- (xyz$Values-min(xyz$Values))/(max(xyz$Values)-min(xyz$Values))
plot(xyz$Lon,xyz$Lat,col=grey(colpal1),cex=0.5,pch=19)

xyz.dists <- as.matrix(dist(cbind(x, y)))
xyz.dists.inv <- 1/xyz.dists
diag(xyz.dists.inv) <- 0
mor_obs<-Moran.I(xyz$Values, xyz.dists.inv)
nld<-1000;out<-matrix(0,nld,4);nm<-length(xyz[,1])

for (i in 1:nld) {
  print(i)
  mat<-xyz[shuffle(nm),]$Values
  MorI<-Moran.I(mat,xyz.dists.inv)
  out[i,]<-c(MorI$observed,MorI$expected,MorI$sd,MorI$p.value)}

Moran_out<-as.data.frame(out[,1])
colnames(Moran_out) <- "Moran_I"
ggplot(Moran_out, aes(x=Moran_I))+
  geom_density(color="darkblue", fill="lightblue")+ 
  geom_vline(aes(xintercept=mor_obs$observed),
             color="blue", linetype="dashed", size=1)

##======================================================
## EXAMPLE 2: NET PRIMARY PRODUCTION OF SOUTH AUSTRALIA DATASET
##======================================================
NppAus<- read.table("NppSahul(0ka).csv",header=T,sep=",") 
colpal2<- (NppAus$Npp-min(NppAus$Npp))/(max(NppAus$Npp)-min(NppAus$Npp))

#regional plot
samap <- readOGR(dsn="sa.shp")
plot(samap)
points(NppAus$Lon,NppAus$Lat,col=grey(colpal2),cex=0.5,pch=19)

#continental plt
map("world",regions = "Australia")
points(NppAus$Lon,NppAus$Lat,col=grey(colpal2),cex=0.5,pch=19)


## MORAN's I
Npp.dists <- as.matrix(dist(cbind(NppAus$Lon, NppAus$Lat)))
Npp.dists.inv <- 1/Npp.dists
diag(Npp.dists.inv) <- 0
mor_obs<-Moran.I(NppAus$Npp, Npp.dists.inv)
nld<-1000;out<-matrix(0,nld,4);nm<-length(NppAus$Npp)

for (i in 1:nld) {
  print(i)
  mat<-NppAus[shuffle(nm),]$Npp
  MorI<-Moran.I(mat,Npp.dists.inv)
  out[i,]<-c(MorI$observed,MorI$expected,MorI$sd,MorI$p.value)}

Moran_out<-as.data.frame(out[,1])
colnames(Moran_out) <- "Moran_I"
ggplot(Moran_out, aes(x=Moran_I))+
  geom_density(color="darkblue", fill="lightblue")+ 
  geom_vline(aes(xintercept=mor_obs$observed),
             color="blue", linetype="dashed", size=1)



#################################################################################################################
################################      SPATIAL POINT PATTERNS      ###############################################
#################################################################################################################
##======================================================
## EXEMPLE 3: DESCRIBING A POINT PATTERN
##======================================================
aa<-rpoispp(100) #random point pattern poisson
summary(aa) #is an object of class 'ppp' (planar point pattern)
plot(aa)
plot(aa, cols="blue", chars="*")

# QUADRAT TEST TO TEST FOR EQUAL INTENSITY
b4 <- quadratcount(aa, 4, 4)
plot(aa, chars=".", cols = "black")
plot(b4, add=TRUE, col="blue")

intensity(aa)
Z<-density(aa)
plot(Z)
contour(Z)
persp(Z, theta=-30)
persp(Z, theta=-50, phi=20, border=NA, col="yellow", shade=0.7, apron=TRUE)

##======================================================
## EXEMPLE 4: DESCRIBING A POINT PATTERN
##======================================================
## actual dataset => using as.ppp
spdat <- read.table("spdat1.csv",header=T,sep=",") 
W<-c(range(spdat$lat),range(spdat$lon))
spdat_pp <- as.ppp(spdat, W)
plot(spdat_pp, cols="blue", chars="*")

b4_spdat <- quadratcount(spdat_pp, 4, 4)
plot(spdat_pp, chars=".", cols = "black")
plot(b4_spdat, add=TRUE, col="blue")

intensity(spdat_pp)
Zsp<-density(spdat_pp)
plot(Zsp)
plot(spdat_pp, col = "white", cex = .4, pch = 16, add = TRUE)



###################################################
##POINT PATTERN CHARACTERISTIC ANALYSES
set.seed(42)
inde <- rpoispp(100)
regu <- rSSI(0.09, 70)
clus <- rMatClust(30, 0.05, 4)

plot(regu)
plot(inde)
plot(clus)

#CLARK-EVANS INDEX => Value greater than 1 suggests a regular pattern.
clarkevans(regu)
clarkevans(inde)
clarkevans(clus)


#"Donnelly": Edge correction of Donnelly (1978), available for rectangular windows only. The theoretical expected value of mean nearest neighbour distance under a Poisson process is adjusted for edge effects by the edge correction of Donnelly (1978). The value of R
#is the ratio of the observed mean nearest neighbour distance to this adjusted theoretical mean.
#"guard": Guard region or buffer area method. The observed mean nearest neighbour distance for the point pattern X is re-defined by averaging only over those points of X that fall inside the sub-window clipregion.
#"cdf": Cumulative Distribution Function method. The nearest neighbour distance distribution function G(r)
#of the stationary point process is estimated by Gest using the Kaplan-Meier type edge correction. Then the mean of the distribution is calculated from the cdf.

###################################################
#NEAREST NEIGHBOURGH DISTANCES
#Estimates the nearest neighbour distance distribution function G(r) from a point pattern in a window of arbitrary shape.
plot(Gest(regu))
plot(envelope(regu, Gest, nsim=19))

plot(Gest(inde))
plot(envelope(inde, Gest, nsim=19))

plot(Gest(clus))
plot(envelope(clus, Gest, nsim=19))

###################################################
# K, L and PCF function
# K FUNCTION
K_reg <- Kest(regu)
plot(K_reg, . ~ r)
plot(K_reg, . - theo ~ r)
plot(envelope(regu, Kest, nsim=100))

K_inde <- Kest(inde)
plot(K_inde, . ~ r)
plot(K_inde, . - theo ~ r)
plot(envelope(inde, Kest, nsim=100))

K_clus <- Kest(clus)
plot(K_clus, . ~ r)
plot(K_clus, . - theo ~ r)
plot(envelope(clus, Kest, nsim=100))

# L FUNCTION
L_reg <- Lest(regu)
plot(L_reg, . ~ r)
plot(L_reg, . - theo ~ r)
plot(envelope(regu, Lest, nsim=100))

L_inde <- Lest(inde)
plot(L_inde, . ~ r)
plot(L_inde, . - theo ~ r)
plot(envelope(inde, Lest, nsim=100))

L_clus <- Lest(clus)
plot(L_clus, . ~ r)
plot(L_clus, . - theo ~ r)
plot(envelope(clus, Lest, nsim=100))

# PAIR CORRELATION FUNCTION
PCF_reg <- pcf(regu)
plot(PCF_reg, . ~ r)
plot(PCF_reg, . - theo ~ r)
plot(envelope(regu, pcf, nsim=100))

PCF_inde <- pcf(inde)
plot(PCF_inde, . ~ r)
plot(PCF_inde, . - theo ~ r)
plot(envelope(inde, pcf, nsim=100))

PCF_clus <- pcf(clus)
plot(PCF_clus, . ~ r)
plot(PCF_clus, . - theo ~ r)
plot(envelope(clus, pcf, nsim=100))

###################################################
#MARKED POINT PATTERN
#amacrine cells in the retina of a rabbit,
#They are either ‘on’ or ‘off’ cells, depending on whether they are excited by an increase or a decrease in illumination.

data (amacrine)
plot(amacrine)

amon <- amacrine[amacrine$marks == "on"]
amonff <- amacrine[amacrine$marks == "off"]
#or 
Yon <- split(amacrine)$on
Yoff <- split(amacrine)$off
#or
plot(Y <- split(amacrine))

# interaction function
plot(envelope(Y$on, pcf, nsim=100))
plot(envelope(Y$off, pcf, nsim=100))

plot(alltypes(amacrine, pcfcross))

#################################################################################################################
################################      ASSIGNEMENTS      ###############################################
#################################################################################################################


Koala<- read.table("KoalaNppSahul.csv",header=T,sep=",") 
colpal3<- (Koala$Npp-min(Koala$Npp))/(max(Koala$Npp)-min(Koala$Npp))

#continental plt
map("world",regions = "Australia")
points(Koala$Lon,Koala$Lat,col=grey(colpal3),cex=0.5,pch=19)



## MORAN's I
KoalaNpp.dists <- as.matrix(dist(cbind(Koala$Lon, Koala$Lat)))
KoalaNpp.dists.inv <- 1/KoalaNpp.dists
diag(KoalaNpp.dists.inv) <- 0
Koala_mor_obs<-Moran.I(Koala$Npp, KoalaNpp.dists.inv)
nld<-1000;out<-matrix(0,nld,4);nm<-length(Koala$Npp)

for (i in 1:nld) {
  print(i)
  mat<-Koala[shuffle(nm),]$Npp
  MorI<-Moran.I(mat,KoalaNpp.dists.inv)
  out[i,]<-c(MorI$observed,MorI$expected,MorI$sd,MorI$p.value)}

Moran_out<-as.data.frame(out[,1])
colnames(Moran_out) <- "Moran_I"
ggplot(Moran_out, aes(x=Moran_I))+
  geom_density(color="darkblue", fill="lightblue")+ 
  geom_vline(aes(xintercept=Koala_mor_obs$observed),
             color="blue", linetype="dashed", size=1)

## STEP #2 : Analysing the Koala spatial pattern
W<-c(range(Koala$Lat),range(Koala$Lon))
K_spdat_pp <- as.ppp(Koala, W)
plot(K_spdat_pp, cols="blue", chars=".")

#quadrat_test (2,2)
Kb4_spdat <- quadrat.test(K_spdat_pp, 2, 2)
plot(K_spdat_pp, chars=".", cols = "black")
plot(Kb4_spdat, add=TRUE, col="blue")

intensity(K_spdat_pp)
Zsp<-density(K_spdat_pp)
plot(Zsp)
plot(K_spdat_pp, col = "white", cex = .4, pch = 16, add = TRUE)



#Clark-Evans test
clarkevans(K_spdat_pp)

#Nearest distance plot
plot(envelope(K_spdat_pp, Gest, nsim=19))

#PCF test
PCF_koala <- pcf(K_spdat_pp)
plot(PCF_koala, . ~ r)
plot(PCF_koala, . - theo ~ r)
plot(envelope(K_spdat_pp, pcf, nsim=100))
