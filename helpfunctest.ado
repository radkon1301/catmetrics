version 18.5

mata:

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
		// place the value of the positive class in the value column for 2-category case
		if (rows(inp.conf_mat) == 2) {
			if (value[1,1] != .) {
				excel.put_number(row_number, 4, value[1,1])
				excel.set_fmtid(row_number, 4, fmtid_num)
			}
			else {
				excel.put_string(row_number, 4, "NA")
				excel.set_fmtid(row_number, 4, fmtid_txt)
			}
		}
	}
	return(value) // return value in case needs to be printed to Stata
}
// KONRAD (31) ^

function get_printable_metrics(selected, struct MetricInputs scalar inp, ncat, do_symmetry) {
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
				ret[row_idx,2] = sprintf("%6.2f", value)
			}
			else {
				value = include_averages(value, rows(inp.conf_mat), inp.n, inp.n_plus_1)
				if (ncat == 2) {
					ret[row_idx,2] = sprintf("%6.2f", value[1])
				}
				for (j=1; j<=cols(value); j++) {
					ret[row_idx,j+2] = sprintf("%6.2f", value[j])
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
	_colnames = colnames
	if (cols(_colnames) > 1){
		_colnames = _colnames'
	}
	
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
		hline = "{hline " + strofreal(rowname_width+1)+ "}{c +}{hline " + strofreal(sum(colwidths :+ 1) + 2)+ "}\n"
	} else {
		hline = "{hline " + strofreal(rowname_width+1+1+sum(colwidths :+ 1) + 2) + "}\n"
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
		printf("%" + strofreal(colwidths[j]) + "s ", colnames[j])
	}
	printf("\n")
	if (mline) {
		printf(hline)
	}
	// print the rest of the table
	if (coltitle_rows==1){
		displayas("txt")
	    printf("%"+strofreal(rowname_width)+ "s {c |}\n",coltitle)
	} else if (coltitle_rows>1){
	    "A higher (>1) number of words for column title is not yet supported"
	}
	for(i=1; i<=n; i++) {
		if (rowname_flag) {
			displayas("txt")
			printf("%" + strofreal(rowname_width)+ "s {c |} ", rownames[i])
		}
		for(j=1; j<=m; j++){
			displayas("res")
			printf("%" + strofreal(colwidths[j]) + "." + numberf + " ", contents[i, j])
		}
		displayas("txt")
		printf("\n")
	}
	if (lline) {
		printf(hline)
	}
}

