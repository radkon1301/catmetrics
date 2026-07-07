{smcl}
{* *! version 0.2.0  02Jul2026}{...}
{title:Title}

{pstd}{helpb catmetrics##catmetrics:catmetrics} {c -} computes 259 measures of association and correlation between two categorical
 variables (dichotomous and polytomous, nominal and ordinal), 6 proper scores for
 probabilistic forecasts, and 12 diagnostic measures of the accuracy of 
 probabilistic forecasts of such variables.{p_end}

{title:Syntax}

{marker nop}{...}
{pstd}The command has four syntax forms:{p_end}

{pstd}{cmd:catmetrics} {depvar} {it:indepvar} {bind:[{cmd:,} {it:options}]}{p_end}

{p 4 7}where {depvar} and {it:indepvar} are two categorical variables with the same
number of observed categories. In the asymmetric context,
{it:indepvar} precedes depvar chronologically or causally. 
In the context of forecasting, {it:indepvar}
stands for the actual outcomes and {depvar} stands for the predicted outcomes.{p_end}

{pstd}{cmd:catmetrics} {depvar} {bind:[{cmd:,} probs(varlist) {it:options}]}{p_end}

{p 4 7}where {depvar} contains the realized values of a categorical variable, and probs(varlist) supplies the predicted probabilities for each category. 
For ordinal outcomes, the probabilities should be listed in ascending category order. 
The number of supplied probability variables must equal the number of distinct observed categories.
{p_end}

{pstd}{cmd:catmetrics} {depvar} {bind:[{cmd:,} predict {it:options}]}{p_end}

{p 4 7}where {depvar} again contains the realized outcomes, and predicted probabilities are obtained
from the most recently estimated Stata model (e.g., probit, logit, oprobit, mlogit) by the post-estimation command predict.
{p_end}

{pstd}{cmd:catmetrics} {bind:[{cmd:,} mat(string) {it:options}]}{p_end}

{p 4 7}where mat(string) supplies a contingency table (confusion matrix) directly.{p_end}

{p 4 7}In each case, the command displays a classification table (confusion matrix), computes 259
measures of association, similarity and categorical hard forecast evaluation,
and also returns the class-specific measures for each
class as well as their simple and weighted averages. When predicted probabilities are supplied,
18 strictly proper scoring rules and diagnostic measures of probabilistic forecast evaluation are additionally computed. The following options are available.{p_end}

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}

{synopt :{opt mat:(string)}} specifies the contingency table that should be used to compute the catmetrics command. When this option is used, no variable input is required. By default, no contingency table is assumed if the option is not used.

{synopt :{opt probs:(varlist)}} specifies the list of variables containing the predicted probabilities for each category of the dependent variable. 
Variables must be supplied in ascending order of the numeric category codes of {depvar}, and the number of probability variables must equal the number of distinct categories. Cannot be combined with {it:indepvar} or {opt predict}.

{synopt :{opt pred:ict}} specifies that the command {cmd:predict} should be used to compute the probability variables from the most recently estimated model. 
The model must support probability prediction (e.g., {cmd:logit}, {cmd:mlogit}). Cannot be combined with {it:indepvar} or {opt probs()}.

{synopt :{opt excel:(string)}} specifies the name of the saved *.xlsx file. By default, the file name is "Catmetrics.xlsx".

{synopt :{opt noexcel}} does not create an *.xlsx file. By default, results are saved to an *.xlsx file.

