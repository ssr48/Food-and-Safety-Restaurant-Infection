# Civic Hackathon DC
# Issue Number 17
# Author:Shashank Rai

setwd("/Users/shashankrai/GitHub/dc_restaurant_inspections")
getwd()
#Import Data

#Summary
df_sum <- read.csv("output/potential_inspection_summary_data.csv", strip.white = T, na = c("",NA,"#N/A"))

#Violations
df_viol <-read.csv("output/potential_violation_details_data.csv", strip.white = T, na = c("",NA,"#N/A"))

#GeoCoding
df_geo <- read.csv("output/inspection_geocodes.csv", strip.white = T, na = c("",NA,"#N/A"))

#dimensions
dim(df_sum)
# [1] 70157    35
dim(df_viol)
# [1] 208981      5
#What's DCMR_25_Code? New Variable!
dim(df_geo)
# [1] 68363     3

#heads
head(df_sum)
head(df_geo)
head(df_viol)

length(unique(df_sum$inspection_id))
# [1] 70156 - 1 duplicate
length(unique(df_viol$inspection_id))
# [1] 41622
length(unique(df_geo$inspection_id))
# [1] 68362

# There seems to be one repeated observation in df_sum and df_geo
n_occur <- data.frame(table(df_sum$inspection_id))

n_occur[n_occur$Freq > 1,]
#       Var1 Freq
# 3959 4000    2
# Its inspection ID 4000

# A quick look at the data tells us that these are exactly the same observations
df_sum <- unique(df_sum)
df_geo <- unique(df_geo)

# We would want to look at the duplicates in the  violations data. But that does not have the date variable
# We will merge over the violations data and try to find a unique level for analysis. 

main <- merge(df_viol, df_sum, by.x = "inspection_id", by.y = "inspection_id", all.x = T, all.y = T)
main <- merge(main, df_geo, by.x = "inspection_id", by.y = "inspection_id", all.x = T, all.y = T)
dim(main)
# [1] 237515     41

#Confirming all inspection ids are in there
length(unique(main$inspection_id))
# [1] 70156

summary(main)

length(unique(main$inspection_id, main$inspection_date))
# [1] 70187

# This is unexpected. Either 31 restaurants have been inspected twice on the same day or there are 31 obs that 
# were not recorded in summary and geo datasets

length(unique(main$inspection_id, main$inspection_date, main$inspection_time_in, fromLast = F))
# [1] 70187

# Looks like there are 31 observations that were not captured in summary and geo datasets

# For now, we'll keep these observations. 

# Inspection years go as far back as 1931 and go up until 2024. We will keep the valid entries and see if the issue persists

table(main$known_valid)
# False   True 
# 71627 165888 

main<-main[!(main$known_valid== "False"),]

dim(main)
# [1] 165888     41

length(unique(main$inspection_id))
# [1] 38860

main$feature_id <- "restaurant_inspections_overdue"

############ Violations #######################
#generate binary variables for priority, priority foundation, and core violations
# If violations are corrected on site, they do not require a follow up. But not all violations may be corrected on
# site. 
#Priority
main$ifpriority[main$priority_violations > 0] <- 1
main$ifpriority[main$priority_violations == 0] <- 0
main$ifpriority[is.na(main$priority_violations)] <- NA
table(main$ifpriority, main$priority_violations, useNA = 'a')

main$priority_left <- main$priority_violations - main$priority_violations_corrected_on_site
table(main$priority_left, useNA = 'a')
table(main$ifpriority, useNA = 'a')
main$ifpriority[main$priority_left == 0] <- 0
table(main$ifpriority, useNA = 'a')
#       0     1  <NA> 
#   39244 34089 92555


#Priority Foundation
main$ifpriorityfoundation[main$priority_foundation_violations > 0] <- 1
main$ifpriorityfoundation[main$priority_foundation_violations == 0] <- 0
main$ifpriorityfoundation[is.na(main$priority_foundation_violations)] <- NA
table(main$ifpriorityfoundation, main$priority_foundation_violations, useNA = 'a')

