version 18.5

mata:

struct idxstruct {
	real colvector idx
}

// Returns the number of elements of sorted ascending vector v that are < x
real scalar lb(real colvector v, real scalar x)
{
    real scalar lo, hi, mid
    lo = 1
    hi = rows(v) + 1
    while (lo < hi) {
        mid = floor((lo + hi) / 2)
        if (v[mid] < x) lo = mid + 1
        else            hi = mid
    }
    return(lo - 1)
}

// Returns the number of elements of sorted ascending vector v that are <= x
real scalar ub(real colvector v, real scalar x)
{
    real scalar lo, hi, mid
    lo = 1
    hi = rows(v) + 1
    while (lo < hi) {
        mid = floor((lo + hi) / 2)
        if (v[mid] <= x) lo = mid + 1
        else             hi = mid
    }
    return(lo - 1)
}

// XXX v
// helper function for 2AFC #1 probability score
// returns 0, 0.5, or 1 based on the comparison of p_lj(l) vs p_ki(l)
real scalar I_func(real scalar p_ki, real scalar p_lj) {
    if (p_lj < p_ki)       return(0)
    else if (p_lj == p_ki) return(0.5)
    else                   return(1)
}

// computes F(p_ki, p_lj) for 2AFC #2
// p_ki: 1 x K row vector (forecast probs for obs i in category k)
// p_lj: 1 x K row vector (forecast probs for obs j in category l)
real scalar F_func(real rowvector p_ki, real rowvector p_lj) {
    K = length(p_ki)
    num   = 0
    denom = 0
    
    for (r = 1; r <= K-1; r++) {
        for (s = r+1; s <= K; s++) {
            num = num + p_ki[r] * p_lj[s]
        }
    }
    
    for (r = 1; r <= K; r++) {
        denom = denom + p_ki[r] * p_lj[r]
    }
    denom = 1 - denom
    
    return(num / denom)
}

// helper function for 2AFC #2 probability score
// returns 0, 0.5, or 1 based on F(p_ki, p_lj) vs 0.5
real scalar I_func2(real rowvector p_ki, real rowvector p_lj) {
    real scalar f
    f = F_func(p_ki, p_lj)
    if (f < 0.5)       return(0)
    else if (f == 0.5) return(0.5)
    else               return(1)
}
// XXX ^

// KONRAD (30) v
// KONRAD (16) v
// function to compute the product of all matrix entries
function prod(X) {
	value = 1
	for (r=1; r<=rows(X); r++) {
		for (c=1; c<=cols(X); c++) {
			value = value * X[r,c]
		}
	}
	return(value)
}

function log2(x) {
	return(log(x) / log(2))
}
// KONRAD (16) ^

//function to add the weighted and macro averages to the end of the vector
function include_averages(value,ncol,n,n_plus_k){
    if(cols(value) > 1 & missing(value) == 0) { // KONRAD(11) - if values missing, the averages are meaningless 
		weighted_average = 0
		macro_average = rowsum(value/ncol) // KONRAD (4) - TODO
			for (j=1; j<=cols(value); j++) {
				weighted_average = weighted_average + value[j]* n_plus_k[j]/n
			}
		return(value, macro_average, weighted_average) // KONRAD (1)
    }
    return(value, ., .)
}
// KONRAD (30) ^

// KONRAD (31) v
// function that computes a metric and adds it to the excel file
function add_to_excel(class xl scalar excel, row_number, score_number, label, funname, struct MetricInputs scalar inp, type, fmtid_num, fmtid_txt) {
	pointer(function) scalar f
	f = findexternal(funname + "()")
	if (f == NULL) {
		errprintf("Function %s not found\n", funname)
		exit(3499)
	}
	pointer(function) scalar f_range
	f_range = findexternal(funname + "_R()")
	if (f_range == NULL) {
		errprintf("Function %s not found\n", funname + "_R()")
		exit(3499)
	}
	excel.put_number(row_number, 1, score_number)
	excel.put_string(row_number, 2, label)
	
	// excel.put_string(row_number, 3, type)
	excel.put_string(row_number, 3, (*f_range)(inp.n, rows(inp.conf_mat), type, inp)) // XXX
	value = (*f)(inp, type)
	if (cols(value) == 1) {
		if (value[1,1] != .) {
			excel.put_number(row_number, 4, value)
			excel.set_fmtid(row_number, 4, fmtid_num)
		}
		else {
			excel.put_string(row_number, 4, "NA")
			excel.set_fmtid(row_number, 4, fmtid_txt)
		}
	}
	else {
		vals = include_averages(value, rows(inp.conf_mat), inp.n, inp.n_plus_1)
		for (i=1; i<=cols(vals); i++) {
			if (vals[i] != .) {
				excel.put_number(row_number, 4+i, vals[i])
				excel.set_fmtid(row_number, 4+i, fmtid_num)
			}
			else {
				excel.put_string(row_number, 4+i, "NA")
				excel.set_fmtid(row_number, 4+i, fmtid_txt)
			}
		}
		// disabled:
		// place the value of the positive class in the value column for 2-category case
		/*if (rows(inp.conf_mat) == 2) {
			if (value[1,1] != .) {
				excel.put_number(row_number, 4, value[1,1])
				excel.set_fmtid(row_number, 4, fmtid_num)
			}
			else {
				excel.put_string(row_number, 4, "NA")
				excel.set_fmtid(row_number, 4, fmtid_txt)
			}
		}*/
	}
	return(value) // return value in case needs to be printed to Stata
}
// KONRAD (31) ^