// Accuracy - Gini 2
function chunk_1(fbeta_r, goalpha_r, gobeta_r, ibaalpha_r, sokalw_r, gl_theta_r, baulieu_kappa_r, custom_kweights, t_alpha, t_beta, fleiss_holder_p_r, fleiss_lehmer_p_r){
	b22_label = "Baulieu 22 (kappa=" + strofreal(round(baulieu_kappa_r, 0.0001)) + ")"
	fbeta_label = "Fb score (beta=" + strofreal(fbeta_r) + ")"

	gen_fleiss_holder_1_label = "Generalized Fleiss (Holder) 1 (p=" + strofreal(round(fleiss_holder_p_r, 0.0001)) + ")"
	gen_fleiss_holder_2_label = "Generalized Fleiss (Holder) 2 (p=" + strofreal(round(fleiss_holder_p_r, 0.0001)) + ")"
	gen_fleiss_holder_3_label = "Generalized Fleiss (Holder) 3 (p=" + strofreal(round(fleiss_holder_p_r, 0.0001)) + ")"
	gen_fleiss_lehmer_1_label = "Generalized Fleiss (Lehmer) 1 (p=" + strofreal(round(fleiss_lehmer_p_r, 0.0001)) + ")"
	gen_fleiss_lehmer_2_label = "Generalized Fleiss (Lehmer) 2 (p=" + strofreal(round(fleiss_lehmer_p_r, 0.0001)) + ")"
	gen_fleiss_lehmer_3_label = "Generalized Fleiss (Lehmer) 3 (p=" + strofreal(round(fleiss_lehmer_p_r, 0.0001)) + ")"

	all_metrics = (
		"Accuracy",                                         "accuracy",                           "CTS", "",    ""    \
		"Added value",                                      "added_value",                        "AS",  "",    ""    \
		"Adjusted noise-to-signal ratio",                   "adjusted_noise_to_signal",           "AS",  "",    ""    \
		"Alroy",                                            "alroy_corrected_forbes_F",           "TS",  "",    ""    \
		"AMPLE",                                            "ample",                              "CS",  "",    ""    \
		"Anderberg",                                        "anderberg",                          "TS",  "",    ""    \
		"Anderberg D",                                      "anderberg_D",                        "CTS", "",    ""    \
		"Appleman",                                         "appleman",                           "CS",  "CTS", ""    \
		"Atkinson",                                         "atkinson",                           "CTS", "",    ""    \
		"Balanced accuracy",                                "balanced_accuracy",                  "CS",  "CTS", ""    \
		"Baroni-Urbani-Buser 1",                            "baroni_urbani_buser_one",            "TS",  "CTS", ""    \
		"Baroni-Urbani-Buser 2",                            "baroni_urbani_buser_two",            "TS",  "CTS", ""    \
		"Base rate",                                        "base_rate",                          "AS",  "CS",  "TS"  \
		"Baulieu 13",                                       "baulieu_13",                         "CTS", "",    ""    \
		b22_label,                                          "baulieu_22",                         "TS",  "",    ""    \
		"Baulieu 23",                                       "baulieu_23",                         "TS",  "",    ""    \
		"Baulieu 24",                                       "baulieu_24",                         "TS",  "",    ""    \
		"Baulieu 25",                                       "baulieu_25",                         "TS",  "",    ""    \
		"Baulieu 27",                                       "baulieu_27",                         "AS",  "",    ""    \
		"Baulieu 28",                                       "baulieu_28",                         "CTS", "",    ""    \
		"Baulieu 29",                                       "baulieu_29",                         "TS",  "",    ""    \
		"Baulieu 30",                                       "baulieu_30",                         "TS",  "",    "")
	all_metrics = all_metrics \ (
		"Baulieu 31",                                       "baulieu_31",                         "TS",  "",    ""    \
		"Baulieu 32",                                       "baulieu_32",                         "AS",  "",    ""    \
		"Baulieu 33",                                       "baulieu_33",                         "TS",  "",    ""    \
		"Benini 1",                                         "benini_1",                           "TS",  "CTS", ""    \
		"Benini 2",                                         "benini_2",                           "CTS", "",    ""    \
		"Benini 3",                                         "benini_3",                           "AS",  "CTS", ""    \
		"Benini 4",                                         "benini_4",                           "AS",  "CTS", ""    \
		"Bennett",                                          "bennett",                            "CTS", "",    ""    \
		"Berger-Parker",                                    "berger_parker",                      "CTS", "",    ""    \
		"Bias",                                             "bias",                               "AS",  "CS",  "TS"  \
		"Blaheta-Johnson",                                  "blaheta_johnson",                    "CTS", "",    ""    \
		"Braun-Blanquet",                                   "braun_blanquet",                     "TS",  "CTS", ""    \
		"Bray-Curtis",                                      "bray_curtis",                        "CTS", "",    ""    \
		"Brin conviction",                                  "brin_conviction",                    "AS",  "CTS", ""    \
		"Causal confidence",                                "causal_confidence",                  "AS",  "CTS", "TS"  \
		"Causal confidence confirmed",                      "causal_confidence_confirmed",        "AS",  "CTS", "TS"  \
		"Causal confirm",                                   "causal_confirm",                     "AS",  "CTS", ""    \
		"Chord distance",                                   "chord_distance",                     "TS",  "",    ""    \
		"Clayton skill score",                              "clayton_skill_score",                "CS",  "CTS", ""    \
		"Clement",                                          "clement",                            "CS",  "CTS", ""    \
		"Cohen kappa coefficient",                          "cohen_pi",                           "CTS", "",    ""    \
		"Cole C5",                                          "cole_c5",                            "CTS", "",    ""    \
		"Collective strength",                              "collective_strength",                "AS",  "CS",  "TS"  \
		"Confirm",                                          "confirm",                            "AS",  "CTS", "TS"  \
		"Consonni-Todeschini 1",                            "consonni_todeschini_1",              "CTS", "",    ""    \
		"Consonni-Todeschini 2",                            "consonni_todeschini_2",              "CTS", "",    "")
	all_metrics = all_metrics \ (
		"Consonni-Todeschini 3",                            "consonni_todeschini_3",              "TS",  "CTS", ""    \
		"Consonni-Todeschini 4",                            "consonni_todeschini_4",              "TS",  "CTS", ""    \
		"Consonni-Todeschini 5",                            "consonni_todeschini_5",              "CTS", "",    ""    \
		"Coverage",                                         "coverage",                           "AS",  "CTS", "TS"  \
		"Cramer concordance",                               "cramer_concordance",                 "CTS", "",    ""    \
		"Cressie-Read",                                     "cressie_read",                       "CTS", "",    ""    \
		"Czekanowski",                                      "czekanowski",                        "TS",  "CTS", ""    \
		"Dennis",                                           "dennis",                             "TS",  "CTS", ""    \
		"Dependency",                                       "dependency",                         "AS",  "CTS", "TS"  \
		"Digby",                                            "digby",                              "CTS", "",    ""    \
		"Discrimination distance",                          "discrimination_distance",            "AS",  "CTS", "TS"  \
		"Dispersion",                                       "dispersion",                         "CTS", "",    ""    \
		"Dominance",                                        "dominance",                          "AS",  "CTS", "TS"  \
		"Donaldson bias",                                   "donaldson_bias",                     "AS",  "CS",  "TS"  \
		"Doolittle association ratio",                      "doolittle_association_ratio",        "CTS", "",    ""    \
		"Doolittle raw accuracy",                           "doolittle_raw_accuracy",             "TS",  "CTS", ""    \
		"Driver-Kroeber",                                   "driver_kroeber",                     "TS",  "CTS", ""    \
		"Example and counterexample rate",                  "ex_and_counterex_rate",              "AS",  "CTS", "TS"  \
		"Extremal dependence",                              "extremal_dependence",                "AS",  "CS",  "TS"  \
		"Extreme dependency",                               "extreme_dependency",                 "AS",  "CS",  "TS"  \
		"Eyraud",                                           "eyraud",                             "CTS", "",    ""    \
		"Fager-McGowan 1",                                  "fager_mcgowan_1",                    "TS",  "CTS", ""    \
		"Fager-McGowan 2",                                  "fager_mcgowan_2",                    "TS",  "CTS", ""    \
		"Faith",                                            "faith",                              "TS",  "CTS", ""    \
		"False alarm ratio",                                "false_alarm_ratio",                  "AS",  "CTS", "TS")
	all_metrics = all_metrics \ (
		"False negative rate",                              "false_negative_rate",                "AS",  "CTS", "TS"  \
		fbeta_label,                                        "f_b_score",                          "AS",  "CTS", "TS"  \
		"Fisher exact statistic",                           "fisher_exact_statistic",             "CTS", "",    ""    \
		"Fleiss kappa",                               		"fleiss_kappa",                  	  "CTS",  "",    ""   \
		"Fleiss-Levin-Paik",                                "fleiss_levin_paik",                  "TS",  "",    ""    \
		"Forbes 1",                               			"forbes_1",                           "TS",  "CTS", ""    \
		"Forbes 2",                                         "forbes_2",                           "TS",  "CTS", ""    \
		"Fossum",                                           "fossum",                             "TS",  "",    ""    \
		"Freeman-Tukey statistic",                          "freeman_tukey_statistic",            "CTS", "",    ""    \
		"F-score adjusted",                                 "f_score_adjusted",                   "AS",  "CTS", ""    \
		"G-mean",                                           "g_mean",                             "CS",  "CTS", ""    \
		"G-mean adjusted",                                  "g_mean_adjusted",                    "AS",  "CS",  "TS"  \
		"Galton",                                           "galton",                             "CTS", "",    ""    \
		"Ganascia",                                         "ganascia",                           "AS",  "CTS", "TS"  \
		"Generalized Fleiss (arithmetic) 2",               "gen_fleiss_arithmetic_2",             "CTS", "",    ""    \
		"Generalized Fleiss (arithmetic) 3",               "gen_fleiss_arithmetic_3",             "CTS", "",    ""    \
		"Generalized Fleiss (contraharmonic) 1",           "gen_fleiss_contraharmonic_1",         "CTS", "",    ""    \
		"Generalized Fleiss (contraharmonic) 2",           "gen_fleiss_contraharmonic_2",         "CTS", "",    ""    \
		"Generalized Fleiss (contraharmonic) 3",           "gen_fleiss_contraharmonic_3",         "CTS", "",    ""    \
		"Generalized Fleiss (harmonic) 1",                 "gen_fleiss_harmonic_1",               "CTS", "",    ""    \
		"Generalized Fleiss (harmonic) 2",                 "gen_fleiss_harmonic_2",               "CTS", "",    ""    \
		"Generalized Fleiss (harmonic) 3",                 "gen_fleiss_harmonic_3",               "CTS", "",    ""    \
		"Generalized Fleiss (Heronian) 1",                 "gen_fleiss_heronian_1",               "CTS", "",    ""    \
		"Generalized Fleiss (Heronian) 2",                 "gen_fleiss_heronian_2",               "CTS", "",    ""    \
		"Generalized Fleiss (Heronian) 3",                 "gen_fleiss_heronian_3",               "CTS", "",    "" )
	all_metrics = all_metrics \ (
		gen_fleiss_holder_1_label,                          "gen_fleiss_holder_1",                "CTS", "",    ""    \
		gen_fleiss_holder_2_label,                          "gen_fleiss_holder_2",                "CTS", "",    ""    \
		gen_fleiss_holder_3_label,                          "gen_fleiss_holder_3",                "CTS", "",    ""    \
		"Generalized Fleiss (identric) 1",                 "gen_fleiss_identric_1",              "CTS", "",    ""    \
		"Generalized Fleiss (identric) 2",                 "gen_fleiss_identric_2",              "CTS", "",    ""    \
		"Generalized Fleiss (identric) 3",                 "gen_fleiss_identric_3",              "CTS", "",    ""    \
		gen_fleiss_lehmer_1_label,                 			"gen_fleiss_lehmer_1",                "CTS", "",    ""    \
		gen_fleiss_lehmer_2_label,                 			"gen_fleiss_lehmer_2",                "CTS", "",    ""    \
		gen_fleiss_lehmer_3_label,                 			"gen_fleiss_lehmer_3",                "CTS", "",    ""    \
		"Generalized Fleiss (logarithmic) 1",              "gen_fleiss_logarithmic_1",           "CTS", "",    ""    \
		"Generalized Fleiss (logarithmic) 2",              "gen_fleiss_logarithmic_2",           "CTS", "",    ""    \
		"Generalized Fleiss (logarithmic) 3",              "gen_fleiss_logarithmic_3",           "CTS", "",    ""    \
		"Generalized Fleiss (quadratic) 1",                "gen_fleiss_quadratic_1",             "CTS", "",    ""    \
		"Generalized Fleiss (quadratic) 2",                "gen_fleiss_quadratic_2",             "CTS", "",    ""    \
		"Generalized Fleiss (quadratic) 3",                "gen_fleiss_quadratic_3",             "CTS", "",    ""    \
		"Generalized Fleiss (Seiffert) 1",                 "gen_fleiss_seiffert_1",              "CTS", "",    ""    \
		"Generalized Fleiss (Seiffert) 2",                 "gen_fleiss_seiffert_2",              "CTS", "",    ""    \
		"Generalized Fleiss (Seiffert) 3",                 "gen_fleiss_seiffert_3",              "CTS", "",    ""    \
		"Gerrity skill score (ORD)",                        "gerrity_skill_score",                "AS",  "",    ""    \
		"Gilbert",                                          "gilbert",                            "TS",  "",    ""    \
		"Gilbert skill score",                              "gilbert_skill_score",                "TS",  "",    ""    \
		"Gilbert-Wells",                                    "gilbert_wells",                      "CTS",  "",    ""    \
		"Gini 1",                                           "gini_1",                             "CS",  "CTS", ""    \
		"Gini 2",                                           "gini_2",                             "CTS", "",    "")

	return(all_metrics)
}

