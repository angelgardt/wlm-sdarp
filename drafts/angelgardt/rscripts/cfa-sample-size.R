library(MBESS)

mdl1 <- "
PR =~ pr01 + pr02 + pr03 + pr04 + pr05 + pr06 + pr07 + pr08 + pr09 + pr10
CO =~ co01 + co02 + co03 + co04 + co05 + co06 + co08 + co09 + co10
UT =~ ut01 + ut02 + ut03 + ut04 + ut05 + ut06 + ut07 + ut08 + ut09 + ut11 + ut12
FA =~ fa01 + fa02 + fa03 + fa04 + fa05 + fa06 + fa07 + fa08 + fa09 + fa10
DE =~ de01 + de02 + de03 + de05 + de06 + de07 + de08 + de09 + de10 + de11
UN =~ un01 + un02 + un03 + un04 + un05 + un06 + un07 + un08 + un09 + un10 + un11 + un12
"
semPower::semPower.aPriori(effect = 0.01, 
                           effect.measure = "RMSEA", 
                           alpha = .05, 
                           power = .8, 
                           df = 1814)

m <- 62
x <- 6
m*(m-1)/2 - 2*m - x*(x-1)/2
semPower::semPower.getDf(mdl1)

1814-1758
ss.power.sem(RMSEA.null=.05, RMSEA.true=.01, df=1752,
             alpha=.05, power=.80)

ss.aipe.rmsea(RMSEA=.045, df=1752, width=.060, conf.level=0.90)


mdl2 <- "
A =~ A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 + A9 + A10
B =~ B1 + B2 + B3 + B4 + B5 + B6 + B7 + B8 + B9 + B10
C =~ C1 + C2 + C3 + C4 + C5 + C6 + C7 + C8 + C9 + C10
D =~ D1 + D2 + D3 + D4 + D5 + D6 + D7 + D8 + D9 + D10
E =~ E1 + E2 + E3 + E4 + E5 + E6 + E7 + E8 + E9 + E10
"
semPower::semPower.getDf(mdl2)
m <- 50
x <- 5
m*(m+1)/2 - 2*m - x*(x-1)/2

(50*(50+1)/2) - (50 + 50-5 + choose(5, 2) + 5)

ap <- semPower::semPower.aPriori(effect = .01, effect.measure = 'RMSEA',
                                 alpha = .05, power = .80, df = 1165)
summary(ap)