function get_printable_metrics(selected, struct MetricInputs scalar inp, ncat, do_symmetry, digs) {
	ret = J(0, 5 + ncat, "")
	row_idx = 1
	for (i=1; i<=rows(selected); i++) {
		
		pointer(function) scalar f
		f = findexternal(selected[i,2] + "()")
		if (f == NULL) {
			errprintf("%-s | function not found\n", selected[i,2] + "()")
			return
		}
		
		pointer(function) scalar f_range
		f_range = findexternal(selected[i,2] + "_R()")
		if (f_range == NULL) {
			errprintf("%-s | function not found\n", selected[i,2] + "_R()")
			return
		}
		
		for (s=3; s<=3+2*do_symmetry; s++) {
			if (selected[i,s] == "") {
				continue
			}
			ret = ret \ J(1, 5 + ncat, "")
			if (!do_symmetry) {
				ret[row_idx, 5 + ncat] = selected[i,1]
			}
			else {
				ret[row_idx, 5 + ncat] = selected[i,1] + " (" + selected[i,s] + ")"
			}
			value = (*f)(inp, selected[i,s])
			range = (*f_range)(inp.n, rows(inp.conf_mat), selected[i,s], inp) // XXX
			ret[row_idx,1] = range
			if (cols(value) == 1) {
				ret[row_idx,2] = sprintf("%6." + strofreal(digs) + "f", value)
			}
			else {
				value = include_averages(value, rows(inp.conf_mat), inp.n, inp.n_plus_1)
				if (ncat == 2) {
					ret[row_idx,2] = sprintf("%6." + strofreal(digs) + "f", value[1])
				}
				for (j=1; j<=cols(value); j++) {
					ret[row_idx,j+2] = sprintf("%6." + strofreal(digs) + "f", value[j])
				}
			}
			row_idx = row_idx + 1
		}
	}
	return(ret)
}

void print_vector(text, elements) {
	printf(text)
	for(i=1;i<=cols(elements);i++) {
		printf("{bf:%9.4f}", elements[i])
	}
	printf("\n")
}	

void print_matrix(contents, rownames, colnames, | uline, lline, mline, digits, rowtitle, coltitle) {
	// because Stata cannot display matrices with dots in colnames, we need our own printing function!
	n = rows(contents)
	m = cols(contents)
	if (rownames == . | rows(rownames) == 0) {
		rowname_width = 0
		rowname_flag = 0
	} else {
		rownames = rownames \ "Total"
		rowname_width = max(strlen(rownames) \ 10 \ strlen(rowtitle) \ strlen(coltitle))
		rowname_flag = 1
	}
	if (uline == . | rows(uline) == 0) {
		uline = 0
	} 
	if (lline == . | rows(lline) == 0) {
		lline = 0
	}
	if (mline == . | rows(mline) == 0) {
		mline = (n > 1)
	}
	if (digits == . | rows(digits) == 0) {
		digits = 4
	}

	// compute row totals, column totals, and the grand total, and append them
	// as an extra column and an extra row
	rowtotals = rowsum(contents)
	coltotals = colsum(contents)
	grandtotal = sum(contents)
	contents_new = (contents, rowtotals) \ (coltotals, grandtotal)
	n = n + 1
	m = m + 1

	_colnames = colnames
	if (cols(_colnames) > 1){
		_colnames = _colnames'
	}
	_colnames = _colnames \ "Total"
	colnames = _colnames
	
	if (rowtitle == . | rows(rowtitle) == 0) {
		rowtitle_rows = 0
	} else {
		// todo: ensure that rowname_flag is true
		rowtitle_rows = rows(rowtitle)
		rowname_width = max((strlen(rowtitle) \ rowname_width))
	}
	if (coltitle == . | rows(coltitle) == 0) {
		coltitle_rows = 0
	} else {
		// todo: ensure that rowname_flag is true
		coltitle_rows = rows(coltitle)
	}
	
	colwidths = rowmax((strlen(_colnames) :+ 3 , J(rows(_colnames), 1, 6)))
	// todo: support word wrap for long colnames and maybe row and col titles
	// todo: make colwidths depend on the contents
	// todo: support lines before totals
	numberf = strofreal(digits) + "f"
	if (rowname_flag) {
		hline = "{hline " + strofreal(rowname_width+1)+ "}{c +}{hline " + strofreal(sum(colwidths) - colwidths[m] + (m-1) + 1)+ "}{c +}{hline " + strofreal(colwidths[m]+2) + "}\n"
	} else {
		hline = "{hline " + strofreal(sum(colwidths) - colwidths[m] + (m-1)) + "}{c +}{hline " + strofreal(colwidths[m]+2) + "}\n"
	}
	// print header
	if (uline) {
		printf(hline)
	}
	
	if (rowtitle_rows > 1) {
		for(i=1; i <= rowtitle_rows; i++) {
			// todo: take into accoutn possible difference in vlines
			printf("%" + strofreal(rowname_width) + "s {c |}", rowtitle[i])
			// todo: make coltitle centered
			if (coltitle_rows > 0) {
				coltitle_current =  i + coltitle_rows - rowtitle_rows + 1
				if ((coltitle_current > 0) & (coltitle_current <= coltitle_rows)) {
					printf(coltitle[coltitle_current])
				}
			}
			if (i < rowtitle_rows) {
				printf("\n")
			}
		}
	} else if (rowtitle_rows==1){
	    printf("%" + strofreal(rowname_width) + "s {c |} ", rowtitle)	    
	} else if (rowname_flag) {
		printf("%" + strofreal(rowname_width) + "s {c |} ", "")
	}
	for(j=1; j<=m; j++){
		displayas("txt")
		if (j == m) {
			printf("{c |} ")
		}
		printf("%" + strofreal(colwidths[j]) + "s ", colnames[j])
	}
	printf("\n")
	if (mline) {
		printf(hline)
	}
	// print the rest of the table
	if (coltitle_rows==1){
		displayas("txt")
	    printf("%"+strofreal(rowname_width)+ "s {c |}%" + strofreal(sum(colwidths) - colwidths[m] + (m-1)) + "s {c |}\n", coltitle, "")
	} else if (coltitle_rows>1){
	    "A higher (>1) number of words for column title is not yet supported"
	}
	for(i=1; i<=n; i++) {
		if (i == n) {
			printf(hline)
		}
		if (rowname_flag) {
			displayas("txt")
			printf("%" + strofreal(rowname_width)+ "s {c |} ", rownames[i])
		}
		for(j=1; j<=m; j++){
			displayas("res")
			if (j == m) {
				printf("{c |} ")
			}
			printf("%" + strofreal(colwidths[j]) + "." + numberf + " ", contents_new[i, j])
		}
		displayas("txt")
		printf("\n")
	}
	if (lline) {
		printf(hline)
	}
}