// Gini 2 - End
function chunk_2(fbeta_r, goalpha_r, gobeta_r, ibaalpha_r, sokalw_r, gl_theta_r, baulieu_kappa_r, custom_kweights, t_alpha, t_beta, fleiss_holder_p_r, fleiss_lehmer_p_r){
	gl_label = "Gower-Legendre S_theta (theta=" + strofreal(gl_theta_r) + ")"
	gray_orlowska_label = "Gray-Orlowska (alpha=" + strofreal(goalpha_r) + ",beta=" + strofreal(gobeta_r) + ")"
	iba_label = "IBA (alpha=" + strofreal(ibaalpha_r) + ")"
	ss_6_label = "Sokal-Sneath 6 (w=" + strofreal(sokalw_r) + ")"
	tversky_label = "Tversky (alpha=" + strofreal(t_alpha) + ",beta=" + strofreal(t_beta) + ")"
	if (custom_kweights) {
		weighted_kappa_label = "Weighted kappa (user weights)"
	}
	else {
		weighted_kappa_label = "Weighted kappa (Id weights)"
	}

	all_metrics = (
		"Goodall",                                   		"goodall",                     		  "CTS", "",    ""    \
		"Goodman concomitance",                             "goodman_concomitance",               "CTS", "",    ""    \
		"Goodman-Kruskal 1",                                "goodman_kruskal_1",                  "CTS", "",    ""    \
		"Goodman-Kruskal 2",                                "goodman_kruskal_2",                  "CTS", "",    ""    \
		"Goodman-Kruskal gamma (ORD)",                      "goodman_kruskal_gamma",              "TS",  "",    ""    \
		"Goodman-Kruskal lambda",                           "goodman_kruskal_lambda",             "CS",  "CTS", ""    \
		"Goodman-Kruskal lambda r",                         "goodman_kruskal_lambda_r",           "CS",  "CTS", ""    \
		"Goodman-Kruskal tau",                              "goodman_kruskal_tau",                "CS",  "CTS", ""    \
		"Goodman-Kruskal weighted lambda",                  "goodman_kruskal_lambda_w",           "CS",  "CTS", ""    \
		"Goodman weighted association",                     "goodman_weighted_association",       "CTS", "",    ""    \
		"Gorodkin Rk",                                      "gorodkin_Rk",                        "CTS", "",    ""    \
		gl_label,                                           "gower_legendre",                     "CTS", "",    ""    \
		gray_orlowska_label,                                "gray_orlowska",                      "TS",  "CTS", ""    \
		"Grier B bias",                                     "grier_B_bias",                       "AS",  "CS",  "TS"  \
		"Guttman",                                          "guttman",                            "CS",  "CTS", ""    \
		"Hamann",                                           "hamann",                             "CTS", "",    ""    \
		"Harris-Lahey",                                     "harris_lahey",                       "CTS", "",    ""    \
		"Hawkins-Dotson",                                   "hawkins_dotson",                     "CTS", "",    ""    \
		"Heidke skill score",                               "heidke_skill_score",                 "CTS", "",    ""    \
		"Hit rate",                                         "hit_rate",                           "AS",  "CTS", "TS"  \
		"Hoeffding 1",                                      "hoeffding_1",                        "CTS", "",    ""    \
		"Hoeffding 2",                                      "hoeffding_2",                        "CTS", "",    ""    \
		"Hubert-Arabie adj Rand index",                     "hubert_arabie",                      "CTS", "",    ""    \
		iba_label,                                          "iba",                                "AS",  "CS",  "TS"  \
		"Information quality ratio",                        "information_quality_ratio",          "CTS", "",    ""    \
		"J-measure",                                        "j_measure",                          "AS",  "CTS", "TS"  \
		"Kendall tau-a (ORD)",                              "kendall_tau_a",                      "TS",  "",    ""    \
		"Kendall tau-b (ORD)",                              "kendall_tau_b",                      "TS",  "",    ""    \
		"Kitamura-Matsumoto",                               "kitamura_matsumoto",                 "TS",  "CTS", ""    \
		"Klosgen",                                          "klosgen",                            "AS",  "CTS", "TS"  \
		"Koppen (ORD)",                                     "koppen",                             "TS",  "",    ""    \
		"Krippendorff alpha",                               "krippendorff",                       "CTS", "",    ""    \
		"Kuder-Richardson",                                 "kuder_richardson",                   "CTS", "",    "")
	all_metrics = all_metrics \ (
		"Kuhns 1",                                          "kuhns_1",                            "TS",  "CTS", ""    \
		"Kuhns 2",                                          "kuhns_2",                            "TS",  "CTS", ""    \
		"Kulczynski 1",                                     "kulczynski_1",                       "TS",  "CTS", ""    \
		"Kulczynski 2",                                     "kulczynski_2",                       "TS",  "CTS", ""    \
		"Lakshmanamurti",                                   "lakshmanamurti",                     "CTS", "",    ""    \
		"Laplace correction",                               "laplace_correction",                 "AS",  "CTS", ""    \
		"Least contradiction",                              "least_contradiction",                "AS",  "CTS", "TS"  \
		"Lerman",                                           "lerman",                             "AS",  "CTS", ""    \
		"Leverage",                                         "leverage",                           "AS",  "CTS", "TS"  \
		"Log Forbes",                             			"log_forbes",                    	  "TS",  "CTS", ""    \
		"Log frequency biased",                             "log_freq_biased",                    "TS",  "CTS", ""    \
		"Likelihood ratio G^2",                             "likelihood_ratio",                   "CTS", "",    ""    \
		"Log odds ratio amended",                           "log_odds_ratio_amended",             "CTS", "",    ""    \
		"Log odds ratio",                                   "log_odds_ratio",                     "CTS", "",    ""    \
		"Mak rho",                           				"mak_rho",             				  "CTS", "",    ""    \
		"Maron-Kuhns",                                      "maron_kuhns",                        "CTS", "",    ""    \
		"Maxwell B",                                        "maxwell_B",                          "CTS", "",    ""    \
		"Maxwell-Pilliner",                                 "maxwell_pilliner",                   "CTS", "",    ""    \
		"McConnaughey",                                     "mcconnaughey",                       "TS",  "CTS", ""    \
		"Merton correct prediction CP",                     "merton_CP",                          "CS",  "",    ""    \
		"Michael",                                          "michael",                            "CTS", "",    ""    \	
		"MDI statistic",                                    "mdis",                               "CTS", "",    ""    \
		"Mountford",                                        "mountford",                          "TS",  "CTS", ""    \
		"Mutual dependency",                                "mutual_dependency",                  "TS",  "CTS", ""    \
		"Mutual information",                               "mutual_information",                 "CTS", "",    ""    \
		"Negative likelihood ratio",                        "neg_likelihood_ratio",               "AS",  "CS",  "TS"  \
		"Neyman modified chi2 statistic",                   "neyman_modified_chi2_statistic",     "CTS", "",    ""    \
		"Normalised Google distance",                       "norm_google_dist",                   "TS",  "CTS", ""    \
		"Odds ratio",                                       "odds_ratio",                         "CTS", "",    ""    \
		"Odds ratio amended",                               "odds_ratio_amended",                 "CTS", "",    ""    \
		"Optimized precision",                              "optimized_precision",                "CS",  "CTS", ""    \
		"P4-score",                                         "p4_score",                           "CTS", "",    ""    \		
		"Pattern difference",                               "pattern_difference",                 "CTS", "",    ""    \
		"Pearson chi^2",                                    "pearson_chi2",                       "CTS", "",    ""    \		
		"Pearson contingency C",                            "pearson_contingency_c",              "CTS", "",    ""    \
		"Pearson-Heron",                                    "pearson_heron",                      "CTS", "",    ""    \
		"Pearson phi",                            			"pearson_phi",              	      "CTS", "",    ""    \
		"Peirce skill score",                               "peirce_skill_score",                 "CTS", "",    ""    \
		"Pietra",                                           "pietra",                             "CTS", "",    ""    )
	all_metrics = all_metrics \ (
		"Poisson-Stirling",                                 "poisson_stirling",                   "TS",  "",    ""    \
		"Pollack-Norman",                                   "pollack_norman",                     "AS",  "CS",  "TS"  \
		"Pollaczek-Geiringer (ORD)",                        "pollaczek_geiringer",                "TS",  "",    ""    \
		"Positive likelihood ratio",                        "pos_likelihood_ratio",               "AS",  "CS",  "TS"  \
		"Positive matching",                                "positive_matching",                  "TS",  "CTS", ""    \
		"Precision",                                        "precision",                          "AS",  "CTS", "TS"  \
		"Prevalence threshold",                             "prevalence_threshold",               "AS",  "CS",  "TS"  \
		"Putative causal dependency",                       "putative_causal_dependency",         "AS",  "CTS", ""    \
		"Relative Risk",                                    "relative_risk",                      "AS",  "CS",  "TS"  \
		"Relative Quetelet index",                          "relative_quetelet_index",            "TS",  "CTS", ""    \
		"Rogers-Tanimoto",                                  "rogers_tanimoto",                    "CTS", "",    ""    \
		"Rogot-Goldberg",                                   "rogot_goldberg",                     "CTS", "",    ""    \
		"Rousseau",                                         "rousseau",                           "TS",  "CTS", ""    \
		"Roux 1",                                           "roux_1",                             "CTS", "",    ""    \
		"Roux 2",                                           "roux_2",                             "CTS", "",    ""    \
		"Russell-Rao",                                      "russell_rao",                        "TS",  "CTS", ""    \
		"Schrank",                                          "schrank",                            "CTS", "",    ""    \
		"Scott",                                            "scott",                              "CTS", "",    ""    \
		"Scott pi",                                         "scott_pi",                           "CTS", "",    ""    \
		"Sebag-Schoenauer",                                 "sebag_schoenauer",                   "AS",  "CTS", "TS"  \
		"Shape difference",                                 "shape_difference",                   "CTS", "",    ""    \
		"Simple matching",                                  "simple_matching",                    "TS",  "CTS", ""    \
		"Size difference",                                  "size_difference",                    "CTS", "",    ""    \
		"Sokal-Sneath 1",                                   "sokal_sneath_1",                     "CTS", "",    ""    \
		"Sokal-Sneath 2",                                   "sokal_sneath_2",                     "CTS", "",    ""    \
		"Sokal-Sneath 3",                                   "sokal_sneath_3",                     "CTS", "",    ""    \
		"Sokal-Sneath 4",                                   "sokal_sneath_4",                     "CTS", "",    ""    \
		"Sokal-Sneath 5",                                   "sokal_sneath_5",                     "TS",  "CTS", ""    \
		ss_6_label,                                         "sokal_sneath_6",                     "TS", "CTS",  ""    \
		"Somers d (ORD)",                                   "somers_d",                           "AS",  "TS",  ""    \
		"Sorensen",                                         "sorensen",                           "TS",  "",    ""    \
		"Standard deviation agreement index",               "sdai",                               "CTS", "",    ""    \
		"Steffensen psi^2",                                 "steffensen_psi2",                    "CTS", "",    ""    \
		"Steffensen omega",                                 "steffensen_omega",                   "CTS", "",    ""    \
		"Stiles",                                           "stiles",                             "CTS", "",    "")
	all_metrics = all_metrics \ (
		"Stuart tau-c (ORD)",                               "kendall_tau_c",                      "TS",  "",    ""    \
		"Success",                                          "success",                            "TS",  "CTS", ""    \
		"Szymkiewicz-Simpson",                              "szymkiewicz_simpson",                "TS",  "CTS", ""    \		
		"Tarantula",                                        "tarantula",                          "AS",  "CS",  "TS"  \
		"Theil",                                            "theil",                              "CS",  "CTS", ""    \
		"Tonnies (ORD)",                                    "tonnies",                            "TS",  "",    ""    \
		"Tschuprow T bias corrected",                       "tschuprow_t_bias_corrected",         "CTS", "",    ""    \
		"Tschuprow T",                                      "tschuprow_t",                        "CTS", "",    ""    \
		"t-score",                                          "t_score",                            "TS",  "CTS", ""    \
		"Tulloss R cost",                                   "tulloss_r_cost",                     "TS",  "CTS", ""    \
		"Tulloss S cost",                                   "tulloss_s_cost",                     "TS",  "CTS", ""    \
		"Tulloss T combined costs",                         "tulloss_t_combined_costs",           "TS",  "CTS", ""    \		
		"Tulloss U cost",                                   "tulloss_u_cost",                     "TS",  "CTS", ""    \
	 	tversky_label, 										"tversky", 							  "AS", "", 	""	  \
		"Two alternative forced choice 1",                  "two_afc_1",                          "CS",  "",    ""    \
		"Two alternative forced choice 2 (ORD)",            "two_afc_2",                          "AS",  "",    ""    \
		"Upholt S",                                         "upholt_s",                           "TS",  "CTS", ""    \
		"Van der Maarel",                                   "van_der_maarel",                     "TS",  "CTS", ""    \
		"Variance dissimilarity", 							"variance_dissimilarity", 			  "CTS", "", 	""	  \
		"Warrens",                                          "warrens",                            "CTS", "",    ""    \
		weighted_kappa_label,                               "weighted_kappa",                     "TS",  "",    ""    \
		"Woodcock",                                         "woodcock",                           "CTS", "",    ""    \
		"Yao-Liu one-way support",                          "yao_liu_one_way_support",            "AS",  "CTS", "TS"  \
		"Yao-Liu two-way support",                          "yao_liu_two_way_support",            "TS",  "CTS", ""    \
		"Yao-Liu two-way support variation",                "yao_liu_two_way_support_v",          "CTS", "",    ""    \
		"Yates chi^2",                                      "yates_chi2",                         "CTS", "",    ""    \
		"Yule phi",                                         "yule_phi",                           "CTS", "",    ""    \
		"Yule Q",                                           "yule_q",                             "CTS", "",    ""	  \
		"Yule Y",                                           "yule_colligation",                   "CTS", "",    ""    \
		"Zhang",                                            "zhang",                              "AS",  "CS",  "TS"  )
	return(all_metrics)

}

