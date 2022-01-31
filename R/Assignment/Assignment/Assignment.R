### Name: Zorigt Munkhjargal
### FAN: munk0011
##########################

#### WEEK 1 EXERCISES 24AUG #####
####################

#################################################################
### EXERCISE #1
#################################################################
# write R script to 
# 1) create a sequence of numbers from 20 to 50
# 2) find the mean of numbers from 20 to 60 
# 3) sum the result of 2) of numbers from 51 to 91
# 4) sample 7 number from 1) with replacement and calculate its mean, sd, range. 
# all decimal values for mean and sd in 4) should be rounded at 2 decimal numbers

a<- seq(20,50)
b<-mean(20:60)
c<- seq(51, 91, 1) 
sum(c)
d<-sample(a,7,replace = TRUE)
round(mean(d))
round(sd(d))
round(range(d))


#################################################################
### EXERCISE #2
#################################################################
# 1) load the "weightgender.csv"
# 2) Plot the data as a histogram
# 3) split the data into Male and Female using a LOOP and IF/ELSE statement
# 4) create histogram for each gender
# 5) look at the summary statistics

dataWeight <- read.csv("/Users/zorigtmunkhjargal/Documents/1. Flinders university 2/2021/Semester 2 /Applied problem solving/R/R code  example data for simple tests  plotting (14 Sep 2001)-20210914/weightgender.csv",header=T,sep=",",dec=".")
head(dataWeight)
str(dataWeight)
comp = dataWeight[ ,1]

hist(comp, 
     main="Histogram for Weight vs Gender", 
     xlab="Weight",
     ylab="Gender",
     border="blue", 
     col="green",
     las=1, 
     breaks=5)

  for (i in 1:length(dataWeight$gender)){
    if(dataWeight$gender[i]=="F"){
      female.data <- subset(dataWeight, gender=="F")
    }
    else{
      male.data <- subset(dataWeight, gender=="M")
    }
  }  

  
histfemale = female.data [ ,1]
hist(histfemale,
     main="Histogram for Women", 
     xlab="Weight",
     ylab="Number of Women",
     border="blue", 
     col="white",
     las=1, 
     breaks=5)

histmale = male.data [ ,1]
hist(histmale,
     main="Histogram for Men", 
     xlab="Weight",
     ylab="Number of Men",
     border="red", 
     col="yellow",
     las=1, 
     breaks=5)

mean(dataWeight$weight)
median(dataWeight$weight)
sort(dataWeight$weight, decreasing=T)[1:50]

meanByM <- mean(male.data$weight)
meanByF <- mean(female.data$weight) 
diffWeight <- (meanByF - meanByM)

#################################################################
### EXERCISE #3
#################################################################
# redo Exercise 2 without a loop or if/else statement

splitdata<- split(dataWeight,dataWeight$gender)
female2.data <- splitdata$F
male2.data <- splitdata$M

histfemale2 = female2.data [ ,1]
hist(histfemale2,
     main="Histogram for Female", 
     xlab="Weight",
     ylab="Number of women",
     border="blue", 
     col="white",
     las=1, 
     breaks=5)

histmale = male.data [ ,1]
hist(histmale,
     main="Histogram for Male", 
     xlab="Weight",
     ylab="Number of men",
     border="red", 
     col="yellow",
     las=1, 
     breaks=5)

####################
#### WEEK 2 EXERCISES 31AUG #####
####################

#################################################################
### EXERCICE #1
#################################################################
# data is from a group of men and women who did workouts at a gym three times a week for a year. 
# Then, their trainer measured the body fat as follow:

Men <- c(13.3, 6.0, 20.0,	8.0, 14.0, 19.0, 18.0, 25.0, 16.0, 24.0, 15.0, 1.0, 15.0)
Women <- c(22.0, 16.0, 21.7, 21.0, 30.0, 26.0, 12.0, 23.2, 28.0, 23.0)

# (i) Visualise your data to identify potential difference beetween Men and Women
# (ii) Test whether the underlying populations of men and women at the gym have the same mean body fat using a randomisation test.
ttest <- t.test(Men, Women)

n1 <- length(Men)
n2 <- length(Women)
N <- n1 + n2

meanNW <- mean(Men) ; meanW <- mean(Women) 
diffObt <- (meanW - meanNW)