// Accuracy - Gini 2
function chunk_1(struct MetricInputs scalar inp){
	b22_label = "Baulieu dissimilarity #22 (kappa=" + strofreal(round(inp.baulieu_kappa, 0.0001)) + ")"
	fbeta_label = "Fbeta-score (beta=" + strofreal(round(inp.fbeta, 0.0001)) + ")"

	gen_fleiss_holder_1_label = "Gener. Fleiss coefficient (Holder) #1 (p=" + strofreal(round(inp.fleiss_holder_p, 0.0001)) + ")"
	gen_fleiss_holder_2_label = "Gener. Fleiss coefficient (Holder) #2 (p=" + strofreal(round(inp.fleiss_holder_p, 0.0001)) + ")"
	gen_fleiss_holder_3_label = "Gener. Fleiss coefficient (Holder) #3 (p=" + strofreal(round(inp.fleiss_holder_p, 0.0001)) + ")"
	gen_fleiss_lehmer_1_label = "Gener. Fleiss coefficient (Lehmer) #1 (p=" + strofreal(round(inp.fleiss_lehmer_p, 0.0001)) + ")"
	gen_fleiss_lehmer_2_label = "Gener. Fleiss coefficient (Lehmer) #2 (p=" + strofreal(round(inp.fleiss_lehmer_p, 0.0001)) + ")"
	gen_fleiss_lehmer_3_label = "Gener. Fleiss coefficient (Lehmer) #3 (p=" + strofreal(round(inp.fleiss_lehmer_p, 0.0001)) + ")"
	
	iba_label = "Gener. index of balanced accuracy (alpha=" + strofreal(round(inp.ibaalpha,0.0001)) + ",M=" + strofreal(round(inp.ibam,0.0001)) + ")"
	
	cr_label = "Cressie-Read power divergence (lambda=" + strofreal(round(inp.crlambda,0.0001)) + ")"

	all_metrics = (
		"Accuracy",                                         "accuracy",                           "CTS", "",    ""    \
		"Added value",                                      "added_value",                        "AS",  "",    ""    \
		"Adjusted noise-to-signal ratio",                   "adjusted_noise_to_signal",           "AS",  "",    ""    \
		"Alroy coefficient",                                "alroy_corrected_forbes_F",           "TS",  "",    ""    \
		"Anderberg coefficient",                            "anderberg",                          "TS",  "",    ""    \
		"Anderberg D",                                      "anderberg_D",                        "CTS", "",    ""    \
		"Appleman index",                                   "appleman",                           "CS",  "CTS", ""    \
		"Atkinson similarity",                              "atkinson",                           "CTS", "",    ""    \
		"Balanced accuracy",                                "balanced_accuracy",                  "CS",  "CTS", ""    \
		"Balanced error rate",                              "balanced_error_rate",                "CS",  "",    ""    \
		"Baroni-Urbani-Buser #1",                           "baroni_urbani_buser_one",            "TS",  "CTS", ""    \
		"Baroni-Urbani-Buser #2",                           "baroni_urbani_buser_two",            "TS",  "CTS", ""    \
		"Base rate",                                        "base_rate",                          "AS",  "CS",  "TS"  \
		"Batagelj-Bren distance Q_0",                       "batagelj_bren",                      "CTS", "",    ""    \
		"Baulieu dissimilarity #13",                        "baulieu_13",                         "CTS", "",    ""    \
		b22_label,                                          "baulieu_22",                         "TS",  "",    ""    \
		"Baulieu dissimilarity #23",                        "baulieu_23",                         "TS",  "",    ""    \
		"Baulieu dissimilarity #24",                        "baulieu_24",                         "TS",  "",    ""    \
		"Baulieu dissimilarity #25",                        "baulieu_25",                         "TS",  "",    ""    \
		"Baulieu dissimilarity #27",                        "baulieu_27",                         "AS",  "",    ""    \
		"Baulieu dissimilarity #28",                        "baulieu_28",                         "CTS", "",    ""    \
		"Baulieu dissimilarity #29",                        "baulieu_29",                         "TS",  "",    ""    \
		"Baulieu dissimilarity #30",                        "baulieu_30",                         "TS",  "",    "")
	all_metrics = all_metrics \ (
		"Baulieu dissimilarity #31",                        "baulieu_31",                         "TS",  "",    ""    \
		"Baulieu dissimilarity #32",                        "baulieu_32",                         "AS",  "",    ""    \
		"Baulieu dissimilarity #33",                        "baulieu_33",                         "TS",  "",    ""    \
		"Benini coefficient #1",                            "benini_1",                           "TS",  "CTS", ""    \
		"Benini coefficient #2",                            "benini_2",                           "CTS", "",    ""    \
		"Benini coefficient #3",                            "benini_3",                           "AS",  "CTS", ""    \
		"Benini coefficient #4",                            "benini_4",                           "AS",  "CTS", ""    \
		"Bennet S coefficient",                             "bennett",                            "CTS", "",    ""    \
		"Berger-Parker index",                                    "berger_parker",                      "CTS", "",    ""    \
		"Bias index",                                             "bias",                               "AS",  "CS",  "TS"  \
		"Blaheta-Johnson unigram subtuples",                                  "blaheta_johnson",                    "CTS", "",    ""    \
		"Braun-Blanquet similarity index",                                   "braun_blanquet",                     "TS",  "CTS", ""    \
		"Bray-Curtis dissimilarity index",                                      "bray_curtis",                        "CTS", "",    ""    \
		"Brin conviction coefficient",                                  "brin_conviction",                    "AS",  "CTS", ""    \
		"Causal confidence",                                "causal_confidence",                  "AS",  "CTS", "TS"  \
		"Causal confirmed confidence",                      "causal_confidence_confirmed",        "AS",  "CTS", "TS"  \
		"Causal confirm",                                   "causal_confirm",                     "AS",  "CTS", ""    \
		"Chord distance metric",                                   "chord_distance",                     "TS",  "",    ""    \
		"Clayton skill score",                              "clayton_skill_score",                "CS",  "CTS", ""    \
		"Clement reliability coefficient",                                          "clement",                            "CS",  "CTS", ""    \
		"Cohen kappa coefficient",                          "cohen_pi",                           "CTS", "",    ""    \
		"Cole C_5 correlation coefficient",                                          "cole_c5",                            "CTS", "",    ""    \
		"Collective strength index",                              "collective_strength",                "AS",  "CS",  "TS"  \
		"Consonni-Todeschini index #1",                            "consonni_todeschini_1",              "CTS", "",    ""    \
		"Consonni-Todeschini index #2",                            "consonni_todeschini_2",              "CTS", "",    "")
	all_metrics = all_metrics \ (
		"Consonni-Todeschini index #3",                            "consonni_todeschini_3",              "TS",  "CTS", ""    \
		"Consonni-Todeschini index #4",                            "consonni_todeschini_4",              "TS",  "CTS", ""    \
		"Consonni-Todeschini index #5",                            "consonni_todeschini_5",              "CTS", "",    ""    \
		"Cramer concordance coefficient",                               "cramer_concordance",                 "CTS", "",    ""    \
		cr_label,          "cressie_read",                       "CTS", "",    ""    \
		"Czekanowski index",                                      "czekanowski",                        "TS",  "CTS", ""    \
		"Dennis z-score",                                           "dennis",                             "TS",  "CTS", ""    \
		"Dependency measure",                                       "dependency",                         "AS",  "CTS", "TS"  \
		"Descriptive confirm",                              "confirm",                            "AS",  "CTS", "TS"  \
		"Digby correlation coefficient",                                            "digby",                              "CTS", "",    ""    \
		"Discriminant power",                               "discriminant_power",                 "CTS", "",    ""    \
		"Discrimination d' distance",                          "discrimination_distance",            "AS",  "CTS", "TS"  \
		"Dominance index",                                        "dominance",                          "AS",  "CTS", "TS"  \
		"Donaldson bias index",                                   "donaldson_bias",                     "AS",  "CS",  "TS"  \
		"Doolittle association ratio",                      "doolittle_association_ratio",        "CTS", "",    ""    \
		"Doolittle raw accuracy",                           "doolittle_raw_accuracy",             "TS",  "CTS", ""    \
		"Driver-Kroeber similarity index",                                   "driver_kroeber",                     "TS",  "CTS", ""    \
		"Error rate",                                       "error_rate",                         "CTS", "",    ""    \
		"Example and counterexample",                  "ex_and_counterex_rate",              "AS",  "CTS", "TS"  \
		"Extremal dependence index",                              "extremal_dependence",                "AS",  "CS",  "TS"  \
		"Extreme dependency index",                               "extreme_dependency",                 "AS",  "CS",  "TS"  \
		"Eyraud index",                                           "eyraud",                             "CTS", "",    ""    \
		"Fager-McGowan index #1",                                  "fager_mcgowan_1",                    "TS",  "CTS", ""    \
		"Fager-McGowan index #2",                                  "fager_mcgowan_2",                    "TS",  "CTS", ""    \
		"Faith similarity index",                                            "faith",                              "TS",  "CTS", ""    \
		"False alarm ratio",                                "false_alarm_ratio",                  "AS",  "CTS", "TS")
	all_metrics = all_metrics \ (
		"False negative rate",                              "false_negative_rate",                "AS",  "CTS", "TS"  \
		"False omission rate",                              "false_omission_rate",                "AS",  "",    ""    \
		"False positive rate",                              "false_positive_rate",                "AS",  "",    ""    \
		fbeta_label,                                        "f_b_score",                          "AS",  "CTS", "TS"  \
		"Fisher exact statistic",                           "fisher_exact_statistic",             "CTS", "",    ""    \
		"Fleiss-Levin-Paik agreement",                                "fleiss_levin_paik",                  "TS",  "",    ""    \
		"Forbes coefficient #1",                               			"forbes_1",                           "TS",  "CTS", ""    \
		"Forbes coefficient #2",                                         "forbes_2",                           "TS",  "CTS", ""    \
		"Fossum index",                                           "fossum",                             "TS",  "",    ""    \
		"Freeman-Tukey F^2 statistic",                     "freeman_tukey_statistic",            "CTS", "",    ""    \
		"Freeman-Tukey F^2 statistic (asymptotic)",        "freeman_tukey_statistic_as",         "CTS", "",    ""    \
		"F-score adjusted",                                 "f_score_adjusted",                   "AS",  "CTS", ""    \
		"Galton agreement coefficient",                                           "galton",                             "CTS", "",    ""    \
		"Ganascia coefficient",                                         "ganascia",                           "AS",  "CTS", "TS"  \
		"Gener. Fleiss coefficient (arithmetic) #2",               "gen_fleiss_arithmetic_2",             "CTS", "",    ""    \
		"Gener. Fleiss coefficient (contraharmonic) #1",           "gen_fleiss_contraharmonic_1",         "CTS", "",    ""    \
		"Gener. Fleiss coefficient (contraharmonic) #2",           "gen_fleiss_contraharmonic_2",         "CTS", "",    ""    \
		"Gener. Fleiss coefficient (contraharmonic) #3",           "gen_fleiss_contraharmonic_3",         "CTS", "",    ""    \
		"Gener. Fleiss coefficient (harmonic) #1",                 "gen_fleiss_harmonic_1",               "CTS", "",    ""    \
		"Gener. Fleiss coefficient (harmonic) #2",                 "gen_fleiss_harmonic_2",               "CTS", "",    ""    \
		"Gener. Fleiss coefficient (harmonic) #3",                 "gen_fleiss_harmonic_3",               "CTS", "",    ""    \
		"Gener. Fleiss coefficient (Heronian) #1",                 "gen_fleiss_heronian_1",               "CTS", "",    ""    \
		"Gener. Fleiss coefficient (Heronian) #2",                 "gen_fleiss_heronian_2",               "CTS", "",    ""    \
		"Gener. Fleiss coefficient (Heronian) #3",                 "gen_fleiss_heronian_3",               "CTS", "",    "" )
	all_metrics = all_metrics \ (
		gen_fleiss_holder_1_label,                          "gen_fleiss_holder_1",                "CTS", "",    ""    \
		gen_fleiss_holder_2_label,                          "gen_fleiss_holder_2",                "CTS", "",    ""    \
		gen_fleiss_holder_3_label,                          "gen_fleiss_holder_3",                "CTS", "",    ""    \
		"Gener. Fleiss coefficient (identric) #1",                 "gen_fleiss_identric_1",              "CTS", "",    ""    \
		"Gener. Fleiss coefficient (identric) #2",                 "gen_fleiss_identric_2",              "CTS", "",    ""    \
		"Gener. Fleiss coefficient (identric) #3",                 "gen_fleiss_identric_3",              "CTS", "",    ""    \
		gen_fleiss_lehmer_1_label,                 			"gen_fleiss_lehmer_1",                "CTS", "",    ""    \
		gen_fleiss_lehmer_2_label,                 			"gen_fleiss_lehmer_2",                "CTS", "",    ""    \
		gen_fleiss_lehmer_3_label,                 			"gen_fleiss_lehmer_3",                "CTS", "",    ""    \
		"Gener. Fleiss coefficient (logarithmic) #1",              "gen_fleiss_logarithmic_1",           "CTS", "",    ""    \
		"Gener. Fleiss coefficient (logarithmic) #2",              "gen_fleiss_logarithmic_2",           "CTS", "",    ""    \
		"Gener. Fleiss coefficient (logarithmic) #3",              "gen_fleiss_logarithmic_3",           "CTS", "",    ""    \
		"Gener. Fleiss coefficient (quadratic) #1",                "gen_fleiss_quadratic_1",             "CTS", "",    ""    \
		"Gener. Fleiss coefficient (quadratic) #2",                "gen_fleiss_quadratic_2",             "CTS", "",    ""    \
		"Gener. Fleiss coefficient (quadratic) #3",                "gen_fleiss_quadratic_3",             "CTS", "",    ""    \
		"Gener. Fleiss coefficient (Seiffert) #1",                 "gen_fleiss_seiffert_1",              "CTS", "",    ""    \
		"Gener. Fleiss coefficient (Seiffert) #2",                 "gen_fleiss_seiffert_2",              "CTS", "",    ""    \
		"Gener. Fleiss coefficient (Seiffert) #3",                 "gen_fleiss_seiffert_3",              "CTS", "",    ""    \
		iba_label,                                          "iba",                                "AS",  "",  ""  \
		"Gerrity skill score [ORD]",                        "gerrity_skill_score",                "AS",  "",    ""    \
		"Gilbert index",                                          "gilbert",                            "TS",  "",    ""    \
		"Gilbert skill score",                              "gilbert_skill_score",                "TS",  "",    ""    \
		"Gilbert-Wells index",                                    "gilbert_wells",                      "CTS",  "",    ""    \
		"Gini coefficient #1",                                           "gini_1",                             "CS",  "CTS", ""    \
		"Gini coefficient #2",                                           "gini_2",                             "CTS", "",    "" \
		"Gini impurity index",                              "gini_impurity",                      "AS",   "",   "" \
		"G-mean",                                           "g_mean",                             "CS",  "CTS", ""    \
		"G-mean adjusted",                                  "g_mean_adjusted",                    "AS",  "CS",  "TS")

	return(all_metrics)
}

