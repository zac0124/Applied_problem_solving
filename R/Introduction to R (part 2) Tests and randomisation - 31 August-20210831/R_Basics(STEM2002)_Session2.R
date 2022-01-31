## STEM_2002
## CJA Bradshaw & Fred Saltré
## 31/08/2021


## remove everything
rm(list = ls())

########################################################################################################################################################
###############################################           SESSION 2                         ############################################### 
########################################################################################################################################################
## EXAMPLE #1 = Randomization test for difference between two means (t-test). 
##when waiting to get someone's parking space, that the driver you are waiting for is taking longer than necessary?
##They hung out in parking lots and recorded the time that it took for a car to leave a parking place. They broke the data down on the basis of whether or not someone in another car was waiting for the space
##I will begin using the mean difference as my statistic, and compare with the t statistic for the same purpose.

NoWaiting <- c(36.30, 42.07, 39.97, 39.33, 33.76, 33.91, 39.65, 84.92, 40.70, 39.65,
               39.48, 35.38, 75.07, 36.46, 38.73, 33.88, 34.39, 60.52, 53.63 )
Waiting <- c(49.48, 43.30, 85.97, 46.92, 49.18, 79.30, 47.35, 46.52, 59.68, 42.89,
             49.29, 68.69, 41.61, 46.81, 43.75, 46.55, 42.33, 71.48, 78.95)


ttest <- t.test(Waiting, NoWaiting) #t-test results

#----- randomization test
n1 <- length(NoWaiting)
n2 <- length(Waiting)
N <- n1 + n2

meanNW <- mean(NoWaiting) ; meanW <- mean(Waiting) 
diffObt <- (meanW - meanNW)

nreps <- 10000             # I am using 10000 resamplings of the data
meanDiff <- numeric(nreps)   #Setting up arrays to hold the results/data set

Combined <- c(NoWaiting, Waiting) # Combining the samples
n1 <- length(NoWaiting) #length noWaiting
n2 <- length(Waiting)#length Waiting
N <- n1 + n2 #length combined sample

#generate a random distribution of the difference of means
for ( i in 1:nreps) {
  data <- sample(Combined, N,  replace = FALSE)
  grp1 <- data[1:n1] #redefine noWaiting group 
  grp2 <- na.omit(data[n1+1: N]) #redefine Waiting group
  meanDiff[i] <- mean(grp1) - mean(grp2)
}

hist(meanDiff) #distribution of resampling
abline(v = diffObt, col = "blue") #add the observed value

# one-sided test using absolute value
absMeanDiff <- abs(meanDiff)
absDiffObt <- abs(diffObt)
nbout<-which(absMeanDiff >= absDiffObt) #The number of times when the absolute mean differences exceeded diffObt
prandom<-length(nbout)/nreps #The proportion of resamplings when each the mean diff exceeded the obtained value

##===========================================================================
## EXAMPLE #2 = Randomization test for correlation
## students to answer SAT-type questions (Score) without having read the passage on which those questions were based. 
##(For non-U.S. students, the SAT is a standardized exam commonly used in university admissions.) 
## The authors looked to see how performance on such items correlated with the SAT scores those students had when they applied to college. 

Score <- c( 58, 48, 48, 41, 34, 43, 38, 53, 41, 60, 55, 44, 43, 49,
            47, 33, 47, 40, 46, 53, 40, 45, 39, 47, 50, 53, 46, 53)
SAT <- c(590,590,580,490,550,580,550,700,560,690,800,600,650,580,
         660,590,600,540,610,580,620,600,560,560,570,630,510,620)

Pearson<-cor.test(SAT, Score) # Pearson's product-moment correlation
reg <- lm(SAT ~ Score) #linear model
robs<-round((summary(reg))$adj.r.squared, 4)

nreps = 10000         # Note: 10,000 replications
N <- length(SAT)
r <- numeric(nreps)

for (i in 1:nreps) {
  randScore <- sample(Score, N, replace = FALSE)
  reg2 <- lm(SAT ~ randScore)
  r[i] <- round((summary(reg2))$adj.r.squared, 4)
  
}

hist(r) #distribution of resampling
abline(v = robs, col = "blue") #add the observed value

# one-sided test using absolute value
absr <- abs(r)
absObt <- abs(robs)
nbout<-which(absr >= absObt) #The number of times when the absolute mean differences exceeded diffObt
prandom<-length(nbout)/nreps #The proportion of resamplings when each the mean diff exceeded the obtained value

