## STEM2002
## CJA Bradshaw
## R basics
## 24 Aug 2021

#############################################################
## simple arithmetic
#############################################################
rm(list = ls())

5 + 5 + 6

5    *5

10/2

1 - 5

3^2

2^5

5 < 3

3 < 5

8 == 10

8 == 8

4 <= 5

4 <= 4

4 != 5

4 != 4


#############################################################
## variable assignment
#############################################################

x <- 5
y <- 5
z <- 6

x
y
z

x + y + z


#############################################################
## vector manipulation
#############################################################
## create a vector
xvec <- c(1,3,2,10,5,8,10)
xvec

yvec <- 0:10
yvec

letters
LETTERS

seq(1,8,0.2)

zvec <- seq(1,10,2)
zvec

rep(0,10)

avec <- rep(1.87,20)
avec


## subscript a vector
xvec[3]

xvec[2:4]

i <- 4
xvec[i]

## length of vector
length(xvec)
length(yvec)
length(zvec)


## useful functions

log10(10)
log10(100)

log(10)
log(100)
log10(10)
log10(100)

exp(2.30258509)

sqrt(25)

min(xvec)

max(yvec)

sum(xvec)

mean(xvec)

median(xvec)

range(xvec)

var(xvec)

sd(xvec)

sample(xvec,10,replace = TRUE)

mysamp <- sample(xvec,100,replace = TRUE)
unique(mysamp)

round(15.2456, 0)
round(15.2456, 2)

ceiling(16.5)
floor(16.5)

vec <- c(1.34, 2.13, 5.32, 1.56, 2.1004)
round(vec, 0)
round(vec, 1)

vec[3] <- NA
vec
is.na(vec)
which(is.na(vec)==T)


#############################################################
## frequencies
#############################################################
xvec <- c(1,3,2,10,5,8,10)

table(xvec)

sort(table(xvec),decreasing=TRUE)

names(sort(table(xvec),decreasing=TRUE))

names(sort(table(xvec),decreasing=TRUE))[1]

as.numeric(names(sort(table(xvec),decreasing=TRUE))[1])


#############################################################
## datasets & matrices
#############################################################

vec.1 <- seq(1,10,1)
vec.2 <- rep(2,10)
vec.3 <- c(1,10,8,3,3,5,4,10,9,1)

dat.1 <- data.frame(vec.1,vec.2,vec.3)
dat.1

dat.2 <- matrix(0,nrow=10,ncol=3)
dat.2[ ,1] <- vec.1
dat.2[, 2] <- vec.2
dat.2[,3] <- vec.3
dat.2

colnames(dat.1) <- c("A","B","C")
dat.1

dim(dat.1)

#############################################################
## simple loops
#############################################################
iter <- 100 # number of iterations
gauss.means <- rep(0,iter) ## storage vector
mymean <- 100; mysd <- 17.5

for (i in 1:iter) {
  gauss.dist <- rnorm(100,mymean,mysd)
  gauss.means[i] <- mean(gauss.dist)
  print(i) ## show progression of loop
}

hist(rnorm(100,mymean,mysd))
gauss.means # list output
hist(gauss.means)
abline(v=mymean, lwd=3)
abline(v=mean(gauss.means), lwd=2, lty=2, col="green")

##########################
## if and ifelse statements
##########################
vec.LETT <- sample(LETTERS[1:5],20,replace=T) #RESAMPLE WITH REPLACEMENT
vec.LETT
vec.LETT.NUM <- ifelse(vec.LETT == "D", 4, vec.LETT)
vec.LETT.NUM

iter <- 100
x <- runif(100, 1, 10)
y <- runif(100, 20, 30)
xy <- data.frame(x,y)
head(xy)
z <- rep(0,100)



for (i in 1:iter) {
  if (xy$x[i] < 5)
    z[i] <- x[i]*y[i]
  else {
    z[i] <- x[i]/y[i]  
  }
} # end i loop
xyz <- data.frame(xy,z)
head(xyz)

# basic plotting
xs <- runif(100, 1, 10)
ys <- rnorm(100, mean=10, sd=2)
plot(xs, ys)

plot(xs, ys, pch=19, xlab="the x values", ylab="the y values", main="my bivariate plot")
linfit <- lm(ys~xs)
summary(linfit)
abline(linfit, lty=2, lwd=2, col="red")

hist(xs)
hist(ys)


####################
#### EXERCISES #####
####################

#################################################################
### EXERCISE #1
#################################################################
# write R script to 
# 1) create a sequence of numbers from 20 to 50
seq(20,50)
# 2) find the mean of numbers from 20 to 60
mean(seq(20,60))
# 3) sum the result of 2) of numbers from 51 to 91
vec1 <- seq(51, 91, 1)
sum(vec1)
# 4) sample 7 number from 1) with replacement and calculate its mean, sd, range. 
# all decimal values for mean and sd in 4) should be rounded at 2 decimal numbers


setwd("~/Documents/Lecturing/Flinders/STEM2005/2021S2")
dat <- read.csv("weightgender.csv")
head(dat)
str(dat)

#################################################################
### EXERCISE #2
#################################################################
# 1) load the "weightgender.csv"
# 2) Plot the data as a histogram
# 3) split the data into Male and Female using a LOOP and IF/ELSE statement
# 4) create histogram for each gender
# 5) look at the summary statistics



#################################################################
### EXERCISE #3
#################################################################
# redo Exercise 2 without a loop or if/else statement

