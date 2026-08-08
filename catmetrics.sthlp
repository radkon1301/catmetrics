{smcl}
{* *! version 0.3.0  07Aug2026}{...}
{title:Title}

{pstd}{helpb catmetrics##catmetrics:catmetrics} {c -} computes 283 measures of association, correlation, similarity,
agreement, and information between two categorical variables, 6 proper scores for probabilistic forecasts, 
and 12 diagnostic measures of the accuracy of probabilistic forecasts of such variables.

{title:Syntax}

{marker nop}{...}
{pstd}The command has four syntax forms:{p_end}

{pstd}{cmd:catmetrics} {it:var1} {it:var2} {bind:[{cmd:,} {it:options}]}{p_end}

{p 4 7}where {it:var1} and {it:var2} are two categorical variables with the same
number of observed categories. In asymmetric applications,
{it:var1} precedes {it:var2} chronologically or causally. 
In forecasting applications, {it:var1}
represents the actual outcome and {it:var2} represents the predicted outcome.
For binary {it:var1} and {it:var2}, the positive category must be coded
using the smallest numeric value.{p_end}

{pstd}{cmd:catmetrics} {it:var1} {bind:[{cmd:,} probs(varlist) {it:options}]}{p_end}

{p 4 7}where {it:var1} contains the realized values of a categorical variable, and probs(varlist) supplies the predicted probabilities for each category.
The probabilities should be listed in ascending category order.
The number of supplied probability variables must equal the number of distinct observed categories.
If {it:var1} is binary, the positive category must be coded using the smallest
numeric value.
{p_end}

{pstd}{cmd:catmetrics} {it:var1} {bind:[{cmd:,} predict {it:options}]}{p_end}

{p 4 7}where {it:var1} again contains the realized outcomes, and predicted probabilities are obtained
from the most recently estimated Stata model (such as {bf:logistic}, {bf:logit}, {bf:probit}, {bf:oprobit},
{bf:cmclogit}, {bf:mlogit}, {bf:mprobit}, {bf:ziologit}, {bf:zioprobit}) using Stata's post-estimation command {bf:predict}.
If {it:var1} is binary, the positive category is assumed to be coded using the smallest numeric value.
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
(see the list of available measures in the {help catmetrics##MetricReferenceTable:Metric Reference Table} and
the list of available probabilistic scores in the {help catmetrics##ProbScoreTable:Probabilistic Score Table} below).
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

{pstd}Compute the catmetrics command by including the true values as {it:var1} and predicted values as {it:var2}.{p_end}
       {bf:. catmetrics y y_pred}

{pstd}Compute the catmetrics command by including the true values as {it:var1} while specifying the probabilities in the options.
In this example, y takes on values in three categories; hence p1, p2, and p3 are necessary.{p_end}
       {bf:. catmetrics y, probs(P1 P2 P3)}

{pstd}Compute the catmetrics command by including the true values as {it:var1} while using the Stata {cmd:predict} command to compute the probabilities.
It is required that variable names p1, p2, up to pK are not already defined within Stata.{p_end}
       {bf:. catmetrics y, pred}

{pstd}Compute the catmetrics command by specifying a contingency table in the options and saving the results to "Example file name.xlsx".
Also display class-specific measures if the data is binary.{p_end}
       {bf:. catmetrics, mat(contingency_table) excel(Example file name) classmet}

{pstd}Compute the catmetrics command for the specified contingency table, not saving the results to an .xlsx book and printing metrics 1, 123, and 5.{p_end}
       {bf:. catmetrics, mat(contingency_table) noexcel metrics(1 123 5)}
	   
{pstd}Compute the catmetrics command with different beta values for the Power and Pseudospherical scores.{p_end}
       {bf:. catmetrics y, probs(P3 P4) power(2.5) pseudo(2.5)}
	   
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
{synopt:{opt P1}}Brier score (aliases: half-Brier score, mean squared (probability) error, probability score, quadratic score) [M]{p_end}
{synopt:{opt P2}}Logarithmic score (aliases: cross-entropy loss, ignorance score, log loss, negative log likelihood / predictive density, surprisal) [M]{p_end}
{synopt:{opt P3}}Power score (with a user-defined parameter {it:β} > 1) (aliases: generalized quadratic score) [M]{p_end}
{synopt:{opt P4}}Pseudospherical score (with a user-defined parameter {it:β} > 1) (aliases: generalized spherical score) [M]{p_end}
{synopt:{opt P5}}Ranked probability score (aliases: Epstein ranked score) [O]{p_end}
{synopt:{opt P6}}Spherical score [M]{p_end}
{synoptline}

{pstd}
Diagnostic measures for probabilistic forecasts:
{p_end}

{synoptset 5 tabbed}{...}
{synopthdr:Token}
{synoptline}
{synopt:{opt P7}}Accuracy rate (aliases: correct classification / success rate, fraction / percent / proportion correct, modal / top-1 accuracy,
zero-one reward / utility; complement: error rate, misclassification / top-1 error, proportion misclassified, zero-one loss / score) [M]{p_end}
{synopt:{opt P8}}Average precision (AP) (aliases: non-interpolated area under the precision-recall curve, AUPRC, AUC-PR, PR-AUC) [B]{p_end}
{synopt:{opt P9}}Expected calibration error (ECE) (with user-defined parameters {it:q} > 0 and {it:m} in {2, 3, ...}) [B]{p_end}
{synopt:{opt P10}}Gain at {it:k} (with a user-defined parameter 0 < {it:k} < 1) (aliases: capture rate, (cumulative) gain, gain@{it:k}, top-{it:k} recall) [B]{p_end}
{synopt:{opt P11}}Lift at {it:k} (with a user-defined parameter 0 < {it:k} < 1) (aliases: (cumulative) lift, lift@{it:k}) [B]{p_end}
{synopt:{opt P12}}Macro average mean probability rate (MAPR) (aliases: macro soft accuracy) [M]{p_end}
{synopt:{opt P13}}Maximum calibration error (MCE) (with user-defined parameters {it:q} > 0 and {it:m} in {2, 3, ...}) [B]{p_end}
{synopt:{opt P14}}Mean probability rate (MPR) (aliases: mean linear score, mean true class probability, soft accuracy; the complement: mean absolute error) [M]{p_end}
{synopt:{opt P15}}Normalized area under cumulative accuracy profile (CAP) (aliases: accuracy ratio, AUCAP, normalized area under cumulative gains/lift curve (AUCG, AUGC), Gini index) [B]{p_end}
{synopt:{opt P16}}Normalized area under receiver operating characteristic (ROC) curve (aliases: AUC, AUROC, concordance {it:c} statistics,
normalized Wilcoxon-Mann-Whitney {it:U} statistic, ROC area, ROC AUC) [B]{p_end}
{synopt:{opt P17}}Two-alternative forced choice (2AFC) score #1 (aliases: generalized discrimination score) [M]{p_end}
{synopt:{opt P18}}Two-alternative forced choice (2AFC) score #2 [O]{p_end}
{synoptline}

{marker MetricReferenceTable}
{title:Metric Reference Table}

{pstd}
For the option {opt metrics:(string)}, the numeric indices should be used.
The table below lists all 283 available metrics with their corresponding index numbers. 
Measures suitable only for binary data (K = 2) are marked [B], measures suitable for multicategory data (K ≥ 2) are marked [M],
and measures suitable only for ordinal data (K ≥ 2) are marked [O].
{p_end}

{synoptset 5 tabbed}{...}
{synopthdr:Number}
{synoptline}
{synopt:{opt 1}}Accuracy (aliases: (crude / observed/ raw) agreement, causal support, classification accuracy/rate, count {it:R}²,
fraction/percent/proportion correct, hit score, Holsti coefficient of agreement {it:C.R.}, Kendall coefficient, Osgood coefficient,
Rand index, ratio test discriminant, simple matching coefficient, Sokal-Michener coefficient, success rate) [M]{p_end}
{synopt:{opt 2}}Added value (aliases: absolute Quetelet index, centered confidence, change of support, gain, Pavillon index) [B]{p_end}
{synopt:{opt 3}}Adjusted noise-to-signal ratio [B]{p_end}
{synopt:{opt 4}}Alroy coefficient (aliases: corrected Forbes {it:F} coefficient) [B]{p_end}
{synopt:{opt 5}}Anderberg coefficient [B]{p_end}
{synopt:{opt 6}}Anderberg {it:D} similarity coefficient [B]{p_end}
{synopt:{opt 7}}Appleman index [B]{p_end}
{synopt:{opt 8}}Atkinson similarity [M]{p_end}
{synopt:{opt 9}}Balanced accuracy (aliases: balanced classification rate; complement: balanced error rate) [M]{p_end}
{synopt:{opt 10}}Balanced error rate (aliases: balanced classification error / rate, half total error rate, complement: balanced accuracy) [M]{p_end}
{synopt:{opt 11}}Baroni-Urbani-Buser coefficient #1 [B]{p_end}
{synopt:{opt 12}}Baroni-Urbani-Buser coefficient #2 [B]{p_end}
{synopt:{opt 13}}Base rate (aliases: event probability, sample climate, (true) prevalence) [B]{p_end}
{synopt:{opt 14}}Batagelj-Bren distance {it:Q}₀ (aliases: inverse (diagnostic) odds ratio) [B]{p_end}
{synopt:{opt 15}}Baulieu dissimilarity coefficient #13 [B]{p_end}
{synopt:{opt 16}}Baulieu dissimilarity coefficient #22 (with a user-supplied parameter {it:κ}, a positive irrational number) [B]{p_end}
{synopt:{opt 17}}Baulieu dissimilarity coefficient #23 [B]{p_end}
{synopt:{opt 18}}Baulieu dissimilarity coefficient #24 [B]{p_end}
{synopt:{opt 19}}Baulieu dissimilarity coefficient #25 [B]{p_end}
{synopt:{opt 20}}Baulieu dissimilarity coefficient #27 [B]{p_end}
{synopt:{opt 21}}Baulieu dissimilarity coefficient #28 [B]{p_end}
{synopt:{opt 22}}Baulieu dissimilarity coefficient #29 [B]{p_end}
{synopt:{opt 23}}Baulieu dissimilarity coefficient #30 [B]{p_end}
{synopt:{opt 24}}Baulieu dissimilarity coefficient #31 [B]{p_end}
{synopt:{opt 25}}Baulieu dissimilarity coefficient #32 [B]{p_end}
{synopt:{opt 26}}Baulieu dissimilarity coefficient #33 [B]{p_end}
{synopt:{opt 27}}Benini {it:φ}/{it:φ}max correlation coefficient #1 [B]{p_end}
{synopt:{opt 28}}Benini {it:φ}/{it:φ}max correlation coefficient #2 (aliases: Benini attraction/repulsion, Gini coefficient, bound-adjusted Cohen {it:κ}) [M]{p_end}
{synopt:{opt 29}}Benini correlation coefficient #3 (aliases: Benini attraction, Cole coefficient, Köppen index, certainty factor) [B]{p_end}
{synopt:{opt 30}}Benini correlation coefficient #4 (aliases: Benini attraction, Cole coefficient) [B]{p_end}
{synopt:{opt 31}}Bennet {it:S} coefficient (aliases: Brennan-Prediger {it:κ}n coefficient, Guilford {it:G} coefficient, Janson-Vegelius {it:C} coefficient,
Maxwell random error {it:RE}, Perreault-Leigh {it:I}ᵣ index, reliability coefficient) [M]{p_end}
{synopt:{opt 32}}Berger-Parker dominance index (aliases: proportional dominance) [M]{p_end}
{synopt:{opt 33}}Bias index (aliases: assessment / forecast / frequency / response bias) [B]{p_end}
{synopt:{opt 34}}Blaheta-Johnson unigram subtuples measure [B]{p_end}
{synopt:{opt 35}}Braun-Blanquet similarity index [B]{p_end}
{synopt:{opt 36}}Bray-Curtis dissimilarity index (aliases: Whittaker index) [M]{p_end}
{synopt:{opt 37}}Brin conviction coefficient [B]{p_end}
{synopt:{opt 38}}Causal confidence [B]{p_end}
{synopt:{opt 39}}Causal confirmed confidence [B]{p_end}
{synopt:{opt 40}}Causal confirm [B]{p_end}
{synopt:{opt 41}}Chord distance metric [B]{p_end}
{synopt:{opt 42}}Clayton skill score (aliases: {it:Δp}, index of separation, markedness) [M]{p_end}
{synopt:{opt 43}}Clement reliability coefficient [B]{p_end}
{synopt:{opt 44}}Cohen {it:κ} coefficient (aliases: Cohen agreement, Cohen kappa, inter-rater agreement, inter-rater reliability, kappa coefficient) [M]{p_end}
{synopt:{opt 45}}Cole {it:C}₅ correlation coefficient [B]{p_end}
{synopt:{opt 46}}Collective strength index [B]{p_end}
{synopt:{opt 47}}Consonni-Todeschini similarity index #1 [B]{p_end}
{synopt:{opt 48}}Consonni-Todeschini similarity index #2 [B]{p_end}
{synopt:{opt 49}}Consonni-Todeschini similarity index #3 [B]{p_end}
{synopt:{opt 50}}Consonni-Todeschini similarity index #4 [B]{p_end}
{synopt:{opt 51}}Consonni-Todeschini similarity index #5 [B]{p_end}
{synopt:{opt 52}}Cramér concordance coefficient [M]{p_end}
{synopt:{opt 53}}Cressie-Read power divergence statistic (with a user-supplied parameter {it:λ}; identical to: Neyman {it:χ}² test statistic if {it:λ} = -2;
Freeman-Tukey ({it:F}² or {it:T}²) test statistic if {it:λ} = -1/2; likelihood ratio {it:G}² test statistic if {it:λ} → 0;
modified likelihood ratio test statistics if {it:λ} = -1, Pearson {it:χ}² if {it:λ} = 1; optimal Cressie-Read power divergence statistic if {it:λ} = 2/3) [M]{p_end}
{synopt:{opt 54}}Czekanowski index (aliases: Burt coefficient, Dice coefficient, Gleason index, {it:F}₁-score, harmonic mean of precision and recall,
Nei-Li index, positive specific agreement, proportion of specific agreement, Sørensen index, Sørensen-Dice coefficient,
Tversky index (special case if {it:α} = {it:β} = 1/2), Upholt {it:F} coefficient, Zijdenbos index; complement: Bray-Curtis index, Lance-Williams coefficient) [B]{p_end}
{synopt:{opt 55}}Dennis {it:z}-score (aliases: {it:z}-score) [B]{p_end}
{synopt:{opt 56}}Dependency measure [B]{p_end}
{synopt:{opt 57}}Descriptive confirm [B]{p_end}
{synopt:{opt 58}}Digby correlation coefficient [B]{p_end}
{synopt:{opt 59}}Discriminant power [B]{p_end}
{synopt:{opt 60}}Discrimination {it:d'} distance (aliases: signal detection sensitivity {it:d'}) [B]{p_end}
{synopt:{opt 61}}Dominance index [B]{p_end}
{synopt:{opt 62}}Donaldson bias index [B]{p_end}
{synopt:{opt 63}}Doolittle association ratio (aliases: Cramér coefficient, inertia, mean square contingency {it:φ}²) [M]{p_end}
{synopt:{opt 64}}Doolittle raw accuracy (aliases: correlation ratio, Doolittle {it:H}ᵤ, Michelet index, Sorgenfrei coefficient, unbiased hit rate {it:H}ᵤ,
Wagner index; complement: Baulieu coefficient #12) [B]{p_end}
{synopt:{opt 65}}Driver-Kroeber similarity index (aliases: Fowlkes-Mallows index, {it:G}-measure, geometric mean of recall and precision, cosine similarity,
Ochiai coefficient, Otsuka coefficient) [B]{p_end}
{synopt:{opt 66}}Error rate (aliases: (mis)classification error, misclassification rate, zero-one loss; the complement: accuracy) [M]{p_end}
{synopt:{opt 67}}Example and counterexample rate [B]{p_end}
{synopt:{opt 68}}Extremal dependence index [B]{p_end}
{synopt:{opt 69}}Extreme dependency index [B]{p_end}
{synopt:{opt 70}}Eyraud index [B]{p_end}
{synopt:{opt 71}}Fager-McGowan similarity index #1 (aliases: corrected Ochiai/cosine similarity) [B]{p_end}
{synopt:{opt 72}}Fager-McGowan similarity index #2 [B]{p_end}
{synopt:{opt 73}}Faith similarity index [B]{p_end}
{synopt:{opt 74}}False alarm ratio (aliases: false discovery rate; complement: precision) [B]{p_end}
{synopt:{opt 75}}False negative rate (aliases: miss rate; complement: hit rate) [B]{p_end}
{synopt:{opt 76}}False omission rate (aliases: detection failure ratio, miss ratio; complement: negative predicted value) [B]{p_end}
{synopt:{opt 77}}False positive rate (aliases: fall-out, false alarm rate, probability of false detection; type II error rate; complement: specificity) [B]{p_end}
{synopt:{opt 78}}{it:F}ᵦ-score (aliases: weighted harmonic mean of the precision and hit rate; complement: van Rijsbergen effectiveness {it:E} measure) [B]{p_end}
{synopt:{opt 79}}Fisher exact statistic (aliases: Freeman-Halton statistic) [M]{p_end}
{synopt:{opt 80}}Fleiss-Levin-Paik agreement index (aliases: negative-class Dice, harmonic mean of negative predictive value and specificity,
negative-class {it:F}₁-score, negative percent agreement, negative (specific) agreement, proportion of negative agreement, negative-class Sørensen) [B]{p_end}
{synopt:{opt 81}}Forbes coefficient #1 (aliases: Forbes {it:F} coefficient, independence, interest, Kocher-Wong measure, lift) [B]{p_end}
{synopt:{opt 82}}Forbes coefficient #2 (aliases: Benini correlation/repulsion, Loevinger {it:H} coefficient, relative improvement over chance (RIOC)) [B]{p_end}
{synopt:{opt 83}}Fossum index [B]{p_end}
{synopt:{opt 84}}Freeman-Tukey ({it:F}² or {it:T}²) statistic [M]{p_end}
{synopt:{opt 85}}Freeman-Tukey test ({it:F}² or {it:T}²) statistic (asymptotic approximation) (identical to Cressie-Read power divergence statistic if {it:λ} = -1/2) [M]{p_end}
{synopt:{opt 86}}{it:F}-score adjusted [B]{p_end}
{synopt:{opt 87}}Galton agreement coefficient (aliases: Cole {it:C}₇ coefficient, conditional kappa, Light coefficient) [B]{p_end}
{synopt:{opt 88}}Ganascia coefficient (aliases: confirmed confidence) [B]{p_end}
{synopt:{opt 89}}Generalized Fleiss correlation coefficient (arithmetic) #2 [B]{p_end}
{synopt:{opt 90}}Generalized Fleiss correlation coefficient (contraharmonic) #1 [B]{p_end}
{synopt:{opt 91}}Generalized Fleiss correlation coefficient (contraharmonic) #2 [B]{p_end}
{synopt:{opt 92}}Generalized Fleiss correlation coefficient (contraharmonic) #3 [B]{p_end}
{synopt:{opt 93}}Generalized Fleiss correlation coefficient (harmonic) #1 (identical to original Fleiss coefficient) [B]{p_end}
{synopt:{opt 94}}Generalized Fleiss correlation coefficient (harmonic) #2 [B]{p_end}
{synopt:{opt 95}}Generalized Fleiss correlation coefficient (harmonic) #3 [B]{p_end}
{synopt:{opt 96}}Generalized Fleiss correlation coefficient (Heronian) #1 [B]{p_end}
{synopt:{opt 97}}Generalized Fleiss correlation coefficient (Heronian) #2 [B]{p_end}
{synopt:{opt 98}}Generalized Fleiss correlation coefficient (Heronian) #3 [B]{p_end}
{synopt:{opt 99}}Generalized Fleiss correlation coefficient (Hölder) #1 (with a user-defined parameter {it:p} ≠ 0) [B]{p_end}
{synopt:{opt 100}}Generalized Fleiss correlation coefficient (Hölder) #2 (with a user-defined parameter {it:p} ≠ 0) [B]{p_end}
{synopt:{opt 101}}Generalized Fleiss correlation coefficient (Hölder) #3 (with a user-defined parameter {it:p} ≠ 0) [B]{p_end}
{synopt:{opt 102}}Generalized Fleiss correlation coefficient (identric) #1 [B]{p_end}
{synopt:{opt 103}}Generalized Fleiss correlation coefficient (identric) #2 [B]{p_end}
{synopt:{opt 104}}Generalized Fleiss correlation coefficient (identric) #3 [B]{p_end}
{synopt:{opt 105}}Generalized Fleiss correlation coefficient (Lehmer) #1 (with a user-defined parameter {it:p}) [B]{p_end}
{synopt:{opt 106}}Generalized Fleiss correlation coefficient (Lehmer) #2 (with a user-defined parameter {it:p}) [B]{p_end}
{synopt:{opt 107}}Generalized Fleiss correlation coefficient (Lehmer) #3 (with a user-defined parameter {it:p}) [B]{p_end}
{synopt:{opt 108}}Generalized Fleiss correlation coefficient (logarithmic) #1 [B]{p_end}
{synopt:{opt 109}}Generalized Fleiss correlation coefficient (logarithmic) #2 [B]{p_end}
{synopt:{opt 110}}Generalized Fleiss correlation coefficient (logarithmic) #3 [B]{p_end}
{synopt:{opt 111}}Generalized Fleiss correlation coefficient (quadratic) #1 [B]{p_end}
{synopt:{opt 112}}Generalized Fleiss correlation coefficient (quadratic) #2 [B]{p_end}
{synopt:{opt 113}}Generalized Fleiss correlation coefficient (quadratic) #3 [B]{p_end}
{synopt:{opt 114}}Generalized Fleiss correlation coefficient (Seiffert) #1 [B]{p_end}
{synopt:{opt 115}}Generalized Fleiss correlation coefficient (Seiffert) #2 [B]{p_end}
{synopt:{opt 116}}Generalized Fleiss correlation coefficient (Seiffert) #3 [B]{p_end}
{synopt:{opt 117}}Generalized index of balanced accuracy (IBA) (with user-defined parameters 0 < {it:α} < 1 and {it:M} - an index of any binary metric) [B]{p_end}
{synopt:{opt 118}}Gerrity skill score (aliases: special case of Gandin-Murphy equitable skill score) [O]{p_end}
{synopt:{opt 119}}Gilbert index (aliases: critical success index, Driver-Kroeber coefficient, intersection over union, Jaccard index,
Jaccardized Czekanowski index, mutual support, ratio of verification, Ružička index, Sneath index, Tanimoto coefficient, threat score, Tversky index) [B]{p_end}
{synopt:{opt 120}}Gilbert skill score (aliases: equitable threat score, ratio of success) [B]{p_end}
{synopt:{opt 121}}Gilbert-Wells index [B]{p_end}
{synopt:{opt 122}}Gini coefficient #1 [B]{p_end}
{synopt:{opt 123}}Gini coefficient #2 [B]{p_end}
{synopt:{opt 124}}Gini impurity index (aliases: Gibbs M1 index, Gini-Simpson index, index of differentiation, Simpson diversity index) [M]{p_end}
{synopt:{opt 125}}{it:G}-mean (aliases: geometric mean of sensitivity and specificity) [B]{p_end}
{synopt:{opt 126}}{it:G}-mean adjusted (aliases: adjusted geometric mean) [B]{p_end}
{synopt:{opt 127}}Goodall index (aliases: Austin-Colwell index) [M]{p_end}
{synopt:{opt 128}}Goodman concomitance coefficient [B]{p_end}
{synopt:{opt 129}}Goodman-Kruskal coefficient #1 [B]{p_end}
{synopt:{opt 130}}Goodman-Kruskal coefficient #2 [B]{p_end}
{synopt:{opt 131}}Goodman-Kruskal {it:γ} coefficient [O]{p_end}
{synopt:{opt 132}}Goodman-Kruskal {it:λ} coefficient (aliases: Guttman {it:λ} coefficient) [M]{p_end}
{synopt:{opt 133}}Goodman-Kruskal {it:λ}ᵣ coefficient (aliases: adjusted count {it:R}², Brennan-Prediger {it:κ}b coefficient) [M]{p_end}
{synopt:{opt 134}}Goodman-Kruskal {it:τ} coefficient [M]{p_end}
{synopt:{opt 135}}Goodman-Kruskal weighted {it:λ} coefficient [M]{p_end}
{synopt:{opt 136}}Goodman unweighted association index [B]{p_end}
{synopt:{opt 137}}Goodman weighted association index [B]{p_end}
{synopt:{opt 138}}Gorodkin {it:R}K correlation coefficient (aliases: generalized Matthews correlation, generalized Yule {it:φ}, Gini index of homophyly) [M]{p_end}
{synopt:{opt 139}}Gower-Legendre {it:S}θ index (with user-defined parameter {it:θ} > 0) (aliases: parameterized overall agreement;
identical to Sokal-Sneath #1 when {it:θ} = 1/2, to accuracy when {it:θ} = 1, to Rogers-Tanimoto when {it:θ} = 2) [M]{p_end}
{synopt:{opt 140}}Gray-Orlowska interestingness index (with user-defined parameters {it:α} > 0 and {it:β} > 0) [B]{p_end}
{synopt:{opt 141}}Grier {it:B}' bias index [B]{p_end}
{synopt:{opt 142}}Guttman coefficient [B]{p_end}
{synopt:{opt 143}}Hamann coefficient (aliases: Hubert {it:Γ} statistic) [M]{p_end}
{synopt:{opt 144}}Harris-Lahey index [B]{p_end}
{synopt:{opt 145}}Hawkins-Dotson coefficient [B]{p_end}
{synopt:{opt 146}}Heidke skill score (aliases: binary Cohen {it:κ}, Doolittle index, generalized Fleiss correlation coefficient (arithmetic) #3, {it:κ} index of agreement) [B]{p_end}
{synopt:{opt 147}}Hellinger distance [B]{p_end}
{synopt:{opt 148}}Hit rate (aliases: completeness, Dice coefficient, fraction correct, power, prefigurance, probability of detection,
producer's accuracy, positive percent agreement, recall, sensitivity, true positive rate) [B]{p_end}
{synopt:{opt 149}}Höffding coefficient #1 [M]{p_end}
{synopt:{opt 150}}Höffding coefficient #2 [M]{p_end}
{synopt:{opt 151}}Hubert-Arabie adjusted Rand index [M]{p_end}
{synopt:{opt 152}}Index of dissimilarity (aliases: analyzing method patterns to locate errors (AMPLE), Duncan dissimilarity / segregation index) [B]{p_end}
{synopt:{opt 153}}Information quality ratio [B]{p_end}
{synopt:{opt 154}}{it:J}-measure (aliases: information content) [B]{p_end}
{synopt:{opt 155}}Johnson (aliases: sum of confidences) [B]{p_end}
{synopt:{opt 156}}Kendall {it:τ}a correlation coefficient [O]{p_end}
{synopt:{opt 157}}Kendall {it:τ}b correlation coefficient with an adjustment for ties [O]{p_end}
{synopt:{opt 158}}Kent-Foster #1 coefficient [B]{p_end}
{synopt:{opt 159}}Kent-Foster #2 coefficient [B]{p_end}
{synopt:{opt 160}}Kitamura-Matsumoto index (aliases: modified Dice coefficient) [B]{p_end}
{synopt:{opt 161}}Klösgen measure [B]{p_end}
{synopt:{opt 162}}Köppen index [O]{p_end}
{synopt:{opt 163}}Krippendorff {it:α} coefficient [M]{p_end}
{synopt:{opt 164}}Kuder-Richardson coefficient [B]{p_end}
{synopt:{opt 165}}Kuhns coefficient #1 (aliases: arithmetic mean overlap) [B]{p_end}
{synopt:{opt 166}}Kuhns coefficient #2 (aliases: proportion of overlap above independence) [B]{p_end}
{synopt:{opt 167}}Kulczyński index #1 [B]{p_end}
{synopt:{opt 168}}Kulczyński index #2 (aliases: Driver-Kroeber coefficient) [B]{p_end}
{synopt:{opt 169}}Lakshmanamurti {it:Λ} coefficient [B]{p_end}
{synopt:{opt 170}}Laplace correction [B]{p_end}
{synopt:{opt 171}}Least contradiction index [B]{p_end}
{synopt:{opt 172}}Lerman implication index [B]{p_end}
{synopt:{opt 173}}Leverage (aliases: Baulieu coefficient #20, Piatetsky-Shapiro index, weighted relative accuracy) [B]{p_end}
{synopt:{opt 174}}Likelihood ratio {it:G}² statistic (aliases: (log) likelihood ratio {it:χ}² statistic, special case of Cressie-Read power divergence statistic if {it:λ} → 0) [M]{p_end}
{synopt:{opt 175}}Log Forbes measure (aliases: Gilbert-Wells index, log pointwise mutual information) [B]{p_end}
{synopt:{opt 176}}Log frequency biased index [B]{p_end}
{synopt:{opt 177}}Log odds ratio amended statistic [B]{p_end}
{synopt:{opt 178}}Log odds ratio statistic [B]{p_end}
{synopt:{opt 179}}Mak {it:ρ} coefficient [B]{p_end}
{synopt:{opt 180}}Mantel-Haenszel statistic (aliases: linear-by-linear association statistic, nonzero correlation statistic) [O]{p_end}
{synopt:{opt 181}}Maron-Kuhns coefficient [B]{p_end}
{synopt:{opt 182}}Maxwell {it:B} coefficient (aliases: Maxwell adjusted random error {it:RE}, maximum-corrected Bennett {it:S} coefficient, bounded uniform agreement index) [M]{p_end}
{synopt:{opt 183}}Maxwell-Pilliner coefficient (aliases: generalized Fleiss coefficient (arithmetic) #1) [B]{p_end}
{synopt:{opt 184}}McConnaughey coefficient [B]{p_end}
{synopt:{opt 185}}Merton correct prediction {it:CP} index [B]{p_end}
{synopt:{opt 186}}Michael index [B]{p_end}
{synopt:{opt 187}}Modified likelihood ratio statistics (aliases: minimum discrimination information (MDI) statistic, modified {it:G}² statistic,
special case of Cressie-Read power divergence statistic if {it:λ} = -1) [M]{p_end}
{synopt:{opt 188}}Mountford index [B]{p_end}
{synopt:{opt 189}}Mueller-Schuessler index of qualitative variation (aliases: Gibbs's M2 index, index of qualitative variation (IQV)) [M]{p_end}
{synopt:{opt 190}}Mutual dependency [B]{p_end}
{synopt:{opt 191}}Mutual information statistic (aliases: information gain) [M]{p_end}
{synopt:{opt 192}}Negative likelihood ratio {it:LR}- statistic (aliases: logical necessity) [B]{p_end}
{synopt:{opt 193}}Negative predicted value (aliases: inverse precision, true negative accuracy; complement: false omission rate) [B]{p_end}
{synopt:{opt 194}}Neyman modified {it:χ}² statistic (aliases: special case of Cressie-Read power divergence statistic if {it:λ} = -2) [M]{p_end}
{synopt:{opt 195}}Normalized Google distance (NGD) metric [B]{p_end}
{synopt:{opt 196}}Odds ratio (aliases: diagnostic odds ratio, cross-product ratio) [B]{p_end}
{synopt:{opt 197}}Odds ratio amended [B]{p_end}
{synopt:{opt 198}}Optimized precision [B]{p_end}
{synopt:{opt 199}}{it:P}₄-score [B]{p_end}
{synopt:{opt 200}}Pattern difference [B]{p_end}
{synopt:{opt 201}}Pearson {it:χ}² statistic (aliases: Cramér statistic, special case of power divergence statistic if {it:λ} = 1) [M]{p_end}
{synopt:{opt 202}}Pearson contingency {it:C} coefficient [M]{p_end}
{synopt:{opt 203}}Pearson-Heron correlation coefficient (aliases: tetrachoric correlation coefficient) [B]{p_end}
{synopt:{opt 204}}Pearson {it:φ} coefficient (aliases: mean square contingency coefficient) [M]{p_end}
{synopt:{opt 205}}Peirce skill score (aliases: (bookmaker) informedness, corrected hit probability, {it:Δp}, Gandin-Murphy equitable skill score,
Hanssen-Kuipers discriminant, Kuipers skill score, true skill score, true skill statistic, Woodworth index, Youden {it:J} statistic) [M]{p_end}
{synopt:{opt 206}}Pietra statistic (aliases: Schutz coefficient) [M]{p_end}
{synopt:{opt 207}}Poisson-Stirling index [B]{p_end}
{synopt:{opt 208}}Pollack-Norman {it:A}' sensitivity statistic [B]{p_end}
{synopt:{opt 209}}Pollaczek-Geiringer correlation coefficient [O]{p_end}
{synopt:{opt 210}}Positive likelihood ratio {it:LR}+ statistic (aliases: Bayes factor, logical sufficiency) [B]{p_end}
{synopt:{opt 211}}Positive matching coefficient [B]{p_end}
{synopt:{opt 212}}Precision (aliases: absolute support, certainty factor, confidence, correct alarm ratio, Dice coefficient, frequency of hits,
positive predictive value, post agreement, strength, success ratio; complement: predicted negative rate) [B]{p_end}
{synopt:{opt 213}}Predicted negative rate (aliases: apparent non-prevalence, negative call rate, predicted negative proportion, rejection rate / ratio,
test-negative proportion, complement: predicted positive rate) [B]{p_end}
{synopt:{opt 214}}Predicted positive rate (aliases: apparent/predicted prevalence, applicability, coverage, generality,
probability of a forecast of occurrence, (positive) forecast rate/frequency, selection ratio; complement: predicted negative rate) [B]{p_end}
{synopt:{opt 215}}Prevalence threshold index [B]{p_end}
{synopt:{opt 216}}Putative causal dependency index [B]{p_end}
{synopt:{opt 217}}Relative risk ratio (aliases: (adverse) impact ratio (AIR), risk ratio) [B]{p_end}
{synopt:{opt 218}}Relative Quetelet index (aliases: centered lift, lift minus one, varying rates liaison (VRL)) [B]{p_end}
{synopt:{opt 219}}Renkonen similarity index (aliases: percentage similarity index; complement: index of dissimilarity) [B]{p_end}
{synopt:{opt 220}}Replacement component (Jaccard-based) (aliases: Ružička replacement index) [B]{p_end}
{synopt:{opt 221}}Replacement component (Sørensen-based) [B]{p_end}
{synopt:{opt 222}}Replacement component (Braun-Blanquet-based) (aliases: Savage replacement index) [B]{p_end}
{synopt:{opt 223}}Richness difference (Jaccard-based) (aliases: Ružička abundance difference) [B]{p_end}
{synopt:{opt 224}}Richness difference (Sørensen-based) (aliases: abundance difference) [B]{p_end}
{synopt:{opt 225}}Richness difference (Braun-Blanquet based) (aliases: abundance difference) [B]{p_end}
{synopt:{opt 226}}Rogers-Tanimoto coefficient [M]{p_end}
{synopt:{opt 227}}Rogot-Goldberg index [B]{p_end}
{synopt:{opt 228}}Root mean square difference (aliases: normalized Euclidean distance, Sokal distance) [B]{p_end}
{synopt:{opt 229}}Rousseau index [B]{p_end}
{synopt:{opt 230}}Roux index #1 [B]{p_end}
{synopt:{opt 231}}Roux index #2 [B]{p_end}
{synopt:{opt 232}}Russell-Rao coefficient (aliases: support) [B]{p_end}
{synopt:{opt 233}}Schrank index [B]{p_end}
{synopt:{opt 234}}Scott {it:π} coefficient (aliases: Scott index of inter-code agreement, the two-rater special case of Fleiss {it:κ}) [M]{p_end}
{synopt:{opt 235}}Sebag-Schoenauer index [B]{p_end}
{synopt:{opt 236}}Shape difference [B]{p_end}
{synopt:{opt 237}}Simple matching coefficient [B]{p_end}
{synopt:{opt 238}}Size difference (aliases: Baulieu coefficient #26, Penrose size difference) [B]{p_end}
{synopt:{opt 239}}Sokal-Sneath similarity coefficient #1 (aliases: Anderberg coefficient) [M]{p_end}
{synopt:{opt 240}}Sokal-Sneath similarity coefficient #2 (aliases: Anderberg coefficient) [M]{p_end}
{synopt:{opt 241}}Sokal-Sneath similarity coefficient #3 (aliases: Anderberg coefficient, Rogot-Goldberg index) [M]{p_end}
{synopt:{opt 242}}Sokal-Sneath similarity coefficient #4 (aliases: Gower coefficient, Ochiai coefficient) [B]{p_end}
{synopt:{opt 243}}Sokal-Sneath similarity coefficient #5 (aliases: Anderberg coefficient) [B]{p_end}
{synopt:{opt 244}}Sokal-Sneath similarity coefficient #6 (with a user-supplied parameter {it:w} > 0) (aliases: weighted Jaccard index;
identical to Sokal-Sneath #5 if {it:w} = 1/2, to Gilbert score if {it:w} = 1, to Gower-Legendre {it:T}θ if {it:w} = 1/{it:θ},
to Czekanowski if {it:w} = 2, to Sørensen if {it:w} = 4 and to Anderberg if {it:w} = 8) [B]{p_end}
{synopt:{opt 245}}Somers {it:d} statistics [O]{p_end}
{synopt:{opt 246}}Sørensen similarity coefficient [B]{p_end}
{synopt:{opt 247}}Specificity (aliases: inverse recall, selectivity, true negative rate; complement: false positive rate) [B]{p_end}
{synopt:{opt 248}}Standard deviation agreement (SDAI) index (aliases: Armitage-Blendis-Smyllie index) [B]{p_end}
{synopt:{opt 249}}Steffensen {it:Ψ}² coefficient [M]{p_end}
{synopt:{opt 250}}Steffensen {it:ω} coefficient [M]{p_end}
{synopt:{opt 251}}Stiles coefficient [B]{p_end}
{synopt:{opt 252}}Stuart {it:τ}c correlation coefficient (for ordinal variables; aliases: Kendall {it:τ}c coefficient, Kendall-Stuart {it:τ}c coefficient) [O]{p_end}
{synopt:{opt 253}}Success index (aliases: Tarwid index) [B]{p_end}
{synopt:{opt 254}}Szymkiewicz-Simpson similarity coefficient (aliases: confidence, overlap) [B]{p_end}
{synopt:{opt 255}}Tarantula metric [B]{p_end}
{synopt:{opt 256}}Theil uncertainty coefficient {it:U} (aliases: entropy, normalized mutual information (NMI) (directional), proficiency, (asymmetric) uncertainty coefficient) [M]{p_end}
{synopt:{opt 257}}Theil symmetric uncertainty coefficient {it:U} (aliases: normalized mutual information (NMI) (symmetric), symmetric uncertainty (SU) coefficient) [M]{p_end}
{synopt:{opt 258}}Tönnies coefficient [O]{p_end}
{synopt:{opt 259}}Tschuprow {it:T} bias-corrected coefficient (aliases: Cramér {it:V} bias-corrected coefficient) [M]{p_end}
{synopt:{opt 260}}Tschuprow {it:T} coefficient (aliases: Cramér {it:V} coefficient or {it:φ}c) [M]{p_end}
{synopt:{opt 261}}{it:t}-score [B]{p_end}
{synopt:{opt 262}}Tulloss {it:R} cost index [B]{p_end}
{synopt:{opt 263}}Tulloss {it:S} cost index [B]{p_end}
{synopt:{opt 264}}Tulloss {it:T} combined costs index (aliases: tripartite similarity {it:T} index) [B]{p_end}
{synopt:{opt 265}}Tulloss {it:U} cost index [B]{p_end}
{synopt:{opt 266}}Tversky index (with user-defined parameters {it:α} > 0 and {it:β} > 0; identical to Sokal-Sneath #6 if {it:α} = {it:β} = 1/{it:w}) [B]{p_end}
{synopt:{opt 267}}Two-alternative forced choice 2{it:AFC} statistic #1 [M]{p_end}
{synopt:{opt 268}}Two-alternative forced choice 2{it:AFC} statistic #2 [O]{p_end}
{synopt:{opt 269}}Upholt {it:S} coefficient [B]{p_end}
{synopt:{opt 270}}Van der Maarel coefficient [B]{p_end}
{synopt:{opt 271}}Van Rijsbergen effectiveness {it:E}-measure (with user-defined parameter 0 ≤ {it:α} ≤ 1) (complement: {it:F}ᵦ-score) [B]{p_end}
{synopt:{opt 272}}Variance dissimilarity measure [B]{p_end}
{synopt:{opt 273}}Warrens coefficient (aliases: harmonic mean of precision, hit rate, negative predicted value and specificity) [B]{p_end}
{synopt:{opt 274}}Weighted {it:κ} coefficient (with user-supplied parameters 0 ≤ {it:ω}ᵢⱼ ≤ 1 with all {it:ω}ᵢᵢ = 1 and all {it:ω}ᵢⱼ = {it:ω}ⱼᵢ)
(aliases: weighted {it:κ}, weighted agreement, weighted Cohen kappa, identical to unweighted Cohen {it:κ} if {it:ω}ᵢⱼ = 0, {it:i} ≠ {it:j}) [M]{p_end}
{synopt:{opt 275}}Woodcock similarity coefficient (complement: Baulieu dissimilarity coefficient #20) [B]{p_end}
{synopt:{opt 276}}Yao-Liu one-way support measure [B]{p_end}
{synopt:{opt 277}}Yao-Liu two-way support measure [B]{p_end}
{synopt:{opt 278}}Yao-Liu two-way support variation [B]{p_end}
{synopt:{opt 279}}Yates {it:χ}² statistics [B]{p_end}
{synopt:{opt 280}}Yule {it:φ} correlation coefficient (aliases: generalized Fleiss correlation coefficient (geometric),
Matthews correlation {it:MCC} coefficient, Pearson product-moment correlation coefficient {it:φ}, {it:r}ᵩ, tetrachoric correlation, Yule correlation) [B]{p_end}
{synopt:{opt 281}}Yule {it:Q} coefficient (aliases: Goodman-Kruskal {it:γ} coefficient, odds ratio skill score, Yule association) [B]{p_end}
{synopt:{opt 282}}Yule {it:Y} coefficient (aliases: Yule colligation, Yule {it:σ}) [B]{p_end}
{synopt:{opt 283}}Zhang coefficient [B]{p_end}
{synoptline}


{title:References}

{p 4 7}Sirchenko, A. 2026. A comprehensive catalogue of association and
forecast-evaluation measures for categorical data. {it:Nyenrode Business University, Manuscript.}
{p_end}