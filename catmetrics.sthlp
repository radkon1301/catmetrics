{smcl}
{* *! version 0.3.0  07Aug2026}{...}
{title:Title}

{pstd}{helpb catmetrics##catmetrics:catmetrics} {c -} computes 283 measures of association and correlation between two categorical
 variables, 6 proper scores for
 probabilistic forecasts, and 12 diagnostic measures of the accuracy of 
 probabilistic forecasts of such variables.{p_end}

{title:Syntax}

{marker nop}{...}
{pstd}The command has four syntax forms:{p_end}

{pstd}{cmd:catmetrics} {it:indepvar} {depvar} {bind:[{cmd:,} {it:options}]}{p_end}

{p 4 7}where {it:indepvar} and {depvar} are two categorical variables with the same
number of observed categories. In asymmetric applications,
{it:indepvar} precedes depvar chronologically or causally. 
In forecasting applications, {it:indepvar}
represents the actual outcome and {depvar} represents the predicted outcome.
For binary {it:indepvar} and {depvar}, the positive category must be coded
using the smallest numeric value.{p_end}

{pstd}{cmd:catmetrics} {it:indepvar} {bind:[{cmd:,} probs(varlist) {it:options}]}{p_end}

{p 4 7}where {it:indepvar} contains the realized values of a categorical variable, and probs(varlist) supplies the predicted probabilities for each category.
The probabilities should be listed in ascending category order.
The number of supplied probability variables must equal the number of distinct observed categories.
If {it:indepvar} is binary, the positive category must be coded using the smallest
numeric value.
{p_end}

{pstd}{cmd:catmetrics} {it:indepvar} {bind:[{cmd:,} predict {it:options}]}{p_end}

{p 4 7}where {it:indepvar} again contains the realized outcomes, and predicted probabilities are obtained
from the most recently estimated Stata model (such as {bf:logistic}, {bf:logit}, {bf:probit}, {bf:oprobit},
{bf:cmclogit}, {bf:mlogit}, {bf:mprobit}, {bf:ziologit}, {bf:zioprobit}) using Stata's post-estimation command {bf:predict}.
If {it:indepvar} is binary, the positive category is assumed to be coded using the smallest numeric value.
{p_end}

{pstd}{cmd:catmetrics} {bind:[{cmd:,} mat(string) {it:options}]}{p_end}

{p 4 7}where mat(string) supplies a contingency table or confusion matrix directly.
If {bf:mat()} is binary, the positive category must be in the first column/row.{p_end}

{p 4 7}In each case, the command displays a classification table (confusion matrix), computes the 283
measures of association, agreement, information, similarity, and deterministic categorical forecast evaluation,
and returns the class-specific measures for each
class as well as their macro and weighted averages. When predicted probabilities are supplied, {cmd:catmetrics}
additionally computes 6 strictly proper scoring rules and 12 diagnostic measures for probabilistic forecast evaluation.
All computed measures can be exported to an Excel file.{p_end}

{p 4 7} The following options are available.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}

{synopt :{opt excel:(string)}} specifies the name of the saved *.xlsx file with all computed measures.
By default, the file is named Catmetrics.xlsx.

{synopt :{opt noexcel}} suppresses creation of the *.xlsx file. 
By default, results are saved to the Catmetrics.xlsx file.