nreps <- 1000             
meanDiff <- numeric(nreps)

Combined <- c(Men, Women) # Combining the samples
n1 <- length(Men) #length noWaiting
n2 <- length(Women)#length Waiting
N <- n1 + n2 #length combined sample


for ( i in 1:nreps) {
  dataGym <- sample(Combined, N,  replace = FALSE)
  Men <- dataGym[1:n1] #redefine noWaiting group 
  Women <- na.omit(dataGym[n1+1: N]) #redefine Waiting group
  meanDiff[i] <- mean(Men) - mean(Women)
}

hist(meanDiff) #distribution of resampling
abline(v = diffObt, col = "blue") #add the observed value

# one-sided test using absolute value
absMeanDiff <- abs(meanDiff)
absDiffObt <- abs(diffObt)
nbout<-which(absMeanDiff >= absDiffObt) #The number of times when the absolute mean differences exceeded diffObt
prandom<-length(nbout)/nreps #The proportion of resamplings when each the mean diff exceeded the obtained value

#################################################################
### EXERCICE #2
#################################################################
# data movement of caterpillar as a function of their exposure to various chemicals  

# (i) Visualise your data to identify potential difference between groups
# (ii) Test whether the exposure to chemicals affect the mouvement of caterpillar

dataCaterpillar <- read.csv("/Users/zorigtmunkhjargal/Documents/1. Flinders university 2/2021/Semester 2 /Applied problem solving/R/Introduction to R (part 2) Tests and randomisation - 31 August-20210831/Caterpillar.csv",header=T,sep=",",dec=".")
catFrame <- data.frame(dataCaterpillar$Status, dataCaterpillar$Distance)

catertest <- t.test(catFrame)
meanCatStat <- mean(dataCaterpillar$Status) ; meanCatDis <- mean(dataCaterpillar$Distance) 
diffObt <- (meanCatStat - meanCatDis)

#linear regression

catreg <- lm(dataCaterpillar$Status ~ dataCaterpillar$Distance, data=catFrame)
plot(dataCaterpillar$Distance, dataCaterpillar$Status, pch=19, xlab="Status", ylab="Distance")
abline(catreg, lty=2, lwd=2, col="red")
summary(catreg)

####################
#### WEEK 3 EXERCISES 07SEP #####
####################

Koala<- read.table("/Users/zorigtmunkhjargal/Documents/1. Flinders university 2/2021/Semester 2 /Applied problem solving/R/Introduction to R (part 3) Spatial Analyses  Point Patterns - 7 September 2021-20210907/KoalaNppSahul.csv",header=T,sep=",",dec=".")
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


####################
#### WEEK 4 EXERCISES 14SEP #####
####################

# Exercise
height.dat <- c(1.64, 1.43, 2.01, 1.56, 1.63, 1.75, 1.76, 2.00, 1.94, 1.46, 1.59, 1.87)
weight.dat <- c(72, 65, 95, 70, 72, 85, 100, 80, 78, 54, 59, 75)

# plot weight vs. height data using plot, ggplot2

whdata <- data.frame(height.dat, weight.dat)

library(ggplot2)

Ctheme = theme(
  axis.title.x = element_text(size = 16),
  axis.text.x = element_text(size = 14),
  axis.title.y = element_text(size = 16),
  axis.text.y = element_text(size = 14),
  plot.title = element_text(size = 18),
  axis.line = element_line(colour = "black", size = 1, linetype = "solid"),
  panel.background = element_rect(fill = "white"),
  panel.grid.major.y = element_line(size = 0.5, linetype = 'dotted', colour = "light grey"),
  panel.grid.minor.y = element_line(size = 0.5, linetype = 'dotted', colour = "light grey"),
  panel.grid.major.x = element_line(size = 0.5, linetype = 'dotted', colour = "light grey"),
  panel.border = element_blank())

ggplot(data=whdata, aes(weight.dat)) +
  geom_histogram(bins=5, colour="grey") +
  labs(x = "weight", y = "frequency") +
  Ctheme

p <- ggplot(whdata, mapping = aes(x = weight.dat, y = height.dat))   
p + geom_point() +
  geom_smooth(formula = y ~ x, method = "lm", colour = "red") +
  labs(x = "Weight", y = "Height") +
  Ctheme