function get_metrics_matrix(fbeta_r, goalpha_r, gobeta_r, ibaalpha_r, sokalw_r, gl_theta_r, baulieu_kappa_r, custom_kweights, t_alpha, t_beta, fleiss_holder_p_r, fleiss_lehmer_p_r) {
	// I left the labels here as well just for convenience
	b22_label = "Baulieu 22 (kappa=" + strofreal(round(baulieu_kappa_r, 0.0001)) + ")"
	fbeta_label = "Fb score (beta=" + strofreal(fbeta_r) + ")"

	gen_fleiss_holder_1_label = "Generalized Fleiss (Holder) 1 (p=" + strofreal(round(fleiss_holder_p_r, 0.0001)) + ")"
	gen_fleiss_holder_2_label = "Generalized Fleiss (Holder) 2 (p=" + strofreal(round(fleiss_holder_p_r, 0.0001)) + ")"
	gen_fleiss_holder_3_label = "Generalized Fleiss (Holder) 3 (p=" + strofreal(round(fleiss_holder_p_r, 0.0001)) + ")"
	gen_fleiss_lehmer_1_label = "Generalized Fleiss (Lehmer) 1 (p=" + strofreal(round(fleiss_lehmer_p_r, 0.0001)) + ")"
	gen_fleiss_lehmer_2_label = "Generalized Fleiss (Lehmer) 2 (p=" + strofreal(round(fleiss_lehmer_p_r, 0.0001)) + ")"
	gen_fleiss_lehmer_3_label = "Generalized Fleiss (Lehmer) 3 (p=" + strofreal(round(fleiss_lehmer_p_r, 0.0001)) + ")"

	gl_label = "Gower-Legendre S_theta (theta=" + strofreal(gl_theta_r) + ")"
	gray_orlowska_label = "Gray-Orlowska (alpha=" + strofreal(goalpha_r) + ",beta=" + strofreal(gobeta_r) + ")"
	iba_label = "IBA (alpha=" + strofreal(ibaalpha_r) + ")"
	ss_6_label = "Sokal-Sneath 6 (w=" + strofreal(sokalw_r) + ")"
	tversky_label = "Tversky (alpha=" + strofreal(t_alpha) + ",beta=" + strofreal(t_beta) + ")"
	if (custom_kweights) {
		weighted_kappa_label = "Weighted kappa (custom)"
	}
	else {
		weighted_kappa_label = "Weighted kappa (Id weights)"
	}

	all_metrics = chunk_1(fbeta_r, goalpha_r, gobeta_r, ibaalpha_r, sokalw_r, gl_theta_r, baulieu_kappa_r, custom_kweights, t_alpha, t_beta, fleiss_holder_p_r, fleiss_lehmer_p_r)
	all_metrics = all_metrics \ chunk_2(fbeta_r, goalpha_r, gobeta_r, ibaalpha_r, sokalw_r, gl_theta_r, baulieu_kappa_r, custom_kweights, t_alpha, t_beta, fleiss_holder_p_r, fleiss_lehmer_p_r)
return(all_metrics)
}


end