main$priority_foundation_left <- main$priority_foundation_violations - main$priority_foundation_violations_corrected_on_site
table(main$priority_foundation_left, useNA = 'a')
table(main$ifpriorityfoundation, useNA = 'a')
main$ifpriorityfoundation[main$priority_foundation_left == 0] <- 0
table(main$ifpriorityfoundation, useNA = 'a')
#     0     1  <NA> 
#   29496 43837 92555


# Core
main$ifcore[main$core_violations > 0] <- 1
main$ifcore[main$core_violations == 0] <- 0
main$ifcore[is.na(main$core_violations)] <- NA
table(main$ifcore, main$core_violations, useNA = 'a')

main$core_left <- main$core_violations - main$core_violations_corrected_on_site
table(main$core_left,useNA = 'a')
table(main$ifcore, useNA = 'a')
main$ifcore[main$core_left == 0] <- 0
table(main$ifcore, useNA = 'a')
#       0     1  <NA> 
#   25222 48111 92555  

#Critical Violations
main$ifcritical[main$critical_violations > 0] <- 1
main$ifcritical[main$critical_violations == 0] <- 0
main$ifcritical[is.na(main$critical_violations)] <- NA
table(main$ifcritical, main$critical_violations, useNA = 'a')

main$critical_left <- main$critical_violations - main$critical_violations_corrected_on_site
table(main$critical_left,useNA = 'a')
table(main$ifcritical, useNA = 'a')
main$ifcritical[main$critical_left == 0] <- 0
table(main$ifcritical, useNA = 'a')
#      0     1  <NA> 
#   27813 64742 73333

#Non-Critical Violations
main$ifnoncritical[main$noncritical_violations > 0] <- 1
main$ifnoncritical[main$noncritical_violations == 0] <- 0
main$ifnoncritical[is.na(main$noncritical_violations)] <- NA
table(main$ifnoncritical, main$noncritical_violations, useNA = 'a')

main$noncritical_left <- main$noncritical_violations - main$noncritical_violations_corrected_on_site
table(main$noncritical_left,useNA = 'a')
table(main$ifnoncritical, useNA = 'a')
main$ifnoncritical[main$noncritical_left == 0] <- 0
table(main$ifnoncritical, useNA = 'a')
#       0     1  <NA> 
#   15701 76854 73333
table(main$ifcritical, main$ifnoncritical, useNA = 'a')
#         0     1    <NA>
# 0    11085 16728     0
# 1     4616 60126     0
# <NA>     0     0 73333

######### Inspections ################
#Routine
main$routine[main$inspection_type == "Routine"] <- 1
main$routine[main$inspection_type == "routine"] <- 1
main$routine[main$inspection_type == "ROUTINE"] <- 1
main$routine[main$inspection_type == "App. Routine"] <- 1
main$routine[main$inspection_type == "Routine (Inaugural Inspection)"] <- 1 
main$routine[main$inspection_type == "Routine / License Renewal"] <- 1 
main$routine[main$inspection_type == "ROUTINE DONE 9/15/10 INFORMATION PROVIDED WHILE IN"] <- 1 
main$routine[main$inspection_type == "Routine/Caterer"] <- 1 
main$routine[main$inspection_type == "Routine/HACCP"] <- 1 
main$routine[main$inspection_type == "ROUTINE/HACCP"] <- 1 
main$routine[main$inspection_type == "Routine/Sweep"] <- 1 
main$routine[main$inspection_type == "ROUTINE/SWEEP"] <- 1 
main$routine[main$inspection_type == "Routune"] <- 1 
main$routine[is.na(main$routine)] <- 0
table(main$routine)
#   0      1 
# 62077 103811   

