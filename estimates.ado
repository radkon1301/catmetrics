version 18.5
mata

function catmetrics(string varlist ,| string AtClasses, string power, string pseudo, string fbeta, string goalpha, string gobeta, string ibaalpha, string sokalw, string gltheta, string bkappa, string talpha, string tbeta, string gfholderp, string gflehmerp, string eceq, string ecem, string gaink, string liftk, string mceq, string mcem, string ealpha, string ibam, string crlambda, string kweights, string metrics, string matrixname, string book, noexcel, string classmetrics, string symmetric) { // KONRAD(20)
	// Stata does weird stuff if defined in-place
	power_r = strtoreal(power)
	pseudo_r = strtoreal(pseudo)
	fbeta_r  = strtoreal(fbeta)
	goalpha_r = strtoreal(goalpha) // KONRAD (20)
	gobeta_r = strtoreal(gobeta) // KONRAD (20)
	ibaalpha_r = strtoreal(ibaalpha) // KONRAD (20)
	sokalw_r = strtoreal(sokalw)
	gl_theta_r = strtoreal(gltheta)
	if (strtoreal(bkappa) == -9999) {
		baulieu_kappa_r = exp(1)
	}
	else {
		baulieu_kappa_r = strtoreal(bkappa)
	}
	if (strtoreal(talpha) == -9999) {
		t_alpha_r = 1/3
	}
	else {
		t_alpha_r = strtoreal(talpha)
	}
	if (strtoreal(tbeta) == -9999) {
		t_beta_r = 1/3
	}
	else {
		t_beta_r = strtoreal(tbeta)
	}
	fleiss_holder_p_r = strtoreal(gfholderp) // this used to be fleissholderp - changed the reference name in the command
	fleiss_lehmer_p_r = strtoreal(gflehmerp) // this used to be fleisslehmerp - changed the reference name in the command
	eceq_r = strtoreal(eceq)
	ecem_r = strtoreal(ecem)
	gaink_r = strtoreal(gaink)
	liftk_r = strtoreal(liftk)
	mceq_r = strtoreal(mceq)
	mcem_r = strtoreal(mcem)
	ealpha_r = strtoreal(ealpha)
	ibam_r = strtoreal(ibam)
	if (strtoreal(crlambda) == -9999) {
		crlambda_r = 2/3
	}
	else {
		crlambda_r = strtoreal(crlambda)
	}
	
	do_excel = (noexcel != "noexcel")
	do_symmetry = 0
	
	if( AtClasses == "Contingency") {
		conf_mat = st_matrix(matrixname)
		// KONRAD (14) v - reject non-square contingency table
		if (rows(conf_mat) != cols(conf_mat)) {
			errprintf("ERROR: The provided contingency table is not square. (%g rows and %g columns)\n",
					  rows(conf_mat), cols(conf_mat))
			exit(1)
		}
		// KONRAD (14) ^

			// check for non-integer entries
		if (any(conf_mat :!= floor(conf_mat))) {
			errprintf("ERROR: Confusion matrix should contain only integer values (data must be in counts, not in frequencies).\n")
			exit(1)
		}
		
		// check for missing entries
		if (missing(conf_mat)) {
			errprintf("ERROR: Missing values in the confusion matrix.\n")
			exit(1)
		}

		comprob = 0
		n = sum(conf_mat)
		ncat = rows(conf_mat)
		ncol = ncat
		allcat = 1::ncat
		varnametrue = "Actual" 
		varnamepredicted = "Predicted"
	}
	else {
		y = st_data(., varlist) // if y, probs(p1 ... pK) provided: 1 column, and if x y then 2 columns - KONRAD
		varnames = (tokens(varlist[`i',1]))'

		colsy = cols(y)

		if(colsy == 1){
			comprob = 1
			varnametrue = varnames + "="
			varnamepredicted = varnames + "="
			
			// KONRAD (9) (suggestion to delete below 2 lines and add them further down)
			// allcat = uniqrows(y)
			// ncat = rows(allcat)
	
			list = tokens(AtClasses)
			X = st_data(., list) // rows are observations 1, 2, ..., n and columns are p1, ..., pK - KONRAD
			// KONRAD (2) v
			to_keep = (rowmissing(X) + rowmissing(y)) :== 0
			initial_length = rows(y) // this is the length of y since it is a column vector
			y = select(y, to_keep) // we just keep the observations with no missing data
			X = select(X, to_keep)
			final_length = rows(y)
			// provide a nice warning message that observations with missing data were removed:
			if (final_length < initial_length) {
				errprintf("WARNING: %g observation(s) with missing data were removed.\n", initial_length - final_length)
				errprintf("(Indices removed:")
				for (i=1; i<=rows(to_keep); i++) {
					if (!to_keep[i]) {
						errprintf(" %g", i)
					}
				}
				errprintf(")\n")
			}
			// KONRAD (2) ^
			
			// KONRAD (9) v
			allcat = uniqrows(y)
			ncat = rows(allcat)
			// KONRAD (9) ^

			if (cols(X) == 1 & ncat == 2) {
				// if allcat[1] is larger: need to swap labels
				if (allcat[1] > allcat[2]) {
					X = (1 :- X[.,1]), X
					tmp = allcat[1]
					allcat[1] = allcat[2]
					allcat[2] = tmp
				}
				// however, if allcat[2] is larger, all good!
				else {
					X = (1 :- X[.,1]), X
				}
				
			}
			rowMax = rowmax(X)
	
			nrow = rows(X)
			ncol = cols(X)
			
			// KONRAD (15) v
			if (ncol != ncat) { // if number of provided probabilities is not equal to the number of categories
				errprintf("ERROR: %g observed categories, but %g probabilities provided.\n", ncat, ncol)
				exit(1)
			}
			// KONRAD (15) ^
	
			prediction = J(nrow, 1, 0)
			for (i=1;i<=nrow;i++) {
				for (j=1;j<=ncol;j++) {
					if (X[i,j] == rowMax[i]) {
						prediction[i] = allcat[j]
					}
				}
			}
			
			// KONRAD (10) v
			if (any(X :< 0) | any(X :> 1)) {
				errprintf("WARNING: At least one provided probability falls outside [0, 1].\n")
			}
			if (any(abs(rowsum(X) :- 1) :> 0.0001)) {
				errprintf("WARNING: Provided probabilities do not sum to 1 for at least one observation.")
			}
			// KONRAD (10) ^'
	
		} 
		else if (colsy == 2) {
	
			comprob = 0
			varnametrue = varnames[1] + "="
			varnamepredicted = varnames[2] + "="
	
			// KONRAD (3) v
			initial_length = rows(y)
			to_keep = rowmissing(y) :== 0
			y = select(y, to_keep) // again, we only keep observations with no missing data
			final_length = rows(y)
			// print a nice warning message if data was removed
			if (final_length < initial_length) {
				errprintf("WARNING: %g observation(s) with missing data were removed.\n", initial_length - final_length)
				errprintf("(Indices removed:")
				for (i=1; i<=rows(to_keep); i++) {
					if (!to_keep[i]) {
						errprintf(" %g", i)
					}
				}
				errprintf(")\n")
			}
			// KONRAD (3) ^
			prediction = y[,2]
			y = y[,1]
		
			allcat = uniqrows(y)
			ncat = rows(allcat)
			
			// KONRAD (13) v - if more predicted than observed categories, then input makes little sense
			if (rows(uniqrows(prediction)) > ncat) {
				errprintf("ERROR: %s (prediction) has %g categories, but %s (observed) has only %g categories.\n", 
						  varnames[2], rows(uniqrows(prediction)), varnames[1], ncat)
				exit(1)
			}
			// KONRAD (13) ^
	
			nrow = rows(y)
			ncol = ncat
	
		} 
		else {
			stata(`"noisily display as err "Too many variables given as input""')
			exit(1)
		}


		// Let's not reverse allcat for binary variables
		/*if (length(allcat) == 2 & allcat[1] == 0 & allcat[2] == 1) {
			// printf("Binary variable detected, reversing categories\n")
			allcat[1] = 1
			allcat[2] = 0
			// XXX v
			// need to swap columns of X in this case for the probability scores!
			if (comprob == 1) {
				X = X[., (2,1)]
			}
			// XXX ^
		}
		else if (length(allcat) == 2) {
			stata(`"noisily display as err "Recode the binary variable:""')
			stata(`"noisily display as err "0 = negative outcome,""')
			stata(`"noisily display as err "1 = positive outcome""')
			exit(1)
		}*/
		
		// KONRAD - this is unused v
		q = J(nrow, ncol, 0)
		for(i=1; i<=ncol; i++) {
			q[.,i] = (y :== allcat[i])
		}
		// ^
		
		conf_mat = J(ncol, ncol, 0)
		for (i=1;i<=nrow;i++) {
			j = prediction[i]
			k = y[i]
			for (l=1;l<=ncol;l++) {
				cat = allcat[l]
				if (cat == j) {
					s = l
				} 
				if (cat == k) {
					t = l
				}
			}
			conf_mat[s,t]=conf_mat[s,t]+1
		}
		n = sum(conf_mat)
		ncat = rows(conf_mat)
	}

	if (ncat == 1) {
		errprintf("ERROR: only one category detected. Provide data with more than one observed category.\n")
		exit(1)
	}
	
	if (n <= 1) {
		errprintf("ERROR: sum of entries in contingency table is less than two. Provide data with at least two observations.\n")
		exit(1)
	}
	
	if (any(colsum(conf_mat) :== 0)) {
		errprintf("WARNING: at least one column of contingency table is zero. Check whether this is intended.\n")
	}
	
	n_kk = sum(diagonal(conf_mat))

	// computation of class specific measures
	n_plus_k = colsum(conf_mat)
	n_k_plus = rowsum(conf_mat)

	n_11 = J(1, ncol, 0)
	n_12 = J(1, ncol, 0)
	n_21 = J(1, ncol, 0)
	n_22 = J(1, ncol, 0)
	n_1_plus = J(1, ncol, 0)
	for (i=1; i<=ncol; i++) {
		n_11[i] = conf_mat[i,i]
		n_12[i] = n_k_plus[i] - conf_mat[i,i]
		n_21[i] = n_plus_k[i] - conf_mat[i,i]
		n_22[i] = n - n_k_plus[i] - n_plus_k[i] + conf_mat[i,i]
	}
	n_1_plus = n_k_plus'
	n_plus_1 = n_plus_k 
	n_2_plus = n :- n_k_plus'
	n_plus_2 = n :- n_plus_k
	
	// XXX v
	// checking if all user-specified parameters are within allowed range
	if (power_r <= 1) {
		errprintf("WARNING: user-specified power beta = %g is outside of allowed range (beta > 1).\n", power_r)
	}
	if (pseudo_r <= 1) {
		errprintf("WARNING: user-specified pseudospherical beta = %g is outside of allowed range (beta > 1).\n", pseudo_r)
	}
	if (fbeta_r < 0) {
		errprintf("WARNING: user-specified fbeta = %g is outside of allowed range (fbeta ≥ 0).\n", fbeta_r)
	}
	if (goalpha_r <= 0) {
		errprintf("WARNING: user-specified Gray-Orlowska alpha = %g is outside of allowed range (alpha > 0).\n", goalpha_r)
	}
	if (gobeta_r <= 0) {
		errprintf("WARNING: user-specified Gray-Orlowska beta = %g is outside of allowed range (beta > 0).\n", gobeta_r)
	}
	if (ibaalpha_r < 0 | ibaalpha_r > 1) {
		errprintf("WARNING: user-specified IBA alpha = %g is outside of allowed range (0 <= alpha <= 1).\n", ibaalpha_r)
	}
	if (sokalw_r <= 0) {
		errprintf("WARNING: user-specified Sokal-Sneath #6 w = %g is outside of allowed range (w > 0).\n", sokalw_r)
	}
	if (gl_theta_r <= 0) {
		errprintf("WARNING: user-specified Gower-Legendre theta = %g is outside of allowed range (theta > 0).\n", gl_theta_r)
	}
	if (baulieu_kappa_r <= 0) {
		errprintf("WARNING: user-specified Baulieu 22 kappa = %g is outside of allowed range (kappa > 0).\n", baulieu_kappa_r)
	}
	// XXX ^
	if (t_alpha_r <= 0) {
		errprintf("WARNING: user-specified Tversy alpha = %g is outside of allowed range (alpha > 0).\n", t_alpha_r)
	}
	if (t_beta_r <= 0) {
		errprintf("WARNING: user-specified Tversky beta = %g is outside of allowed range (beta > 0).\n", t_beta_r)
	}
	if (fleiss_holder_p_r == 0) {
		errprintf("WARNING: user-specified Generalized Fleiss (Holder) p = %g is outside of allowed range (p != 0).\n", fleiss_holder_p_r)
	}
	if (eceq_r <= 0) {
		errprintf("WARNING: user-specified Expected calibration error q = %g is outside of allowed range (q > 0).\n", eceq_r)
	}
	if (ecem_r <= 1 | abs(ecem_r - round(ecem_r)) > 1e-9) {
		errprintf("WARNING: user-specified Expected calibration error M = %g is outside of allowed range (M > 1, must be an integer).\n", ecem_r)
	}
	if (gaink_r <= 0 | gaink_r >= 1) {
		errprintf("WARNING: user-specified Gain at k k = %g is outside of allowed range (0 < k < 1).\n", gaink_r)
	}
	if (liftk_r <= 0 | liftk_r >= 1) {
		errprintf("WARNING: user-specified Lift at k k = %g is outside of allowed range (0 < k < 1).\n", liftk_r)
	}
	if (mceq_r <= 0) {
		errprintf("WARNING: user-specified Maximum calibration error q = %g is outside of allowed range (q > 0).\n", mceq_r)
	}
	if (mcem_r <= 1 | abs(mcem_r - round(mcem_r)) > 1e-9) {
		errprintf("WARNING: user-specified Maximum calibration error M = %g is outside of allowed range (M > 1, must be an integer).\n", mcem_r)
	}
	if (ealpha_r < 0 | ealpha_r > 1) {
		errprintf("WARNING: user-specified Van Rijsbergen effectiveness E-measure alpha = %g is outside of allowed range (0 <= alpha <= 1).\n", ealpha_r)
	}
	if (ibam_r < 1 | ibam_r > 283 | abs(ibam_r - round(ibam_r)) > 1e-9) {
		errprintf("ERROR: user-specified Generalized index of balanced accuracy m = %g is outside of allowed range (1 <= m <= 283, must be an integer referring to index of binary measure).\n", ibam_r)
		exit(1)
	}
	
	// KONRAD (20) This is for measure #203 v
	custom_kweights = 1
	if (kweights == "") {
		custom_kweights = 0
		kweights_mat = 0.5 :* I(ncat) :+ 0.5
	}
	else {
		tol = 1e-8
		kweights_mat = st_matrix(kweights)
		if (rows(kweights_mat) != ncat | cols(kweights_mat) != ncat) {
			errprintf("ERROR: user-specified kappa weighting matrix is not the same dimensions as the contingency table.\n")
			exit(1)
		}
		if (max(abs(kweights_mat :- kweights_mat')) > tol) {
			errprintf("WARNING: user-specified kappa weighting matrix is not symmetric.\n")
		}
		if (max(abs(diagonal(kweights_mat) :- 1)) > tol) {
			errprintf("WARNING: user-specified kappa weighting matrix does not contain constant 1 diagonal.\n")
		}
		if (any(kweights_mat :< -tol :| kweights_mat :> (1 + tol))) {
			errprintf("WARNING: user-specified kappa weighting matrix contains value(s) outside [0, 1].\n")
		}
	}
	// KONRAD (20)' ^
	
	if (strpos(metrics, ",")) {
		errprintf("WARNING: metrics should be listed without commas. For example, use metrics(1 2 3) instead of metrics(1, 2, 3).\n")
	}
	if (metrics != "all" & metrics != "none" & metrics != "ordinal" & regexm(metrics, "[^P[:space:]0-9,-]")) {
		errprintf("WARNING: metrics option should only specify the metric indices to be used or specify 'none', 'all', or 'ordinal', but extraneous characters were found.\n")
	}
	
	// KONRAD (27) v
	// create an object that stores all of the input information -- very clean to call!
	// now to call a metric, we do metric(inp, type)
	struct MetricInputs scalar inp
	inp.conf_mat     = conf_mat
	inp.kweights_mat = kweights_mat
	inp.n_11         = n_11
	inp.n_12         = n_12
	inp.n_21         = n_21
	inp.n_22         = n_22
	inp.n_1_plus     = n_1_plus
	inp.n_plus_1     = n_plus_1
	inp.n_2_plus     = n_2_plus
	inp.n_plus_2     = n_plus_2
	inp.n            = n
	inp.n_kk         = n_kk
	inp.fbeta        = fbeta_r
	inp.goalpha      = goalpha_r
	inp.gobeta       = gobeta_r
	inp.ibaalpha     = ibaalpha_r
	inp.sokal_w      = sokalw_r
	inp.gl_theta     = gl_theta_r
	inp.baulieu_kappa= baulieu_kappa_r
	inp.t_alpha 	 = t_alpha_r
	inp.t_beta 		 = t_beta_r
	inp.fleiss_holder_p = fleiss_holder_p_r
	inp.fleiss_lehmer_p = fleiss_lehmer_p_r
	inp.ealpha       = ealpha_r
	inp.ibam         = ibam_r
	inp.crlambda     = crlambda_r
	inp.custom_kweights = custom_kweights
	// KONRAD (27) ^
	
	// Only compute probability scores if probabilities are given by user (e.g., not when input is a confusion matrix or two variables)
	if (comprob == 1) {
		power_beta  = power_r
		pseudo_beta = pseudo_r

		brier_vec = J(nrow, 1, 0)
		logscore_vec = J(nrow, 1, 0)
		power_vec = J(nrow, 1, 0)
		pseudo_vec = J(nrow, 1, 0)

		//Power score
		for (i=1; i<=nrow; i++) {
			power_vec[i] = power_vec[i] + 1/power_beta
			for (j=1; j<=ncol; j++) {
				if (y[i] == allcat[j]) {
					power_vec[i] = power_vec[i] + (power_beta-1)/power_beta * X[i,j]^power_beta - X[i,j]^(power_beta-1)
				} else {
					power_vec[i] = power_vec[i] + (power_beta-1)/power_beta * X[i,j]^power_beta
				}
			}
		}

		//Pseudospherical score
		for (i=1; i<=nrow; i++) {
			numerator_i = 0
			denominator_i = 0
		for (j=1; j<=ncol; j++) {
				if (y[i] == allcat[j]) {
					numerator_i = numerator_i + X[i,j]^(pseudo_beta-1)
					denominator_i = denominator_i + X[i,j]^pseudo_beta 
				} else {
					denominator_i = denominator_i + X[i,j]^pseudo_beta 
				}
			}
			pseudo_vec[i] = numerator_i/(denominator_i^((pseudo_beta-1)/pseudo_beta))
		}

		spher_sum = 0
		s_sum = 0
		//Brier, log, zero-one and spherical score
		for (i=1; i<=nrow; i++) {
			spher_sum_top = 0
			spher_sum_bot = 0
			prob_max = rowmax(X[i,.])
			m_count = 0
			hit = 0
			for (j=1; j<=ncol; j++) {
				if (y[i] == allcat[j]) {
					brier_vec[i] = brier_vec[i] + (X[i,j]-1)^2
					logscore_vec[i] = logscore_vec[i] + log(X[i,j])
					spher_sum_top = spher_sum_top + X[i,j]
					spher_sum_bot = spher_sum_bot + X[i,j]^2
				} else {
					brier_vec[i] = brier_vec[i] + (X[i,j]-0)^2
					logscore_vec[i] = logscore_vec[i] + log(1 - X[i,j])
					spher_sum_bot = spher_sum_bot + X[i,j]^2
				}
				if (X[i,j] == prob_max) {
					m_count = m_count + 1
					if (y[i] == allcat[j]) {
						hit = hit + 1
					}
				}
			}
			spher_sum = spher_sum + spher_sum_top/sqrt(spher_sum_bot)
			if (hit > 0) {
				s_sum = s_sum + 1/m_count
			}
		}

		// ranked probability score
		rkd = 0
		for (i=1; i<=nrow; i++) {
			rkd_sum = 0
			for (j=1; j<=ncol-1; j++) {
				rkd_prob_sum = 0
				rkd_d_sum = 0
				for (k=1;k<=j;k++) {
					if (y[i] == allcat[k]) {
						rkd_d_sum = rkd_d_sum + 1
					}
					rkd_prob_sum = rkd_prob_sum + X[i,k]
				}
				rkd_sum = rkd_sum + (rkd_prob_sum-rkd_d_sum)^2
			}
			rkd = rkd + rkd_sum
		}

		// XXX v
		// 2AFC #1
		K = ncat

		// --- Step 1: pre-sort, for each category l, the forecast probabilities
		//     of category l among observations whose TRUE category is l. ------
		sorted_l = J(1, K, NULL)      // pointer vector: sorted_l[l] -> sorted col-l values
		n_l_vec  = J(K, 1, .)
		idx_l_all = asarray_create("real")

		for (l = 1; l <= K; l++) {
			idx_l            = select((1::rows(X)), y :== allcat[l])
			asarray(idx_l_all, l, select((1::rows(X)), y :== allcat[l]))
			sorted_l[l]      = &sort(X[idx_l, l], 1)   // ascending sort
			n_l_vec[l]       = rows(idx_l)
		}
		// --- Step 2: main accumulation loop --------------------------------
		num_afc_1 = 0
		den_afc_1 = 0

		for (l = 1; l <= K; l++) {
			B   = *sorted_l[l]        // sorted p_{l,j}(l), j = 1..n_l
			n_l = n_l_vec[l]

			for (k = 1; k <= K; k++) {
				if (k == l) continue

				idx_k = select((1::rows(X)), y :== allcat[k])
				n_k   = rows(idx_k)

				// O(n_k log n_l) instead of O(n_k * n_l)
				for (i = 1; i <= n_k; i++) {
					p_ki_l = X[idx_k[i], l]
					lo = lb(B, p_ki_l)     // # of category-l values strictly <  p_ki_l
					hi = ub(B, p_ki_l)     // # of category-l values <= p_ki_l

					// (n_l - hi)  = # values >  p_ki_l   -> contributes 1 each
					// (hi  - lo)  = # values == p_ki_l    -> contributes 0.5 each
					num_afc_1 = num_afc_1 + (n_l - hi) + 0.5 * (hi - lo)
				}

				den_afc_1 = den_afc_1 + n_plus_1[k] * n_plus_1[l]
			}
		}

		two_afc_1 = num_afc_1 / den_afc_1
		
		// 2AFC #2		
		UT = uppertriangle(J(K, K, 1), 0)   // UT[r,s] = 1 if s>r (strict upper triangle)

		num_afc_2 = 0
		den_afc_2 = 0

		for (k = 1; k <= K-1; k++) {
			idx_k = asarray(idx_l_all, k)
			P_k   = X[idx_k, .]           // n_k x K forecast-probability matrix

			for (l = k+1; l <= K; l++) {
				idx_l = asarray(idx_l_all, l)
				P_l   = X[idx_l, .]       // n_l x K

				Num   = P_k * UT * P_l'   // n_k x n_l : Num[i,j]   = sum_{r<s} p_ki[r]*p_lj[s]
				D     = P_k * P_l'        // n_k x n_l : D[i,j]     = sum_r p_ki[r]*p_lj[r]
				Denom = 1 :- D            // n_k x n_l : Denom[i,j] = 1 - D[i,j]
				F     = Num :/ Denom      // n_k x n_l : missing where Denom[i,j]==0

				contrib = (F :> 0.5) + 0.5 :* (F :== 0.5)

				num_afc_2 = num_afc_2 + sum(contrib)
				den_afc_2 = den_afc_2 + n_plus_1[k] * n_plus_1[l]
			}
		}

		two_afc_2 = num_afc_2 / den_afc_2

		// XXX' ^

		//Macro average mean probability rate MAPR
		mapr_inner = 0
		for (j=1; j<=ncol; j++) {
			class_sum = 0
			for (i=1; i<=nrow; i++) {
				if (y[i] == allcat[j]) {
					class_sum = class_sum + X[i,j]
				}
			}
			if (n_plus_k[j] > 0) {
				mapr_inner = mapr_inner + class_sum / n_plus_k[j]
			}
		}

		//Mean probability rate MPR
		mpr_inner = 0
		for (i=1; i<=nrow; i++) {
			for (j=1; j<=ncol; j++) {
				if (y[i] == allcat[j]) {
					mpr_inner = mpr_inner + X[i,j]
				}
			}
		}
		
		// AUC
		auc = J(1, K, .)
		for (c = 1; c <= K; c++) {
			idx_pos = asarray(idx_l_all, c)
			idx_neg = select((1::rows(X)), y :!= allcat[c])
			// Sort negative-class probabilities once
			neg = sort(X[idx_neg, c], 1)
			num_auc = 0
			for (i = 1; i <= rows(idx_pos); i++) {
				p = X[idx_pos[i], c]
				// # negatives strictly smaller
				less = lb(neg, p)
				// # negatives tied
				ties = ub(neg, p) - less
				num_auc = num_auc + less + 0.5 * ties
			}
			den_auc = rows(idx_pos) * rows(idx_neg)
			auc[c] = num_auc / den_auc
		}
		auc = include_averages(auc, ncat, n, n_plus_1)

		// AUGC
		augc = J(1, K, .)
		for (c = 1; c <= K; c++) {
			order_c = order(-X[, c], 1)
			num_augc = 0
			Sk = 0
			for (k = 1; k <= rows(X); k++) {
				delta = (y[order_c[k]] == allcat[c])
				Sk = Sk + delta
				num_augc = num_augc + (2 * Sk - delta) / n_plus_1[c]
			}
			num_augc = num_augc / (2 * rows(X)) - 0.5
			augc[c] = num_augc / (1 - n_plus_1[c] / (2 * rows(X)) - 0.5)
		}
		augc = include_averages(augc, ncat, n, n_plus_1)
		
		// Average precision
		ap = J(1, K, .)
		n = rows(X)
		for (c = 1; c <= K; c++) {
			order_c = order(-X[, c], 1)
			delta   = (y[order_c] :== allcat[c])
			np      = n_plus_1[c]
			// Cumulative sums S_r = sum_{i=1}^r delta_i1, S_0 = 0
			S = J(n + 1, 1, 0)
			for (r = 1; r <= n; r++) {
				S[r + 1] = S[r] + delta[r]
			}
			sum_term = 0
			for (r = 1; r <= n; r++) {
				// (S_r - S_{r-1}) = delta_r1; multiply by S_r, divide by r
				sum_term = sum_term + (1 / r) * (S[r + 1] - S[r]) * S[r + 1]
			}
			ap[c] = sum_term / np
		}
		ap = include_averages(ap, ncat, n, n_plus_1)

		// Expected Calibration Error
		ece = J(1, K, .)
		n = rows(X)
		for (c = 1; c <= K; c++) {
			delta = (y :== allcat[c])       // delta_i1 (not sorted — bins are on raw prob)
			p     = X[., c]                 // Pr(y_i = 1) for class c
			// Assign each observation to bin m = 1,...,M
			// Bins: [0,1/M), [1/M,2/M), ..., [(M-1)/M, 1]  (last bin closed on right)
			binwidth = 1 / ecem_r
			bin = floor(p :/ binwidth) :+ 1
			bin = editvalue(bin, ecem_r + 1, ecem_r)   // p == 1 falls into last bin, not M+1
			sum_term = 0
			for (m = 1; m <= ecem_r; m++) {
				idx_m = select((1::n), bin :== m)
				nBm = rows(idx_m)
				if (nBm > 0) {
					mean_delta = mean(delta[idx_m])
					mean_prob  = mean(p[idx_m])
					sum_term = sum_term + (nBm / n) * abs(mean_delta - mean_prob)^eceq_r
				}
				// if nBm == 0, contributes 0 to the sum
			}
			ece[c] = sum_term
		}
		ece = include_averages(ece, ncat, n, n_plus_1)

		// Gain at k (top-k recall / capture rate)
		gaink_vals = J(1, K, .)
		n = rows(X)
		for (c = 1; c <= K; c++) {
			order_c = order(-X[, c], 1)
			delta   = (y[order_c] :== allcat[c])
			np      = n_plus_1[c]
			kn = round(gaink_r * n)      // kn need not be an integer in theory; round to nearest obs
			if (kn < 1) kn = 1
			if (kn > n) kn = n
			num = sum(delta[1::kn])
			gaink_vals[c] = num / np
		}
		gaink_vals = include_averages(gaink_vals, ncat, n, n_plus_1)

		// Lift at k
		liftk_vals = J(1, K, .)
		n = rows(X)
		for (c = 1; c <= K; c++) {
			order_c = order(-X[, c], 1)
			delta   = (y[order_c] :== allcat[c])
			np      = n_plus_1[c]
			kn = round(liftk_r * n)
			if (kn < 1) kn = 1
			if (kn > n) kn = n
			num = sum(delta[1::kn])
			liftk_vals[c] = (n / (liftk_r * np)) * num
		}
		liftk_vals = include_averages(liftk_vals, ncat, n, n_plus_1)

		// Maximum Calibration Error (per class)
		mce = J(1, K, .)
		n = rows(X)
		for (c = 1; c <= K; c++) {
			delta = (y :== allcat[c])
			p     = X[., c]
			binwidth = 1 / mcem_r
			bin = floor(p :/ binwidth) :+ 1
			bin = editvalue(bin, mcem_r + 1, mcem_r)   // p == 1 falls into last bin
			max_term = .
			for (m = 1; m <= mcem_r; m++) {
				idx_m = select((1::n), bin :== m)
				nBm = rows(idx_m)
				if (nBm > 0) {
					mean_delta = mean(delta[idx_m])
					mean_prob  = mean(p[idx_m])
					term = abs(mean_delta - mean_prob)^mceq_r
					if (max_term == . | term > max_term) {
						max_term = term
					}
				}
				// empty bins are excluded from the max (undefined, not 0)
			}
			mce[c] = max_term
		}
		mce = include_averages(mce, ncat, n, n_plus_1)
		
		brier_score = sum(brier_vec)/(nrow*2)
		log_score = -sum(logscore_vec)/nrow
		power_score = sum(power_vec)/nrow
		pseudo_score = 1 - sum(pseudo_vec)/nrow
		ranked_probability_score = rkd/(nrow*(ncol-1))		
		spherical_score = 1-spher_sum/nrow
		zero_one_score = s_sum/nrow
		macro_avg_mean_probability_rate = mapr_inner / ncol
		mean_probability_rate = mpr_inner / nrow
	}

	//colstripes = varnametrue :+ strofreal(allcat) 
	//rowstripes = varnamepredicted :+ strofreal(allcat)
	if (ncat == 2) {
		colstripes = ("Positive (" + strofreal(allcat[1]) + ")" \ "Negative (" + strofreal(allcat[2]) + ")")
		rowstripes = ("Positive (" + strofreal(allcat[1]) + ")" \ "Negative (" + strofreal(allcat[2]) + ")")
	}
	else {
		colstripes =  strofreal(allcat)
		rowstripes =  strofreal(allcat)
	}
	if (comprob == 1) {
		rowtitle = "Actual"
		coltitle = "Predicted"
	} else {
		rowtitle = varnametrue
		coltitle = varnamepredicted
	}
	displayas("txt")
	if (AtClasses == "Contingency" | colsy == 2) {
		printf("\n{bf:Contingency Table}\n")
		printf("\n")
	} else {
		printf("\n{bf:Confusion Matrix}\n") 
		printf("\n")
	}

	/*row_sums = rowsum(conf_mat)
	col_sums = colsum(conf_mat)
	colstripes_tot = colstripes \ "row sum"*/
	print_matrix(conf_mat, rowstripes, colstripes, ., ., ., 0, rowtitle, coltitle)
	
	/*colwidths_tot = rowmax((strlen(colstripes_tot) :+ 3, J(rows(colstripes_tot), 1, 6)))
	rowname_width_tot = max((strlen(rowstripes) \ 10 \ strlen(rowtitle) \ strlen(coltitle)))
	displayas("txt")
	printf("{hline %g}{c +}{hline %g}\n", rowname_width_tot+1, sum(colwidths_tot :+ 1) + 2)
	printf("%" + strofreal(rowname_width_tot) + "s {c |} ", "col. sum")
	footer = (col_sums, sum(col_sums))
	for (j=1; j<=rows(colwidths_tot); j++) {
		displayas("res")
		printf("%" + strofreal(colwidths_tot[j]) + ".0f ", footer[j])
	}
	printf("\n")*/

//Only if probabilities were given
	if (comprob == 1) {
		proper_mat = ("Brier score",                      "P1", "[0 " + uchar(8592) + " 1]",  strofreal(brier_score)                \
				"Logarithmic score",                      "P2", "[0 " + uchar(8592) + " " + uchar(8734) + "]", strofreal(log_score) \
		        "Power score (beta=" + strofreal(fbeta_r) + ")", "P3", "[0 " + uchar(8592) + " 1]",  strofreal(power_score)                \
		        "Pseudospherical score (beta=" + strofreal(pseudo_r) + ")", "P4", "[0 " + uchar(8592) + " 1]",  strofreal(pseudo_score)               \
		        "Ranked probability score [ORD]",         "P5", "[0 " + uchar(8592) + " 1]",  strofreal(ranked_probability_score)   \
		        "Spherical score",                        "P6", "[0 " + uchar(8592) + " 1]",  strofreal(spherical_score))

		// Tokens that carry one value PER CATEGORY rather than a single scalar.
		// For these, column 4 of diag_mat stores the per-category values joined
		// into one blank-separated string (via invtokens), which is split back
		// out with tokens() when printing.
		percat_diag = ("P8" \ "P9" \ "P10" \ "P11" \ "P13" \ "P15" \ "P16")

		diag_mat = ("Accuracy rate",                          "P7", "[0 " + uchar(8594) + " 1]",  strofreal(zero_one_score) \
				"Average precision",                       "P8",  "[0 " + uchar(8594) + " 1]",  invtokens(strofreal(ap))              \
				"Expected calibration error (q=" + strofreal(eceq_r) + ",m=" + strofreal(ecem_r) + ")", 
														   "P9", "[0 " + uchar(8592) + " 1]",  invtokens(strofreal(ece))                    \
				"Gain at k (k=" + strofreal(gaink_r) + ")","P10", "[0 " + uchar(8594) + " 1]",  invtokens(strofreal(gaink_vals))             \
				"Lift at k (k=" + strofreal(liftk_r) + ")","P11", "[0 " + uchar(8594) + " " + uchar(8734) + "]",  invtokens(strofreal(liftk_vals)) \
		        "Macro-average mean probability rate",                       "P12", "[0 " + uchar(8594) + " 1]",  strofreal(macro_avg_mean_probability_rate) \
				"Maximum calibration error (q=" + strofreal(mceq_r) + ",m=" + strofreal(mcem_r) + ")",
														   "P13", "[0 " + uchar(8592) + " 1]",  invtokens(strofreal(mce))             \
		        "Mean probability rate",                   "P14", "[0 " + uchar(8594) + " 1]",  strofreal(mean_probability_rate)           \
				"Normalized area under CAP",                    "P15",  "[0 " + uchar(8594) + " 1]",  invtokens(strofreal(augc))                 \
				"Normalized area under ROC",                "P16",  "[0 " + uchar(8594) + " 1]",  invtokens(strofreal(auc))                  \
				"2AFC score #1",         "P17", "[0 " + uchar(8594) + " 1]",  strofreal(two_afc_1)                       \
		        "2AFC score #2 [ORD]",   "P18", "[0 " + uchar(8594) + " 1]",  strofreal(two_afc_2))
		
		all_proper = proper_mat[., 2]
		all_diag = diag_mat[., 2]
		// determine which scores to show
		if (metrics == "all") {
			sel_proper = all_proper
			if (ncat == 2 | classmetrics == "classmetrics") {
				sel_diag = all_diag
			}
			else {
				sel_diag = ("P7" \ "P12" \ "P14" \ "P17" \ "P18")
			}
		}
		else if (metrics == "none") {
			sel_proper = J(0, 1, "")
			sel_diag = J(0, 1, "")
		}
		else if (metrics == "ordinal") {
			sel_proper = ("P5")
			sel_diag = ("P18")
		}
		else if (metrics == "") {
			if (ncat == 2) {
				sel_proper = ("P1" \ "P2" \ "P6")
				sel_diag = ("P7" \ "P8" \ "P12" \ "P14" \ "P15" \ "P16")
			}
			else {
				sel_proper = ("P1" \ "P2" \ "P6")
				sel_diag = ("P12" \ "P14" \ "P17")
			}
		}
		else {
			ptoks = tokens(metrics)' //'
			mask_proper = J(rows(ptoks), 1, 0)
			mask_diag = J(rows(ptoks), 1, 0)
			for (pi = 1; pi <= rows(ptoks); pi++) {
				mask_proper[pi] = anyof(all_proper, ptoks[pi])
				mask_diag[pi] = anyof(all_diag, ptoks[pi])
			}
			sel_proper = select(ptoks, mask_proper)
			sel_diag = select(ptoks, mask_diag)
		}
		sel_ord = 0
		if (rows(sel_proper) > 0){		
			displayas("txt")
			if (metrics != "all") {
				printf("\n{bf:Selected proper scores for probabilistic forecasts}\n")
			}
			else {
				printf("\n{bf:Proper scores for probabilistic forecasts}\n")
			}
			M_score_len = 0
			for (pi = 1; pi <= rows(sel_proper); pi++) {
				idx = selectindex(all_proper :== sel_proper[pi])
				if (rows(idx) == 0) continue
				M_score_len = colmax(M_score_len \ strlen(proper_mat[idx, 1]))
			}
			prob_div_length = M_score_len + 29
			printf("{hline %g}\n", prob_div_length)
			printf("%-" + strofreal(M_score_len) + "s        Range           Value\n", "Score")
			printf("{hline %g}\n", prob_div_length)
			for (pi = 1; pi <= rows(sel_proper); pi++) {
				idx = selectindex(all_proper :== sel_proper[pi])
				if (rows(idx) == 0) continue
				printf("%-2s %-" + strofreal(M_score_len) + "s    %s    {bf:%11.4f}\n", proper_mat[idx,2], proper_mat[idx,1], proper_mat[idx,3], strtoreal(proper_mat[idx,4]))
				if (strpos(proper_mat[idx, 1], "ORD") > 0) {
					sel_ord = 1
				}
			}
			printf("{hline %g}\n", prob_div_length)
			if (sel_ord) {
				printf("ORD: suited for ordinal data only.\n")
			}
		}
		if (rows(sel_diag) > 0){		
			displayas("txt")
			if (metrics != "all") {
				printf("\n{bf:Selected diagnostic measures for probabilistic forecasts}\n")
			}
			else {
				printf("\n{bf:Diagnostic measures for probabilistic forecasts}\n")
			}
			has_percat = 0
			for (i = 1; i <= rows(sel_diag); i++) {
				if (sum(percat_diag :== sel_diag[i])) {
					has_percat = 1
					break
				}
			}
			if (ncat == 2 & classmetrics != "classmetrics") {
				has_percat = 0
			}
			M_score_len = 0
			for (pi = 1; pi <= rows(sel_diag); pi++) {
				idx = selectindex(all_diag :== sel_diag[pi])
				if (rows(idx) == 0) continue
				M_score_len = colmax(M_score_len \ strlen(diag_mat[idx, 1]))
			}
			if (has_percat) {
				if (ncat == 2) {
					prob_div_length = M_score_len + 47 + 10 * ncat
				}
				else {
					prob_div_length = M_score_len + 45 + 9 * ncat
				}
				printf("{hline %g}\n", prob_div_length)
				printf("%-" + strofreal(M_score_len) + "s         Range        Value", "Score")
				if (ncat == 2) {
					printf("%10s", "Postv")
					printf("%10s", "Negtv")
					printf("     Macro     Wgted\n")
					printf("%" + strofreal(M_score_len + 27) + "s", "")
					printf("%10s", "(" + strofreal(allcat[1]) + ")")
					printf("%10s", "(" + strofreal(allcat[2]) + ")")
					printf("     averg     averg")
				}
				else {
					for (i=1; i<=ncat; i++) {
						printf("%9s", "Class")
					}
					printf("    Macro    Wgted\n")
					printf("%" + strofreal(M_score_len + 27) + "s", "")
					for (i=1; i<=ncat; i++) {
						printf("%9s", "(" + strofreal(allcat[i]) + ")")
					}
					printf("    averg    averg")
				}
				printf("\n")
			}
			else {
				prob_div_length = M_score_len + 27
				printf("{hline %g}\n", prob_div_length)
				printf("%-" + strofreal(M_score_len) + "s         Range        Value\n", "Score")
			}
			printf("{hline %g}\n", prob_div_length)
			sel_ord = 0
			digs = 4
			if (has_percat & ncat > 2) {
				digs = 3
			}
			for (pi = 1; pi <= rows(sel_diag); pi++) {
				idx = selectindex(all_diag :== sel_diag[pi])
				if (rows(idx) == 0) continue
				if (strpos(diag_mat[idx, 1], "ORD") > 0) {
					sel_ord = 1
				}
				is_percat = anyof(percat_diag, diag_mat[idx,2])
				if (is_percat) {
					catvals = strtoreal(tokens(diag_mat[idx,4]))
					if (ncat == 2 & classmetrics != "classmetrics") {
						value_of_bin = 1
					}
					else {
						value_of_bin = 0
					}
					if (ncat > 2) {
						printf("%-3s %-" + strofreal(M_score_len) + "s    %s     {bf:%7s}", diag_mat[idx,2], diag_mat[idx,1], diag_mat[idx,3], "")
					}
					else {
						if (value_of_bin) {
							if (sel_diag[pi] == "P11") {
								printf("%-3s %-" + strofreal(M_score_len) + "s    %s     {bf:%7.1f}", diag_mat[idx,2], diag_mat[idx,1], diag_mat[idx,3], catvals[1])
							}
							else {
								printf("%-3s %-" + strofreal(M_score_len) + "s    %s     {bf:%7.4f}", diag_mat[idx,2], diag_mat[idx,1], diag_mat[idx,3], catvals[1])
							}
						}
						else {
							if (sel_diag[pi] == "P11") {
								printf("%-3s %-" + strofreal(M_score_len) + "s    %s     %7s", diag_mat[idx,2], diag_mat[idx,1], diag_mat[idx,3], "")
							}
							else {
								printf("%-3s %-" + strofreal(M_score_len) + "s    %s     %7s", diag_mat[idx,2], diag_mat[idx,1], diag_mat[idx,3], "")
							}
						}
					}
					if (has_percat) {
						for (i = 1; i <= cols(catvals); i++) {
							if (ncat == 2) {
								width = 9
								if (sel_diag[pi] == "P11") {
									printf(" {bf:%" + strofreal(width) + ".1f}", catvals[i])
								}
								else {
									printf(" {bf:%" + strofreal(width) + "." + strofreal(digs) + "f}", catvals[i])
								}
							}
							else {
								width = 8
								if (sel_diag[pi] == "P11") {
									printf(" {bf:%" + strofreal(width) + ".1f}", catvals[i])
								}
								else {
									printf(" {bf:%" + strofreal(width) + "." + strofreal(digs) + "f}", catvals[i])
								}
							}
							
						}
					}
					printf("\n")
				}
				else if (!is_percat) {
					printf("%-3s %-" + strofreal(M_score_len) + "s    %s     {bf:%7." + strofreal(digs) + "f}", diag_mat[idx,2], diag_mat[idx,1], diag_mat[idx,3], strtoreal(diag_mat[idx,4]))
					/*if (has_percat) {
						for (i = 1; i <= ncat + 2; i++) {
							printf("         ")
						}
					}*/
					printf("\n")
				}
			}
			printf("{hline %g}\n", prob_div_length)
			if (sel_ord) {
				printf("ORD: suited for ordinal data only.\n")
			}
		}
	}

	// Strip p-tokens from metrics before association parsing
	if (metrics != "" & metrics != "all" & metrics != "none" & metrics != "ordinal") {
		_atoks = tokens(metrics)'
		_mask = J(rows(_atoks), 1, 0)
		for (_i = 1; _i <= rows(_atoks); _i++) _mask[_i] = anyof(all_pids, _atoks[_i])
		_atoks = select(_atoks, !_mask)
		metrics_assoc = invtokens(_atoks')
	}
	else {
		metrics_assoc = metrics
	}

	// Handle default association metrics
	if (metrics_assoc == "" | rows(tokens(metrics_assoc)') == 0) {
		// show association defaults'
		if (ncat == 2) {
			metrics_tokens_num = (1, 2, 9, 42, 64, 65, 119, 120, 125, 132, 134, 146, 148, 163, 205,
212, 234, 241, 256, 280, 281, 282)
			metrics_tokens = strofreal(metrics_tokens_num)
		}
		else {
			metrics_tokens_num = (1, 9, 42, 44, 52, 132, 134, 138, 163, 205,
234, 241, 256, 260)
			metrics_tokens = strofreal(metrics_tokens_num)
		}
		
	}
	else if (metrics == "ordinal") {
		metrics_tokens_num = (118, 131, 156, 157, 162, 180, 209, 245, 252, 258, 268)
		metrics_tokens = strofreal(metrics_tokens_num)
	}
	else {
		metrics_tokens = tokens(metrics_assoc)
	}
	
	// Matrix containing label, function name, and symmetry type'	
	// all_metrics = get_metrics_matrix(fbeta_r, goalpha_r, gobeta_r, ibaalpha_r, sokalw_r, gl_theta_r, baulieu_kappa_r, custom_kweights)
	
	// In order to use this, modify the "get_metrics_matrix" function in helpfunctest.ado
	all_metrics = get_metrics_matrix(inp)

	inp.ibam_f = findexternal(all_metrics[ibam_r,2] + "()")
	inp.ibam_type = all_metrics[ibam_r, 3]
	if (inp.ibam_f == NULL) {
		errprintf("%-s not found for the Generalized index of balanced accuracy.\n", all_metrics[ibam_r,2] + "()")
		return
	}
	
	// col 1 = label, col 2 = funname, cols 3, 4, 5 = types. FOR NOW, we will only print the original symmetry versions
	selected = J(0, 5, "")
	if (metrics_assoc != "all" & metrics_assoc != "none") {
		sel_idx = 1
		for (i = 1; i <= cols(metrics_tokens); i++) {
			token = metrics_tokens[i]
			num = strtoreal(token)
			if (!missing(num)) {
				idx = trunc(num)
				if (idx < 1 | idx > rows(all_metrics)) {
					errprintf("WARNING: metric index %g out of range, skipping.\n", num)
					continue
				}
				selected = selected \ all_metrics[idx, .]
				selected[sel_idx,1] = strofreal(idx) + ". " + selected[sel_idx,1]
				sel_idx = sel_idx + 1
			} else {
				row_idx = selectindex(all_metrics[., 2] :== token)
				if (rows(row_idx) == 0) {
					//errprintf("WARNING: '%s' not found, skipping.\n", token)
					continue
				}
				selected = selected \ all_metrics[row_idx, .]
				selected[sel_idx,1] = strofreal(row_idx) + ". " + selected[sel_idx,1]
				sel_idx = sel_idx + 1
			}
		}
	}
	else if (metrics_assoc == "all") {
		selected = all_metrics
		for (row=1; row<=rows(selected); row++) {
			selected[row,1] = strofreal(row) + ". " + selected[row,1] // adds index number to name
		}
	}

	if (classmetrics == "classmetrics") {
		digs = 3
	}
	else {
		digs = 4
	}
	printable_metrics_init = get_printable_metrics(selected, inp, ncat, do_symmetry, 2)
	need_value_col = any(printable_metrics_init[,2] :!= "")
	need_cat_col = any(printable_metrics_init[,3..(cols(printable_metrics_init) - 1)] :!= "") & (!(ncat == 2 & classmetrics != "classmetrics")) & (!(ncat > 2 & metrics == "all" & classmetrics != "classmetrics"))
	
	printing_class_metrics = (classmetrics == "classmetrics") | (metrics != "none" & metrics != "" & need_cat_col)
	if (need_cat_col & ncat > 2) {
		printable_metrics = get_printable_metrics(selected, inp, ncat, do_symmetry, 3)
	}
	else {
		printable_metrics = get_printable_metrics(selected, inp, ncat, do_symmetry, 4)
	}
	name_len = max(strlen(selected[,1])) + 6 * do_symmetry // determine width of metric name column
	range_len = max(udstrlen(printable_metrics[,1])) + 1 // determine width of range column
	value_len = colmax(max(strlen(printable_metrics[,2])) \ 5) + 2
	class_len = colmax(max(strlen(printable_metrics[,3..(ncat+2)])) \ 7) + 2
	macro_len = colmax(max(strlen(printable_metrics[,ncat+3])) \ 9) + 2
	weigh_len = colmax(max(strlen(printable_metrics[,ncat+4])) \ 12) + 2

	displayas("txt")
	
	//for loop option for now, it is easier to code and preserves the order
	if (ncat == 2) {
		if (!(need_cat_col & printing_class_metrics)) {
			div_length = name_len + 2 + range_len + value_len * need_value_col + need_cat_col * printing_class_metrics * 53 + sum(strlen(strofreal(allcat)))
		}
		else {
			div_length = name_len + 2 + range_len + value_len * need_value_col + need_cat_col * printing_class_metrics * 40
		}
	}
	else {
		if (!(need_cat_col & printing_class_metrics)) {
			div_length = name_len + 2 + range_len + value_len * need_value_col + (class_len * ncat + macro_len + weigh_len) * need_cat_col * (printing_class_metrics) + 2
		}
		else {
			div_length = name_len + range_len + value_len * need_value_col + (class_len * ncat + macro_len + weigh_len) * need_cat_col * (printing_class_metrics) - 1
		}
	}
	if (rows(selected) > 0){
		if (metrics != "all") {
			printf("\n{bf:Selected measures of association & hard forecast evaluation}\n")
		}
		else {
			printf("\n{bf:Measures of association & hard forecast evaluation}\n")
		}
		printf("{hline %g}\n", div_length)
		printf("%-" + strofreal(name_len) + "s  %" + strofreal(range_len) + "s  ", "Measure", "Range")
		if (need_value_col) {
			printf("%" + strofreal(value_len) + "s", "Value")
		}
		if (need_cat_col & printing_class_metrics) {
			if (ncat == 2) {
				printf("%9s", "Postv")
				printf("%9s", "Negtv")
				printf("%" + strofreal(macro_len - 1) + "s", "Macro")
				printf("%" + strofreal(weigh_len - 4) + "s\n", "Wgted")
				printf("%" + strofreal(name_len + 1) + "s ", "")
				printf("%" + strofreal(range_len + 1) + "s ", "")
				printf("%" + strofreal(value_len * need_value_col) + "s", "")
				//printf("%" + strofreal(name_len + 2 + range_len + value_len * need_value_col) + "s", "")
				printf("%9s", "(" + strofreal(allcat[1]) + ")")
				printf("%9s", "(" + strofreal(allcat[2]) + ")")
				printf("%" + strofreal(macro_len - 1) + "s", "averg")
				printf("%" + strofreal(weigh_len - 4) + "s", "averg")
			}
			else {
				for (k = 1; k <= ncat; k++) {
					printf("%" + strofreal(class_len) + "s", "Class")
				}
				printf("%" + strofreal(macro_len-1) + "s%" + strofreal(weigh_len-4) + "s", "Macro", "Wgted")
				printf("\n%" + strofreal(4 + name_len + range_len + value_len * need_value_col) + "s", "")
				for (k = 1; k <= ncat; k++) {
					printf("%" + strofreal(class_len) + "s", "(" + strofreal(allcat[k]) + ")")
				}
				printf("%" + strofreal(macro_len-1) + "s%" + strofreal(weigh_len-4) + "s", "averg", "averg")
			}
		}
		printf("\n{hline %g}\n", div_length)
		bool_ord = 0
		bool_cl = 0
		bool_au = 0
		bool_con = 0
		bool_uni = 0
		for (i = 1; i <= rows(printable_metrics); i++) {
			if (!(metrics == "all" & ncat > 2 & classmetrics != "classmetrics" & any(printable_metrics[i,3..(2+ncat)] :!= ""))) {
				if (strpos(printable_metrics[i, 5+ncat], "ORD") > 0) {
					bool_ord = 1
				}
				if (strpos(printable_metrics[i, 1], "cl") > 0) {
					bool_cl = 1
				}
				if (strpos(printable_metrics[i, 1], "au") > 0) {
					bool_au = 1
				}
				if (strpos(printable_metrics[i, 1], "con") > 0) {
					bool_con = 1
				}
				if (strpos(printable_metrics[i, 1], "uni") > 0) {
					bool_uni = 1
				}
				printf("%-" + strofreal(name_len) + "s  ", printable_metrics[i, 5+ncat]) // metric name
				printf("%" + strofreal(range_len) + "us  ", printable_metrics[i,1]) // range
				if (need_value_col) {
					if (!(ncat == 2 & classmetrics == "classmetrics" & any(printable_metrics[i,3..(2+ncat)] :!= ""))) {
						printf("{bf:%" + strofreal(value_len) + "s}", printable_metrics[i,2])
					}
					else {
						printf("%" + strofreal(value_len) + "s", "")
					}
				}
				if (need_cat_col & printing_class_metrics) {
					if (ncat == 2) {
						printf("{bf:%9s}", printable_metrics[i,3])
						printf("{bf:%9s}", printable_metrics[i,4])
						printf("{bf:%" + strofreal(macro_len-1) + "s}", printable_metrics[i,ncat+3])
						printf("{bf:%" + strofreal(weigh_len-4) + "s}", printable_metrics[i,ncat+4])
					}
					else {
						for (j=3; j<3+ncat; j++) {
							printf("{bf:%" + strofreal(class_len) + "s}", printable_metrics[i,j])
						}
						printf("{bf:%" + strofreal(macro_len-1) + "s}", printable_metrics[i,ncat+3])
						printf("{bf:%" + strofreal(weigh_len-4) + "s}", printable_metrics[i,ncat+4])
					}
				}
				printf("\n")
			}
		}
		printf("{hline %g}\n", div_length)
		footnote_ord = ""
		footnote_rest = ""
		if (bool_ord) {
			footnote_ord = "ORD: suited for ordinal data only"
		}
		if (bool_cl) {
			footnote_rest = footnote_rest + "cl: conservative lower bound"
		}
		if (bool_au) {
			if (footnote_rest != "") {
				footnote_rest = footnote_rest + "; "
			}
			footnote_rest = footnote_rest + "au: approximate upper bound"
		}
		if (bool_con) {
			if (footnote_rest != "") {
				footnote_rest = footnote_rest + "; "
			}
			footnote_rest = footnote_rest + "con: concentrated"
		}
		if (bool_uni) {
			if (footnote_rest != "") {
				footnote_rest = footnote_rest + "; "
			}
			footnote_rest = footnote_rest + "uni: uniform"
		}
		if (footnote_ord != "") {
			printf("%s\n", footnote_ord)
		}
		if (footnote_rest != "") {
			printf("%s\n", footnote_rest)
		}
		//printf("ORD: suited for ordinal data only; cl: conservative lower bound; au: approximate upper bound; con: concentrated; uni: uniform \n")
	}
	
	if (do_excel) {
		class xl scalar excel
		excel = xl()
		excel.load_book(book)
		excel.set_mode("open")
		
		fmtid_num = excel.add_fmtid()
		excel.fmtid_set_number_format(fmtid_num, "#.0000;-#.0000")
		fmtid_txt = excel.add_fmtid()
		excel.fmtid_set_horizontal_align(fmtid_txt, "right")
		fontid_bold = excel.add_fontid()
		excel.fontid_set_font_bold(fontid_bold, "on")
		fmtid_bold = excel.add_fmtid()
		excel.fmtid_set_fontid(fmtid_bold, fontid_bold)
		
		// XXX v
		//First Sheet
		K = cols(conf_mat)

		excel.set_sheet("Probabilistic scores")
		excel.clear_sheet("Probabilistic scores")

		// ---------------- Table 1: proper scores ----------------
		row = 1
		excel.put_string(row, 1, "No.")
		excel.put_string(row, 2, "Score name")
		excel.put_string(row, 3, "Range")
		excel.put_string(row, 4, "Value")
		row = row + 1
		excel.put_string(row, 2, "Strictly proper scoring rules")

		row = row + 1

		for (i = 1; i <= rows(proper_mat); i++) {
			excel.put_string(row, 1, proper_mat[i, 2])
			excel.put_string(row, 2, proper_mat[i, 1])
			excel.put_string(row, 3, proper_mat[i, 3])
			excel.put_number(row, 4, strtoreal(proper_mat[i, 4]))
			row = row + 1
		}

		// ---------------- Table 2: diagnostic measures ----------------
		excel.set_sheet_merge("Probabilistic scores", (row,row), (5,6+ncat))
		excel.put_string(row, 5, "Class-specific values")
		row = row + 1

		excel.put_string(row, 2, "Diagnostic scores")
		for (c = 1; c <= K; c++) {
			excel.put_string(row, 4 + c, "Class " + strofreal(allcat[c]))
		}
		excel.put_string(row, 5 + ncat, "Macro avg")
		excel.put_string(row, 6 + ncat, "Weighted avg")
		row = row + 1

		for (i = 1; i <= rows(diag_mat); i++) {
			tok = diag_mat[i, 2]
			excel.put_string(row, 1, tok)
			excel.put_string(row, 2, diag_mat[i, 1])
			excel.put_string(row, 3, diag_mat[i, 3])

			if (anyof(percat_diag, tok)) {
				vals = strtoreal(tokens(diag_mat[i, 4]))
				for (c = 1; c <= cols(vals); c++) {
					excel.put_number(row, 4 + c, vals[c])
				}
				// disable copying to value column:
				/*if (ncat == 2) {
					excel.put_number(row, 4, vals[1])
				}*/
			}
			else {
				excel.put_number(row, 4, strtoreal(diag_mat[i, 4]))
			}
			row = row + 1
		}
		excel.set_sheet_merge("Probabilistic scores", (row,row), (2,4))
		excel.put_string(row, 2, "ORD: suited for ordinal data only.")
		
		// only do formatting if there is actual data
		if (comprob == 1) {
			excel.set_fmtid((3, 8), (4, 4), fmtid_num)
			excel.set_fmtid((11,22), (4, 6+ncat), fmtid_num)
			excel.set_fmtid((1,1), (1,4), fmtid_bold)
			excel.set_fmtid(2, 2, fmtid_bold)
			excel.set_fmtid(9, 5, fmtid_bold)
			excel.set_fmtid(10, 2, fmtid_bold)
			excel.set_fmtid((10,10), (5,6+ncat), fmtid_bold)
		}
		// XXX ^

		//Second Sheet
		excel.set_sheet("Association measures")
		excel.clear_sheet("Association measures")
		excel.set_sheet_merge("Association measures", (1,1), (5,6+ncol))
		
		//excel.set_font_bold((1,2), (2,6+ncol), "on")

		excel.put_string(2, 2, "Coefficient name")
		// excel.put_string(2, 3, "Symmetry")
		excel.put_string(2, 3, "Range")
		excel.put_string(1, 5, "Class-specific values")

		excel.put_string(2, 1, "No.")
		excel.put_string(2, 4, "Value")
		excel.put_string(2, 5 + ncol, "Macro average")
		excel.put_string(2, 6 + ncol, "Weighted average")
		
		// KONRAD
		for (i=1; i<=ncol; i++){
			excel.put_string(2, 4+i, "Class " + strofreal(allcat[i]))
		}
		
		// We will use automatic row numbers to simplify copy pasting
		row_number = 2
		score_number = 0

		// Look how nicely this can be done now:
		current_row = row_number
		if (do_symmetry) {
			for (i=1; i<=rows(all_metrics); i++) {
				for (l=1; l<=3; l++) {
					sym_type = all_metrics[i, 2+l]
					if (sym_type == "") continue
					current_row = current_row + 1
					name = all_metrics[i,1]
					value = add_to_excel(excel, current_row, score_number + i, name, all_metrics[i,2], inp, sym_type, fmtid_num, fmtid_txt)
				}
			}
		}
		else {
			for (i=1; i<=rows(all_metrics); i++) {
				current_row = current_row + 1
				value = add_to_excel(excel, current_row, score_number + i, all_metrics[i,1], all_metrics[i,2], inp, all_metrics[i,3], fmtid_num, fmtid_txt)
			}
		}
		
		excel.set_fmtid(1, 5, fmtid_bold)
		excel.set_fmtid((2, 2), (1, 6+ncat), fmtid_bold)
		
		current_row = current_row + 1
		excel.set_sheet_merge("Association measures", (current_row,current_row), (2,6+ncol))
		//excel.set_font_bold(current_row, 2, "on")
		excel.put_string(current_row, 2, "ORD: suited for ordinal data only; cl: conservative lower bound; au: approximate upper bound.")
		
		//Closing Excel
		excel.close_book()
		// let user know where to find full output
		displayas("txt")
		printf("\n{bf:See the Excel file '%s' for the complete output.}\n", book)
	}
}

end
