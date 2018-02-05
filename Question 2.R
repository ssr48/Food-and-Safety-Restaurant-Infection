setwd("/Users/shashankrai/GitHub/Data Incubator/Question 2")
getwd()

#Load Datasets
#GS = Group Scores
GS<-read.csv("Data/Physician_Compare_2015_Group_Public_Reporting___Performance_Scores.csv", 
              header = TRUE, sep = ",",na.string = c("NA", ""), skip = 0, 
              strip.white = TRUE, fill = TRUE, comment.char = "#", stringsAsFactors=FALSE)

# PE = Patient Experience
PE <- read.csv("Data/Physician_Compare_2015_Group_Public_Reporting_-_Patient_Experience.csv", 
               header = TRUE, sep = ",",na.string = c("NA", ""), skip = 0, 
               strip.white = TRUE, fill = TRUE, comment.char = "#", stringsAsFactors=FALSE)

# IS = Individual Scores
IS <- read.csv("Data/Physician_Compare_2015_Individual_EP_Public_Reporting___Performance_Scores.csv", 
               header = TRUE, sep = ",",na.string = c("NA", ""), skip = 0, 
               strip.white = TRUE, fill = TRUE, comment.char = "#", stringsAsFactors=FALSE)

#National
national <- read.csv("Data/Physician_Compare_National_Downloadable_File.csv", 
                     header = TRUE, sep = ",",na.string = c("NA", ""), skip = 0, 
                     strip.white = TRUE, fill = TRUE, comment.char = "#", stringsAsFactors=FALSE)

length(unique(paste0(GS$Group.PAC.ID, GS$Measure.Identifier)))
# [1] 11117
length(unique(paste0(IS$PAC.ID, IS$Measure.Identifier)))
# [1] 495417 -> unique at PAC.ID and Measure Identifier

#National
length(unique(national$NPI))
# [1] 1070395
length(unique(national$PAC.ID))
# [1] 1070399
length(unique(paste0(national$PAC.ID, national$Line.1.Street.Address)))
# [1] 2146727
length(unique(paste0(national$NPI, national$Line.1.Street.Address)))
# [1] 2146727
length(unique(paste0(national$NPI, national$Line.1.Street.Address, national$Line.2.Street.Address, 
                     national$Group.Practice.PAC.ID)))
# [1] 2931123

NT1 <- national[!duplicated(national$PAC.ID), ]
length(unique(NT1$NPI))
# [1] 1070395
# All unique NPIs are retained

x <- NT1[duplicated(NT1$NPI), ]
library(dplyr)
y <- NT1 %>% filter(NPI %in% x$NPI)

#looking at "y' we can see that not all PAC IDs are unique. So we'll use NPI
options(digits=10)
#1
NT2 <- NT1[!duplicated(NT1$NPI), ]
length(unique(NT2$NPI))
# [1] 1070395

#2
table(NT2$Gender)
#       F      M      U   <NA> 
#   492304 578090      1      0 
578090/492304
# [1] 1.174254119

#3
table(NT2$Gender[!is.na(NT2$Credential)], useNA = 'a')
#       F      M      U   <NA> 
#   124339 216670      1      0
124339/216670
# [1] 0.573863479

#4
length(unique(GS$Group.PAC.ID))
# [1] 2371
GS1 <- GS[!duplicated(GS$Group.PAC.ID), ]
facility <- as.data.frame(table(GS1$State, useNA = 'a'))
facility$lessthan10 <- 0
facility$lessthan10[facility$Freq < 10] <- 1
sum(facility$lessthan10) # 10

#5
length(unique(IS$NPI)) # 180723
length(unique(IS$PAC.ID)) #180723 
#No disagreement between NPI and PAC.ID
library(doBy)
performance <- as.data.frame(summaryBy(Measure.Performance.Rate ~ NPI, data=IS,na.rm=TRUE))
sd(performance$Measure.Performance.Rate.mean)
# [1] 25.04924721

#6
summary(IS$Measure.Performance.Rate)
# Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
# 0.00000  62.00000  98.00000  77.97635 100.00000 100.00000 
# No NAs
length(unique(IS$NPI))
# [1] 180723
length(unique(paste0(IS$NPI, IS$Measure.Identifier)))
# [1] 495417 unique at NPI and Measure Identifier level
# counts of NPI = number of measures, and since there are no NA's in measure rates, 
# counts of NPI = counts of measure rates
counts<-data.frame(table(IS$NPI)) #180723 observations

counts <- counts[counts$Freq > 9 , ] #2533 clinicians
colnames(counts)[colnames(counts) == "Var1"] <- "NPI"

performance2 <- merge(IS, counts, by = c("NPI"), all.y = TRUE, all.x = FALSE) 
# 2533 clinicians with 28164 observations
length(unique(paste0(performance2$NPI, performance2$Measure.Identifier)))
# 28164

#merge with graduation year variable
NT3 <- merge(NT2, performance2, by = c("NPI"), all.x = TRUE, all.y = TRUE)
length(unique(NT3$NPI))
# [1] 1070460
summary(NT3$Measure.Performance.Rate)
#     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
#   0.0000  39.0000  69.0000  63.7049  97.0000 100.0000  1067927 

regression <- NT3[((NT3$Graduation.year > 1972) & (NT3$Graduation.year < 2004)), ]
summary(regression$Graduation.year)
reg1 <- regression[!is.na(regression$Graduation.year), ]
summary(reg1$Measure.Performance.Rate)
# Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
# 0.00000  40.00000  72.00000  64.79712  97.00000 100.00000 
reg1 <- reg1[!is.na(reg1$Measure.Performance.Rate), ]
dim(reg1)
# [1] 20924    51

length(unique(reg1$NPI)) #1874

reg2 <- as.data.frame(summaryBy(Measure.Performance.Rate + reg1$Graduation.year ~ NPI, data=reg1,na.rm=TRUE))

reg2$gradyear <- as.factor(reg2$`reg1$Graduation.year.mean`)
summary(lm(Measure.Performance.Rate.mean ~ `reg1$Graduation.year.mean`, data = reg2), digits = 10)
# 0.002659825

#7
MD <- NT3 %>% filter(Credential %in% c("MD", "NP"))
table(MD$Credential, useNA = 'a')
#     MD     NP   <NA> 
#   225088  18808      0 

MD <- MD[!is.na(MD$Measure.Performance.Rate), ]
mean(MD$Measure.Performance.Rate[MD$Credential == "MD"]) - mean(MD$Measure.Performance.Rate[MD$Credential=="NP"])
# 8.129945246

#8
t.test(MD$Measure.Performance.Rate[MD$Credential == "MD"], MD$Measure.Performance.Rate[MD$Credential == "NP"])
#0.000001222927

