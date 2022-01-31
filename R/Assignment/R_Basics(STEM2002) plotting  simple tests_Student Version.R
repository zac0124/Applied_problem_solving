## STEM2002
## CJA Bradshaw
## 14/09/2021


#############################################################
## importing data
#############################################################
## red-cheeked dunnart (Sminthopsis virginiae) weights
wd <- "~/Documents/1. Flinders university 2/2021/Semester 2 /Applied problem solving/R/R code  example data for simple tests  plotting (14 Sep 2001)-20210914" 
setwd(wd)
getwd()

dat <- read.table("weightgender.csv", header = TRUE, sep = ",")
str(dat)
head(dat)
tail(dat)

hist(dat$weight)
mean(dat$weight)
median(dat$weight)
sort(dat$weight, decreasing=T)[1:50]

attach(dat) #access variables of a data.frame without calling the data.frame
hist(weight)
mean(weight)
detach(dat)


##########################
## subsetting
##########################
mean(subset(dat, gender=="F")$weight) # average female weight
mean(subset(dat, gender=="M")$weight) # average male weight
datF <- subset(dat, gender != "F")
## percentiles
##########################
mean(dat$weight)
range(dat$weight)

# 95% confidence interval
quantile(dat$weight, probs=0.025, na.rm=T)
quantile(dat$weight, probs=0.975, na.rm=T)

# 70% confidence interval
quantile(dat$weight, probs=0.15, na.rm=T)
quantile(dat$weight, probs=0.85, na.rm=T)

fem.dat <- subset(dat, gender=="F")
wt.lo.fem <- quantile(fem.dat$weight, probs=0.15, na.rm=T)
wt.up.fem <- quantile(fem.dat$weight, probs=0.85, na.rm=T)

mal.dat <- subset(dat, gender=="M")
wt.lo.mal <- quantile(mal.dat$weight, probs=0.15, na.rm=T)
wt.up.mal <- quantile(mal.dat$weight, probs=0.85, na.rm=T)

## plot error bars
means.vec <- c(mean(fem.dat$weight), mean(mal.dat$weight))
lo.vec <- c(wt.lo.fem, wt.lo.mal)
up.vec <- c(wt.up.fem, wt.up.mal)


## libraries!
library(Hmisc)
errbar(c("female","male"), y=means.vec, yplus=up.vec, yminus=lo.vec, ylim=c(0,max(up.vec)))


##########################
## merging & intersecting
##########################
vec.4 <- sample(LETTERS[10:15],100,replace=T)
vec.5 <- sample(1:100,100,replace=T)
vec.6 <- sample(LETTERS[1:12],100,replace=T)
vec.7 <- sample(1:100,100,replace=T)

dat.2 <- data.frame(vec.4,vec.5)
colnames(dat.2) <- c("area","measure.1")
dat.3 <- data.frame(vec.6,vec.7)
colnames(dat.3) <- c("area","measure.2")

head(dat.2)
head(dat.3)

dat.4 <- merge(dat.2, dat.3, by.x="area", by.y="area")
dim(dat.4)
head(dat.4)
dat.4

vec.8 <- sample(letters[5:10], 20, replace=T)
vec.9 <- sample(letters[8:13], 20, replace=T)
vec.8
vec.9
intersect(vec.8, vec.9)


##########################
## correlations
##########################
dat2 <- read.table("Correlation.csv", header = TRUE, sep = ",")
head(dat2)
plot(dat2$x, dat2$y, pch=19)
cor(dat2$x, dat2$y, method="pearson")
cor(dat2$x, dat2$y, method="spearman")


##########################
# row/column functions
##########################
colSums(dat2)
rowSums(dat2)

apply(dat2, MARGIN = 2, "sum")
apply(dat2, MARGIN = 1, "sum")

##########################
## correlations
##########################
dat2 <- read.table("Correlation.csv", header = TRUE, sep = ",")
head(dat2)
plot(dat2$x, dat2$y, pch=19)
cor(dat2$x, dat2$y, method="pearson")
cor(dat2$x, dat2$y, method="spearman")


##########################
# row/column functions
##########################
colSums(dat2)
rowSums(dat2)

apply(dat2, MARGIN = 2, "sum")
apply(dat2, MARGIN = 1, "sum")



################
## simple tests
################
TreeDens <- c(1270, 1210, 1800, 1875, 1300, 2150, 1330, 964, 961, 1400, 1280, 976, 771, 833, 883, 956) ## tree density
CWD <- c(121, 41, 183, 130, 127, 134, 65, 52, 12, 46, 54, 97, 1, 4, 1, 4) ## coarse woody debris
labs <- c(rep("A", 4), rep("B", 4), rep("C", 4), rep("D", 4))

tree.dat <- data.frame(TreeDens,CWD, labs)
# linear regression
fit1 <- lm(CWD ~ TreeDens, data=tree.dat)
plot(TreeDens, CWD, pch=19, xlab="tree density", ylab="coarse woody debris")
abline(fit1, lty=2, lwd=2, col="red")
summary(fit1)