{synopt :{opt metrics:(string)}}
specifies the measures to display in the Results window. Measures can be selected in any order
using their indices
(see the list of available measures in {help catmetrics##MetricReferenceTable:Metric Reference Table} below).
{p_end}

{synopt :}
{opt metrics(all)} displays all available measures. Probability-based measures are computed only
when predicted probabilities are supplied.
{p_end}

{synopt :}
{opt metrics(ordinal)} displays only the measures for ordinal data.
{p_end}

{synopt :}
{opt metrics(none)} suppresses the display of all measures.
{p_end}

{synopt :}
If {opt metrics()} is not specified, {cmd:catmetrics} displays the default set of measures: {break}
for binary data: 1, 2, 9, 42, 64, 65, 119, 120, 125, 132, 134, 146, 148,
163, 205, 212, 234, 241, 256, 280, 281, and 282, and additionally, if predicted
probabilities are supplied, P1, P2, P6, P7, P8, P12, P14, P15, and P16; {break}
for multicategory data with K > 2: 1, 9, 42, 44, 52, 132, 134, 138, 163, 205,
234, 241, 256, 260, and additionally, if predicted probabilities are supplied,
P1, P2, P6, P12, P14, and P17.
{p_end}

{synopt :{opt classmet:rics}} displays class-specific measures for binary data. By default,
class-specific measures for binary data are not displayed. For multicategory data (K > 2), if
binary metrics are selected in {opt metrics()}, their class-specific values are always displayed.

{synopt :{opt bkappa:(scalar)}} specifies the value of kappa, a positive irrational number,
used for [16] Baulieu coefficient #22. By default, kappa = e.

{synopt :{opt crlambda:(scalar)}} specifies the value of lambda used for [53]
Cressie-Read power divergence statistic. By default, lambda = 2/3.

{synopt :{opt ealpha:(scalar)}} specifies the value of 0 <= alpha <= 1 used for
[271] van Rijsbergen effectiveness E-measure. By default, alpha = 0.5.

{synopt :{opt eceq:(scalar)}} specifies the value of q > 0 used for [P9]
expected calibration error. By default, q = 1.

{synopt :{opt ecem:(scalar)}} specifies the integer value of m in {2,3,...} used for
the [P9] expected calibration error. By default, m = 10.

{synopt :{opt fbeta:(scalar)}} specifies the value of beta >= 0 used for
[78] F-beta score. By default, beta = 1.5.

{synopt :{opt gaink:(scalar)}} specifies the value of 0 < k < 1 used for
[P10] gain at k. By default, k = 0.1.

{synopt :{opt gfholderp:(scalar)}} specifies the value of p != 0 used for
[99-101] generalized Fleiss coefficients (Hölder) #1, #2, and #3.
By default, p = 0.5.

{synopt :{opt gflehmerp:(scalar)}} specifies the value of p used for [105-107]
generalized Fleiss coefficients (Lehmer) #1, #2, and #3. By default, p = 1.5.

{synopt :{opt gltheta:(scalar)}} specifies the value of theta > 0 used for [139]
Gower-Legendre S_theta index. By default, theta = 1.5.

{synopt :{opt goalpha:(scalar)}} specifies the value of alpha > 0 used for [140]
Gray-Orlowska interestingness index. By default, alpha = 2.

{synopt :{opt gobeta:(scalar)}} specifies the value of beta > 0 used for [140]
Gray-Orlowska interestingness index. By default, beta = 2.

{synopt :{opt ibaalpha:(scalar)}} specifies the value of alpha (0 <= alpha <= 1)
used for [117] generalized index of balanced accuracy. By default, alpha = 0.5.

{synopt :{opt ibam:(scalar)}} specifies the value of m, the index of the binary measure,
used for [117] generalized index of balanced accuracy. By default, m = 125,
corresponding to the G-mean.

{synopt :{opt kweights:(string)}} specifies the weighting matrix used for [274]
weighted kappa coefficient. The weighting matrix must be symmetric and have the
same dimensions as the contingency table. All main diagonal entries ωii must equal
1, and all off-diagonal entries ωij, i ≠ j, must lie in the interval [0,1].
By default, ωii = 1 and ωij = 0.5, i ≠ j.

{synopt :{opt liftk:(scalar)}} specifies the value of 0 < k < 1 used for [P11]
lift at k. By default, k = 0.1.

{synopt :{opt mceq:(scalar)}} specifies the value of q > 0 used for [P13]
maximum calibration error. By default, q = 1.

{synopt :{opt mcem:(scalar)}} specifies the integer value of m in {2,3,...} used
for [P13] maximum calibration error. By default, m = 10.

{synopt :{opt power:(scalar)}} specifies the value of beta > 1 used for [P3]
power score. By default, beta = 1.5.

{synopt :{opt pseudo:spherical(scalar)}} specifies the value of beta > 1 used for
[P4] pseudospherical score. By default, beta = 1.5.

{synopt :{opt sokalw:(scalar)}} specifies the value of w > 0 used for [244]
Sokal-Sneath coefficient #6. By default, w = 3.

{synopt :{opt talpha:(scalar)}} specifies the value of alpha > 0 used for [266]
Tversky index. By default, alpha = 1/3.

{synopt :{opt tbeta:(scalar)}} specifies the value of beta > 0 used for [266]
Tversky index. By default, beta = 1/3.

{synoptline}

{title:Examples}

{pstd}Compute the catmetrics command by including the true values as the independent variable and predicted values as the dependent variable.{p_end}
       {bf:. catmetrics y y_pred}

{pstd}Compute the catmetrics command by including the true values as dependent variable while specifying the probabilities in the options.
In this example, y takes on values in three categories; hence p1, p2, and p3 are necessary.{p_end}
       {bf:. catmetrics y, probs(p1 p2 p3)}

{pstd}Compute the catmetrics command by including the true values as dependent variable while using the Stata {cmd:predict} command to compute the probabilities.
It is required that variable names p1, p2, up to pK are not already defined within Stata.{p_end}
       {bf:. catmetrics y, pred}

{pstd}Compute the catmetrics command by specifying a contingency table in the options and saving the results to "Example file name.xlsx".
Also display class-specific measures if the data is binary.{p_end}
       {bf:. catmetrics, mat(contingency_table) excel(Example file name) classmet}

{pstd}Compute the catmetrics command for the specified contingency table, not saving the results to an .xlsx book and printing metrics 1, 123, and 5.{p_end}
       {bf:. catmetrics, mat(contingency_table) noexcel metrics(1 123 5)}
	   
{pstd}Compute the catmetrics command with different beta values for the Power, Pseudospherical, and Fbeta score.{p_end}
       {bf:. catmetrics y, probs(p1 p2 p3) power(2.5) pseudospherical(2.5) fbeta(2.5)}
	   
{pstd}Compute the catmetrics command with different parameter values for the Gray-Orlowska interestingness weighting dependency, index of balanced accuracy, and weighted kappa metrics.{p_end}
       {bf:. catmetrics y y_pred, goalpha(1.5) gobeta(0.5) ibaalpha(0.75) kweights(kappa_matrix)}

{pstd}Compute the catmetrics command for a contingency table named Confusion, saving to "demo_1.xlsx" and suppressing all printed metrics, including probabilistic scores.{p_end}
       {bf:. catmetrics, mat(Confusion) metrics(none) excel(demo_1)}

{pstd}Compute the catmetrics command with only probabilistic-score tokens specified in {opt metrics()}.{p_end}
       {bf:. webuse fullauto}
       {bf:. oprobit rep77 foreign length mpg}
       {bf:. catmetrics rep77, pred metrics(P1 P3 P5 P10)}

{title:Output}

{p 4 7}By default, a selection of measures along with their ranges and values is printed in the Stata console.{p_end}
{p 4 7}The printed contingency (or confusion) table includes an additional row and column reporting the row and column sums, with the overall sample size n shown in the bottom-right corner.{p_end}
{p 4 7}The arrows in the ranges should be interpreted as general guidelines: {break}
If two arrows point in the same direction, as in [-1 → 0 → 1], they indicate a progression from
perfect negative association to independence and then to perfect positive association. {break}
If arrows point toward a central value, as in [-1 → 0 ← 1], the midpoint is a neutral value,
such as no dependence or no skill. {break}
If only one arrow is shown, as in [0 → 1], the arrow points toward stronger positive association
or better performance. {break}
If no arrow is shown, as in [0 (never), 1 (always)], none of these directional interpretations apply
to the measure's range.
{p_end}
{p 4 7}The theoretical range of a measure may depend on the table dimensions and sample size.
Consequently, nominal endpoints may not always be attainable, even when marginal totals are not fixed.
{p_end}
{p 4 7}In case of two categories and no class-specific measures being printed,
the Value column refers to the value of the metric for the positive category.
Overall sample values and category-specific values are printed as available.
The macro average is an arithmetic average over metric values across categories.
The weighted average is the average of category-specific values weighted by the observed counts of each category.
Dots '.' signify any metrics that cannot be computed for the given data.{p_end}
{p 4 7}Some of the metrics' and probability scores' names may end in (ORD). 
These metrics and scores are suited only for ordinal data.
Ordinal categories must be entered from the smallest to largest.{p_end}
{p 4 7}Some computed ranges may have 'cl' or 'au' next to the presented range: 'cl' refers to a conservative lower bound 
(when no analytical lower bound is available and cannot easily be approximated),
and 'au' refers to an approximate upper bound (when the exact upper bound is not available).{p_end}
{p 4 7}By default, a similar table is saved to an .xlsx output file.
This table can be found in the 'Association measures' sheet.
In case probabilities are provided (using either {opt predict} or {opt probs:(varlist)}), 
a selection of probabilistic scores can be found in the 'Probabilistic scores' sheet.
Numerical values in the output file are displayed using 4-digit rounding for ease of use. The underlying values
are the raw values computed within Stata, with no precision loss due to rounding.{p_end}
 
{marker DefaultPrintOuts}
{title:Default print-outs}

{pstd} If there are two categories present:{p_end}
	1. Accuracy
	2. Added value
	9. Balanced accuracy
	42. Clayton skill score
	64. Doolittle raw accuracy
	65. Driver-Kroeber similarity index
	119. Gilbert index
	120. Gilbert skill score
	125. G-mean
	132. Goodman-Kruskal lambda coefficient
	134. Goodman-Kruskal tau coefficient
	146. Heidke skill score
	148. Hit rate
	163. Krippendorff alpha coefficient
	205. Peirce skill score
	212. Precision
	234. Scott pi coefficient
	241. Sokal-Sneath similarity coefficient #3
	256. Theil uncertainty coefficient U
	280. Yule phi correlation coefficient
	281. Yule Q coefficient
	282. Yule Y coefficient
	If probabilistic scores are available:
	P1 Brier score
	P2 Logarithmic score
	P6 Spherical score
	P7 Accuracy rate
	P8 Average precision
	P12 Macro-average mean probability rate
	P14 Mean probability rate
	P15 Normalized area under CAP
	P16 Normalized area under ROC


{pstd} If there are more than two categories present:{p_end}
	1. Accuracy
	9. Balanced accuracy
	42. Clayton skill score
	44. Cohen kappa coefficient
	52. Cramer concordance coefficient
	132. Goodman-Kruskal lambda coefficient
	134. Goodman-Kruskal tau coefficient
	138. Gorodkin Rk coefficient
	163. Krippendorff alpha coefficient
	205. Peirce skill score
	234. Scott pi coefficient
	241. Sokal-Sneath similarity coefficient #3
	256. Theil uncertainty coefficient U
	260. Tschuprow T coefficient
	If probabilistic scores are available:
	P1 Brier score
	P2 Logarithmic score
	P6 Spherical score
	P12 Macro-average mean probability rate
	P14 Mean probability rate
	P17 2AFC score #1


{marker ProbScoreTable}
{title:Probabilistic Score Table}

{pstd}
The following tokens can be used in {opt metrics()} to select individual probabilistic scores for terminal display.
All scores require predicted probabilities to be supplied via {opt probs()} or {opt predict}.
{p_end}

{pstd}
Strictly proper scoring rules for probabilistic forecasts:
{p_end}

{synoptset 5 tabbed}{...}
{synopthdr:Token}
{synoptline}
{synopt:{opt P1}}Brier score {p_end}
{synopt:{opt P2}}Logarithmic score {p_end}
{synopt:{opt P3}}Power score {p_end}
{synopt:{opt P4}}Pseudospherical score {p_end}
{synopt:{opt P5}}Ranked probability score {p_end}
{synopt:{opt P6}}Spherical score {p_end}
{synoptline}

{pstd}
Diagnostic measures for probabilistic forecasts:
{p_end}

{synoptset 5 tabbed}{...}
{synopthdr:Token}
{synoptline}
{synopt:{opt P7}}Accuracy rate{p_end}
{synopt:{opt P8}}Average precision (AP){p_end}
{synopt:{opt P9}}Expected calibration error (ECE){p_end}
{synopt:{opt P10}}Gain at k{p_end}
{synopt:{opt P11}}Lift at k{p_end}
{synopt:{opt P12}}Macro-average mean probability rate (MAPR){p_end}
{synopt:{opt P13}}Maximum calibration error (MCE){p_end}
{synopt:{opt P14}}Mean probability rate (MPR){p_end}
{synopt:{opt P15}}Normalized area under cumulative accuracy profile (CAP){p_end}
{synopt:{opt P16}}Normalized area under receiver operating characteristic (ROC) curve{p_end}
{synopt:{opt P17}}Two-alternative forced choice (2AFC) score #1{p_end}
{synopt:{opt P18}}Two-alternative forced choice (2AFC) score #2 [ORD]{p_end}
{synoptline}

{marker MetricReferenceTable}
{title:Metric Reference Table}

{pstd}
For the option {opt metrics:(string)}, the numeric indices should be used.
The table below lists all 283 available metrics with their corresponding index numbers.
The metric names printed in the Results window and Excel are usually
shortened for readability and to save space.
{p_end}

{synoptset 5 tabbed}{...}
{synopthdr:Number}
{synoptline}
{synopt:{opt 1}}Accuracy{p_end}
{synopt:{opt 2}}Added value{p_end}
{synopt:{opt 3}}Adjusted noise-to-signal ratio{p_end}
{synopt:{opt 4}}Alroy coefficient{p_end}
{synopt:{opt 5}}Anderberg coefficient{p_end}
{synopt:{opt 6}}Anderberg D{p_end}
{synopt:{opt 7}}Appleman index{p_end}
{synopt:{opt 8}}Atkinson similarity{p_end}
{synopt:{opt 9}}Balanced accuracy{p_end}
{synopt:{opt 10}}Balanced error rate{p_end}
{synopt:{opt 11}}Baroni-Urbani-Buser #1{p_end}
{synopt:{opt 12}}Baroni-Urbani-Buser #2{p_end}
{synopt:{opt 13}}Base rate{p_end}
{synopt:{opt 14}}Batagelj-Bren distance Q_0{p_end}
{synopt:{opt 15}}Baulieu dissimilarity #13{p_end}
{synopt:{opt 16}}Baulieu dissimilarity #22 (kappa=2.7183){p_end}
{synopt:{opt 17}}Baulieu dissimilarity #23{p_end}
{synopt:{opt 18}}Baulieu dissimilarity #24{p_end}
{synopt:{opt 19}}Baulieu dissimilarity #25{p_end}
{synopt:{opt 20}}Baulieu dissimilarity #27{p_end}
{synopt:{opt 21}}Baulieu dissimilarity #28{p_end}
{synopt:{opt 22}}Baulieu dissimilarity #29{p_end}
{synopt:{opt 23}}Baulieu dissimilarity #30{p_end}
{synopt:{opt 24}}Baulieu dissimilarity #31{p_end}
{synopt:{opt 25}}Baulieu dissimilarity #32{p_end}
{synopt:{opt 26}}Baulieu dissimilarity #33{p_end}
{synopt:{opt 27}}Benini coefficient #1{p_end}
{synopt:{opt 28}}Benini coefficient #2{p_end}
{synopt:{opt 29}}Benini coefficient #3{p_end}
{synopt:{opt 30}}Benini coefficient #4{p_end}
{synopt:{opt 31}}Bennet S coefficient{p_end}
{synopt:{opt 32}}Berger-Parker index{p_end}
{synopt:{opt 33}}Bias index{p_end}
{synopt:{opt 34}}Blaheta-Johnson unigram subtuples{p_end}
{synopt:{opt 35}}Braun-Blanquet similarity index{p_end}
{synopt:{opt 36}}Bray-Curtis dissimilarity index{p_end}
{synopt:{opt 37}}Brin conviction coefficient{p_end}
{synopt:{opt 38}}Causal confidence{p_end}
{synopt:{opt 39}}Causal confirmed confidence{p_end}
{synopt:{opt 40}}Causal confirm{p_end}
{synopt:{opt 41}}Chord distance metric{p_end}
{synopt:{opt 42}}Clayton skill score{p_end}
{synopt:{opt 43}}Clement reliability coefficient{p_end}
{synopt:{opt 44}}Cohen kappa coefficient{p_end}
{synopt:{opt 45}}Cole C_5 correlation coefficient{p_end}
{synopt:{opt 46}}Collective strength index{p_end}
{synopt:{opt 47}}Consonni-Todeschini index #1{p_end}
{synopt:{opt 48}}Consonni-Todeschini index #2{p_end}
{synopt:{opt 49}}Consonni-Todeschini index #3{p_end}
{synopt:{opt 50}}Consonni-Todeschini index #4{p_end}
{synopt:{opt 51}}Consonni-Todeschini index #5{p_end}
{synopt:{opt 52}}Cramer concordance coefficient{p_end}
{synopt:{opt 53}}Cressie-Read power divergence (lambda=.6667){p_end}
{synopt:{opt 54}}Czekanowski index{p_end}
{synopt:{opt 55}}Dennis z-score{p_end}
{synopt:{opt 56}}Dependency measure{p_end}
{synopt:{opt 57}}Descriptive confirm{p_end}
{synopt:{opt 58}}Digby correlation coefficient{p_end}
{synopt:{opt 59}}Discriminant power{p_end}
{synopt:{opt 60}}Discrimination d' distance{p_end}
{synopt:{opt 61}}Dominance index{p_end}
{synopt:{opt 62}}Donaldson bias index{p_end}
{synopt:{opt 63}}Doolittle association ratio{p_end}
{synopt:{opt 64}}Doolittle raw accuracy{p_end}
{synopt:{opt 65}}Driver-Kroeber similarity index{p_end}
{synopt:{opt 66}}Error rate{p_end}
{synopt:{opt 67}}Example and counterexample{p_end}
{synopt:{opt 68}}Extremal dependence index{p_end}
{synopt:{opt 69}}Extreme dependency index{p_end}
{synopt:{opt 70}}Eyraud index{p_end}
{synopt:{opt 71}}Fager-McGowan index #1{p_end}
{synopt:{opt 72}}Fager-McGowan index #2{p_end}
{synopt:{opt 73}}Faith similarity index{p_end}
{synopt:{opt 74}}False alarm ratio{p_end}
{synopt:{opt 75}}False negative rate{p_end}
{synopt:{opt 76}}False omission rate{p_end}
{synopt:{opt 77}}False positive rate{p_end}
{synopt:{opt 78}}Fbeta-score (beta=1.5){p_end}
{synopt:{opt 79}}Fisher exact statistic{p_end}
{synopt:{opt 80}}Fleiss-Levin-Paik agreement{p_end}
{synopt:{opt 81}}Forbes coefficient #1{p_end}
{synopt:{opt 82}}Forbes coefficient #2{p_end}
{synopt:{opt 83}}Fossum index{p_end}
{synopt:{opt 84}}Freeman-Tukey F^2 statistic{p_end}
{synopt:{opt 85}}Freeman-Tukey F^2 statistic (asymptotic){p_end}
{synopt:{opt 86}}F-score adjusted{p_end}
{synopt:{opt 87}}Galton agreement coefficient{p_end}
{synopt:{opt 88}}Ganascia coefficient{p_end}
{synopt:{opt 89}}Gener. Fleiss coefficient (arithmetic) #2{p_end}
{synopt:{opt 90}}Gener. Fleiss coefficient (contraharmonic) #1{p_end}
{synopt:{opt 91}}Gener. Fleiss coefficient (contraharmonic) #2{p_end}
{synopt:{opt 92}}Gener. Fleiss coefficient (contraharmonic) #3{p_end}
{synopt:{opt 93}}Gener. Fleiss coefficient (harmonic) #1{p_end}
{synopt:{opt 94}}Gener. Fleiss coefficient (harmonic) #2{p_end}
{synopt:{opt 95}}Gener. Fleiss coefficient (harmonic) #3{p_end}
{synopt:{opt 96}}Gener. Fleiss coefficient (Heronian) #1{p_end}
{synopt:{opt 97}}Gener. Fleiss coefficient (Heronian) #2{p_end}
{synopt:{opt 98}}Gener. Fleiss coefficient (Heronian) #3{p_end}
{synopt:{opt 99}}Gener. Fleiss coefficient (Holder) #1 (p=.5){p_end}
{synopt:{opt 100}}Gener. Fleiss coefficient (Holder) #2 (p=.5){p_end}
{synopt:{opt 101}}Gener. Fleiss coefficient (Holder) #3 (p=.5){p_end}
{synopt:{opt 102}}Gener. Fleiss coefficient (identric) #1{p_end}
{synopt:{opt 103}}Gener. Fleiss coefficient (identric) #2{p_end}
{synopt:{opt 104}}Gener. Fleiss coefficient (identric) #3{p_end}
{synopt:{opt 105}}Gener. Fleiss coefficient (Lehmer) #1 (p=1.5){p_end}
{synopt:{opt 106}}Gener. Fleiss coefficient (Lehmer) #2 (p=1.5){p_end}
{synopt:{opt 107}}Gener. Fleiss coefficient (Lehmer) #3 (p=1.5){p_end}
{synopt:{opt 108}}Gener. Fleiss coefficient (logarithmic) #1{p_end}
{synopt:{opt 109}}Gener. Fleiss coefficient (logarithmic) #2{p_end}
{synopt:{opt 110}}Gener. Fleiss coefficient (logarithmic) #3{p_end}
{synopt:{opt 111}}Gener. Fleiss coefficient (quadratic) #1{p_end}
{synopt:{opt 112}}Gener. Fleiss coefficient (quadratic) #2{p_end}
{synopt:{opt 113}}Gener. Fleiss coefficient (quadratic) #3{p_end}
{synopt:{opt 114}}Gener. Fleiss coefficient (Seiffert) #1{p_end}
{synopt:{opt 115}}Gener. Fleiss coefficient (Seiffert) #2{p_end}
{synopt:{opt 116}}Gener. Fleiss coefficient (Seiffert) #3{p_end}
{synopt:{opt 117}}Gener. index of balanced accuracy (alpha=.5,M=125){p_end}
{synopt:{opt 118}}Gerrity skill score [ORD]{p_end}
{synopt:{opt 119}}Gilbert index{p_end}
{synopt:{opt 120}}Gilbert skill score{p_end}
{synopt:{opt 121}}Gilbert-Wells index{p_end}
{synopt:{opt 122}}Gini coefficient #1{p_end}
{synopt:{opt 123}}Gini coefficient #2{p_end}
{synopt:{opt 124}}Gini impurity index{p_end}
{synopt:{opt 125}}G-mean{p_end}
{synopt:{opt 126}}G-mean adjusted{p_end}
{synopt:{opt 127}}Goodall index{p_end}
{synopt:{opt 128}}Goodman concomitance coefficient{p_end}
{synopt:{opt 129}}Goodman-Kruskal coefficient #1{p_end}
{synopt:{opt 130}}Goodman-Kruskal coefficient #2{p_end}
{synopt:{opt 131}}Goodman-Kruskal gamma coefficient [ORD]{p_end}
{synopt:{opt 132}}Goodman-Kruskal lambda coefficient{p_end}
{synopt:{opt 133}}Goodman-Kruskal lambda_r coefficient{p_end}
{synopt:{opt 134}}Goodman-Kruskal tau coefficient{p_end}
{synopt:{opt 135}}Goodman-Kruskal weighted lambda{p_end}
{synopt:{opt 136}}Goodman unweighted association{p_end}
{synopt:{opt 137}}Goodman weighted association{p_end}
{synopt:{opt 138}}Gorodkin Rk coefficient{p_end}
{synopt:{opt 139}}Gower-Legendre Stheta index (theta=1.5){p_end}
{synopt:{opt 140}}Gray-Orlowska index (alpha=2,beta=2){p_end}
{synopt:{opt 141}}Grier B' bias index{p_end}
{synopt:{opt 142}}Guttman coefficient{p_end}
{synopt:{opt 143}}Hamann coefficient{p_end}
{synopt:{opt 144}}Harris-Lahey index{p_end}
{synopt:{opt 145}}Hawkins-Dotson coefficient{p_end}
{synopt:{opt 146}}Heidke skill score{p_end}
{synopt:{opt 147}}Hellinger distance{p_end}
{synopt:{opt 148}}Hit rate{p_end}
{synopt:{opt 149}}Hoffding coefficient #1{p_end}
{synopt:{opt 150}}Hoffding coefficient #2{p_end}
{synopt:{opt 151}}Hubert-Arabie adjusted Rand index{p_end}
{synopt:{opt 152}}Index of dissimilarity{p_end}
{synopt:{opt 153}}Information quality ratio{p_end}
{synopt:{opt 154}}J-measure{p_end}
{synopt:{opt 155}}Johnson{p_end}
{synopt:{opt 156}}Kendall tau-a coefficient [ORD]{p_end}
{synopt:{opt 157}}Kendall tau-b coefficient [ORD]{p_end}
{synopt:{opt 158}}Kent-Foster #1 coefficient{p_end}
{synopt:{opt 159}}Kent-Foster #2 coefficient{p_end}
{synopt:{opt 160}}Kitamura-Matsumoto index{p_end}
{synopt:{opt 161}}Klosgen measure{p_end}
{synopt:{opt 162}}Koppen index [ORD]{p_end}
{synopt:{opt 163}}Krippendorff alpha coefficient{p_end}
{synopt:{opt 164}}Kuder-Richardson coefficient{p_end}
{synopt:{opt 165}}Kuhns coefficient #1{p_end}
{synopt:{opt 166}}Kuhns coefficient #2{p_end}
{synopt:{opt 167}}Kulczynski index #1{p_end}
{synopt:{opt 168}}Kulczynski index #2{p_end}
{synopt:{opt 169}}Lakshmanamurti Lambda coefficient{p_end}
{synopt:{opt 170}}Laplace correction{p_end}
{synopt:{opt 171}}Least contradiction index{p_end}
{synopt:{opt 172}}Lerman implication index{p_end}
{synopt:{opt 173}}Leverage{p_end}
{synopt:{opt 174}}Likelihood ratio G^2 statistic{p_end}
{synopt:{opt 175}}Log Forbes measure{p_end}
{synopt:{opt 176}}Log frequency biased index{p_end}
{synopt:{opt 177}}Log odds ratio amended statistic{p_end}
{synopt:{opt 178}}Log odds ratio statistic{p_end}
{synopt:{opt 179}}Mak rho coefficient{p_end}
{synopt:{opt 180}}Mantel-Haenszel statistic [ORD]{p_end}
{synopt:{opt 181}}Maron-Kuhns coefficient{p_end}
{synopt:{opt 182}}Maxwell B coefficient{p_end}
{synopt:{opt 183}}Maxwell-Pilliner coefficient{p_end}
{synopt:{opt 184}}McConnaughey coefficient{p_end}
{synopt:{opt 185}}Merton correct prediction CP index{p_end}
{synopt:{opt 186}}Michael index{p_end}
{synopt:{opt 187}}Modified likelihood ratio statistics{p_end}
{synopt:{opt 188}}Mountford index{p_end}
{synopt:{opt 189}}Mueller-Schuessler IQV index{p_end}
{synopt:{opt 190}}Mutual dependency{p_end}
{synopt:{opt 191}}Mutual information statistic{p_end}
{synopt:{opt 192}}Negative likelihood ratio statistic{p_end}
{synopt:{opt 193}}Negative predicted value{p_end}
{synopt:{opt 194}}Neyman modified chi^2 statistic{p_end}
{synopt:{opt 195}}Normalized Google distance{p_end}
{synopt:{opt 196}}Odds ratio{p_end}
{synopt:{opt 197}}Odds ratio amended{p_end}
{synopt:{opt 198}}Optimized precision{p_end}
{synopt:{opt 199}}P4-score{p_end}
{synopt:{opt 200}}Pattern difference{p_end}
{synopt:{opt 201}}Pearson chi^2 statistic{p_end}
{synopt:{opt 202}}Pearson contingency C coefficient{p_end}
{synopt:{opt 203}}Pearson-Heron coefficient{p_end}
{synopt:{opt 204}}Pearson phi coefficient{p_end}
{synopt:{opt 205}}Peirce skill score{p_end}
{synopt:{opt 206}}Pietra statistic{p_end}
{synopt:{opt 207}}Poisson-Stirling index{p_end}
{synopt:{opt 208}}Pollack-Norman A' sensitivity statistic{p_end}
{synopt:{opt 209}}Pollaczek-Geiringer coefficient [ORD]{p_end}
{synopt:{opt 210}}Positive likelihood ratio{p_end}
{synopt:{opt 211}}Positive matching coefficient{p_end}
{synopt:{opt 212}}Precision{p_end}
{synopt:{opt 213}}Predicted negative rate{p_end}
{synopt:{opt 214}}Predicted positive rate{p_end}
{synopt:{opt 215}}Prevalence threshold index{p_end}
{synopt:{opt 216}}Putative causal dependency index{p_end}
{synopt:{opt 217}}Relative risk ratio{p_end}
{synopt:{opt 218}}Relative Quetelet index{p_end}
{synopt:{opt 219}}Renkonen similarity index{p_end}
{synopt:{opt 220}}Replacement comp. (Jaccard){p_end}
{synopt:{opt 221}}Replacement comp. (Sorensen){p_end}
{synopt:{opt 222}}Replacement comp. (Braun-Blanquet){p_end}
{synopt:{opt 223}}Richness difference (Jaccard){p_end}
{synopt:{opt 224}}Richness difference (Sorensen){p_end}
{synopt:{opt 225}}Richness difference (Braun-Blanquet){p_end}
{synopt:{opt 226}}Rogers-Tanimoto coefficient{p_end}
{synopt:{opt 227}}Rogot-Goldberg index{p_end}
{synopt:{opt 228}}Root mean square difference{p_end}
{synopt:{opt 229}}Rousseau index{p_end}
{synopt:{opt 230}}Roux index #1{p_end}
{synopt:{opt 231}}Roux index #2{p_end}
{synopt:{opt 232}}Russell-Rao coefficient{p_end}
{synopt:{opt 233}}Schrank index{p_end}
{synopt:{opt 234}}Scott pi coefficient{p_end}
{synopt:{opt 235}}Sebag-Schoenauer index{p_end}
{synopt:{opt 236}}Shape difference{p_end}
{synopt:{opt 237}}Simple matching coefficient{p_end}
{synopt:{opt 238}}Size difference{p_end}
{synopt:{opt 239}}Sokal-Sneath similarity coefficient #1{p_end}
{synopt:{opt 240}}Sokal-Sneath similarity coefficient #2{p_end}
{synopt:{opt 241}}Sokal-Sneath similarity coefficient #3{p_end}
{synopt:{opt 242}}Sokal-Sneath similarity coefficient #4{p_end}
{synopt:{opt 243}}Sokal-Sneath similarity coefficient #5{p_end}
{synopt:{opt 244}}Sokal-Sneath similarity coefficient #6 (w=3){p_end}
{synopt:{opt 245}}Somers d statistics [ORD]{p_end}
{synopt:{opt 246}}Sorensen similarity coefficient{p_end}
{synopt:{opt 247}}Specificity{p_end}
{synopt:{opt 248}}Standard deviation agreement index{p_end}
{synopt:{opt 249}}Steffensen psi^2 coefficient{p_end}
{synopt:{opt 250}}Steffensen omega coefficient{p_end}
{synopt:{opt 251}}Stiles coefficient{p_end}
{synopt:{opt 252}}Stuart tau-c correlation [ORD]{p_end}
{synopt:{opt 253}}Success index{p_end}
{synopt:{opt 254}}Szymkiewicz-Simpson coefficient{p_end}
{synopt:{opt 255}}Tarantula metric{p_end}
{synopt:{opt 256}}Theil uncertainty coefficient U{p_end}
{synopt:{opt 257}}Theil symmetric coefficient U{p_end}
{synopt:{opt 258}}Tonnies coefficient [ORD]{p_end}
{synopt:{opt 259}}Tschuprow T bias-corrected coefficient{p_end}
{synopt:{opt 260}}Tschuprow T coefficient{p_end}
{synopt:{opt 261}}t-score{p_end}
{synopt:{opt 262}}Tulloss R cost index{p_end}
{synopt:{opt 263}}Tulloss S cost index{p_end}
{synopt:{opt 264}}Tulloss T combined costs index{p_end}
{synopt:{opt 265}}Tulloss U cost index{p_end}
{synopt:{opt 266}}Tversky index (alpha=.3333,beta=.3333){p_end}
{synopt:{opt 267}}2AFC statistic #1{p_end}
{synopt:{opt 268}}2AFC statistic #2 [ORD]{p_end}
{synopt:{opt 269}}Upholt S coefficient{p_end}
{synopt:{opt 270}}Van der Maarel coefficient{p_end}
{synopt:{opt 271}}Van Rijsbergen E-measure (alpha=.5){p_end}
{synopt:{opt 272}}Variance dissimilarity measure{p_end}
{synopt:{opt 273}}Warrens coefficient{p_end}
{synopt:{opt 274}}Weighted kappa coefficient (default weights){p_end}
{synopt:{opt 275}}Woodcock similarity coefficient{p_end}
{synopt:{opt 276}}Yao-Liu one-way support measure{p_end}
{synopt:{opt 277}}Yao-Liu two-way support measure{p_end}
{synopt:{opt 278}}Yao-Liu two-way support variation{p_end}
{synopt:{opt 279}}Yates chi^2 statistics{p_end}
{synopt:{opt 280}}Yule phi correlation coefficient{p_end}
{synopt:{opt 281}}Yule Q coefficient{p_end}
{synopt:{opt 282}}Yule Y coefficient{p_end}
{synopt:{opt 283}}Zhang coefficient{p_end}
{synoptline}


{title:References}

{p 4 7}Sirchenko, A. 2026. A comprehensive catalogue of association and
forecast-evaluation measures for categorical data. {it:Nyenrode Business University, Manuscript.}
{p_end}