#Follow up
main$followup[main$inspection_type == "Follow-up"] <- 1
main$followup[main$inspection_type == "2nd follow up"] <- 1
main$followup[main$inspection_type == "follow bup"] <- 1
main$followup[main$inspection_type == "follow up"] <- 1
main$followup[main$inspection_type == "follow uP"] <- 1
main$followup[main$inspection_type == "Follow up"] <- 1
main$followup[main$inspection_type == "Follow Up"] <- 1
main$followup[main$inspection_type == "FOLLOW UP"] <- 1
main$followup[main$inspection_type == "follow-up"] <- 1
main$followup[main$inspection_type == "Folow-up"] <- 1
main$followup[main$inspection_type == "5-Day Extension Follow-up"] <- 1
main$followup[main$inspection_type == "Complaint (Follow-up)"] <- 1
main$followup[main$inspection_type == "Complaint / Follow-up"] <- 1
main$followup[main$inspection_type == "complaint follow up"] <- 1
main$followup[main$inspection_type == "Follow up /License Transfer"] <- 1
main$followup[main$inspection_type == "Follow up, new"] <- 1
main$followup[main$inspection_type == "Follow-up  / License Transfer"] <- 1
main$followup[main$inspection_type == "Follow-up / License Transfer"] <- 1
main$followup[main$inspection_type == "FOLLOW-UP PRE-OP"] <- 1
main$followup[main$inspection_type == "FOLLOW-UP PRE-OPERATIONAL"] <- 1
main$followup[main$inspection_type == "Follow-up Preoperational"] <- 1
main$followup[main$inspection_type == "Follow-up restoration"] <- 1
main$followup[main$inspection_type == "FOLLOWUP RENEWAL"] <- 1
main$followup[main$inspection_type == "HACCP Follow UP"] <- 1
main$followup[main$inspection_type == "HACCP FOLLOW_UP INSPECTION"] <- 1
main$followup[main$inspection_type == "HACCP Follow-up"] <- 1
main$followup[main$inspection_type == "HACCP FOLLOW-UP "] <- 1
main$followup[main$inspection_type == "HACCP FOLLOW-UP INSPECTION"] <- 1
main$followup[main$inspection_type == "License Transfer / Follow-up"] <- 1
main$followup[main$inspection_type == "Preoperational  follow up"] <- 1
main$followup[main$inspection_type == "Preoperational  follow-up"] <- 1
main$followup[main$inspection_type == "Preoperational - Follow-up"] <- 1
main$followup[main$inspection_type == "Preoperational / Follow-up"] <- 1
main$followup[main$inspection_type == "Preoperational Follow Up"] <- 1
main$followup[main$inspection_type == "preopt follow up"] <- 1
main$followup[main$inspection_type == "RCP Follow up"] <- 1
main$followup[main$inspection_type == "Restoration Follow-Up Inspecion"] <- 1 
main$followup[main$inspection_type == "restoration, follow up"] <- 1 
main$followup[main$inspection_type == "ROUTINE FOR FOLLOW-UP"] <- 1 #Routine for follow-up is treated as follow-up and not routine
main$followup[main$inspection_type == "ROUTINE FOR FOLLW UP"] <- 1 #Routine for follow-up is treated as follow-up and not routine
main$followup[is.na(main$followup)] <- 0
table(main$followup)
#     0      1 
# 147551  18337 

table(main$routine, main$followup)
#       0      1
# 0  43740  18337
# 1 103811      0

main$otherinspections <- 0
main$otherinspections[(main$followup==0)&(main$routine == 0)] <- 1
table(main$otherinspections, useNA = 'a')
#       0      1   <NA> 
#   122148  43740      0 

################# Inspection Date, Month, Year #########################
library(zoo)
main$date_inspection <- as.Date(main$inspection_date)
summary(main$date_inspection)

main$year_inspection <- format(main$date_inspection,"%Y")
table(main$year_inspection, useNA = 'a')

#drop 2009
main <- main[(main$year_inspection != "2009"), ] #7 observations dropped
table(main$year_inspection, useNA = 'a')

main$month_inspection <- format(main$date_inspection, "%m")
table(main$month_inspection, useNA = 'a')