{synopt :{opt metrics:(string)}}
specifies which measures to display in the Results window. Metrics can be selected in any order
using their indices
(see the names and indices in {help catmetrics##MetricReferenceTable:Metric Reference Table} below).
Probability scores can be
selected using tokens P1 through P18 (see the {help catmetrics##ProbScoreTable:Probabilistic Score Table} below). 
Specifying metrics(none) results in no metrics and scores being displayed. Specifying metrics(all)
displays all available metrics in the Results window (measures for probabilistic forecast
evaluation are computed only if predicted probabilities are supplied).
If any metrics or probability scores are selected,
neither the default metrics nor probability scores will be displayed.
For the default print-outs, refer to {help catmetrics##DefaultPrintOuts:Default Print-outs section}.
{p_end}

{synopt :{opt bkappa:(scalar)}} specifies the kappa (a positive irrational number)
 to be used for the [15] Baulieu #22 metric.
By default, the kappa value is set to Euler's e. It is required that kappa > 0.

{synopt :{opt eceq:(scalar)}} specifies the q value to be used for the [P10] Expected Calibration
Error. By default, the q value is set to 1.
It is required that q > 0.

{synopt :{opt ecem:(scalar)}} specifies the m value to be used for the [P10] Expected Calibration
Error. By default, the m value is set to 10.
It is required that m is an integer and m > 1.

{synopt :{opt fbeta:(scalar)}} specifies the beta value to be used for the [75] F_beta score. By default, the beta value is set to 1.5.
It is required that beta ≥ 0.

{synopt :{opt gaink:(scalar)}} specifies the k value to be used for the [P11] Gain at k. By default, the k value is set to 0.1.
It is required that 0 < k < 1.

{synopt :{opt gfholderp:(scalar)}} specifies the p value to be used for the [99-101] Generalized Fleiss
(Holder) #1, #2, and #3 coefficients. By default, the p value is set to 0.5. It is required that p != 0.

{synopt :{opt gflehmerp:(scalar)}} specifies the p value to be used for the [105-107] Generalized Fleiss
(Lehmer) #1, #2, and #3 coefficients. By default, the p value is set to 1.5.
There are no restrictions on the value of p.

{synopt :{opt gltheta:(scalar)}} specifies the theta value to be used for the [134] Gower-Legendre S_theta index.
By default, the theta value is set to 1.5. It is required that theta > 0.

{synopt :{opt goalpha:(scalar)}} specifies the alpha value to be used for the [135] Gray-Orlowska interestingness index. By default, the alpha value is set to 2.
It is required that alpha > 0.

{synopt :{opt gobeta:(scalar)}} specifies the beta value to be used for the [135] Gray-Orlowska interestingness index. By default, the beta value is set to 2.
It is required that beta > 0.

{synopt :{opt ibaalpha:(scalar)}} specifies the alpha value to be used for the [146] Index of balanced accuracy. By default, the alpha value is set to 0.5.
It is required that 0 <= alpha <= 1.

{synopt :{opt kweights:(string)}} specifies the weighting matrix to be used for the [250] Weighted kappa coefficient.
The weighting matrix must have the same dimensions as the contingency table.
It is required that the weighting matrix is symmetric, all main diagonal entries are 1, and that all entries are in [0, 1].
By default, the weighting matrix is set to the identity matrix.

{synopt :{opt liftk:(scalar)}} specifies the k value to be used for the [P12] Lift at k. By default, the k value is set to 0.1.
It is required that 0 < k < 1.

{synopt :{opt mceq:(scalar)}} specifies the q value to be used for the [P14] Maximum Calibration
Error. By default, the q value is set to 1.
It is required that q > 0.

{synopt :{opt mcem:(scalar)}} specifies the m value to be used for the [P14] Maximum Calibration
Error. By default, the m value is set to 10.
It is required that m is an integer and m > 1.

{synopt :{opt power:(scalar)}} specifies the beta value to be used for the [P3] Power score. By default, the beta value is set to 1.5.
It is required that beta > 1.

{synopt :{opt pseudo:spherical(scalar)}} specifies the beta value to be used for the [P4] Pseudospherical score. By default, the beta value is set to 1.5.
It is required that beta > 1.

{synopt :{opt sokalw:(scalar)}} specifies the w value to be used for the [223] Sokal-Sneath coefficient #6.
By default, the w value is set to 3. It is required that w > 0.

{synopt :{opt talpha:(scalar)}} specifies the alpha value to be used for the [243] Tversky index.
By default, the alpha value is set to 4. It is required that alpha > 0.

{synopt :{opt tbeta:(scalar)}} specifies the beta value to be used for the [243] Tversky index.
By default, the beta value is set to 4. It is required that beta > 0.

{synoptline}

{title:Examples}

{pstd}Compute the catmetrics command by including the true values as the dependent variable and predicted values as dependent variable.{p_end}
       {bf:. catmetrics y y_pred}

{pstd}Compute the catmetrics command by including the true values as dependent variable while specifying the probabilities in the options.
In this example, y takes on values in three categories; hence p1, p2, and p3 are necessary.{p_end}
       {bf:. catmetrics y, probs(p1 p2 p3)}

{pstd}Compute the catmetrics command by including the true values as dependent variable while using the Stata {cmd:predict} command to compute the probabilities.
It is required that variable names p1, p2, up to pK are not already defined within Stata.{p_end}
       {bf:. catmetrics y, pred}

{pstd}Compute the catmetrics command by specifying a contingency table in the options and saving the results to "Example file name.xlsx".{p_end}
       {bf:. catmetrics, mat(contingency_table) excel(Example file name)}

{pstd}Compute the catmetrics command for the specified contingency table, not saving the results to an .xlsx book and printing metrics 1 (accuracy), 123 (goodall), and 5 (ample).{p_end}
       {bf:. catmetrics, mat(contingency_table) noexcel metrics(1 goodall 5)}
	   
{pstd}Compute the catmetrics command with different beta values for the Power, Pseudospherical, and Fbeta score.{p_end}
       {bf:. catmetrics y, probs(p1 p2 p3) power(2.5) pseudospherical(2.5) fbeta(2.5)}
	   
{pstd}Compute the catmetrics command with different parameter values for the Gray-Orlowska interestingness weighting dependency, index of balanced accuracy, and weighted kappa metrics.{p_end}
       {bf:. catmetrics y y_pred, goalpha(1.5) gobeta(0.5) ibaalpha(0.75) kweights(kappa_matrix)}

{pstd}Compute the catmetrics command for a contingency table named Confusion, saving to "demo_1.xlsx" and suppressing all printed metrics, including probabilistic scores.{p_end}
       {bf:. catmetrics, mat(Confusion) metrics(none) excel(demo_1)}

{pstd}Compute the catmetrics command with only probabilistic-score tokens specified in {opt metrics()}; the default association metrics are printed alongside the requested scores.{p_end}
       {bf:. webuse fullauto}
       {bf:. oprobit rep77 foreign length mpg}
       {bf:. catmetrics rep77, pred metrics(p1 p3 p5 p10)}

{title:Output}

{p 4 7}By default, a selection of measures along with their ranges and values are printed in the Stata console.{p_end}
{p 4 7}The printed contingency (or confusion) table includes an additional row and column reporting the row and column sums, with the overall sample size n shown in the bottom-right corner.{p_end}
{p 4 7}The arrows in the ranges can be interpreted as follows.
In case of two arrows pointing in the same direction, such as [-1 → 0 → 1],
the arrows point from the value for perfect negative association, to the midpoint
achieved under independence, to the value for perfect positive association.
In case of two arrows pointing towards the middle value, the middle value is
optimal in the sense of representing the most balanced classes.
If only one arrow is present, it points from either the perfect negative association
or independence endpoint in the direction of perfect positive association. Note
that the endpoint is not necessarily achieved for perfect positive association.
The arrow only serves as a general guideline in the direction of increasingly positive
association.
Finally, if no arrow is present, none of the above interpretations are available
for the measure's value. There is more detail provided with the range itself,
or for more information refer to literature of the specific measure.
{p_end}
{p 4 7}In case of two categories, the Value column refers to the value of the metric for the positive category.
Overall sample values and category-specific values are printed as available.
The macro average is an arithmetic average over metric values across cateogories.
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
Numerical values in the the output file are displayed using 4-digit rounding for ease of use. The underlying values
are the raw values computed within Stata, with no precision loss due to rounding.{p_end}
 
{marker DefaultPrintOuts}
{title:Default print-outs}

{pstd} If there are two categories present:{p_end}
       1. Accuracy
       11. Baroni-Urbani-Buser 1
       42. Clement
       56. Dennis
       84. G-mean
       130. Goodman-Kruskal tau
       136. Grier B bias
       139. Harris-Lahey
       140. Hawkins-Dotson
       190. Pearson contingency C
       197. Pollaczek-Geiringer (ORD)
       211. Schrank
       253. Yao-Liu two-way support
       254. Yao-Liu two-way support variation
       255. Yates chi^2

{pstd} If there are more than two categories present:{p_end}
       1. Accuracy
       11. Baroni-Urbani-Buser 1
       42. Clement
       54. Cressie-Read
       129. Goodman-Kruskal lambda r
       131. Goodman-Kruskal weighted lambda
       136. Grier B bias
       139. Harris-Lahey
       190. Pearson contingency C
       211. Schrank
       216. Simple matching
       232. Szymkiewicz-Simpson
       235. Tonnies (ORD)

{pstd} If probabilistic scores are available:{p_end}
       P1. Brier score
       P2. Logarithmic score
       P3. Power score
       P7. Area under ROC curve
       P13. Macro average mean probability rate
       P15. Mean probability rate
       P18. Zero-one score

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
{synopt:{opt P7}}Area under ROC curve (AUC) {p_end}
{synopt:{opt P8}}Area under CAP curve (AUGC) {p_end}
{synopt:{opt P9}}Average precision (AP) {p_end}
{synopt:{opt P10}}Expected calibration error (ECE) {p_end}
{synopt:{opt P11}}Gain at k {p_end}
{synopt:{opt P12}}Lift at k {p_end}
{synopt:{opt P13}}Macro average mean probability rate (MAPR) {p_end}
{synopt:{opt P14}}Maximum calibration error (MCE) {p_end}
{synopt:{opt P15}}Mean probability rate (MPR) {p_end}
{synopt:{opt P16}}Two-alternative forced choice score (2AFC) #1 {p_end}
{synopt:{opt P17}}Two-alternative forced choice score (2AFC) #2 {p_end}
{synopt:{opt P18}}Zero-one score {p_end}
{synoptline}

{marker MetricReferenceTable}
{title:Metric Reference Table}

{pstd}
For the option {opt metrics:(string)}, the numeric indices should be used.
The table below lists all 259 available metrics with their corresponding index numbers.
The metric names printed in the Results window and Excel are usually
shortened for readability and to save space.
{p_end}

{synoptset 5 tabbed}{...}
{synopthdr:Number}
{synoptline}
{synopt:{opt 1}}Accuracy{p_end}
{synopt:{opt 2}}Added value{p_end}
{synopt:{opt 3}}Adjusted noise-to-signal ratio{p_end}
{synopt:{opt 4}}Alroy measure{p_end}
{synopt:{opt 5}}AMPLE index{p_end}
{synopt:{opt 6}}Anderberg coefficient{p_end}
{synopt:{opt 7}}Anderberg D similarity coefficient{p_end}
{synopt:{opt 8}}Appleman index{p_end}
{synopt:{opt 9}}Atkinson similarity{p_end}
{synopt:{opt 10}}Balanced accuracy{p_end}
{synopt:{opt 11}}Baroni-Urbani-Buser coefficient #1{p_end}
{synopt:{opt 12}}Baroni-Urbani-Buser coefficient #2{p_end}
{synopt:{opt 13}}Base rate{p_end}
{synopt:{opt 14}}Baulieu dissimilarity coefficient #13{p_end}
{synopt:{opt 15}}Baulieu dissimilarity coefficient #22{p_end}
{synopt:{opt 16}}Baulieu dissimilarity coefficient #23{p_end}
{synopt:{opt 17}}Baulieu dissimilarity coefficient #24{p_end}
{synopt:{opt 18}}Baulieu dissimilarity coefficient #25{p_end}
{synopt:{opt 19}}Baulieu dissimilarity coefficient #27{p_end}
{synopt:{opt 20}}Baulieu dissimilarity coefficient #28{p_end}
{synopt:{opt 21}}Baulieu dissimilarity coefficient #29{p_end}
{synopt:{opt 22}}Baulieu dissimilarity coefficient #30{p_end}
{synopt:{opt 23}}Baulieu dissimilarity coefficient #31{p_end}
{synopt:{opt 24}}Baulieu dissimilarity coefficient #32{p_end}
{synopt:{opt 25}}Baulieu dissimilarity coefficient #33{p_end}
{synopt:{opt 26}}Benini phi/phi_max correlation coefficient #1{p_end}
{synopt:{opt 27}}Benini phi/phi_max correlation coefficient #2{p_end}
{synopt:{opt 28}}Benini correlation coefficient #3{p_end}
{synopt:{opt 29}}Benini correlation coefficient #4{p_end}
{synopt:{opt 30}}Bennet S coefficient{p_end}
{synopt:{opt 31}}Berger-Parker dominance index{p_end}
{synopt:{opt 32}}Bias index{p_end}
{synopt:{opt 33}}Blaheta-Johnson unigram subtuples measure{p_end}
{synopt:{opt 34}}Braun-Blanquet similarity index{p_end}
{synopt:{opt 35}}Bray-Curtis dissimilarity index{p_end}
{synopt:{opt 36}}Brin conviction coefficient{p_end}
{synopt:{opt 37}}Causal confidence{p_end}
{synopt:{opt 38}}Causal confirmed confidence{p_end}
{synopt:{opt 39}}Causal confirm{p_end}
{synopt:{opt 40}}Chord distance metric{p_end}
{synopt:{opt 41}}Clayton skill score{p_end}
{synopt:{opt 42}}Clement reliability coefficient{p_end}
{synopt:{opt 43}}Cohen kappa coefficient{p_end}
{synopt:{opt 44}}Cole C5 correlation coefficient{p_end}
{synopt:{opt 45}}Collective strength index{p_end}
{synopt:{opt 46}}Confirm{p_end}
{synopt:{opt 47}}Consonni-Todeschini similarity index #1{p_end}
{synopt:{opt 48}}Consonni-Todeschini similarity index #2{p_end}
{synopt:{opt 49}}Consonni-Todeschini similarity index #3{p_end}
{synopt:{opt 50}}Consonni-Todeschini similarity index #4{p_end}
{synopt:{opt 51}}Consonni-Todeschini similarity index #5{p_end}
{synopt:{opt 52}}Coverage{p_end}
{synopt:{opt 53}}Cramér concordance coefficient{p_end}
{synopt:{opt 54}}Cressie-Read power divergence statistic{p_end}
{synopt:{opt 55}}Czekanowski index{p_end}
{synopt:{opt 56}}Dennis z-score{p_end}
{synopt:{opt 57}}Dependency measure{p_end}
{synopt:{opt 58}}Digby correlation coefficient{p_end}
{synopt:{opt 59}}Discrimination d distance{p_end}
{synopt:{opt 60}}Dispersion index{p_end}
{synopt:{opt 61}}Dominance index{p_end}
{synopt:{opt 62}}Donaldson bias index{p_end}
{synopt:{opt 63}}Doolittle association ratio{p_end}
{synopt:{opt 64}}Doolittle raw accuracy{p_end}
{synopt:{opt 65}}Driver-Kroeber similarity index{p_end}
{synopt:{opt 66}}Example and counterexample rate{p_end}
{synopt:{opt 67}}Extremal dependence index{p_end}
{synopt:{opt 68}}Extreme dependency index{p_end}
{synopt:{opt 69}}Eyraud index{p_end}
{synopt:{opt 70}}Fager-McGowan similarity index #1{p_end}
{synopt:{opt 71}}Fager-McGowan similarity index #2{p_end}
{synopt:{opt 72}}Faith similarity index{p_end}
{synopt:{opt 73}}False alarm ratio{p_end}
{synopt:{opt 74}}False negative rate{p_end}
{synopt:{opt 75}}F_beta-score{p_end}
{synopt:{opt 76}}Fisher exact test statistic{p_end}
{synopt:{opt 77}}Fleiss kappa coefficient{p_end}
{synopt:{opt 78}}Fleiss-Levin-Paik agreement index{p_end}
{synopt:{opt 79}}Forbes coefficient #1{p_end}
{synopt:{opt 80}}Forbes coefficient #2{p_end}
{synopt:{opt 81}}Fossum index{p_end}
{synopt:{opt 82}}Freeman-Tukey statistic{p_end}
{synopt:{opt 83}}F-score adjusted{p_end}
{synopt:{opt 84}}G-mean{p_end}
{synopt:{opt 85}}G-mean adjusted{p_end}
{synopt:{opt 86}}Galton agreement coefficient{p_end}
{synopt:{opt 87}}Ganascia coefficient{p_end}
{synopt:{opt 88}}Generalized Fleiss correlation coefficient (arithmetic) #2{p_end}
{synopt:{opt 89}}Generalized Fleiss correlation coefficient (arithmetic) #3{p_end}
{synopt:{opt 90}}Generalized Fleiss correlation coefficient (contraharmonic) #1{p_end}
{synopt:{opt 91}}Generalized Fleiss correlation coefficient (contraharmonic) #2{p_end}
{synopt:{opt 92}}Generalized Fleiss correlation coefficient (contraharmonic) #3{p_end}
{synopt:{opt 93}}Generalized Fleiss correlation coefficient (harmonic) #1{p_end}
{synopt:{opt 94}}Generalized Fleiss correlation coefficient (harmonic) #2{p_end}
{synopt:{opt 95}}Generalized Fleiss correlation coefficient (harmonic) #3{p_end}
{synopt:{opt 96}}Generalized Fleiss correlation coefficient (Heronian) #1{p_end}
{synopt:{opt 97}}Generalized Fleiss correlation coefficient (Heronian) #2{p_end}
{synopt:{opt 98}}Generalized Fleiss correlation coefficient (Heronian) #3{p_end}
{synopt:{opt 99}}Generalized Fleiss correlation coefficient (Hölder) #1{p_end}
{synopt:{opt 100}}Generalized Fleiss correlation coefficient (Hölder) #2{p_end}
{synopt:{opt 101}}Generalized Fleiss correlation coefficient (Hölder) #3{p_end}
{synopt:{opt 102}}Generalized Fleiss correlation coefficient (identric) #1{p_end}
{synopt:{opt 103}}Generalized Fleiss correlation coefficient (identric) #2{p_end}
{synopt:{opt 104}}Generalized Fleiss correlation coefficient (identric) #3{p_end}
{synopt:{opt 105}}Generalized Fleiss correlation coefficient (Lehmer) #1{p_end}
{synopt:{opt 106}}Generalized Fleiss correlation coefficient (Lehmer) #2{p_end}
{synopt:{opt 107}}Generalized Fleiss correlation coefficient (Lehmer) #3{p_end}
{synopt:{opt 108}}Generalized Fleiss correlation coefficient (logarithmic) #1{p_end}
{synopt:{opt 109}}Generalized Fleiss correlation coefficient (logarithmic) #2{p_end}
{synopt:{opt 110}}Generalized Fleiss correlation coefficient (logarithmic) #3{p_end}
{synopt:{opt 111}}Generalized Fleiss correlation coefficient (quadratic) #1{p_end}
{synopt:{opt 112}}Generalized Fleiss correlation coefficient (quadratic) #2{p_end}
{synopt:{opt 113}}Generalized Fleiss correlation coefficient (quadratic) #3{p_end}
{synopt:{opt 114}}Generalized Fleiss correlation coefficient (Seiffert) #1{p_end}
{synopt:{opt 115}}Generalized Fleiss correlation coefficient (Seiffert) #2{p_end}
{synopt:{opt 116}}Generalized Fleiss correlation coefficient (Seiffert) #3{p_end}
{synopt:{opt 117}}Gerrity skill score{p_end}
{synopt:{opt 118}}Gilbert index{p_end}
{synopt:{opt 119}}Gilbert skill score{p_end}
{synopt:{opt 120}}Gilbert-Wells index{p_end}
{synopt:{opt 121}}Gini coefficient #1{p_end}
{synopt:{opt 122}}Gini coefficient #2{p_end}
{synopt:{opt 123}}Goodall index{p_end}
{synopt:{opt 124}}Goodman concomitance coefficient{p_end}
{synopt:{opt 125}}Goodman-Kruskal coefficient #1{p_end}
{synopt:{opt 126}}Goodman-Kruskal coefficient #2{p_end}
{synopt:{opt 127}}Goodman-Kruskal gamma coefficient{p_end}
{synopt:{opt 128}}Goodman-Kruskal lambda coefficient{p_end}
{synopt:{opt 129}}Goodman-Kruskal lambda_r coefficient{p_end}
{synopt:{opt 130}}Goodman-Kruskal tau coefficient{p_end}
{synopt:{opt 131}}Goodman-Kruskal weighted lambda coefficient{p_end}
{synopt:{opt 132}}Goodman weighted association index{p_end}
{synopt:{opt 133}}Gorodkin R_K correlation coefficient{p_end}
{synopt:{opt 134}}Gower-Legendre S_theta index{p_end}
{synopt:{opt 135}}Gray-Orlowska interestingness weighting dependency GOI - D index{p_end}
{synopt:{opt 136}}Grier B bias index{p_end}
{synopt:{opt 137}}Guttman coefficient{p_end}
{synopt:{opt 138}}Hamann coefficient{p_end}
{synopt:{opt 139}}Harris-Lahey index{p_end}
{synopt:{opt 140}}Hawkins-Dotson coefficient{p_end}
{synopt:{opt 141}}Heidke skill score{p_end}
{synopt:{opt 142}}Hit rate{p_end}
{synopt:{opt 143}}Höffding coefficient #1{p_end}
{synopt:{opt 144}}Höffding coefficient #2{p_end}
{synopt:{opt 145}}Hubert-Arabie adjusted Rand index{p_end}
{synopt:{opt 146}}Index of balanced accuracy IBA{p_end}
{synopt:{opt 147}}Information quality ratio{p_end}
{synopt:{opt 148}}J-measure{p_end}
{synopt:{opt 149}}Kendall tau_a correlation coefficient{p_end}
{synopt:{opt 150}}Kendall tau_b correlation coefficient with an adjustment for ties{p_end}
{synopt:{opt 151}}Kitamura-Matsumoto index{p_end}
{synopt:{opt 152}}Klösgen measure{p_end}
{synopt:{opt 153}}Köppen index{p_end}
{synopt:{opt 154}}Krippendorff alpha coefficient{p_end}
{synopt:{opt 155}}Kuder-Richardson coefficient{p_end}
{synopt:{opt 156}}Kuhns coefficient #1{p_end}
{synopt:{opt 157}}Kuhns coefficient #2{p_end}
{synopt:{opt 158}}Kulczyński index #1{p_end}
{synopt:{opt 159}}Kulczyński index #2{p_end}
{synopt:{opt 160}}Lakshmanamurti Lambda coefficient{p_end}
{synopt:{opt 161}}Laplace correction{p_end}
{synopt:{opt 162}}Least contradiction index{p_end}
{synopt:{opt 163}}Lerman implication index{p_end}
{synopt:{opt 164}}Leverage{p_end}
{synopt:{opt 165}}Log Forbes measure{p_end}
{synopt:{opt 166}}Log frequency biased index{p_end}
{synopt:{opt 167}}Log likelihood ratio statistic{p_end}
{synopt:{opt 168}}Log odds ratio amended statistic{p_end}
{synopt:{opt 169}}Log odds ratio statistic{p_end}
{synopt:{opt 170}}Mak rho coefficient{p_end}
{synopt:{opt 171}}Maron-Kuhns coefficient{p_end}
{synopt:{opt 172}}Maxwell B coefficient{p_end}
{synopt:{opt 173}}Maxwell-Pilliner coefficient{p_end}
{synopt:{opt 174}}McConnaughey coefficient{p_end}
{synopt:{opt 175}}Merton correct prediction CP index{p_end}
{synopt:{opt 176}}Michael index{p_end}
{synopt:{opt 177}}Minimum discrimination information MDI statistic{p_end}
{synopt:{opt 178}}Mountford index{p_end}
{synopt:{opt 179}}Mutual dependency measure{p_end}
{synopt:{opt 180}}Mutual information statistic{p_end}
{synopt:{opt 181}}Negative likelihood ratio statistic{p_end}
{synopt:{opt 182}}Neyman modified chi-squared statistic{p_end}
{synopt:{opt 183}}Normalized Google distance NGD metric{p_end}
{synopt:{opt 184}}Odds ratio{p_end}
{synopt:{opt 185}}Odds ratio amended{p_end}
{synopt:{opt 186}}Optimized precision{p_end}
{synopt:{opt 187}}P4-score{p_end}
{synopt:{opt 188}}Pattern difference{p_end}
{synopt:{opt 189}}Pearson chi-squared statistic{p_end}
{synopt:{opt 190}}Pearson contingency C coefficient{p_end}
{synopt:{opt 191}}Pearson-Heron correlation coefficient{p_end}
{synopt:{opt 192}}Pearson phi coefficient{p_end}
{synopt:{opt 193}}Peirce skill score{p_end}
{synopt:{opt 194}}Pietra statistic{p_end}
{synopt:{opt 195}}Poisson-Stirling index{p_end}
{synopt:{opt 196}}Pollack-Norman A sensitivity statistic{p_end}
{synopt:{opt 197}}Pollaczek-Geiringer correlation coefficient{p_end}
{synopt:{opt 198}}Positive likelihood ratio statistic{p_end}
{synopt:{opt 199}}Positive matching coefficient{p_end}
{synopt:{opt 200}}Precision{p_end}
{synopt:{opt 201}}Prevalence threshold index{p_end}
{synopt:{opt 202}}Putative causal dependency index{p_end}
{synopt:{opt 203}}Relative risk ratio{p_end}
{synopt:{opt 204}}Relative Quetelet index{p_end}
{synopt:{opt 205}}Rogers-Tanimoto coefficient{p_end}
{synopt:{opt 206}}Rogot-Goldberg index{p_end}
{synopt:{opt 207}}Rousseau index{p_end}
{synopt:{opt 208}}Roux index #1{p_end}
{synopt:{opt 209}}Roux index #2{p_end}
{synopt:{opt 210}}Russell-Rao coefficient{p_end}
{synopt:{opt 211}}Schrank index{p_end}
{synopt:{opt 212}}Scott coefficient{p_end}
{synopt:{opt 213}}Scott pi coefficient{p_end}
{synopt:{opt 214}}Sebag-Schoenauer index{p_end}
{synopt:{opt 215}}Shape difference measure{p_end}
{synopt:{opt 216}}Simple matching coefficient{p_end}
{synopt:{opt 217}}Size difference{p_end}
{synopt:{opt 218}}Sokal-Sneath similarity coefficient #1{p_end}
{synopt:{opt 219}}Sokal-Sneath similarity coefficient #2{p_end}
{synopt:{opt 220}}Sokal-Sneath similarity coefficient #3{p_end}
{synopt:{opt 221}}Sokal-Sneath similarity coefficient #4{p_end}
{synopt:{opt 222}}Sokal-Sneath similarity coefficient #5{p_end}
{synopt:{opt 223}}Sokal-Sneath similarity coefficient #6{p_end}
{synopt:{opt 224}}Somers d statistic{p_end}
{synopt:{opt 225}}Sørensen similarity coefficient{p_end}
{synopt:{opt 226}}Standard deviation agreement SDAI index{p_end}
{synopt:{opt 227}}Steffensen Psi-squared coefficient{p_end}
{synopt:{opt 228}}Steffensen omega coefficient{p_end}
{synopt:{opt 229}}Stiles coefficient{p_end}
{synopt:{opt 230}}Stuart tau_c correlation coefficient{p_end}
{synopt:{opt 231}}Success index{p_end}
{synopt:{opt 232}}Szymkiewicz-Simpson similarity coefficient{p_end}
{synopt:{opt 233}}Tarantula metric{p_end}
{synopt:{opt 234}}Theil index{p_end}
{synopt:{opt 235}}Tönnies coefficient{p_end}
{synopt:{opt 236}}Tschuprow T bias-corrected coefficient{p_end}
{synopt:{opt 237}}Tschuprow T coefficient{p_end}
{synopt:{opt 238}}t-score{p_end}
{synopt:{opt 239}}Tulloss R cost index{p_end}
{synopt:{opt 240}}Tulloss S cost index{p_end}
{synopt:{opt 241}}Tulloss T combined costs index{p_end}
{synopt:{opt 242}}Tulloss U cost index{p_end}
{synopt:{opt 243}}Tversky index{p_end}
{synopt:{opt 244}}Two-alternative forced choice 2AFC statistic #1{p_end}
{synopt:{opt 245}}Two-alternative forced choice 2AFC statistic #2{p_end}
{synopt:{opt 246}}Upholt S coefficient{p_end}
{synopt:{opt 247}}Van der Maarel coefficient{p_end}
{synopt:{opt 248}}Variance dissimilarity measure{p_end}
{synopt:{opt 249}}Warrens coefficient{p_end}
{synopt:{opt 250}}Weighted kappa coefficient{p_end}
{synopt:{opt 251}}Woodcock dissimilarity coefficient{p_end}
{synopt:{opt 252}}Yao-Liu one-way support measure{p_end}
{synopt:{opt 253}}Yao-Liu two-way support measure{p_end}
{synopt:{opt 254}}Yao-Liu two-way support variation{p_end}
{synopt:{opt 255}}Yates chi-squared statistic{p_end}
{synopt:{opt 256}}Yule phi correlation coefficient{p_end}
{synopt:{opt 257}}Yule Q coefficient{p_end}
{synopt:{opt 258}}Yule Y coefficient{p_end}
{synopt:{opt 259}}Zhang coefficient{p_end}
{synoptline}


{title:References}

{p 4 7}Sirchenko, A. 2026. A comprehensive catalogue of association and
forecast-evaluation measures for categorical data. {it:Nyenrode Business University, Manuscript.}
{p_end}