// Gini 2 - End
function chunk_2(struct MetricInputs scalar inp) {
	gl_label = "Gower-Legendre Stheta index (theta=" + strofreal(round(inp.gl_theta, 0.0001)) + ")"
	gray_orlowska_label = "Gray-Orlowska index (alpha=" + strofreal(round(inp.goalpha, 0.0001)) + ",beta=" + strofreal(round(inp.gobeta,0.0001)) + ")"
	ss_6_label = "Sokal-Sneath similarity coefficient #6 (w=" + strofreal(round(inp.sokal_w,0.0001)) + ")"
	tversky_label = "Tversky index (alpha=" + strofreal(round(inp.t_alpha,0.0001)) + ",beta=" + strofreal(round(inp.t_beta,0.0001)) + ")"
	if (inp.custom_kweights) {
		weighted_kappa_label = "Weighted kappa coefficient (user weights)"
	}
	else {
		weighted_kappa_label = "Weighted kappa coefficient (default weights)"
	}
	van_rijsbergen_label = "Van Rijsbergen E-measure (alpha=" + strofreal(round(inp.ealpha, 0.01)) + ")"

	all_metrics = (
		"Goodall index",                                   		"goodall",                     		  "CTS", "",    ""    \
		"Goodman concomitance coefficient",                             "goodman_concomitance",               "CTS", "",    ""    \
		"Goodman-Kruskal coefficient #1",                                "goodman_kruskal_1",                  "CTS", "",    ""    \
		"Goodman-Kruskal coefficient #2",                                "goodman_kruskal_2",                  "CTS", "",    ""    \
		"Goodman-Kruskal gamma coefficient [ORD]",                      "goodman_kruskal_gamma",              "TS",  "",    ""    \
		"Goodman-Kruskal lambda coefficient",                           "goodman_kruskal_lambda",             "CS",  "CTS", ""    \
		"Goodman-Kruskal lambda_r coefficient",                         "goodman_kruskal_lambda_r",           "CS",  "CTS", ""    \
		"Goodman-Kruskal tau coefficient",                              "goodman_kruskal_tau",                "CS",  "CTS", ""    \
		"Goodman-Kruskal weighted lambda",                  "goodman_kruskal_lambda_w",           "CS",  "CTS", ""    \
		"Goodman unweighted association",                   "goodman_unweighted_assc",            "CTS", "",    ""    \
		"Goodman weighted association",                     "goodman_weighted_association",       "CTS", "",    ""    \
		"Gorodkin Rk coefficient",                                      "gorodkin_Rk",                        "CTS", "",    ""    \
		gl_label,                                           "gower_legendre",                     "CTS", "",    ""    \
		gray_orlowska_label,                                "gray_orlowska",                      "TS",  "CTS", ""    \
		"Grier B' bias index",                                     "grier_B_bias",                       "AS",  "CS",  "TS"  \
		"Guttman coefficient",                                          "guttman",                            "CS",  "CTS", ""    \
		"Hamann coefficient",                                           "hamann",                             "CTS", "",    ""    \
		"Harris-Lahey index",                                     "harris_lahey",                       "CTS", "",    ""    \
		"Hawkins-Dotson coefficient",                                   "hawkins_dotson",                     "CTS", "",    ""    \
		"Heidke skill score",                               "heidke_skill_score",                 "CTS", "",    ""    \
		"Hellinger distance",                               "hellinger_distance",                 "TS",  "",    ""    \
		"Hit rate",                                         "hit_rate",                           "AS",  "CTS", "TS"  \
		"Hoffding coefficient #1",                                      "hoeffding_1",                        "CTS", "",    ""    \
		"Hoffding coefficient #2",                                      "hoeffding_2",                        "CTS", "",    ""    \
		"Hubert-Arabie adjusted Rand index",                     "hubert_arabie",                      "CTS", "",    ""    \
		"Index of dissimilarity",                           "ample",                              "CS",  "",    ""    \
		"Information quality ratio",                        "information_quality_ratio",          "CTS", "",    ""    \
		"J-measure",                                        "j_measure",                          "AS",  "CTS", "TS"  \
		"Johnson",                                          "johnson",                            "TS",  "",    ""    \
		"Kendall tau-a coefficient [ORD]",                              "kendall_tau_a",                      "TS",  "",    ""    \
		"Kendall tau-b coefficient [ORD]",                              "kendall_tau_b",                      "TS",  "",    ""    \
		"Kent-Foster #1 coefficient",                       "kent_foster_1",                      "TS",  "",    ""    \
		"Kent-Foster #2 coefficient",                       "kent_foster_2",                      "TS",  "",    ""    \
		"Kitamura-Matsumoto index",                               "kitamura_matsumoto",                 "TS",  "CTS", ""    \
		"Klosgen measure",                                          "klosgen",                            "AS",  "CTS", "TS"  \
		"Koppen index [ORD]",                                     "koppen",                             "TS",  "",    ""    \
		"Krippendorff alpha coefficient",                               "krippendorff",                       "CTS", "",    ""    \
		"Kuder-Richardson coefficient",                                 "kuder_richardson",                   "CTS", "",    "")
	all_metrics = all_metrics \ (
		"Kuhns coefficient #1",                                          "kuhns_1",                            "TS",  "CTS", ""    \
		"Kuhns coefficient #2",                                          "kuhns_2",                            "TS",  "CTS", ""    \
		"Kulczynski index #1",                                     "kulczynski_1",                       "TS",  "CTS", ""    \
		"Kulczynski index #2",                                     "kulczynski_2",                       "TS",  "CTS", ""    \
		"Lakshmanamurti Lambda coefficient",                                   "lakshmanamurti",                     "CTS", "",    ""    \
		"Laplace correction",                               "laplace_correction",                 "AS",  "CTS", ""    \
		"Least contradiction index",                              "least_contradiction",                "AS",  "CTS", "TS"  \
		"Lerman implication index",                                           "lerman",                             "AS",  "CTS", ""    \
		"Leverage",                                         "leverage",                           "CTS", "",    ""    \
		"Likelihood ratio G^2 statistic",              "likelihood_ratio",                   "CTS", "",    ""    \
		"Log Forbes measure",                             			"log_forbes",                    	  "TS",  "CTS", ""    \
		"Log frequency biased index",                             "log_freq_biased",                    "TS",  "CTS", ""    \
		"Log odds ratio amended statistic",                           "log_odds_ratio_amended",             "CTS", "",    ""    \
		"Log odds ratio statistic",                                   "log_odds_ratio",                     "CTS", "",    ""    \
		"Mak rho coefficient",                           				"mak_rho",             				  "CTS", "",    ""    \
		"Mantel-Haenszel statistic [ORD]",                  "mantel_haenszel",                    "CTS", "",    ""    \
		"Maron-Kuhns coefficient",                                      "maron_kuhns",                        "CTS", "",    ""    \
		"Maxwell B coefficient",                                        "maxwell_B",                          "CTS", "",    ""    \
		"Maxwell-Pilliner coefficient",                                 "maxwell_pilliner",                   "CTS", "",    ""    \
		"McConnaughey coefficient",                                     "mcconnaughey",                       "TS",  "CTS", ""    \
		"Merton correct prediction CP index",                     "merton_CP",                          "CS",  "",    ""    \
		"Michael index",                                          "michael",                            "CTS", "",    ""    \
		"Modified likelihood ratio statistics",         "mdis",                               "CTS", "",    ""    \
		"Mountford index",                                        "mountford",                          "TS",  "CTS", ""    \
		"Mueller-Schuessler IQV index",                     "mueller_schuessler",                 "AS",  "",    ""    \
		"Mutual dependency",                                "mutual_dependency",                  "TS",  "CTS", ""    \
		"Mutual information statistic",                               "mutual_information",                 "CTS", "",    ""    \
		"Negative likelihood ratio statistic",                        "neg_likelihood_ratio",               "AS",  "CS",  "TS"  \
		"Negative predicted value",                         "neg_pred_value",                     "AS",  "",    ""    \
		"Neyman modified chi^2 statistic",                   "neyman_modified_chi2_statistic",     "CTS", "",    ""    \
		"Normalized Google distance",                       "norm_google_dist",                   "TS",  "CTS", ""    \
		"Odds ratio",                                       "odds_ratio",                         "CTS", "",    ""    \
		"Odds ratio amended",                               "odds_ratio_amended",                 "CTS", "",    ""    \
		"Optimized precision",                              "optimized_precision",                "CS",  "CTS", ""    \
		"P4-score",                                         "p4_score",                           "CTS", "",    ""    \		
		"Pattern difference",                               "pattern_difference",                 "CTS", "",    ""    \
		"Pearson chi^2 statistic",                                    "pearson_chi2",                       "CTS", "",    ""    \		
		"Pearson contingency C coefficient",                            "pearson_contingency_c",              "CTS", "",    ""    \
		"Pearson-Heron coefficient",                                    "pearson_heron",                      "CTS", "",    ""    \
		"Pearson phi coefficient",                            			"pearson_phi",              	      "CTS", "",    ""    \
		"Peirce skill score",                               "peirce_skill_score",                 "CTS", "",    ""    \
		"Pietra statistic",                                           "pietra",                             "CTS", "",    ""    )
	all_metrics = all_metrics \ (
		"Poisson-Stirling index",                                 "poisson_stirling",                   "TS",  "",    ""    \
		"Pollack-Norman A' sensitivity statistic",                                   "pollack_norman",                     "AS",  "CS",  "TS"  \
		"Pollaczek-Geiringer coefficient [ORD]",                        "pollaczek_geiringer",                "TS",  "",    ""    \
		"Positive likelihood ratio",                        "pos_likelihood_ratio",               "AS",  "CS",  "TS"  \
		"Positive matching coefficient",                                "positive_matching",                  "TS",  "CTS", ""    \
		"Precision",                                        "precision",                          "AS",  "CTS", "TS"  \
		"Predicted negative rate",                          "predicted_negative_rate",            "AS",  "",    ""    \
		"Predicted positive rate",                          "coverage",                           "AS",  "CTS", "TS"  \
		"Prevalence threshold index",                             "prevalence_threshold",               "AS",  "CS",  "TS"  \
		"Putative causal dependency index",                       "putative_causal_dependency",         "AS",  "CTS", ""    \
		"Relative risk ratio",                                    "relative_risk",                      "AS",  "CS",  "TS"  \
		"Relative Quetelet index",                          "relative_quetelet_index",            "TS",  "CTS", ""    \
		"Renkonen similarity index",                        "renkonen",                           "AS",  "",    ""    \
		"Replacement comp. (Jaccard)",            "replacement_comp_j",                 "TS",  "",    ""    \
		"Replacement comp. (Sorensen)",           "replacement_comp_s",                 "TS",  "",    ""    \
		"Replacement comp. (Braun-Blanquet)",     "replacement_comp_b",                 "TS",  "",    ""    \
		"Richness difference (Jaccard)",              "richness_diff_j",                    "TS",  "",    ""    \
		"Richness difference (Sorensen)",             "richness_diff_s",                    "TS",  "",    ""    \
		"Richness difference (Braun-Blanquet)",       "richness_diff_b",                    "TS",  "",    ""    \
		"Rogers-Tanimoto coefficient",                                  "rogers_tanimoto",                    "CTS", "",    ""    \
		"Rogot-Goldberg index",                                   "rogot_goldberg",                     "CTS", "",    ""    \
		"Root mean square difference",                      "root_mean_sq_diff",                  "CTS", "",    ""    \
		"Rousseau index",                                         "rousseau",                           "TS",  "CTS", ""    \
		"Roux index #1",                                           "roux_1",                             "CTS", "",    ""    \
		"Roux index #2",                                           "roux_2",                             "CTS", "",    ""    \
		"Russell-Rao coefficient",                                      "russell_rao",                        "TS",  "CTS", ""    \
		"Schrank index",                                          "schrank",                            "CTS", "",    ""    \
		"Scott pi coefficient",                                         "scott_pi",                           "CTS", "",    ""    \
		"Sebag-Schoenauer index",                                 "sebag_schoenauer",                   "AS",  "CTS", "TS"  \
		"Shape difference",                                 "shape_difference",                   "CTS", "",    ""    \
		"Simple matching coefficient",                                  "simple_matching",                    "TS",  "CTS", ""    \
		"Size difference",                                  "size_difference",                    "CTS", "",    ""    \
		"Sokal-Sneath similarity coefficient #1",                                   "sokal_sneath_1",                     "CTS", "",    ""    \
		"Sokal-Sneath similarity coefficient #2",                                   "sokal_sneath_2",                     "CTS", "",    ""    \
		"Sokal-Sneath similarity coefficient #3",                                   "sokal_sneath_3",                     "CTS", "",    ""    \
		"Sokal-Sneath similarity coefficient #4",                                   "sokal_sneath_4",                     "CTS", "",    ""    \
		"Sokal-Sneath similarity coefficient #5",                                   "sokal_sneath_5",                     "TS",  "CTS", ""    \
		ss_6_label,                                         "sokal_sneath_6",                     "TS", "CTS",  ""    \
		"Somers d statistics [ORD]",                                   "somers_d",                           "AS",  "TS",  ""    \
		"Sorensen similarity coefficient",                                         "sorensen",                           "TS",  "",    ""    \
		"Specificity",                                        "specificity",                        "AS",  "",    ""    \
		"Standard deviation agreement index",               "sdai",                               "CTS", "",    ""    \
		"Steffensen psi^2 coefficient",                                 "steffensen_psi2",                    "CTS", "",    ""    \
		"Steffensen omega coefficient",                                 "steffensen_omega",                   "CTS", "",    ""    \
		"Stiles coefficient",                                           "stiles",                             "CTS", "",    "")
	all_metrics = all_metrics \ (
		"Stuart tau-c correlation [ORD]",                               "kendall_tau_c",                      "TS",  "",    ""    \
		"Success index",                                          "success",                            "TS",  "CTS", ""    \
		"Szymkiewicz-Simpson coefficient",                              "szymkiewicz_simpson",                "TS",  "CTS", ""    \		
		"Tarantula metric",                                        "tarantula",                          "AS",  "CS",  "TS"  \
		"Theil uncertainty coefficient U",                  "theil",                              "CS",  "CTS", ""    \
		"Theil symmetric coefficient U",        "theil_sym",                          "CTS", "",    ""    \
		"Tonnies coefficient [ORD]",                                    "tonnies",                            "TS",  "",    ""    \
		"Tschuprow T bias-corrected coefficient",                       "tschuprow_t_bias_corrected",         "CTS", "",    ""    \
		"Tschuprow T coefficient",                                      "tschuprow_t",                        "CTS", "",    ""    \
		"t-score",                                          "t_score",                            "TS",  "CTS", ""    \
		"Tulloss R cost index",                                   "tulloss_r_cost",                     "TS",  "CTS", ""    \
		"Tulloss S cost index",                                   "tulloss_s_cost",                     "TS",  "CTS", ""    \
		"Tulloss T combined costs index",                         "tulloss_t_combined_costs",           "TS",  "CTS", ""    \		
		"Tulloss U cost index",                                   "tulloss_u_cost",                     "TS",  "CTS", ""    \
	 	tversky_label, 										"tversky", 							  "AS", "", 	""	  \
		"2AFC statistic #1",                  "two_afc_1",                          "CS",  "",    ""    \
		"2AFC statistic #2 [ORD]",            "two_afc_2",                          "AS",  "",    ""    \
		"Upholt S coefficient",                                         "upholt_s",                           "TS",  "CTS", ""    \
		"Van der Maarel coefficient",                                   "van_der_maarel",                     "TS",  "CTS", ""    \
		van_rijsbergen_label,                               "van_rijsbergen",                     "AS",  "",    ""    \
		"Variance dissimilarity measure", 							"variance_dissimilarity", 			  "CTS", "", 	""	  \
		"Warrens coefficient",                                          "warrens",                            "CTS", "",    ""    \
		weighted_kappa_label,                               "weighted_kappa",                     "TS",  "",    ""    \
		"Woodcock similarity coefficient",                                         "woodcock",                           "CTS", "",    ""    \
		"Yao-Liu one-way support measure",                          "yao_liu_one_way_support",            "AS",  "CTS", "TS"  \
		"Yao-Liu two-way support measure",                          "yao_liu_two_way_support",            "TS",  "CTS", ""    \
		"Yao-Liu two-way support variation",                "yao_liu_two_way_support_v",          "CTS", "",    ""    \
		"Yates chi^2 statistics",                                      "yates_chi2",                         "CTS", "",    ""    \
		"Yule phi correlation coefficient",                                         "yule_phi",                           "CTS", "",    ""    \
		"Yule Q coefficient",                                           "yule_q",                             "CTS", "",    ""	  \
		"Yule Y coefficient",                                           "yule_colligation",                   "CTS", "",    ""    \
		"Zhang coefficient",                                            "zhang",                              "AS",  "CS",  "TS"  )
	return(all_metrics)

}

function get_metrics_matrix(struct MetricInputs scalar inp) {
	all_metrics = chunk_1(inp)
	all_metrics = all_metrics \ chunk_2(inp)
return(all_metrics)
}


end