#create season 
main$year_inspection <- as.numeric(main$year_inspection)
main$month_inspection <- as.numeric(main$month_inspection)
main$season_inspection <- "Spring"
main$season_inspection[(main$month_inspection >= 6) & (main$month_inspection <= 8)] <- "Summer"
main$season_inspection[(main$month_inspection >= 9) & (main$month_inspection <= 11)] <- "Fall"
main$season_inspection[(main$month_inspection == 12) | (main$month_inspection <= 2)] <- "Winter"
table(main$season_inspection, main$month_inspection, useNA = 'a')

##############
main$establishment_category[(main$establishment_type == "Bakery") | (main$establishment_type == "Caterer") | 
                              (main$establishment_type == "Ice Cream Manufacturer")] <- "Confectionary and Catering"
main$establishment_category[(main$establishment_type == "Delicatessen") | (main$establishment_type == "Food Products") | 
                              (main$establishment_type == "Grocery Store")] <- "Grocery and Food Products"
main$establishment_category[(main$establishment_type == "Hotel") |  
                              (main$establishment_type == "Restaurant Total")] <- "Restaurants and Hotels"
main$establishment_category[(main$establishment_type == "Commission Merchant") | (main$establishment_type == "Unknown") |
                              (main$establishment_type == "Unlicensed Food")] <- "Others"
main$establishment_category[(main$establishment_type == "Marine-Food (Wholesale)") |  
                              (main$establishment_type == "Marine-Food Prod (Retail)")] <- "Marine"
main$establishment_category[(main$establishment_type == "Mobile Vending") |  
                              (main$establishment_type == "School Cafeteria")] <- "Vending and Cafeteria"
table(main$establishment_type, main$establishment_category, useNA = 'a')

write.csv(as.data.frame(table(main$establishment_category, main$risk_category, useNA = 'a')),
          file = "establishment_risk.csv")
write.csv(as.data.frame(table(main$establishment_category, main$routine, useNA = 'a')),
          file = "establishment_routine.csv")
write.csv(as.data.frame(table(main$establishment_category, main$followup, useNA = 'a')),
          file = "establishment_followup.csv")

library(psych)
write.csv(as.data.frame(describe(main)), file = "summarystats.csv")

###### Analysis #######
main$risk_category_factor <- as.factor(main$risk_category)
main$year <- as.factor(main$year_inspection)
main$inspection_category[main$routine == 1] <- "Routine"
main$inspection_category[main$followup == 1] <- "Follow Up"
main$inspection_category[main$otherinspections == 1] <- "Others"
table(main$inspection_category, useNA = 'a')
main$inspection_category <- as.factor(main$inspection_category)
main$inspection_category <- relevel(main$inspection_category, "Routine")
main$season_inspection <- as.factor(main$season_inspection)
main$establishment_category <- as.factor(main$establishment_category)
main$establishment_category <- relevel(main$establishment_category, "Restaurants and Hotels")
#total violations
summary(lm(main$total_violations ~ main$risk_category_factor + main$year + main$inspection_category 
           + main$season_inspection + main$establishment_category))
#If priority
summary(glm(main$ifpriority ~ main$risk_category_factor + main$year + main$inspection_category 
            + main$season_inspection + main$establishment_category, family = binomial))

#If priority foundation
summary(glm(main$ifpriorityfoundation ~ main$risk_category_factor + main$year + main$inspection_category 
            + main$season_inspection + main$establishment_category, family = binomial))

#If core
summary(glm(main$ifcore ~ main$risk_category_factor + main$year + main$inspection_category 
            + main$season_inspection + main$establishment_category, family = binomial))

#If critical
summary(glm(main$ifcritical ~ main$risk_category_factor + main$year + main$inspection_category 
            + main$season_inspection + main$establishment_category, family = binomial))

#If non critical
summary(glm(main$ifnoncritical ~ main$risk_category_factor + main$year + main$inspection_category 
            + main$season_inspection + main$establishment_category, family = binomial))
####################################
write.csv(main, file = "main.csv")