# t-test
x <- rnorm(20, mean=10, sd=5)
y <- rnorm(20, mean=10, sd=3)
t.test(x,y)

x <- rnorm(20, mean=10, sd=5)
y <- rnorm(20, mean=12, sd=3)
t.test(x,y)


# ANOVA
fit.anova <- aov(CWD ~ labs, data = tree.dat)
summary(fit.anova)
boxplot(CWD ~ labs, data=tree.dat, xlab="group", ylab="coarse woody debris", col="orange", border="brown")


# test for normality
# normality tests
library(ggpubr)
ggdensity(tree.dat$CWD, 
          xlab = "coarse woody debris")
ggqqplot(tree.dat$CWD)
shapiro.test(tree.dat$CWD)


################
### plotting ###
################

## data
TreeDens <- c(1270, 1210, 1800, 1875, 1300, 2150, 1330, 964, 961, 1400, 1280, 976, 771, 833, 883, 956) ## tree density
CWD <- c(121, 41, 183, 130, 127, 134, 65, 52, 12, 46, 54, 97, 1, 4, 1, 4) ## coarse woody debris
labs <- c(rep("A", 4), rep("B", 4), rep("C", 4), rep("D", 4))

plot(TreeDens,CWD, pch=5, xlab="tree density (#/100 m2", ylab="coarse woody debris (#pieces/m2)")

fit <- lm(CWD ~ TreeDens)
summary(fit)
abline(fit, lty=2, col="red")

mean(subset(tree.dat, labs=="A")$CWD)
mean(subset(tree.dat, labs=="B")$CWD)
mean(subset(tree.dat, labs=="C")$CWD)
mean(subset(tree.dat, labs=="D")$CWD)

## retrieving elements of the fit
fit$coefficients
fit$coefficients[1] # intercept
fit$coefficients[2] # slope

# residuals
residuals(fit)
plot(TreeDens, fit$residuals, pch=19)
hist(fit$residuals, col="grey", border="black", main="", xlab="residual")

# plot residuals with original data
plot(TreeDens,CWD, pch=19, xlab="tree density", ylab="coarse woody debris")
abline(fit, lty=2)

for (i in 1:length(TreeDens)) {
  xs <- c(TreeDens[i], TreeDens[i])
  ys <- c(CWD[i], CWD[i] - fit$residuals[i])
  lines(xs, ys, lty=3, col="dark grey", lwd=1.5)
} # end i loop
points(TreeDens, fit$fitted.values, pch=3, col="red", cex=1.3)


# model information
# 1. residuals vs. fitted: shows if residuals have non-linear patterns
# 2. Normal Q-Q: shows if residuals are normally distributed
# 3. Scale-Location: shows if residuals are spread equally along the ranges of predictors
# 4. Residuals vs. Leverage: helps us to find influential cases
plot(fit)

plot(TreeDens,CWD, pch=19, xlab="tree density", ylab="coarse woody debris")
abline(fit, lty=2)
points(TreeDens[6], CWD[6], col="red", cex=1.5, pch=19)


# plotting with ggplot
tree.dat <- data.frame(labs, TreeDens, CWD)
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

ggplot(data=tree.dat, aes(TreeDens)) +
  geom_histogram(bins=5, colour="grey") +
  labs(x = "tree density", y = "frequency") +
  Ctheme


p <- ggplot(tree.dat, mapping = aes(x = TreeDens, y = CWD))   
p + geom_point() +
  labs(x = "tree density", y = "coarse woody debris") +
  Ctheme

p <- ggplot(tree.dat, mapping = aes(x = TreeDens, y = CWD))   
p + geom_point() +
  geom_smooth(method = "lm", colour = "red") +
  labs(x = "tree density", y = "coarse woody debris") +
  Ctheme


p <- ggplot(tree.dat, mapping = aes(x = TreeDens, y = CWD))   
p + geom_point() +
  geom_smooth(colour = "red") +
  labs(x = "tree density", y = "coarse woody debris") +
  Ctheme

library(ggrepel)
p <- ggplot(tree.dat, mapping = aes(x = TreeDens, y = CWD))   
p + geom_point() +
  geom_smooth(colour = "red") +
  geom_label_repel(aes(label = labs),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50',
                   segment.alpha = 0.7,
                   show.legend = F,
                   alpha=0.7) +
  scale_radius(c(0.45,0.45)) +
  labs(x = "tree density", y = "coarse woody debris") +
  Ctheme




# Exercise
height.dat <- c(1.64, 1.43, 2.01, 1.56, 1.63, 1.75, 1.76, 2.00, 1.94, 1.46, 1.59, 1.87)
weight.dat <- c(72, 65, 95, 70, 72, 85, 100, 80, 78, 54, 59, 75)

# plot weight vs. height data using plot, ggplot2
