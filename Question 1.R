# Q1: A bee walks around on a honeycomb, an infinite tessalating hexagonal grid, starting at a fixed hexagon. 
# At each step, the bee moves to one of the six adjacent hexagons with equal probability. We'll assume adjacent 
# hexagons are always a distance of one unit away from each other.

# For the first step the probability is 1 to go total distance 1
# From second step onwards, 
# probability of moving 1 step further = 0.5
#                 staying the same distance = 0.33
#                 going one step backwards = 0.167

options(digits = 10)

T <- c(1:64)

v.s <- c(1,0,-1)
p.s <- c(0.5, (1/3), (1/6))

# for T=1: probability 1 for s=1 and thus s=1

# the expected value for each step from second step onwards:
# next incremental distance:

expS.r <- p.s[1] * v.s[1] + p.s[2] * v.s[2] + p.s[3] * v.s[3] 
# this is the expected INCREMENTAL distance for every  round starting round 2!

expD.rT <- function(t) {
  D <- 1 + (t-1) * expS.r
  D
}

# 1. After T=16 steps, what is the expected value of the bee's distance from the starting hexagon?
expD.rT(16)
# [1] 6

# 2. After T=16 steps, what is the expected value of the deviation of the bee's distance from the starting hexagon?
sd.r <- sqrt((p.s[1] * v.s[1]^2 - expS.r^2) + (p.s[2] * v.s[2]^2 - expS.r^2) + (p.s[3] * v.s[3]^2 - expS.r^2))

# Now we need to think of the deviation. In this case, we have 3 possible outcomes for every step: -1, 0, 1
# for round 1, the standard deviation is 0, because there is just one outcome. Hence, round 1 doesn't matter for sd
# for round 2, the standard deviation is as follows

sd.r <- sqrt((p.s[1] * v.s[1]^2 - expS.r^2) + (p.s[2] * v.s[2]^2 - expS.r^2) + (p.s[3] * v.s[3]^2 - expS.r^2))
# this is the expected INCREMENTAL standard deviation for every  round starting round 2!

expSD.rT <- function(t) {
  SD <- 0 + (t-1) * sd.r
  SD
}

expSD.rT(16)
# [1] 8.660254038

# 3. After T=64 steps, what is the expected value of the bee's distance from the starting hexagon?
expD.rT(64)
# [1] 22

# 4. After T=64 steps, what is the expected value of the deviation of the bee's distance from the starting hexagon?
expSD.rT(64)
# 36.37306696

# 5. After T=16 moves, what is the probability that the bee is at least A=8 distance away from the starting 
# hexagon, given it is at least B=6 distance?


# 6. After T=64 moves, what is the probability that the bee is at least A=24 distance away from the starting 
# hexagon, given it is at least B=20 distance?
