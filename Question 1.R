# Q1: A bee walks around on a honeycomb, an infinite tessalating hexagonal grid, starting at a fixed hexagon. 
# At each step, the bee moves to one of the six adjacent hexagons with equal probability. We'll assume adjacent 
# hexagons are always a distance of one unit away from each other.

# For the first step the probability is 1 to go total distance 1
# From second step onwards, 
# probability of moving 1 step further = 0.5
#                 staying the same distance = 0.33
#                 going one step backwards = 0.167

# D = Total distance
# s = next incremental distance
# T = Total steps




d <- seq(0, 100, 1)


for (t in c(1:16)) {
  if (t = 1){
    d = t
  } else (t>1) {
    d2 = d+1
    d1 = d+0
    d0 = d-1
    D = c(d2, d1, d0)
    
  }
  
  for (D in d2){
    
  }
}
for (D in d){ # D is total distance
if (D > 0){
  Pplusone = 0.5
  Ppluszero = 0.33
  Pminusone = 0.1666667
}  else {
    Pplusone = 1
    Ppluszero = 0
    Pminusone = 0
} if (D = 0){
  Splusone = 0
  Spluszero = 0
  Sminusone = 0
} if (D = 1){
  Splusone = 1
  Spluszero = 1
  Sminusone = 1
} if (D > 1) {
  Splusone = toneagain + tsameplusone + tminusplusone  #should signify total probability till the nth step
  Spluszero = tonesame + tsamepluszero + tminuspluszero
  Sminusone = toneminus + tsameminusone + tminusminusone {
    toneagain = Splusone*Pplusone #+1+1
    tonesame = Splusone*Ppluszero # +1 + 0
    toneminus = Splusone*Pminusone # +1 - 1
    tsameplusone = Spluszero*Pplusone # +0 + 1
    tsamepluszero = Spluszero*Ppluszero # +0 + 0
    tsameminusone = Spluszero*Pminusone # +0 -1
    tminusplusone = Sminusone*Pplusone # -1 + 1
    tminuspluszero = Sminusone*Ppluszero # -1 + 0
    tminusminusone = Sminusone*Pminusone # -1 -1
  }
}
}
 

# 1. After T=16 steps, what is the expected value of the bee's distance from the starting hexagon?

# 2. After T=16 steps, what is the expected value of the deviation of the bee's distance from the starting hexagon?

# 3. After T=64 steps, what is the expected value of the bee's distance from the starting hexagon?

# 4. After T=64 steps, what is the expected value of the deviation of the bee's distance from the starting hexagon?

# 5. After T=16 moves, what is the probability that the bee is at least A=8 distance away from the starting 
# hexagon, given it is at least B=6 distance?

# 6. After T=64 moves, what is the probability that the bee is at least A=24 distance away from the starting 
# hexagon, given it is at least B=20 distance?