#if we use non parametric test instead = Kendall
Kendall<-cor.test(SAT, Score, method = "kendall", exact = FALSE) # KENDALL's product-moment correlation

##===========================================================================
## EXAMPLE #3 = Randomization test for Analysis of Variance
## ANOVA provides a statistical test of whether two or more population means are equal, and therefore generalizes the t-test beyond two means
## numnber of bacteria as a functiuon of 4 methods of hand washing "water", regular "soap", antibacterial soap (ABS) and antibacterial spray (AS)
Bact <- c(51,5,19,18,58,50,82,17,70,164,88,111,73,119,20,95,84,51,110,67,119,108,207,102,74,135,102,124,105,139,170,87)
Method <- c("AS","AS","AS","AS","AS","AS","AS","AS","ABS","ABS","ABS","ABS","ABS","ABS","ABS","ABS","Soap","Soap","Soap","Soap","Soap","Soap","Soap","Soap","Water","Water","Water","Water","Water","Water","Water","Water")


boxplot(Bact ~ Method, 
        xlab = "Treatment", ylab = "Bacteria",
        frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))

fit.anova <- aov(Bact ~ Method)
reg<-summary(fit.anova)

model<-anova(lm(Bact ~ Method))
robs<-model$"F value"[1]

nreps = 10000         # Note: 10,000 replications
N <- length(Bact)
r <- numeric(nreps)

for (i in 1:nreps) {
  newBact <- sample(Bact, N, replace = FALSE)
  newmodel<-anova(lm(newBact ~ Method))
  r[i] <- newmodel$"F value"[1]
}

hist(r) #distribution of resampling
abline(v = robs, col = "blue") #add the observed value

# one-sided test using absolute value
absr <- abs(r)
absObt <- abs(robs)
nbout<-which(absr >= absObt) #The number of times when the absolute mean differences exceeded diffObt
prandom<-length(nbout)/nreps #The proportion of resamplings when each the mean diff exceeded the obtained value

##===========================================================================
## EXAMPLE #4 = Randomization test of normality => parametric bootstrap 
##The Shapiro-Wilks test for normality is one of three general normality tests designed to detect all departures from normality.

## data
TreeDens <- c(1270, 1210, 1800, 1875, 1300, 2150, 1330, 964, 961, 1400, 1280, 976, 771, 833, 883, 956) ## tree density
CWD <- c(121, 41, 183, 130, 127, 134, 65, 52, 12, 46, 54, 97, 1, 4, 1, 4) ## coarse woody debris
labs <- c(rep("A", 4), rep("B", 4), rep("C", 4), rep("D", 4))
tree.dat <- data.frame(labs, TreeDens, CWD)

fit.anova <- aov(CWD ~ labs, data = tree.dat)
summary(fit.anova)
boxplot(CWD ~ labs, data=tree.dat, xlab="group", ylab="coarse woody debris", col="orange", border="brown")

SW<-shapiro.test(tree.dat$CWD)
SWonb<-SW$statistic

nreps = 10000         # Note: 10,000 replications
N <- length(CWD)
r <- numeric(nreps)
mCWD<-mean(tree.dat$CWD)
sdCWD<-sd(tree.dat$CWD)

for (i in 1:nreps) {
  newCWD <- rnorm(N, mean = mCWD, sd = sdCWD)
  newSW<-shapiro.test(newCWD)
  r[i] <- newSW$statistic
}

hist(r) #distribution of resampling
abline(v = SWonb, col = "blue") #add the observed value

# one-sided test using absolute value
absr <- abs(r)
absObt <- abs(SWonb)
nbout<-which(absr <= absObt) #The number of times when the absolute mean differences exceeded diffObt
prandom<-length(nbout)/nreps #The proportion of resamplings when each the mean diff exceeded the obtained value

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
  data <- sample(Combined, N,  replace = FALSE)
  Men <- data[1:n1] #redefine noWaiting group 
  Women <- na.omit(data[n1+1: N]) #redefine Waiting group
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
# data mouvement of caterpillar as a function of their exporure to various chemicals  
data <- read.csv("/Users/zorigtmunkhjargal/Documents/1. Flinders university 2/2021/Semester 2 /Applied problem solving/R/Introduction to R (part 2) Tests and randomisation - 31 August-20210831/Caterpillar.csv",header=T,sep=",",dec=".")

# (i) Visualise your data to identify potential difference between groups
# (ii) Test whether the exposure to chemicals affect the mouvement of caterpillar
ttest <- t.test(data)
n1<-length(data)
meanNW <- mean(Men) ; 
diffObt <- (meanW - meanNW)
