*! version 30jul2026
// This do-file reproduces the examples shown in the article

mata: mata clear
clear mata
clear all
// order in which these are loaded is important!
run test_metrics.ado
run metric_ranges.ado
run helpfunctest.ado
run cat_est.ado
run catmetrics.ado

capture log close

sjlog using output1, replace
matrix C = (11,2,3 \ 3,16,6 \ 7,5,22)
catmetrics, mat(C)
sjlog close, replace

sjlog using output2, replace
webuse lbw, clear
catmetrics smoke low, metrics(54 196 217 256 266 280 281 282) talpha(0.2) tbeta(0.2)
sjlog close, replace

sjlog using output3, replace
webuse sysdsn1, clear
quietly mlogit insure age male nonwhite i.site
predict p*
catmetrics insure, probs(p1 p2 p3) classmetrics noexcel ///
metrics(P1 P2 P6 P14 P15 P16 P17 1 9 44 54 120 138 148 205)
sjlog close, replace

sjlog using output4, replace
webuse tobacco, clear
quietly zioprobit tobacco education income i.female age,  ///
inflate(education income i.parent age i.female i.religion)
catmetrics tobacco, pred metrics(ordinal)
sjlog close, replace

// view help
view catmetrics.sthlp