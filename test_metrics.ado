version 18.5
mata

// struct that contains all inputs used across all metrics
struct MetricInputs {
	real matrix conf_mat, kweights_mat
	real rowvector n_11, n_12, n_21, n_22, n_1_plus, n_plus_1, n_2_plus, n_plus_2
	real scalar n, n_kk, fbeta, goalpha, gobeta, ibaalpha, sokal_w, gl_theta, baulieu_kappa, t_alpha, t_beta, fleiss_holder_p, fleiss_lehmer_p, ealpha, ibam, ibam_type, crlambda, custom_kweights
	pointer(function) scalar ibam_f
}

//#1
function accuracy(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = inp.n_kk / inp.n
	}
    return(value)
}

//#2
function added_value(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = (inp.n_11 :/ inp.n_1_plus) :- (inp.n_plus_1 :/ inp.n)
    }
    else if(type == "CTS") {
    	value = (inp.n_11 :+ inp.n_22):/inp.n :- 1/2
    }
    else if(type == "TS") {
    	value = (2 :* inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1)) :- (inp.n_1_plus :+ inp.n_plus_1) :/ 2*inp.n
    }
    return(value)
}

//3
function adjusted_noise_to_signal(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = (inp.n_12 :* inp.n_plus_1) :/ (inp.n_plus_2 :* inp.n_11)
    }
    else if(type == "CS") {
    	value = (inp.n_12 :* inp.n_plus_1 :+ inp.n_21 :* inp.n_plus_2) :/ (inp.n_plus_2:*inp.n_11 :+ inp.n_plus_1 :*inp.n_plus_2)
    }
    else if(type == "TS") {
    	value = (inp.n_12 :* inp.n_plus_1 :+ inp.n_21:*inp.n_1_plus) :/ ((inp.n_plus_2 :+ inp.n_2_plus) :* inp.n_11)
    }
    return(value)
}

//4
function alroy_corrected_forbes_F(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = (inp.n_11 :* (inp.n :+ sqrt(inp.n))) :/ (inp.n_11 :* (inp.n :+ sqrt(inp.n)):+ 3/2 :* inp.n_12 :* inp.n_21)
    }
    else if(type == "CTS") {
    	value = ((inp.n_11 :+ inp.n_22):*(inp.n :+ sqrt(inp.n))):/((inp.n_11 :+ inp.n_22):*(inp.n :+ sqrt(inp.n)):+3:*inp.n_12:*inp.n_21)
    }
    return(value)
}

//5
function ample(struct MetricInputs scalar inp, type) { 
    if(type == "CS") {
    	value = abs(inp.n_11:/inp.n_1_plus :- inp.n_21 :/inp.n_2_plus)
    }
    else if(type == "CTS") {
    	value = abs(2:*inp.n_11:/(inp.n_1_plus :+ inp.n_plus_1) :- (inp.n_12 :+ inp.n_21):/(inp.n_2_plus :+ inp.n_plus_2))
    }
    return(value)
}

//6
function anderberg(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = 8:*inp.n_11:/(8:*inp.n_11:+inp.n_12:+inp.n_21)
    }
    else if(type == "CTS") {
    	value = 4:*(inp.n_11 :+ inp.n_22):/(4:*(inp.n_11:+inp.n_22):+inp.n_12:+inp.n_21)
    }
    return(value)
}

//7
function anderberg_D(struct MetricInputs scalar inp, type) { 
    if(type == "CTS") {
    	value = 1/(2*inp.n):*(colmax(inp.n_11\inp.n_12):+colmax(inp.n_21\inp.n_22):+colmax(inp.n_11\inp.n_21):+colmax(inp.n_12\inp.n_22):-colmax(inp.n_plus_1\inp.n_plus_2):-colmax(inp.n_1_plus\inp.n_2_plus))
    }
    return(value)
}

//8 - Dragos 
function appleman(struct MetricInputs scalar inp, type) {    
    if(type == "CS") {        
        value = J(1, cols(inp.n_11), .)
        for (i=1; i<=cols(inp.n_11); i++) {
        if(inp.n_11[i]+inp.n_21[i] > inp.n_12[i]+inp.n_22[i]){
            value[i] =  (inp.n_22[i]-inp.n_21[i])/
                        (inp.n_12[i]+inp.n_22[i])         
        }
        else{
            value[i] =  (inp.n_11[i]-inp.n_12[i])/
                        (inp.n_21[i]+inp.n_11[i])
            } 
        }
    }
    else if(type == "CTS"){
        value = J(1, cols(inp.n_11), .)
        for (i=1; i<=cols(inp.n_11); i++) {
        if(inp.n_11[i]+inp.n_21[i] > inp.n_12[i]+inp.n_22[i]){
            value[i] =  (2*inp.n_22[i] - inp.n_12[i] - inp.n_21[i]) / 
                        (2*inp.n_22[i] + inp.n_12[i] + inp.n_21[i])      
        }
        else{
            value[i] =  (2*inp.n_11[i] - inp.n_12[i] - inp.n_21[i]) / 
                        (2*inp.n_11[i] + inp.n_12[i] + inp.n_21[i])
            } 
        }        
    }
    return(value)
}

//9 (KONRAD)
function atkinson(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 1 - prod(inp.conf_mat :/ inp.n :* rows(inp.conf_mat)^2)^(1/rows(inp.conf_mat)^2)
	}
	return(value)
}

//10 - Dragos
function goodall(struct MetricInputs scalar inp, type){
    if(type == "CTS"){
        value = 2 / pi() * asin(sqrt(sum(inp.n_11) / inp.n))
    }
    return(value)
}

//11 (KONRAD)
function balanced_accuracy(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = 1/cols(inp.n_11) * sum(inp.n_11 :/ inp.n_plus_1)
	}
	else if (type == "CTS") {
		value = 2/cols(inp.n_11) * sum(inp.n_11 :/ (inp.n_plus_1 :+ inp.n_1_plus))
	}
	return(value)
}

//12
function baroni_urbani_buser_one(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = (sqrt(inp.n_11:*inp.n_22):+inp.n_11):/(sqrt(inp.n_11:*inp.n_22):+inp.n_11:+inp.n_12:+inp.n_21)
    }
    else if(type == "CTS") {
    	value = (sqrt(inp.n_11:*inp.n_22):+1/2:*(inp.n_11:+inp.n_22)):/(sqrt(inp.n_11:*inp.n_22):+inp.n_12:+inp.n_21:+1/2:*(inp.n_11:+inp.n_22))
    }
    return(value)
}

//13
function baroni_urbani_buser_two(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = (sqrt(inp.n_11:*inp.n_22):+inp.n_11:-inp.n_12:-inp.n_21):/(sqrt(inp.n_11:*inp.n_22):+inp.n_11:+inp.n_12:+inp.n_21)
    }
    else if(type == "CTS") {
    	value = (sqrt(inp.n_11:*inp.n_22):+1/2:*(inp.n_11:+inp.n_22):-inp.n_12:-inp.n_21):/(sqrt(inp.n_11:*inp.n_22):+inp.n_12:+inp.n_21:+1/2:*(inp.n_11:+inp.n_22))
    }
    return(value)
}

//14
function base_rate(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = inp.n_plus_1:/inp.n
    }
    else if(type == "CS") {
    	value = 1/2
    }
    else if(type == "TS") {
    	value = (inp.n_plus_1:+inp.n_1_plus):/(2:*inp.n)
    }
    return(value)
}

//19
function benini_1(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = (inp.n_11:*inp.n_22:-inp.n_12:*inp.n_21):/(inp.n_11:+colmin(inp.n_12\inp.n_21):-inp.n_1_plus:*inp.n_plus_1)
    }
    else if(type == "CTS") {
    	value = 2*(inp.n_11:*inp.n_22:-inp.n_12:*inp.n_21):/(inp.n_11:+inp.n_22:+2*colmin(inp.n_12\inp.n_21):-inp.n_1_plus:*inp.n_plus_1-inp.n_2_plus:*inp.n_plus_2)
    }
    return(value)
}

// KONRAD (23) v
//20
function benini_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n * sum(inp.n_11) - sum(inp.n_1_plus :* inp.n_plus_1)) / (inp.n * sum(colmin(inp.n_1_plus \ inp.n_plus_1)) - sum(inp.n_1_plus :* inp.n_plus_1))
	}
	return(value)
}
// KONRAD (23) ^

//#34
function benini_3(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
    	value = ((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21)) :/ (inp.n_1_plus :* inp.n_plus_2)
    }
    else if(type == "CTS") {
    	value = (2 :* ((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21))) :/ ((inp.n_1_plus :* inp.n_plus_2) :+ (inp.n_plus_1 :* inp.n_2_plus))
    }
    return(value)
}

//#35
function benini_4(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
    	value = ((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21)) :/ (inp.n_plus_1 :* inp.n_2_plus)
    }
    else if(type == "CTS") {
    	value = (2 :* ((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21))) :/ ((inp.n_plus_1 :* inp.n_2_plus) :+ (inp.n_1_plus :* inp.n_plus_2))
    }
    return(value)
}

//21 (KONRAD)
function bennett(struct MetricInputs scalar inp, type) {
	if (type=="CTS") {
		value = (cols(inp.n_11) * sum(inp.n_11) - inp.n) / ((cols(inp.n_11) - 1) * inp.n)
	}
	return(value)
}

//22 - Dragos
function berger_parker(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = max(vec(inp.conf_mat)) / inp.n
    }
    return(value)
}

//23
function bias(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = inp.n_1_plus:/inp.n_plus_1
    }
    else if(type == "CS") {
    	value = 1
    }
    else if(type == "TS") {
    	value = 1
    }
    return(value)
}

//24
function blaheta_johnson(struct MetricInputs scalar inp, type) { 
    if(type == "CTS") {
    	value = log((inp.n_11:*inp.n_22):/(inp.n_12:*inp.n_21)):-3.29:*sqrt(1:/inp.n_11 :+ 1:/inp.n_12 :+ 1:/inp.n_21 :+ 1:/inp.n_22)
    }
    return(value)
}

//25
function braun_blanquet(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = inp.n_11:/(inp.n_11:+colmax(inp.n_12\inp.n_21))
    }
    else if(type == "CTS") {
    	value = (inp.n_11:+inp.n_22):/(inp.n_11:+inp.n_22:+2*colmax(inp.n_12\inp.n_21))
    }
    return(value)
}

//26 - Dragos
function bray_curtis(struct MetricInputs scalar inp, type) {
    if (type == "CTS"){
        K = cols(inp.conf_mat)
        sum_min = 0
        for (i=1; i<= rows(inp.conf_mat); i++){
	        for (j=1; j<= cols(inp.conf_mat); j++){
		        sum_min = sum_min + min((inp.conf_mat[i,j], inp.n / K^2))
	        }
        }
        value = 1/inp.n * sum_min
    }
    return(value)
}

//27
function brin_conviction(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = (inp.n_1_plus:*inp.n_plus_2):/(inp.n:*inp.n_12)
    }
    else if(type == "CTS") {
    	value = (inp.n_1_plus:*inp.n_plus_2 :+ inp.n_2_plus:*inp.n_plus_1):/(inp.n:*(inp.n_12:+inp.n_21))
    }
    return(value)
}

//#28
function causal_confidence(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = 0.5 :* ((inp.n_11 :/ inp.n_1_plus) :+ (inp.n_22 :/ inp.n_plus_2))
    }
    else if(type == "CTS") {
    	value = (inp.n_11 :+ inp.n_22):/inp.n
    }
    else if(type == "TS") {
    	value = (inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1)) :+ (inp.n_22 :/ (inp.n_2_plus :+ inp.n_plus_2))
    }
    return(value)
}

//#29
function causal_confidence_confirmed(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = 0.5 :* ((inp.n_11 :/ inp.n_1_plus) :+ (inp.n_22 :/ inp.n_plus_2)) :- (inp.n_12 :/ inp.n_1_plus)
    }
    else if(type == "CTS") {
    	value = (inp.n_11 :+ inp.n_22 :- inp.n_12 :- inp.n_21):/inp.n
    }
    else if(type == "TS") {
    	value = (inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1)) :+ (inp.n_22 :/ (inp.n_2_plus :+ inp.n_plus_2)) :- ((inp.n_12 :+ inp.n_21) :/ (inp.n_1_plus :+ inp.n_plus_1 ))
    }
    return(value)
}

//#30
function causal_confirm(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
    	value = (inp.n_11 :+ inp.n_22 :- (2 :* inp.n_12)) :/ inp.n
    }
    else if(type == "CTS") {
    	value = (inp.n_11 :+ inp.n_22 :- inp.n_12 :- inp.n_21) :/ inp.n
    }
    return(value)
}

//#32
function clayton_skill_score(struct MetricInputs scalar inp, type) {
    if(type == "CS") { // KONRAD (7)
    	//value = ((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21)) :/ (inp.n_1_plus :* inp.n_2_plus)
		value = (inp.n * sum(inp.n_11) - sum(inp.n_1_plus :* inp.n_plus_1)) / (inp.n^2 - sum(inp.n_1_plus:^2))
    }
    else if(type == "CTS") {
    	// value = (2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21)) :/ ((inp.n_1_plus :* inp.n_2_plus) :+ (inp.n_plus_1 :* inp.n_plus_2))
		value = (inp.n * sum(inp.n_11) - sum(inp.n_1_plus :* inp.n_plus_1)) / (inp.n^2 - 1/2 * (sum(inp.n_1_plus:^2) + sum(inp.n_plus_1 :^ 2)))
	}
    return(value)
}

//#33
function clement(struct MetricInputs scalar inp, type) {
    if(type == "CS") { // KONRAD (7)
    	value = ((inp.n_11 :* inp.n_2_plus) :/ inp.n_1_plus) :+ ((inp.n_22 :* inp.n_1_plus) :/ inp.n_2_plus)
    }
    else if(type == "CTS") {
    	value = (inp.n_11 :* (inp.n_2_plus :+ inp.n_plus_2)) :/ (inp.n_1_plus :+ inp.n_plus_1) :+ (inp.n_22 :* (inp.n_1_plus :+ inp.n_plus_1)) :/ (inp.n_2_plus :+ inp.n_plus_2)
    }
    return(value)
}

//#36
function cole_c5(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = (sqrt(2) :* ((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21))) :/ sqrt((((inp.n_11 :* inp.n_22) :- (inp.n_12 :* inp.n_21)) :^ 2) :+ (inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus))
    }
    return(value)
}

function galton(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		a = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ colmin(inp.n_1_plus :* inp.n_plus_2 \ inp.n_plus_1 :* inp.n_2_plus) :* (inp.n_11 :* inp.n_22 :>= inp.n_12 :* inp.n_21)
		b = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ colmin(inp.n_1_plus :* inp.n_plus_1 \ inp.n_plus_2 :* inp.n_2_plus) :* (inp.n_11 :* inp.n_22 :< inp.n_12 :* inp.n_21)
		value = a :+ b
	}
	return(value)
}

//#37
function collective_strength(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
    	value = (((inp.n_11 :/ inp.n) :+ (inp.n_22 :/ inp.n_2_plus)) :/ (((inp.n_1_plus :* inp.n_plus_1) :/ inp.n^2) :+ ((inp.n_2_plus :* inp.n_plus_2) :/ inp.n^2))) :* (((1 :- ((inp.n_1_plus :* inp.n_plus_1) :/ inp.n^2)) :- ((inp.n_2_plus :* inp.n_plus_2) :/ inp.n^2)) :/ (1 :- (inp.n_11 :/ inp.n) :- (inp.n_22 :/ inp.n_2_plus)))
		for (i=1; i<=rows(inp.conf_mat); i++) {
			if (inp.n_11[i] * inp.n_2_plus[i] + inp.n_22[i] * inp.n == inp.n * inp.n_2_plus[i]) {
				value[i] = .
			}
		}
    }
    else if(type == "CS") {
    	value = (((((inp.n_11 :+ inp.n_22) :/ inp.n) :+ (inp.n_22 :/ inp.n_2_plus) :+ (inp.n_11 :/ inp.n_1_plus))) :/ (((inp.n_1_plus :* inp.n_plus_1) :/ inp.n^2) :+ ((inp.n_2_plus :* inp.n_plus_2) :/ inp.n^2))) :* ((1 :- (inp.n_1_plus :* inp.n_plus_1) :/ (inp.n^2) :- (inp.n_2_plus :* inp.n_plus_2) :/ (inp.n^2)) :/ (2 :- ((inp.n_11 :+ inp.n_22) :/ inp.n) :- (inp.n_22 :/ inp.n_2_plus) :- (inp.n_11 :/ inp.n_1_plus)))                                                                                                    
    }
    else if(type == "TS") {
        value = (((2 :* (inp.n_11 :/ inp.n)) :+ (inp.n_22 :/ inp.n_2_plus) :+ (inp.n_22 :/ inp.n_plus_2)) :/ ((inp.n_1_plus :* inp.n_plus_1) :/ (inp.n^2)) :+ ((inp.n_2_plus :* inp.n_plus_2) :/ (inp.n^2))) :* ((1 :- ((inp.n_1_plus :* inp.n_plus_1) :/ (inp.n^2)) :- ((inp.n_2_plus :* inp.n_plus_2) :/ (inp.n^2))) :/ (2 :- ((2 :* (inp.n_11 :/ inp.n)) :- (inp.n_22 :/ inp.n_2_plus) :- (inp.n_22 :/ inp.n_plus_2))))
    }
    return(value)
}

//39 (KONRAD)
function confirm(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = (inp.n_11 :- inp.n_12) :/ inp.n
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22 :- inp.n_12 :- inp.n_21) :/ (2*inp.n)
	}
	else if (type == "TS") {
		value = (2 :* inp.n_11 :- (inp.n_12 :+ inp.n_21)) :/ (2*inp.n)
	}
	return(value)
}

// 40 Dragos
function consonni_todeschini_1(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
    	value = (log(1 :+ inp.n_11 :+ inp.n_22)) :/  log(1 :+ inp.n) 
    }
    return(value)
}

//41 (KONRAD)
function consonni_todeschini_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (log(1 + inp.n) :- log(1 :+ inp.n_12 :+ inp.n_21)) :/ log(1 + inp.n)
	}
	return(value)
}

// 42 Dragos
function consonni_todeschini_3(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
    	value = (log(1 :+ inp.n_11)) / (log(1 :+ inp.n))
    }
    else if(type == "CTS") {
    	value = (log(1 :+ inp.n_11) + log(1 :+ inp.n_22)) / (2 * log(1 :+ inp.n))
    }
    return(value)
}

//43 (KONRAD)
function consonni_todeschini_4(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = log(1 :+ inp.n_11) :/ log(1 :+ inp.n :- inp.n_22)
	}
	else if (type == "CTS") {
		value = (log(1 :+ inp.n_11) :+ log(1 :+ inp.n_22)) :/ (log(1 :+ inp.n :- inp.n_22) :+ log(1 :+ inp.n :- inp.n_11))
	}
	return(value)
}

// 44 Dragos
function consonni_todeschini_5(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
    	value = (log(1 :+ inp.n_11 :* inp.n_22) - log(1 :+ inp.n_12 :* inp.n_21)) :/  log(1 :+ (inp.n^2) / 4) 
    }
    return(value)
}

//45 (KONRAD)
function coverage(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_1_plus :/ inp.n
	}
	else if (type == "CTS") {
		value = J(1, cols(inp.n_11), 1/2)
	}
	else if (type == "TS") {
		value = (inp.n_1_plus :+ inp.n_plus_1) :/ (2*inp.n)
	}
	return(value)
}

// 46 Dragos
function cramer_concordance(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        K = cols(inp.conf_mat)
        _sum = 0
        for(i=1; i<=K; i++){
            for(j=1; j<=K; j++){
                _sum = _sum + (inp.conf_mat[i, j]-inp.n_1_plus[i]*inp.n_plus_1[j]/inp.n) ^ 2 / (inp.n_1_plus[i]*inp.n_plus_1[j])
            }
        }
    	value = _sum / (K-1)
    }
    return(value)
}

//47 (KONRAD)
function cressie_read(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		lambda = inp.crlambda
		if (lambda == 0) {
			value = likelihood_ratio(inp, "CTS")
		}
		else if (lambda == -1) {
			value = mdis(inp, "CTS")
		}
		else {
			value = 2 / (lambda * (lambda + 1)) * sum(inp.conf_mat :* ((inp.conf_mat :* inp.n :/ (inp.n_1_plus' * inp.n_plus_1)):^lambda :- 1))
		}
	}
	return(value)
}

// 48 Dragos
function dennis(struct MetricInputs scalar inp, type) { 
    if(type == "TS") {
    	value = (inp.n_11 :*inp.n_22 - inp.n_12 :* inp.n_21) :/ (sqrt(inp.n_1_plus :* inp.n_plus_1 :* inp.n))
    }
    else if(type == "CTS") {
    	value = 2 * (inp.n_11 :*inp.n_22 - inp.n_12 :* inp.n_21) :/ (sqrt(inp.n_1_plus :* inp.n_plus_1 :* inp.n) :+ sqrt(inp.n_2_plus :* inp.n_plus_2 :* inp.n))
    }
    return(value)
}

//49 (KONRAD)
function dependency(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = abs(inp.n_12 :/ inp.n_1_plus :- inp.n_plus_2 :/ inp.n)
	}
	else if (type == "CTS") {
		value = abs((inp.n_12 :+ inp.n_21) :/ inp.n :- (1/2))
	}
	else if (type == "TS") {
		value = abs((inp.n_12 :+ inp.n_21) :/ (inp.n_1_plus :+ inp.n_plus_1) :- (inp.n_plus_2 :+ inp.n_2_plus) :/ (2*inp.n))
	}
	return(value)
}

//50
function digby(struct MetricInputs scalar inp, type) { 
    if(type == "CTS") {
    	value = ((inp.n_11:*inp.n_22):^(3/4):-(inp.n_12:*inp.n_21):^(3/4)):/((inp.n_11:*inp.n_22):^(3/4):+(inp.n_12:*inp.n_21):^(3/4))
    }
    return(value)
}

//51 (KONRAD)
function discrimination_distance(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = invnormal(inp.n_11 :/ inp.n_plus_1) :- invnormal(inp.n_12 :/ inp.n_plus_2)
	}
	else if (type == "CTS") {
		value = invnormal((inp.n_11 :+ inp.n_22) :/ inp.n) :- invnormal((inp.n_12 :+ inp.n_21) :/ inp.n)
	}
	else if (type == "TS") {
		value = invnormal(2 :* inp.n_11 :/ (inp.n_plus_1 :+ inp.n_1_plus)) :- invnormal((inp.n_12 :+ inp.n_21) :/ (inp.n_plus_2 :+ inp.n_2_plus))
	}
	return(value)
}

//52
function dominance(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = inp.n_11:/inp.n_plus_1:-inp.n_22:/inp.n_plus_2
    }
    else if(type == "CTS") {
    	value = 0
    }
    else if(type == "TS") {
    	value = 2*inp.n_11:/(inp.n_plus_1:+inp.n_1_plus):-2*inp.n_22:/(inp.n_plus_2:+inp.n_2_plus)
    }
    return(value)
}

//53
function donaldson_bias(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
    	value = ((1:-inp.n_11:/inp.n_plus_1):*(1:-inp.n_12:/inp.n_plus_2):-inp.n_11:/inp.n_plus_1:*inp.n_12:/inp.n_plus_2):/((1:-inp.n_11:/inp.n_plus_1):*(1:-inp.n_12:/inp.n_plus_2):+inp.n_11:/inp.n_plus_1:*inp.n_12:*inp.n_plus_2)
    }
    else if(type == "CS") {
    	value = ((1:-inp.n_11:/inp.n_plus_1):*(1:-inp.n_12:/inp.n_plus_2):-inp.n_11:/inp.n_plus_1:*inp.n_12:/inp.n_plus_2:+(1:-inp.n_22:/inp.n_plus_2):*(1:-inp.n_21:/inp.n_plus_1):-inp.n_22:/inp.n_plus_2:*inp.n_21:/inp.n_plus_1):/((1:-inp.n_11:/inp.n_plus_1):*(1:-inp.n_12:/inp.n_plus_2):+inp.n_11:/inp.n_plus_1:*inp.n_12:/inp.n_plus_2:+(1:-inp.n_22:/inp.n_plus_2):*(1:-inp.n_21:/inp.n_plus_1):+inp.n_22:/inp.n_plus_2:*inp.n_21:*inp.n_plus_1)
    }
    else if(type == "TS") {
    	value = ((1:-inp.n_11:/inp.n_plus_1):*(1:-inp.n_12:/inp.n_plus_2):-inp.n_11:/inp.n_plus_1:*inp.n_12:/inp.n_plus_2:+(1:-inp.n_11:/inp.n_1_plus):*(1:-inp.n_21:/inp.n_2_plus):-inp.n_11:/inp.n_1_plus:*inp.n_21:/inp.n_2_plus):/((1:-inp.n_11:/inp.n_plus_1):*(1:-inp.n_12:/inp.n_plus_2):+inp.n_11:/inp.n_plus_1:*inp.n_12:/inp.n_plus_2:+(1:-inp.n_11:/inp.n_1_plus):*(1:-inp.n_21:/inp.n_2_plus):+inp.n_11:/inp.n_1_plus:*inp.n_21:/inp.n_2_plus)
    }
    return(value)
}

//54
function doolittle_association_ratio(struct MetricInputs scalar inp, type) { 
    if(type == "CTS") {
    	//value = (((inp.n_11:*inp.n_22):-(inp.n_12:*inp.n_21)):^2):/(inp.n_1_plus:*inp.n_plus_1:*inp.n_2_plus:*inp.n_plus_2)
		value = sum((inp.conf_mat :- inp.n_1_plus' * inp.n_plus_1 :/ inp.n):^2 :/ (inp.n_1_plus' * inp.n_plus_1))
    }
    return(value)
}

//55
function doolittle_raw_accuracy(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
    	value = (inp.n_11:^2):/(inp.n_1_plus:*inp.n_plus_1)
    }
    else if(type == "CTS") {
    	value = ((inp.n_11:^2):+(inp.n_22:^2)):/(inp.n_1_plus:*inp.n_plus_1:*inp.n_2_plus:*inp.n_plus_2)
    }
    return(value)
}

//56
function driver_kroeber(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
    	value = inp.n_11:/((inp.n_1_plus:*inp.n_plus_1):^(0.5))
    }
    else if(type == "CTS") {
    	value = (inp.n_11:+inp.n_22):/(((inp.n_1_plus:*inp.n_plus_1):^(0.5)):+((inp.n_2_plus:*inp.n_plus_2):^(0.5)))
    }
    return(value)
}

//57
function ex_and_counterex_rate(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
    	value = 1:-(inp.n_12:/inp.n_11)
    }
    else if(type == "CTS") {
    	value = 1:-((inp.n_12:+inp.n_21):/(inp.n_11:+inp.n_22))
    }
    else if(type == "TS") {
    	value = 1:-((inp.n_12:+inp.n_21):/(2:*inp.n_11))
    }
    return(value)
}

//58
function extremal_dependence(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = (log((inp.n_12:/inp.n_plus_2)):-log((inp.n_11:/inp.n_plus_1))):/(log((inp.n_12:/inp.n_plus_2)):+log((inp.n_11:/inp.n_plus_1)))
    }
    else if(type == "CS") {
        value = (log((inp.n_12:/inp.n_plus_2)):-log((inp.n_11:/inp.n_plus_1)):+log((inp.n_21:/inp.n_plus_1)):-log((inp.n_22:/inp.n_plus_2))):/(log((inp.n_12:/inp.n_plus_2)):+log((inp.n_11:/inp.n_plus_1)):+log((inp.n_21:/inp.n_plus_1)):+log((inp.n_22:/inp.n_plus_2)))
    }
    else if(type == "TS") {
        value = (log((inp.n_12:/inp.n_plus_2)):-log((inp.n_11:/inp.n_plus_1)):+log((inp.n_21:/inp.n_plus_1)):-log((inp.n_22:/inp.n_plus_2))):/(log((inp.n_12:/inp.n_plus_2)):+log((inp.n_11:/inp.n_plus_1)):+log((inp.n_21:/inp.n_plus_1)):+log((inp.n_22:/inp.n_plus_2)))
    }
    return(value)
}

//59
function extreme_dependency(struct MetricInputs scalar inp, type) { 
    if(type == "AS") {
        value = ((2:*log((inp.n_plus_1:/inp.n))):/log(inp.n_11:/inp.n)):-1
    }
    else if(type == "CS") {
        value = ((2:*log((inp.n_plus_1:/inp.n)):+2:*log(inp.n_plus_2:/inp.n)):/(log(inp.n_11:/inp.n):+log(inp.n_22:/inp.n))):-1
    }
    else if(type == "TS") {
        value = ((log(inp.n_1_plus:/inp.n):+log(inp.n_plus_1:/inp.n)):/(log(inp.n_11:/inp.n))):-1
    }
    return(value)
}

//60
function eyraud(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = ((inp.n:^2):*(inp.n_11:*inp.n_22:-inp.n_12:*inp.n_21)):/(inp.n_1_plus:*inp.n_plus_1:*inp.n_2_plus:*inp.n_plus_2)
    }
    return(value)
}

//61
function fager_mcgowan_1(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (inp.n_11:/(sqrt((inp.n_1_plus:*inp.n_plus_1)))):-(1:/(2:*sqrt(colmax(inp.n_1_plus\inp.n_plus_1))))
    } 
    else if(type == "CTS") {
        value = ((inp.n_11:+inp.n_22):/((sqrt(inp.n_1_plus:*inp.n_plus_1)):+(sqrt(inp.n_2_plus:*inp.n_plus_2)))):-(1:/((sqrt(colmax(inp.n_1_plus\inp.n_plus_1))):+sqrt(colmax(inp.n_2_plus\inp.n_plus_2))))
    }
    return(value)
}

//62
function fager_mcgowan_2(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (inp.n_11:/(sqrt((inp.n_1_plus:*inp.n_plus_1)))):-colmax(inp.n_12\inp.n_21)
    }
    else if(type == "CTS") {
        value = ((inp.n_11:+inp.n_22):/((sqrt(inp.n_1_plus:*inp.n_plus_1)):+(sqrt(inp.n_2_plus:*inp.n_plus_2)))):-colmax(inp.n_12\inp.n_21)
    }
    return(value)
}

//63
function faith(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (inp.n_11:+(0.5:*inp.n_22)):/inp.n
    }
    else if(type == "CTS") {
        value = (3:*(inp.n_11:+inp.n_22)):/(4:*inp.n)
    }
    return(value)
}

//64
function false_alarm_ratio(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = inp.n_12:/inp.n_1_plus
    }
    else if(type == "CTS") {
        value = (inp.n_12:+inp.n_21):/inp.n
    }
    else if(type == "TS") {
        value = (inp.n_12:+inp.n_21):/(inp.n_1_plus:+inp.n_plus_1)
    }
    return(value)
}

//65
function false_negative_rate(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = inp.n_21:/inp.n_plus_1
    }
    else if(type == "CTS") {
        value = (inp.n_12:+inp.n_21):/inp.n
    }
    else if(type == "TS") {
        value = (inp.n_12:+inp.n_21):/(inp.n_1_plus:+inp.n_plus_1)
    }
    return(value)
}

//66 Dragos - Comment - In order to not use incredibly big calculations, take a log, calculate, and exponentiate at the end again, this saves computation time
function fisher_exact_statistic(struct MetricInputs scalar inp, type) {
    if (type == "CTS") {
        K = cols(inp.conf_mat)

        log_num = 0 // numerator computed as log to save time
        log_den = lnfactorial(inp.n) // denominator - same thing

        for (i=1; i<=K; i++) {
            log_num = log_num + lnfactorial(inp.n_1_plus[i])
            log_num = log_num + lnfactorial(inp.n_plus_1[i])
            for (j=1; j<=K; j++) {
                log_den = log_den + lnfactorial(inp.conf_mat[i,j])
            }
        }

        value = exp(log_num - log_den)
    }
    return(value)
}

//69
function forbes_1(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (inp.n:*inp.n_11):/(inp.n_1_plus:*inp.n_plus_1)
    }
    else if(type == "CTS") {
        value = (inp.n:*(inp.n_11:+inp.n_22)):/(inp.n_1_plus:*inp.n_plus_1:+inp.n_2_plus:*inp.n_plus_2)
    }
    return(value)
}

//68
function forbes_2(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (inp.n:*inp.n_11:-inp.n_1_plus:*inp.n_plus_1):/(inp.n:*colmin(inp.n_1_plus\inp.n_plus_1):-inp.n_1_plus:*inp.n_plus_1)
    }
    else if(type == "CTS") {
        value = (inp.n:*(inp.n_11:+inp.n_22):-inp.n_1_plus:*inp.n_plus_1:-inp.n_2_plus:*inp.n_plus_2):/((inp.n:*(colmin(inp.n_1_plus\inp.n_plus_1):+colmin(inp.n_2_plus\inp.n_plus_2))):-inp.n_1_plus:*inp.n_plus_1:-inp.n_2_plus:*inp.n_plus_2)
    }
    return(value)
}

//70 - Dragos 
function freeman_tukey_statistic_as(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        K = cols(inp.conf_mat)
		
        _sum = 0
        for(i=1; i<=K; i++){
            for(j=1; j<=K; j++){
                _sum = _sum + (sqrt(inp.conf_mat[i, j]) - sqrt(inp.n_1_plus[i] * inp.n_plus_1[j] / inp.n)) ^ 2
            }
        }

        value = 4 * _sum
    }
    return(value)
}

//71
function f_score_adjusted(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = 5:*sqrt((inp.n_11:*inp.n_22):/((4:*inp.n_plus_1:+inp.n_1_plus):*(inp.n_plus_2:+4:*inp.n_2_plus)))
    }
    else if(type == "CTS") {
        value = (10:*sqrt(inp.n_11:*inp.n_22)):/(sqrt((4:*inp.n_plus_1:+inp.n_1_plus):*(inp.n_plus_2:+4:*inp.n_2_plus)):+sqrt(((4:*inp.n_plus_2:+inp.n_2_plus):*(inp.n_plus_1:+4:*inp.n_1_plus))))
    }
    return(value)
}

//72
function czekanowski(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (2:*inp.n_11):/(inp.n_1_plus:+inp.n_plus_1)
    }
    else if(type == "CTS") {
        value = (inp.n_11:+inp.n_22):/inp.n
    }
    return(value)
}

//73
function f_b_score(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value =((1:+inp.fbeta:^2):*inp.n_11):/(inp.fbeta:^2:*inp.n_plus_1:+inp.n_1_plus)
    }
    else if(type == "CTS") {
        value = (inp.n_11 :+ inp.n_22):/inp.n
    }
    else if(type == "TS") {
        value = (2:*inp.n_11):/(inp.n_1_plus :+ inp.n_plus_1)
    }
    return(value)
}

//74
function ganascia(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = (inp.n_11 :- inp.n_12):/inp.n_1_plus
    }
    else if(type == "CTS") {
        value = (inp.n_11 :+ inp.n_22 :- inp.n_21 :- inp.n_12):/inp.n
    }
    else if(type == "TS") {
        value = (2:*inp.n_11:-inp.n_12:-inp.n_21):/(inp.n_1_plus:+inp.n_plus_1)
    }
    return(value)
}

//75 (KONRAD)
function gerrity_skill_score(struct MetricInputs scalar inp, type) {
    if (type == "AS") {
		K = cols(inp.n_11)
		Dr = J(1, K-1, 0)
		s = 0
		for (j=1; j<=K-1; j++) {
			s = s + inp.n_plus_1[j]
			Dr[j] = (inp.n - s) / s
		}
		wij = J(K, K, 0)
		for (j=1; j<=K-1; j++) {
			for (i=j+1; i<=K; i++) {
				if (j > 1) {
					if (i < K) {
						wij[i,j] = 1/(K-1) * (j - i + sum(1 :/ Dr[1, 1..(j-1)]) + sum(Dr[1, i..(K-1)]))
					}
					else {
						wij[i,j] = 1/(K-1) * (j - i + sum(1 :/ Dr[1, 1..(j-1)]))
					}
				}
				else {
					if (i < K) {
						wij[i,j] = 1/(K-1) * (j - i + sum(Dr[1, i..(K-1)]))
					}
					else {
						wij[i,j] = 1/(K-1) * (j - i)
					}
				}
				wij[j,i] = wij[i,j]
			}
		}
		wij[1,1] = 1/(K-1) * sum(Dr[1, 1..(K-1)])
		for (k=2; k<=K-1; k++) {
			wij[k,k] = 1/(K-1) * (sum(1 :/ Dr[1, 1..(k-1)]) + sum(Dr[1, k..(K-1)]))
		}
		wij[K,K] = 1/(K-1) * sum(1 :/ Dr[1, 1..(K-1)])
		value = 1/(inp.n) * sum(inp.conf_mat :* wij)
	}
	return(value)
}

//76
function gilbert(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = inp.n_11:/(inp.n:-inp.n_22)
    }
    else if(type == "CTS") {
        value = (inp.n_11:+inp.n_22):/(2:*inp.n:-inp.n_22:-inp.n_11)
    }
    return(value)
}

//77
function gilbert_skill_score(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (inp.n_11:-((inp.n_1_plus:*inp.n_plus_1):/inp.n)):/(inp.n:-inp.n_22:-((inp.n_1_plus:*inp.n_plus_1):/inp.n))
    }
    else if(type == "CTS") {
        value = (inp.n_11:+inp.n_22:-((inp.n_1_plus:*inp.n_plus_1):/inp.n):-((inp.n_2_plus:*inp.n_plus_2):/inp.n)):/(2:*inp.n:-inp.n_22:-inp.n_11:-((inp.n_1_plus:*inp.n_plus_1):/inp.n):-((inp.n_2_plus:*inp.n_plus_2):/inp.n))
    }
    return(value)
}

//78
function gilbert_wells(struct MetricInputs scalar inp, type) {
    if (type == "CTS") {
        value = log(inp.n^3 :/ (2 * pi() :* inp.n_1_plus :* inp.n_plus_1 :* inp.n_2_plus :* inp.n_plus_2)) :+ 2 :* (lnfactorial(inp.n) :+ lnfactorial(inp.n_11) :+ lnfactorial(inp.n_12) :+  lnfactorial(inp.n_21) :+ lnfactorial(inp.n_22) :-
                     lnfactorial(inp.n_1_plus) :- lnfactorial(inp.n_plus_1) :- lnfactorial(inp.n_2_plus) :- lnfactorial(inp.n_plus_2))
    }
    return(value)
}

//80
function gini_1(struct MetricInputs scalar inp, type) {
    if(type == "CS") {
        value = 0.5:*abs((inp.n_11:*inp.n_plus_2:-inp.n_12:*inp.n_plus_1):/(inp.n_plus_1:*inp.n_plus_2)):+0.5:*abs((inp.n_21:*inp.n_plus_2:-inp.n_22:*inp.n_plus_1):/(inp.n_plus_1:*inp.n_plus_2))
    }
    else if(type == "CTS") {
        value = 0.5:*abs((inp.n_11:*inp.n_plus_2:-inp.n_12:*inp.n_plus_1:+inp.n_11:*inp.n_2_plus:-inp.n_21:*inp.n_1_plus):/(inp.n_plus_1:*inp.n_plus_2:+inp.n_1_plus:*inp.n_2_plus)):+0.5:*abs((inp.n_21:*inp.n_plus_2:-inp.n_22:*inp.n_plus_1:+inp.n_12:*inp.n_2_plus:-inp.n_22:*inp.n_1_plus):/(inp.n_plus_1:*inp.n_plus_2:+inp.n_1_plus:*inp.n_2_plus))
    }
    return(value)
}

//81
function gini_2(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        val_1 = (inp.n_1_plus:/inp.n):*((inp.n_11:/inp.n_1_plus):^2:+(inp.n_12:/inp.n_1_plus):^2):-(inp.n_1_plus:/inp.n):^2:+(inp.n_2_plus:/inp.n):*((inp.n_21:/inp.n_2_plus):^2:+(inp.n_22:/inp.n_2_plus):^2):-(inp.n_plus_2:/inp.n):^2
        val_2 = (inp.n_plus_1:/inp.n):*((inp.n_11:/inp.n_plus_1):^2:+(inp.n_21:/inp.n_plus_1):^2):-(inp.n_1_plus:/inp.n):^2:+(inp.n_plus_2:/inp.n):*((inp.n_12:/inp.n_plus_2):^2:+(inp.n_22:/inp.n_plus_2):^2):-(inp.n_2_plus:/inp.n):^2
        value = colmax((val_1)\(val_2))
    }
    return(value)
}

//82
function g_mean(struct MetricInputs scalar inp, type) {
    if(type == "CS") {
        value = sqrt((inp.n_11:/inp.n_plus_1):*(inp.n_22:/inp.n_plus_2))
    }
    else if(type == "CTS") {
        value = (2:*sqrt(inp.n_11:*inp.n_22)):/(sqrt(inp.n_plus_1:*inp.n_plus_2):+sqrt(inp.n_1_plus:*inp.n_2_plus))
    }
    return(value)
}

//83 (KONRAD)
function g_mean_adjusted(struct MetricInputs scalar inp, type) {
    if (type == "AS") {
		value = (inp.n_11 :> 0) :* (sqrt(inp.n_11 :* inp.n_22 :/ inp.n_plus_1 :/ inp.n_plus_2) :+ inp.n_22) :/ (1 :+ inp.n_plus_2)
	}
	else if (type == "CS") {
		value = (inp.n_11 :> 0 :| inp.n_22 :> 0) :* (2 :* sqrt(inp.n_11 :* inp.n_22 :/ (inp.n_plus_1 :* inp.n_plus_2)) :+ inp.n_22 :+ inp.n_11) :/ (2 + inp.n)
	}
	else if (type == "TS") {
		value = (inp.n_11 :> 0) :* (sqrt(inp.n_11 :* inp.n_22 :/ (inp.n_plus_1 :* inp.n_plus_2)) :+ sqrt(inp.n_11 :* inp.n_22 :/ (inp.n_1_plus :* inp.n_2_plus)) :+ 2 :* inp.n_22) :/ (2 :+ inp.n_plus_2 :+ inp.n_2_plus)
	}
	return(value)
}

//84
function goodman_concomitance(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = 2:*sqrt(inp.n_11:*inp.n_2_plus:*inp.n_plus_2):+sqrt(inp.n_22:*inp.n_plus_1:*inp.n_1_plus):-sqrt(inp.n_12:*inp.n_2_plus:*inp.n_plus_1):-sqrt(inp.n_21:*inp.n_1_plus:*inp.n_plus_2)
    }
    return(value)
}

//85 (KONRAD)
function goodman_kruskal_gamma(struct MetricInputs scalar inp, type) {
    if (type == "TS") {
		num = 0
		denom = 0
		K = rows(inp.conf_mat)
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
				first_sum = 0
				second_sum = 0
				for (h=i+1; h<=K; h++) {
					for (k=j+1; k<=K; k++) {
						first_sum = first_sum + inp.conf_mat[h,k]
					}
					for (k=1; k<j; k++) {
						second_sum = second_sum + inp.conf_mat[h,k]
					}
				}
				num = num + inp.conf_mat[i,j] * first_sum - inp.conf_mat[i,j] * second_sum
				denom = denom + inp.conf_mat[i,j] * first_sum + inp.conf_mat[i,j] * second_sum
			}
		}
		value = num / denom
	}
	return(value)
}

//86 KONRAD (25)
function goodman_kruskal_lambda(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = (sum(colmax(inp.conf_mat)) - colmax(rowsum(inp.conf_mat))) / (inp.n - colmax(rowsum(inp.conf_mat)))
	}
	else if (type == "CTS") {
		value = (sum(colmax(inp.conf_mat)) + sum(rowmax(inp.conf_mat)) - max(inp.n_1_plus) - max(inp.n_plus_1)) / (2 * inp.n - max(inp.n_1_plus) - max(inp.n_plus_1))
	}
    return(value)
}

//87 KONRAD (25)
function goodman_kruskal_lambda_w(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = (sum(colmax(inp.conf_mat) :/ colsum(inp.conf_mat)) - colmax(rowsum(inp.conf_mat :/ colsum(inp.conf_mat)))) / ( cols(inp.conf_mat) - colmax(rowsum(inp.conf_mat :/ colsum(inp.conf_mat))))
	}
	else if (type == "CTS") {
		value = (sum(colmax(inp.conf_mat) :/ colsum(inp.conf_mat)) + sum(rowmax(inp.conf_mat) :/ rowsum(inp.conf_mat)) - max(rowsum(inp.conf_mat :/ colsum(inp.conf_mat))) - max(colsum(inp.conf_mat :/ rowsum(inp.conf_mat)))) / (2 * cols(inp.conf_mat) - max(rowsum(inp.conf_mat :/ colsum(inp.conf_mat))) - max(colsum(inp.conf_mat :/ rowsum(inp.conf_mat))))
	}
    return(value)
}

//88 KONRAD (25)
function goodman_kruskal_lambda_r(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = (sum(diagonal(inp.conf_mat)) - rowmax(colsum(inp.conf_mat))) / (inp.n - rowmax(colsum(inp.conf_mat)))
	}
	else if (type == "CTS") {
		value = (2 * sum(diagonal(inp.conf_mat)) - colmax(rowsum(inp.conf_mat)) - rowmax(colsum(inp.conf_mat))) / (2 * inp.n - colmax(rowsum(inp.conf_mat)) - rowmax(colsum(inp.conf_mat)))
	}
    return(value)
}

//89
function goodman_kruskal_tau(struct MetricInputs scalar inp, type) {
    if(type == "CS") {
        //value = ((inp.n_11:*inp.n_22:-inp.n_12:*inp.n_21):^2):/(inp.n_1_plus:*inp.n_plus_1:*inp.n_plus_2:*inp.n_2_plus)
		value = (inp.n * sum(inp.conf_mat:^2 :/ inp.n_plus_1) - sum(inp.n_1_plus:^2)) / (inp.n^2 - sum(inp.n_1_plus:^2))
    }
    else if(type == "CTS") {
		value = (inp.n * (sum(inp.conf_mat:^2 :/ inp.n_plus_1) + sum(inp.conf_mat:^2 :/ inp.n_1_plus) )- sum(inp.n_1_plus:^2) - sum(inp.n_plus_1:^2) ) / (2 * inp.n^2 - sum(inp.n_1_plus:^2) - sum(inp.n_plus_1:^2))
		// value = ((inp.n_11:*inp.n_22:-inp.n_12:*inp.n_21):^2):/(inp.n_1_plus:*inp.n_plus_1:*inp.n_plus_2:*inp.n_2_plus)
    }
    return(value)
}

//90
function goodman_kruskal_1(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        val_1 = 2:*colmin(inp.n_11\inp.n_22):-inp.n_12:-inp.n_21
        val_2 = 2:*colmin(inp.n_11\inp.n_22):+inp.n_12:+inp.n_21
        value = val_1:/val_2
    }
    return(value)
}

//92
function goodman_kruskal_2(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        val_1 = colmax(inp.n_11\inp.n_12):+colmax(inp.n_21\inp.n_22):+colmax(inp.n_11\inp.n_21):+colmax(inp.n_12\inp.n_22):-colmax(inp.n_plus_1\inp.n_plus_2):-colmax(inp.n_1_plus\inp.n_2_plus)
        val_2 = 2:*inp.n:-colmax(inp.n_plus_1\inp.n_plus_2):-colmax(inp.n_1_plus\inp.n_2_plus)
        value = val_1:/val_2
    }
    return(value)
}

//93
function goodman_weighted_association(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = log((inp.n_11:*inp.n_22):/(inp.n_12:*inp.n_21)):*sqrt(inp.n_1_plus:*inp.n_plus_1:*inp.n_2_plus:*inp.n_plus_2)
    }
    return(value)
}

//94
function gorodkin_Rk(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        //value = ((inp.n_11:*inp.n_22):-(inp.n_12:*inp.n_21)):/(sqrt(inp.n_1_plus:*inp.n_plus_1:*inp.n_2_plus:*inp.n_plus_2))
		value = (inp.n * sum(inp.n_11) - sum(inp.n_1_plus :* inp.n_plus_1)) / sqrt((inp.n^2 - sum(inp.n_1_plus:^2)) * (inp.n^2 - sum(inp.n_plus_1:^2)))
    }
    return(value)
}

//95
function gray_orlowska(struct MetricInputs scalar inp, type) {
    if(type == "TS") {
        value = (((inp.n:*inp.n_11):/(inp.n_1_plus:*inp.n_plus_1)):^inp.goalpha:-1):*(inp.n_11:/inp.n):^inp.gobeta
    }
    else if(type == "CTS") {
        val_1 = inp.n:^inp.goalpha:*(inp.n_11:^inp.goalpha:+inp.n_22:^inp.goalpha)
        val_2 = (inp.n_1_plus:*inp.n_plus_1):^inp.goalpha:+(inp.n_2_plus:*inp.n_plus_2):^inp.goalpha
        val_3 = inp.n_11:^inp.gobeta:+inp.n_22:^inp.gobeta
        val_4 = 2:*inp.n:^inp.gobeta 
        value = (val_1:/val_2:-1):*(val_3:/val_4)
    }
    return(value)
}

//96
function grier_B_bias(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        a = inp.n_11:/inp.n_plus_1
        b = inp.n_12:/inp.n_plus_2
        value = (((a:*(1:-a)):-(b:*(1:-b))):/((a:*(1:-a)):+(b:*(1:-b)))):*sign(a:-b)
    }
    else if(type == "CS") {
        a = inp.n_11:/inp.n_plus_1
        b = inp.n_12:/inp.n_plus_2
        c = inp.n_21:/inp.n_plus_1
        d = inp.n_22:/inp.n_plus_2
        value = (((a:*(1:-a)):-(b:*(1:-b)):+(d:*(1:-d)):-(c:*(1:-c))):/((a:*(1:-a)):+(b:*(1:-b)):+(d:*(1:-d)):+(c:*(1:-c)))):*sign((a:-b))
    }
    else if(type == "TS") {
        a = inp.n_11:/inp.n_plus_1
        b = inp.n_12:/inp.n_plus_2
        c = inp.n_21:/inp.n_2_plus
        d = inp.n_11:/inp.n_1_plus
        value = (((a:*(1:-a)):-(b:*(1:-b)):+(d:*(1:-d)):-(c:*(1:-c))):/((a:*(1:-a)):+(b:*(1:-b)):+(d:*(1:-d)):+(c:*(1:-c)))):*sign((a:-b))
    }
    return(value)
}

//97
function guttman(struct MetricInputs scalar inp, type) {
    if(type == "CS") {
        value = (colmax(inp.n_11\inp.n_21):+colmax(inp.n_12\inp.n_22):-colmax(inp.n_1_plus\inp.n_2_plus)):/(inp.n:-colmax(inp.n_1_plus\inp.n_2_plus))
    }
    else if(type == "CTS") {
        value = (colmax(inp.n_11\inp.n_21):+colmax(inp.n_12\inp.n_22):+colmax(inp.n_11\inp.n_12):+colmax(inp.n_21\inp.n_22):-colmax(inp.n_1_plus\inp.n_2_plus):-colmax(inp.n_plus_1\inp.n_plus_2)):/(2:*inp.n:-colmax(inp.n_1_plus\inp.n_2_plus):-colmax(inp.n_plus_1\inp.n_plus_2))
    }
    return(value)
}

//98 - Dragos
function hamann(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        value = 1 / inp.n * (2 * sum(diagonal(inp.conf_mat)) - inp.n )
    }
    return(value)
}

//99
function harris_lahey(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = ((inp.n_11:*(2:*inp.n_22:+inp.n_12:+inp.n_21)):/(2:*(inp.n_11:+inp.n_12:+inp.n_21))):+((inp.n_22:*(2:*inp.n_11:+inp.n_12:+inp.n_21)):/(2:*(inp.n_22:+inp.n_12:+inp.n_21)))
    }
    return(value)
}

//100 - Dragos
function hawkins_dotson(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        K = cols(inp.conf_mat)
        _sum = 0
        for(i=1; i<=K; i++){
            _sum = _sum + (inp.conf_mat[i, i] / (inp.n_1_plus[i] + inp.n_plus_1[i] - inp.conf_mat[i, i]))
        }

        value = 1 / K * _sum
    }
    return(value)
}

//101
function heidke_skill_score(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 2 :* (inp.n_11 :* inp.n_22 - inp.n_12 :* inp.n_21) :/ (inp.n_plus_1 :* inp.n_2_plus :+ inp.n_1_plus :* inp.n_plus_2)
	}
    return(value)
}

function cohen_pi(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n * sum(inp.n_11) - sum(inp.n_1_plus :* inp.n_plus_1)) / (inp.n^2 - sum(inp.n_1_plus :* inp.n_plus_1))
	}
    return(value)
}

//102
function hit_rate(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = inp.n_11 :/ inp.n_plus_1
    }
	else if (type == "CTS") {
		value = (inp.n_11 + inp.n_22):/ inp.n
	}
	else if (type == "TS") {
		value =  2 :* inp.n_11 :/ ( inp.n_plus_1 + inp.n_1_plus ) 
	}
    return(value)
}

//103 (KONRAD)
function hoeffding_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		K = rows(inp.conf_mat)
		sums_hi = J(1, K, 0)
		sums_kj = J(1, K, 0)
		for (ind=2; ind<=K; ind++) {
			sums_hi[1,ind] = sums_hi[1,ind-1] + inp.n_1_plus[ind-1]
			sums_kj[ind] = sums_kj[ind-1] + inp.n_plus_1[ind-1]
		}
		value = 0
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
				value = value + 3 * inp.conf_mat[i,j] * (2 * sums_hi[i] + inp.n_1_plus[i] - inp.n) * (2 * sums_kj[j] + inp.n_plus_1[j] - inp.n)
			}
		}
		value = value / sqrt((inp.n^3 - sum(inp.n_1_plus:^3)) * (inp.n^3 - sum(inp.n_plus_1:^3)))
	}
	return(value)
}

// 104	Dragos - combo signature - uses combined arguments
function hoeffding_2(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        K = cols(inp.conf_mat)
        _sum_1 = 0
        _sum_2 = 0
        for(i=1; i<=K; i++){
            for(j=1; j<=K; j++){
                s = inp.conf_mat[i, j] - inp.n_1_plus[i] * inp.n_plus_1[j] / inp.n 
              _sum_1  = _sum_1 + abs(s)
              if(s > 0 ){
                _sum_2 = _sum_2 + inp.conf_mat[i, j]^2 / inp.n
              }
            }
        }

        value =  ( 1/2 * (_sum_1) ) / (inp.n - _sum_2)
    }
    return(value)
}

//105 (KONRAD)
function iba(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		M_value = (*inp.ibam_f)(inp, inp.ibam_type)
		if (cols(M_value) < cols(inp.conf_mat)) {
			errprintf("ERROR: [118] Generalized index of balanced accuracy requires M to refer to binary measure.\n")
			exit(1)
		}
		value = (1 :+ inp.ibaalpha :* (inp.n_11 :/ inp.n_plus_1 :- inp.n_22 :/ inp.n_plus_2)) :* M_value
	}
	return(value)
}

// 106	Dragos
function information_quality_ratio(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        K = cols(inp.conf_mat)
        _sum_1 = 0
        _sum_2 = 0
        for(i=1; i<=K; i++){
            for(j=1; j<=K; j++){
                if (inp.conf_mat[i,j] > 0){
                    _sum_1 = _sum_1 + inp.conf_mat[i, j] * log2(inp.n_1_plus[i] * inp.n_plus_1[j] / inp.n^2)
                    _sum_2 = _sum_2 + inp.conf_mat[i, j] * log2(inp.conf_mat[i, j] / inp.n)
                }
            }
        }
        if (_sum_2 == 0) {
            value = 0
        }
        else {
            value = _sum_1 / _sum_2 - 1
        }
    }
    return(value)
}

// 108	Dragos - !!!!!!!!!!!!!!! ISSUE !!!!!!!!!!!!!!!
function j_measure(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = (inp.n_11 :/ inp.n) :* log(inp.n :* inp.n_11 :/ (inp.n_1_plus :* inp.n_plus_1)) + (inp.n_12 :/ inp.n) :* log(inp.n :* inp.n_12 :/ (inp.n_1_plus :* inp.n_plus_2))
    }
    else if(type == "CTS") {
        s1 = inp.n_11 :+ inp.n_22
        s2 = inp.n_12 :+ inp.n_21

        t1 = (s1 :/ (2 :* inp.n)) :* log(inp.n :* s1 :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2) :+ (s1 :== 0))
        t2 = (s2 :/ (2 :* inp.n)) :* log(inp.n :* s2 :/ (inp.n_1_plus :* inp.n_plus_2 :+ inp.n_plus_1 :* inp.n_2_plus) :+ (s2 :== 0))

        t1 = t1 :* (s1 :!= 0)
        t2 = t2 :* (s2 :!= 0)

        value = t1 :+ t2
    }
    else if(type == "TS") {
        s2 = inp.n_12 :+ inp.n_21

        t1 = (inp.n_11 :/ inp.n) :* log(inp.n :* inp.n_11 :/ (inp.n_1_plus :* inp.n_plus_1) :+ (inp.n_11 :== 0))
        t2 = (s2 :/ (2 :* inp.n)) :* log(inp.n :* s2 :/ (inp.n_1_plus :* inp.n_plus_2 :+ inp.n_plus_1 :* inp.n_2_plus) :+ (s2 :== 0))

        t1 = t1 :* (inp.n_11 :!= 0)
        t2 = t2 :* (s2  :!= 0)

        value = t1 :+ t2
    }
    return(value)
}

//109 (KONRAD)
function kendall_tau_a(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 0
		K = rows(inp.conf_mat)
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
				first_sum = 0
				second_sum = 0
				for (h=i+1; h<=K; h++) {
					for (k=j+1; k<=K; k++) {
						first_sum = first_sum + inp.conf_mat[h,k]
					}
					for (k=1; k<j; k++) {
						second_sum = second_sum + inp.conf_mat[h,k]
					}
				}
				value = value + inp.conf_mat[i,j] * (first_sum - second_sum)
			}
		}
		value = 2 * value / (inp.n * (inp.n - 1))
	}
	return(value)
}

// 110	Dragos
function kendall_tau_b(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 0
		K = rows(inp.conf_mat)
        sum2_i = 0
        sum2_j = 0
		for (i=1; i<=K; i++) {
            sum2_i = sum2_i + inp.n_1_plus[i]^2
            sum2_j = sum2_j + inp.n_plus_1[i]^2

			for (j=1; j<=K; j++) {
				first_sum = 0
				second_sum = 0
				for (h=i+1; h<=K; h++) {
					for (k=j+1; k<=K; k++) {
						first_sum = first_sum + inp.conf_mat[h,k]
					}
					for (k=1; k<j; k++) {
						second_sum = second_sum + inp.conf_mat[h,k]
					}
				}
				value = value + inp.conf_mat[i,j] * (first_sum - second_sum)
			}
		}
        root = sqrt((inp.n^2 - sum2_i)*(inp.n^2 - sum2_j))
		value = 2 * value / root
	}
	return(value)
}

// 111  (KONRAD) / changes - Dragos
function kendall_tau_c(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 0
		K = rows(inp.conf_mat)
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
				first_sum = 0
				second_sum = 0
				for (h=i+1; h<=K; h++) {
					for (k=j+1; k<=K; k++) {
						first_sum = first_sum + inp.conf_mat[h,k]
					}
					for (k=1; k<j; k++) {
						second_sum = second_sum + inp.conf_mat[h,k]
					}
				}
				value = value + inp.conf_mat[i,j] * first_sum - inp.conf_mat[i,j] * second_sum
			}
		}
		value = 2 * K * value / (inp.n^2 * (K - 1))
	}
	return(value)
}

//112 (KONRAD)
function kitamura_matsumoto(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = log2(2 :* inp.n_11:^2 :/ (inp.n_1_plus :+ inp.n_plus_1))
	}
	else if (type == "CTS") {
		value = log2((inp.n_11:^2 :+ inp.n_22:^2) :/ inp.n)
	}
	return(value)
}

// 113	Dragos
function klosgen(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = sqrt((inp.n_11 :/ inp.n)) :* ((inp.n_11 :/ inp.n_1_plus) :- (inp.n_plus_1 :/ inp.n))
    }
    if(type == "CTS") {
        value = sqrt(( (inp.n_11 :+ inp.n_22) :/ (2*inp.n) )) :* ((inp.n_11 :+ inp.n_22 ) :/ inp.n :- 1/2)
    }
    if(type == "TS") {
        value = sqrt((inp.n_11 :/ inp.n)) :* ( (2 :* inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1) ) - ( (inp.n_1_plus :+ inp.n_plus_1) :/ (2*inp.n) ) )
    }
    return(value)
}

//114 (KONRAD)
function koppen(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 0
		K = rows(inp.conf_mat)
		for (i=1; i<=K; i++) {
			for (di=-1; di<=1; di++) {
				if (i+di >= 1 & i+di <= K) {
					if (di == 0) {
						value = value + 1/inp.n * inp.conf_mat[i,i]
					}
					else {
						value = value + 1/(2*inp.n) * inp.conf_mat[i,i+di]
					}
				}
			}
		}
	}
	return(value)
}

// 115	Dragos
function krippendorff(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        sum1 = sum(inp.n_11)
        sum0 = 0
        for(i=1; i<=cols(inp.n_11); i++){
            sum0 = sum0 + (inp.n_1_plus[i] + inp.n_plus_1[i]) ^ 2
        }
        value = 1 - ( ((2*inp.n - 1) * (inp.n - sum1)) / ( 2*inp.n^2 - (1/2) * sum0) )
    }
    return(value)
}

//116 (KONRAD)
function kuder_richardson(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 4 :* (inp.n_11:*inp.n_22 :- inp.n_12:*inp.n_21) :/ (inp.n_1_plus:*inp.n_2_plus :+ inp.n_plus_1:*inp.n_plus_2 :+ 2:*(inp.n_11:*inp.n_22 :- inp.n_12:*inp.n_21))
	}
	return(value)
}

// 117	Dragos
function kuhns_1(struct MetricInputs scalar inp, type) {
    if(type == "TS"){
        value = (2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21)) :/ (inp.n :* (2 :* inp.n_11 :+ inp.n_12 :+ inp.n_21))
    }
    else if(type == "CTS"){
        value = (2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21)) :/ (inp.n ^ 2)
    }
    return(value)
}

//118 (KONRAD)
function kuhns_2(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_11:*inp.n_22:-inp.n_12:*inp.n_21) :/ (inp.n:*inp.n_11:/(inp.n_1_plus:*inp.n_plus_1) :* (2:*inp.n_11:+inp.n_12:+inp.n_21:-inp.n_1_plus:*inp.n_plus_1:/inp.n))
	}
	else if (type == "CTS") {
		value = 2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ (inp.n :* inp.n_11 :/ (inp.n_1_plus :* inp.n_plus_1) :* (2:*inp.n_11 :+ inp.n_12 :+ inp.n_21 :- inp.n_1_plus :* inp.n_plus_1 :/ inp.n) :+ inp.n :* inp.n_22 :/ (inp.n_2_plus :* inp.n_plus_2) :* (2:*inp.n_22 :+ inp.n_12 :+ inp.n_21 :- inp.n_2_plus :* inp.n_plus_2 :/ inp.n))
	}
	return(value)
}

// 119	Dragos
function kulczynski_1(struct MetricInputs scalar inp, type) {
    if(type == "TS"){
        denominator = inp.n :- inp.n_11 :- inp.n_22
        value = J(1, cols(inp.n_11), 0)
        for (k=1; k<=cols(inp.n_11); k++) {
            if (denominator[k] > 0) {
                value[k] = inp.n_11[k] / denominator[k]
            }
            else {
                value[k] = inp.n-1  
            }
        }
    }
    else if(type == "CTS"){
        denominator = 2:* (inp.n :- inp.n_11 :- inp.n_22)
        value = J(1, cols(inp.n_11), 0)
        for (k=1; k<=cols(inp.n_11); k++) {
            if (denominator[k] > 0) {
                value[k] = (inp.n_11[k] + inp.n_22[k]) / denominator[k]
            }
            else {
                value[k] = inp.n-1  
            }
        }
    }
    return(value)
}

//120 (KONRAD)
function kulczynski_2(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 1/2 :* (inp.n_11:/inp.n_1_plus :+ inp.n_11:/inp.n_plus_1)
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ inp.n
	}
	return(value)
}

// 121	Dragos
function lakshmanamurti(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
        denom_1 = ( (inp.n_11:*inp.n_plus_2) :/ (inp.n_plus_1 :* inp.n_12) ) :+ ( (inp.n_11:*inp.n_2_plus) :/ (inp.n_1_plus :* inp.n_21) )
        denom_2 = ( (inp.n_22:*inp.n_plus_1) :/ (inp.n_plus_2 :* inp.n_21) ) :+ ( (inp.n_22:*inp.n_1_plus) :/ (inp.n_2_plus :* inp.n_12) )
        value = 1 :- 1:/denom_1 :- 1:/denom_2
    }
    return(value)
}

//122 (KONRAD)
function laplace_correction(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = (inp.n_11 :+ 1) :/ (inp.n_1_plus :+ 2)
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22 :+ 2) :/ (inp.n + 4)
	}
	else if (type == "TS") {
		value = (2 :* (inp.n_11 :+ 1)) :/ (inp.n_1_plus :+ inp.n_plus_1 :+ 4)
	}
	return(value)
}

// 123	Dragos
function least_contradiction(struct MetricInputs scalar inp, type) {
    if(type == "AS"){
        value = (inp.n_11 :- inp.n_12) :/ inp.n_plus_1
    }
    else if(type == "CTS"){
        value = (inp.n_11 :+ inp.n_22 :- inp.n_21 :- inp.n_12) :/ inp.n
    }
    else if(type == "TS"){
        value = (2:* inp.n_11 :- inp.n_12 :- inp.n_21) :/ (inp.n_1_plus :+ inp.n_plus_1)
    }
    return(value)
}

//124 (KONRAD)
function lerman(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = (inp.n :* inp.n_12 :- inp.n_1_plus :* inp.n_plus_2) :/ sqrt(inp.n :* inp.n_1_plus :* inp.n_plus_2)
	}
	else if (type == "CTS") {
		value = (inp.n :* (inp.n_12 :+ inp.n_21) :- inp.n_1_plus :* inp.n_plus_2 :- inp.n_2_plus :* inp.n_plus_1) :/ (sqrt(inp.n :* inp.n_1_plus :* inp.n_plus_2) :+ sqrt(inp.n :* inp.n_2_plus :* inp.n_plus_1))
	}
	return(value)
}

// 125	Dragos
function leverage(struct MetricInputs scalar inp, type){
    if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ (inp.n^2)
	}
    return(value)
}

//126 (KONRAD)
function likelihood_ratio(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 2 * sum(inp.conf_mat :* log(inp.conf_mat :* inp.n :/ (inp.n_1_plus' * inp.n_plus_1)))
	}
	return(value)
}

//130 (KONRAD)
function log_freq_biased(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = log(inp.n_11:^2 :/ (inp.n_1_plus :* inp.n_plus_1)) :+ log(inp.n_11 :/ inp.n)
	}
	else if (type == "CTS") {
		value = log((inp.n_11:^2 :+ inp.n_22:^2) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2)) :+ log((inp.n_11 :+ inp.n_22) :/ (2*inp.n))
	}
	return(value)
}

// 131	Dragos
function log_odds_ratio(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = log((inp.n_11 :* inp.n_22) :/ (inp.n_12 :* inp.n_21))
    }
    return(value)
}

//132 (KONRAD)
function log_odds_ratio_amended(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = log((inp.n_11 :+ 0.5) :* (inp.n_22 :+ 0.5) :/ ((inp.n_12 :+ 0.5) :* (inp.n_21 :+ 0.5)))
	}
	return(value)
}

// 133	Dragos
function maron_kuhns(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ inp.n
    }
    return(value)
}

//134 (KONRAD) 
function maxwell_pilliner(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ (inp.n_1_plus :* inp.n_2_plus :+ inp.n_plus_1 :* inp.n_plus_2)
	}
	return(value)
}

// 135 Dragos
function michael(struct MetricInputs scalar inp, type){
    if(type == "CTS") {
        value = 4 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ ((inp.n_11 :+ inp.n_22) :^2 :+ (inp.n_12 :+ inp.n_21) :^2)
    }
    return(value)
}

//136 (KONRAD)
function mcconnaughey(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_11:^2 :- inp.n_12 :* inp.n_21) :/ (inp.n_1_plus :* inp.n_plus_1)
	}
	else if (type == "CTS") {
		value = (inp.n_11:^2 :+ inp.n_22:^2 :- 2 :* inp.n_12 :* inp.n_21) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2)
	}
	return(value)
}

//138 (KONRAD)
function mdis(struct MetricInputs scalar inp, type) {
	if (type == "CTS" & !any(inp.conf_mat :== 0)) {
		value = 2 * sum((inp.n_1_plus' * inp.n_plus_1) :/ inp.n :* log((inp.n_1_plus' * inp.n_plus_1) :/ (inp.n :* inp.conf_mat)))
	}
	else {
		return(.)
	}
	return(value)
}

// 139	Dragos
function mountford(struct MetricInputs scalar inp, type){
    if(type == "TS"){
        value = 2 :* inp.n_11 :/ (inp.n_11 :* (inp.n_12 :+ inp.n_21) :+ 2:* inp.n_12 :* inp.n_21 )
    }
    if(type == "CTS"){
        value = 2 :* (inp.n_11 :+ inp.n_22) :/ ( (inp.n_11 :+ inp.n_22) :* (inp.n_12 :+ inp.n_21) :+ 4:* inp.n_12 :* inp.n_21 )
    }
    return(value)
}

//140 (KONRAD)
function mutual_dependency(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = log(inp.n_11:^2 :/ (inp.n_1_plus :* inp.n_plus_1))
	}
	else if (type == "CTS") {
		value = log((inp.n_11:^2 :+ inp.n_22:^2) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2))
	}
	return(value)
}

// 141	Dragos
function mutual_information(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
		_sum = 0
		K = cols(inp.n_11)
		for(i=1;i<=K;i++){
			for(j=1;j<=K;j++){
			_sum = _sum + (inp.conf_mat[i, j] * log((inp.conf_mat[i, j] * inp.n) / (inp.n_1_plus[i] * inp.n_plus_1[j])))
			}
		}   
		value = 1/inp.n * _sum
		}
    return(value)
}

//142 (KONRAD)
function neg_likelihood_ratio(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_21 :* inp.n_plus_2 :/ (inp.n_plus_1 :* inp.n_22)
	}
	else if (type == "CS") {
		value = (inp.n_21 :* inp.n_plus_2 :+ inp.n_12 :* inp.n_plus_1) :/ (inp.n_plus_1 :* inp.n_22 :+ inp.n_plus_2 :* inp.n_11)
	}
	else if (type == "TS") {
		value = (inp.n_21 :* inp.n_plus_2 :+ inp.n_12 :* inp.n_2_plus) :/ ((inp.n_plus_1 :+ inp.n_1_plus) :* inp.n_22)
	}
	return(value)
}

// 143	Dragos
function neyman_modified_chi2_statistic(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
		if (any(inp.conf_mat :== 0)) {
			return((.))
		}
		_sum = 0
		K = cols(inp.n_11)
		for(i=1;i<=K;i++){
			for(j=1;j<=K;j++){
				if (inp.conf_mat[i, j] > 0) {
					_sum = _sum + ((inp.conf_mat[i, j] - (inp.n_1_plus[i] * inp.n_plus_1[j]) / inp.n)^2) / inp.conf_mat[i, j]
				}
			}
		}   
		value = _sum
    }
    return(value)
}


//144 (KONRAD)
function norm_google_dist(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (colmax(log(inp.n_12) \ log(inp.n_21)) :- log(inp.n_11)) :/ (log(inp.n) :- colmin(log(inp.n_12) \ log(inp.n_21)))
	}
	else if (type == "CTS") {
		value = (colmax(log(inp.n_12) \ log(inp.n_21)) :- (1/2) :* (log(inp.n_11) :+ log(inp.n_22))) :/ (log(inp.n) :- colmin(log(inp.n_12) \ log(inp.n_21)))
	}
	return(value)
}

//145
function odds_ratio(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = (inp.n_11 :* inp.n_22) :/ (inp.n_12 :* inp.n_21)
    }
    return(value)
}

//146 (KONRAD)
function odds_ratio_amended(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
        value = ((inp.n_11 :+ 0.5) :* (inp.n_22 :+ 0.5)) :/ ((inp.n_12 :+ 0.5) :* (inp.n_21 :+ 0.5))
    }
    return(value)
}

// 147	Dragos !!!!!!! PLUS sign
function optimized_precision(struct MetricInputs scalar inp, type){
    if(type == "CS"){
        numerator_2 = abs(inp.n_11 :/ inp.n_plus_1 :- inp.n_22 :/ inp.n_plus_2)
        denominator_2 = inp.n_11 :/ inp.n_plus_1 :+ inp.n_22 :/ inp.n_plus_2
        value = ((inp.n_11 :+ inp.n_22) :/ inp.n ) :- numerator_2 :/ denominator_2
    }
    else if(type == "CTS"){
        numerator_2 = abs(inp.n_11 :/ inp.n_plus_1 :- inp.n_22 :/ inp.n_plus_2) :+ abs(inp.n_11 :/ inp.n_1_plus :- inp.n_22 :/ inp.n_2_plus)
        denominator_2 = inp.n_11 :/ inp.n_plus_1 :+ inp.n_22 :/ inp.n_plus_2 :+ inp.n_11 :/ inp.n_1_plus :- inp.n_22 :/ inp.n_2_plus // <------ The last plus/minus sign is a minus sign in the catalogue, but according to the 2006 paper, i think it should be a +
        value = ((inp.n_11 :+ inp.n_22) :/ inp.n ):- numerator_2 :/ denominator_2
        }
    return(value)
}

//148 (KONRAD)
function pearson_contingency_c(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		chi2 = pearson_chi2(inp, type)
		value = sqrt(chi2 / (inp.n + chi2))
	}
	return(value)
}

// 149	Dragos
function pearson_phi(struct MetricInputs scalar inp, type){
    if(type == "CTS"){
        sum_1 = 0
        K = cols(inp.n_11)
        for (i=1; i<=K; i++) {
           for (j=1; j<=K; j++) {
                sum_1 = sum_1 + ((inp.conf_mat[i,j] - inp.n_1_plus[i] * inp.n_plus_1[j] / inp.n)^2) / (inp.n_1_plus[i] * inp.n_plus_1[j])
            }
        }
        value = sqrt(sum_1)
    }
    return(value)
}

// 150	Dragos
function pearson_heron(struct MetricInputs scalar inp, type) {
    if(type == "CTS") {
        value = cos(pi() :* sqrt(inp.n_12:*inp.n_21) :/ (sqrt(inp.n_11:*inp.n_22) :+ sqrt(inp.n_12:*inp.n_21)) )
    }
    return(value)
}

// 151 (KONRAD)
function pearson_chi2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = sum((inp.conf_mat :- (inp.n_1_plus' * inp.n_plus_1) :/ inp.n):^2 :/ ((inp.n_1_plus' * inp.n_plus_1) :/ inp.n))
	}
	return(value)
}

// 152
function peirce_skill_score(struct MetricInputs scalar inp, type) {
    value = (inp.n * sum(diagonal(inp.conf_mat)) - sum(colsum(inp.conf_mat)' :* rowsum(inp.conf_mat))) / (inp.n*inp.n - sum(colsum(inp.conf_mat) :* colsum(inp.conf_mat)))
    return(value)
}

// 154	Dragos - quick nice fix for logs and missing values, but i need to know what the limits should be in order to automatically assign a bad/good value
function poisson_stirling(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		value = inp.n_11 :* (log(inp.n_11) :+ log(inp.n_1_plus :* inp.n_plus_1 :/ inp.n) :- 1)
            for (i=1; i<=cols(inp.n_11); i++) {
                if (inp.n_11[i] == 0) {
                    value[i] = . // KONRAD - switch to missing value (instead of 0)
                }
            }
	}
	else if(type == "CTS") {
		s1 = (inp.n_11 :+ inp.n_22) :/ 2
		value = s1 :* (log(s1) :+ log((inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2) :/ (2 :* inp.n)) :- 1)
        
        for (i=1; i<=cols(inp.n_11); i++) {
            if (s1[i] == 0) {
                value[i] = 0
            }
	    }
    }
    return(value)
}

//155 (KONRAD)
function pollack_norman(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		a = inp.n_11 :/ inp.n_plus_1
		b = inp.n_12 :/ inp.n_plus_2
		value = 1/2 :+ 1/4 :* sign(a :- b) :* ((a :- b):^2 :+ abs(a :- b)) :/ (colmax(a \ b) :- a :* b)
	}
	else if (type == "CS") {
		a = inp.n_11 :/ inp.n_plus_1
		b = inp.n_12 :/ inp.n_plus_2
		c = inp.n_22 :/ inp.n_plus_2
		d = inp.n_21 :/ inp.n_plus_1
		value = 1/2 :+ 1/4 :* sign(a :- b) :* ((a :- b):^2 :+ abs(a :- b) :+ (c :- d):^2 :+ abs(c :- d)) :/ (colmax(a \ b) :- a :* b :+ colmax(c \ d) :- c :* d)
	}
	else if (type == "TS") {
		a = inp.n_11 :/ inp.n_plus_1
		b = inp.n_12 :/ inp.n_plus_2
		c = inp.n_11 :/ inp.n_1_plus
		d = inp.n_21 :/ inp.n_2_plus
		value = 1/2 :+ 1/4 :* sign(a :- b) :* ((a :- b):^2 :+ abs(a :- b) :+ (c :- d):^2 :+ abs(c :- d)) :/ (colmax(a \ b) :- a :* b :+ colmax(c \ d) :- c :* d)
	}
	return(value)
}

// 156	Dragos
function pollaczek_geiringer(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		K = rows(inp.conf_mat)
		numer = 0
		denom = 0
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
				leq_sum = 0
				geq_sum = 0
				for (h=1; h<=i; h++) {
					for (k=1; k<=j; k++) {
						leq_sum = leq_sum  + inp.conf_mat[h,k]
					}
				}
				for (h=i+1; h<=K; h++) {
					for (k=j+1; k<=K; k++){
						geq_sum  = geq_sum + inp.conf_mat[h,k]
					}
				}
				gt_leq_sum = 0
				leq_gt_sum = 0
				for (h=i+1; h<=K; h++) {
					for (k=1; k<=j; k++){
						gt_leq_sum = gt_leq_sum + inp.conf_mat[h,k]
					}
				}
				for (h=1; h<=i; h++) {
					for (k=j+1; k<=K; k++) {
						leq_gt_sum = leq_gt_sum +  inp.conf_mat[h,k]
					}
				}
                numer = numer + (leq_sum*geq_sum - gt_leq_sum*leq_gt_sum)
                denom = denom + (leq_sum*geq_sum + gt_leq_sum*leq_gt_sum)
			}
		}
        if (denom == 0) return(.)
		value = numer / denom
	}
	return(value)
}

//157 (KONRAD)
function pos_likelihood_ratio(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_11 :* inp.n_plus_2 :/ (inp.n_plus_1 :* inp.n_12)
	}
	else if (type == "CS") {
		value = (inp.n_11 :* inp.n_plus_2 :+ inp.n_22 :* inp.n_plus_1) :/ (inp.n_plus_1 :* inp.n_12 :+ inp.n_plus_2 :* inp.n_21)
	}
	else if (type == "TS") {
		value = inp.n_11 :* (inp.n_plus_2 :+ inp.n_2_plus) :/ (inp.n_plus_1 :* inp.n_12 :+ inp.n_1_plus :* inp.n_21)
	}
	return(value)
}

// 158	Dragos
function positive_matching(struct MetricInputs scalar inp, type) {
    value = J(1, cols(inp.n_11), 0)

    if (type == "TS") {
        term = (inp.n_11 :+ colmax((inp.n_21 \ inp.n_12))) :/ (inp.n_11 :+ colmin((inp.n_21 \ inp.n_12)))
        den  = abs(inp.n_21 :- inp.n_12)
		value = inp.n_11 :/ den :* log(term)
    }
    else if (type == "CTS") {
        term = (inp.n_11 :+ inp.n_22 :+ 2 :* colmax((inp.n_21 \ inp.n_12))) :/ (inp.n_11 :+ inp.n_22 :+ 2 :* colmin((inp.n_21 \ inp.n_12)))
        den  = 2 :* abs(inp.n_21 :- inp.n_12)

        for (i=1; i<=cols(inp.n_11); i++) {
            if (den[i] == 0) {
                value[i] = 1
            }
            else if (term[i] > 0 & term[i] < .) {
                value[i] = (inp.n_11[i] + inp.n_22[i]) / den[i] * log(term[i])
            }
            else {
                value[i] = 0
            }
        }
    }

    return(value)
}

//159 (KONRAD symmetries)
function precision(struct MetricInputs scalar inp, type) {
    if(type == "AS") {
        value = inp.n_11 :/ inp.n_1_plus
    }
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ inp.n
	}
	else if (type == "TS") {
		value = 2 :* inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1)
	}
    return(value)
}

// 160	Dragos
function prevalence_threshold(struct MetricInputs scalar inp, type) {
	if(type == "AS") {
		value = sqrt(inp.n_12 :/ inp.n_plus_2) :/ (sqrt(inp.n_11 :/ inp.n_plus_1) :+ sqrt(inp.n_12 :/ inp.n_plus_2))
	}
	else if(type == "CS") {
		value = (sqrt(inp.n_12 :/ inp.n_plus_2) :+ sqrt(inp.n_21 :/ inp.n_plus_1)) :/ (sqrt(inp.n_11 :/ inp.n_plus_1) :+ sqrt(inp.n_12 :/ inp.n_plus_2) :+ sqrt(inp.n_22 :/ inp.n_plus_2) :+ sqrt(inp.n_21 :/ inp.n_plus_1))
	}
	else if(type == "TS") {
		value = (sqrt(inp.n_12 :/ inp.n_plus_2) :+ sqrt(inp.n_21 :/ inp.n_2_plus)) :/ (sqrt(inp.n_11 :/ inp.n_plus_1) :+ sqrt(inp.n_12 :/ inp.n_plus_2) :+ sqrt(inp.n_11 :/ inp.n_1_plus) :+ sqrt(inp.n_21 :/ inp.n_2_plus))
	}
	return(value)
}

//161 (KONRAD)
function putative_causal_dependency(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = 1/2 :* (inp.n_11 :/ inp.n_1_plus :- inp.n_plus_1 :/ inp.n) :+ (inp.n_22 :/ inp.n_plus_2 :- inp.n_2_plus :/ inp.n) :- (inp.n_12 :/ inp.n_1_plus :- inp.n_plus_2 :/ inp.n) :- (inp.n_12 :/ inp.n_plus_2 :- inp.n_1_plus :/ inp.n)
	}
	else if (type == "CTS") {
		value = (3 :* (inp.n_11 :+ inp.n_22) :- 4 :* (inp.n_12 :+ inp.n_21)) :/ (2*inp.n) :+ (1/4)
	}
	else if (type == "TS") {
		value = (inp.n_11:-inp.n_12:-inp.n_21):/(inp.n_1_plus:+inp.n_plus_1) :+ (2:*inp.n_22:-inp.n_12:-inp.n_21):/(inp.n_plus_2:+inp.n_2_plus) :+ (inp.n_1_plus:+inp.n_plus_1):/(4*inp.n)
	}
	return(value)
}

// 162	Dragos - used to be called Quetelet 1
function relative_risk(struct MetricInputs scalar inp, type) {
	if(type == "AS") {
		value = (inp.n_11 :* inp.n_2_plus) :/ (inp.n_1_plus :* inp.n_21)
	}
	else if(type == "CS") {
		value = (inp.n_11 :* inp.n_2_plus :+ inp.n_22 :* inp.n_1_plus) :/ (inp.n_1_plus :* inp.n_21 :+ inp.n_2_plus :* inp.n_12)
	}
	else if(type == "TS") {
		value = (inp.n_11 :* (inp.n_2_plus :+ inp.n_plus_2)) :/ (inp.n_1_plus :* inp.n_21 :+ inp.n_plus_1 :* inp.n_12)
	}
	return(value)
}


//163 (KONRAD) - used to be called Quetelet 2
function relative_quetelet_index(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ (inp.n_plus_1 :* inp.n_1_plus)
	}
	else if (type == "CTS") {
		value = 2 :* (inp.n_11:*inp.n_22 :- inp.n_12:*inp.n_21) :/ (inp.n_plus_1 :* inp.n_1_plus :+ inp.n_plus_2 :* inp.n_2_plus)
	}
	return(value)
}


// 166	Dragos
function rogers_tanimoto(struct MetricInputs scalar inp, type) {
    if (type == "CTS"){
	value = inp.n_kk / (2*inp.n - inp.n_kk)
    }
	return(value)
}

//167 (KONRAD)
function rogot_goldberg(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		if (any(inp.n_1_plus :+ inp.n_plus_1 :== 0)) {
			return((.))
		}
		value = sum(inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1))
	}
	return(value)
}

// 168	Dragos
function rousseau(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		t1 = 2:*inp.n_11 :+ inp.n_21 :+ inp.n_12
		value = (4 :* inp.n_11 :- t1:^2) :/ (2 :* t1 :- t1:^2)
	}
	else if(type == "CTS") {
		t1 = 2:*inp.n_11 :+ inp.n_21 :+ inp.n_12
		t2 = 2:*inp.n_22 :+ inp.n_21 :+ inp.n_12
		value = (4:*(inp.n_11:+inp.n_22) :- t1:^2 :- t2:^2) :/ (2 :* t1 + 2 :* t2 :- t1:^2 :- t2:^2)
	}
	return(value)
}

//169 (KONRAD)
function roux_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ (colmin(inp.n_12 \ inp.n_21) + colmin(inp.n :- inp.n_12 \ inp.n :- inp.n_21))
	}
	return(value)
}

// 170	Dragos
function roux_2(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		value = (inp.n :- inp.n_11 :* inp.n_22) :/ sqrt(inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus)
	}
	return(value)
}

// 171 (KONRAD)
function russell_rao(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = inp.n_11 :/ inp.n
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ (2*inp.n)
	}
	return(value)
}

// 172	Dragos
function schrank(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		value = inp.n :* (inp.n_11 :+ inp.n_22) :- (inp.n :/ 2) :* (inp.n_12 :+ inp.n_21) :- (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_plus_2 :* inp.n_2_plus)
	}
	return(value)
}

//173 (KONRAD)
function scott(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (4 :* inp.n_11 :* inp.n_22 :- (inp.n_12 :+ inp.n_21):^2) :/ ((2:*inp.n_11 :+ inp.n_12 :+ inp.n_21) :* (2:*inp.n_22 :+ inp.n_12 :+ inp.n_21))
	}
	return(value)
}

// 174	Dragos
function scott_pi(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		K = cols(inp.n_11)
        n_kk_sum = inp.n * sum(inp.n_11)
        sum_2 = 0
		for (k=1; k<=K; k++) {
			sum_2 = sum_2 + ((inp.n_1_plus[k] + inp.n_plus_1[k]) )^2
		}
        num = n_kk_sum - (1/4 * sum_2)
        den = inp.n^2 - (1/4 * sum_2)
		value = num / den
	}
	return(value)
}

function fleiss_kappa(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		K = cols(inp.n_11)
        n_kk_sum = inp.n * sum(inp.n_11)
        sum_2 = 0
		for (k=1; k<=K; k++) {
			sum_2 = sum_2 + ((inp.n_1_plus[k] + inp.n_plus_1[k]) )^2
		}
        num = n_kk_sum - (1/4 * sum_2)
        den = inp.n^2 - (1/4 * sum_2)
		value = num / den
	}
	return(value)
}

//175 (KONRAD)
function sebag_schoenauer(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_11 :/ inp.n_12
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ (inp.n_12 :+ inp.n_21)
	}
	else if (type == "TS") {
		value = 2 :* inp.n_11 :/ (inp.n_12 :+ inp.n_21)
	}
	return(value)
}

// 176	Dragos
function simple_matching(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		value = (inp.n_11 :+ inp.n_22) :/ (2:*inp.n_11 :+ inp.n_21 :+ inp.n_12)
	}
	else if(type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ inp.n
	}
	return(value)
}

//177 (KONRAD)
function sokal_sneath_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 2 * sum(inp.n_11) / (inp.n + sum(inp.n_11))
	}
	return(value)
}

// 178	Dragos
function sokal_sneath_2(struct MetricInputs scalar inp, type) {
    if(type == "CTS"){
	value = inp.n_kk / (inp.n - inp.n_kk)
    if( (inp.n - inp.n_kk) == 0){
        value = inp.n-1 //reverts to inp.n-1
    }
    }
	return(value)
}

//179 (KONRAD)
function sokal_sneath_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 1/(2 * cols(inp.n_11)) * (sum(inp.n_11 :/ inp.n_plus_1) + sum(inp.n_11 :/ inp.n_1_plus))
	}
	return(value)
}

// 180	Dragos
function sokal_sneath_4(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
        denom = (inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus)
		value = (inp.n_11 :* inp.n_22) :/ sqrt(denom)
        for(i=1;i<=cols(inp.n_11);i++){
            if(denom[i] == 0){
                value[i] = 1
            }
        }
	}
	return(value)
}

//181 (KONRAD)
function sokal_sneath_5(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = inp.n_11 :/ (inp.n_11 :+ 2 :* (inp.n_12 :+ inp.n_21))
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ (inp.n_11 :+ inp.n_22 :+ 4:*(inp.n_12 :+ inp.n_21))
	}
	return(value)
}

// 182	Dragos
function somers_d(struct MetricInputs scalar inp, type) {
    if(type == "AS"){
        K = cols(inp.n_11)
        sum_gt = 0
        sum_lt = 0
        for(i=1; i<=K; i++){
            for(j=1; j<=K; j++){
                gt_sum = 0
                lt_sum = 0
                for(h=i+1; h<=K; h++){
                    for(k=j+1; k<=K; k++){
                        gt_sum = gt_sum + inp.conf_mat[h,k]
                    }
                    for(k=1; k<j; k++){
                        lt_sum = lt_sum + inp.conf_mat[h,k]
                    }
                }
                sum_gt = sum_gt + inp.conf_mat[i,j] * gt_sum
                sum_lt = sum_lt + inp.conf_mat[i,j] * lt_sum

            }
        }
        denominator = inp.n^2 - sum(inp.n_plus_1:^2)
        value = (2 * (sum_gt - sum_lt)) / denominator
    }
    if(type == "TS"){
        K = cols(inp.n_11)
        sum_gt = 0
        sum_lt = 0
        for(i=1; i<=K; i++){
            for(j=1; j<=K; j++){
                gt_sum = 0
                lt_sum = 0
                for(h=i+1; h<=K; h++){
                    for(k=j+1; k<=K; k++){
                        gt_sum = gt_sum + inp.conf_mat[h,k]
                    }
                    for(k=1; k<j; k++){
                        lt_sum = lt_sum + inp.conf_mat[h,k]
                    }
                }
                sum_gt = sum_gt + inp.conf_mat[i,j] * gt_sum
                sum_lt = sum_lt + inp.conf_mat[i,j] * lt_sum

            }
        }
        denominator = 2 * (inp.n^2) - sum(inp.n_1_plus:^2) - sum(inp.n_plus_1:^2)
        value = (4 * (sum_gt - sum_lt)) / denominator
    }
    return(value)
}

//183 (KONRAD)
function sorensen(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 4 :* inp.n_11 :/ (4 :* inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	else if (type == "CTS") {
		value = 2 :* (inp.n_11 :+ inp.n_22) :/ (2 :* (inp.n_11 :+ inp.n_22) :+ inp.n_12 :+ inp.n_21)
	}
	return(value)
}

// 184	Dragos
function steffensen_psi2(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		K = rows(inp.conf_mat)
		_sum = 0
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
                num = inp.conf_mat[i,j] * (inp.conf_mat[i,j] - inp.n_1_plus[i] * inp.n_plus_1[j] / inp.n)^2
                denom = inp.n_1_plus[i] * (inp.n-inp.n_1_plus[i]) * inp.n_plus_1[j] * (inp.n - inp.n_plus_1[j])
                frac = num / denom
                _sum = _sum + frac
			}
		}
		value = inp.n * _sum
	}
	return(value)
}

//185 (KONRAD)
function steffensen_omega(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		mat = (inp.n_1_plus' * inp.n_plus_1) :/ inp.n
		mask = inp.conf_mat :> mat
		s = sum(mask :* (inp.conf_mat :- mat))
		value = 2 * s / (s + inp.n - sum(mask :* inp.conf_mat:^2 :/ inp.n))
	}
	return(value)
}

// 186	Dragos
function stiles(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
        term = inp.n :* (abs(inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :- inp.n:/2):^2 :/ (inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus)
		value = log10(term)
        // value[selectindex(term :== 0)] = 0
        // value[selectindex(term :== .)] = 1
	}
	return(value)
}

// 187	Dragos
function success(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		value = (inp.n :* inp.n_11 :- inp.n_1_plus :* inp.n_plus_1) :/ 
                (inp.n :* inp.n_11 :+ inp.n_1_plus :* inp.n_plus_1)
	}
	else if(type == "CTS") {
		value = (inp.n :* (inp.n_11 :+ inp.n_22) :- inp.n_1_plus :* inp.n_plus_1 :- inp.n_2_plus :* inp.n_plus_2) :/ 
                (inp.n :* (inp.n_11 :+ inp.n_22) :+ inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2)
	}
	return(value)
}

//188 (KONRAD)
function szymkiewicz_simpson(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = inp.n_11 :/ (inp.n_11 :+ colmin(inp.n_12 \ inp.n_21))
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ (inp.n_11 :+ inp.n_22 :+ 2 :* colmin(inp.n_12 \ inp.n_21))
	}
	return(value)
}

// 189	Dragos
function tarantula(struct MetricInputs scalar inp, type) {
	if(type == "AS") {
		value = (inp.n_11 :/ inp.n_1_plus) :/ 
        (inp.n_11 :/ inp.n_1_plus :+ inp.n_21 :/ inp.n_2_plus)
	}
	else if(type == "CS") {
		value = (inp.n_11 :/ inp.n_1_plus :+ inp.n_22 :/ inp.n_2_plus) :/ 
        (inp.n_11 :/ inp.n_1_plus :+ inp.n_21 :/ inp.n_2_plus :+ inp.n_22 :/ inp.n_2_plus :+ inp.n_12 :/ inp.n_1_plus)
	}
	else if(type == "TS") {
		value = (inp.n_11 :/ inp.n_1_plus :+ inp.n_11 :/ inp.n_plus_1) :/ 
        (inp.n_11 :/ inp.n_1_plus :+ inp.n_21 :/ inp.n_2_plus :+ inp.n_11 :/ inp.n_plus_1 :+ inp.n_12 :/ inp.n_plus_2)
	}
	return(value)
}

//190 (KONRAD)
function theil(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = -sum(inp.conf_mat :* log(inp.conf_mat :* inp.n :/ (inp.n_1_plus' * inp.n_plus_1))) / sum(inp.n_1_plus :* log(inp.n_1_plus :/ inp.n))
	}
	else if (type == "CTS") {
		value = -2 * sum(inp.conf_mat :* log(inp.conf_mat :* inp.n :/ (inp.n_1_plus' * inp.n_plus_1))) / (sum(inp.n_1_plus :* log(inp.n_1_plus :/ inp.n)) + sum(inp.n_plus_1 :* log(inp.n_plus_1 :/ inp.n)))
	}
	return(value)
}

// 191	Dragos
function tonnies(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		K = rows(inp.conf_mat)
		diag_sum = sum(diagonal(inp.conf_mat))
		sum_1 = 0
		sum_2 = 0
		sum_3 = 0
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
				if(abs(i-j) == 1) sum_1 = sum_1 + inp.conf_mat[i,j]
				if(i+j-1 == K)   sum_2 = sum_2 + inp.conf_mat[i,j]
				if(i+j-1 == K+1 | i+j-1 == K-1) sum_3 = sum_3 + inp.conf_mat[i,j] // KONRAD
			}
		}
		value = 2/inp.n * diag_sum + 1/inp.n * sum_1 - 2/inp.n * sum_2 - 1/inp.n * sum_3
	}
	return(value)
}

//192 (KONRAD)
function tschuprow_t(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		chi2 = pearson_chi2(inp, type)
		value = sqrt(chi2 / (inp.n * (rows(inp.conf_mat) - 1)))
	}
	return(value)
}

// 193	Dragos
function tschuprow_t_bias_corrected(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		K = rows(inp.conf_mat)
		sum_1 = 0
		for (i=1; i<=K; i++) {
			for (j=1; j<=K; j++) {
                sum_1 = sum_1 + ((inp.conf_mat[i,j] - inp.n_1_plus[i] * inp.n_plus_1[j] / inp.n)^2) / (inp.n_1_plus[i] * inp.n_plus_1[j])
			}
		}
        term_2 = sum_1 - (K-1)^2 / (inp.n-1)
        term_1 = 1 / (K -(K-1)^2 / (inp.n-1) - 1)
        maxx = max((0, term_2))
        value = sqrt(term_1 * maxx) 
	}
	return(value)
}

//194 (KONRAD)
function t_score(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_11 :- inp.n_1_plus :* inp.n_plus_1 :/ inp.n) :/ sqrt(inp.n_11)
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22 :- inp.n_1_plus :* inp.n_plus_1 :/ inp.n :- inp.n_2_plus :* inp.n_plus_2 :/ inp.n) :/ (sqrt(inp.n_11) :+ sqrt(inp.n_22))
	}
	return(value)
}

// 195	Dragos
function tulloss_r_cost(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		value = log2(1 :+ inp.n_11 :/ inp.n_1_plus)  :* log2(1 :+ inp.n_11 :/ inp.n_plus_1)
	}
	else if(type == "CTS") {
		value = (log2(1 :+ (inp.n_11 :+ inp.n_22) :/ inp.n)):^2
	}
	return(value)
}

//196 (KONRAD)
function tulloss_s_cost(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (log(2 :+ colmin(inp.n_12 \ inp.n_21) :/ (1 :+ inp.n_11)) :/ log(2)):^(-1/2)
	}
	else if (type == "CTS") {
		value = (log(2 :+ 2 :* colmin(inp.n_12 \ inp.n_21) :/ (2 :+ inp.n_11 :+ inp.n_22)) :/ log(2)):^(-1/2)
	}
	return(value)
}

// 197	Dragos
function tulloss_u_cost(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		mn = colmin((inp.n_12 \ inp.n_21))
		mx = colmax((inp.n_12 \ inp.n_21))
		value = log2(1 :+ (mn :+ inp.n_11) :/ (mx :+ inp.n_11))
	}
	else if(type == "CTS") {
		mn = colmin((inp.n_12 \ inp.n_21))
		mx = colmax((inp.n_12 \ inp.n_21))
		value = log2(1 :+ (2:*mn :+ inp.n_11 :+ inp.n_22) :/ (2:*mx :+ inp.n_11 :+ inp.n_22))
	}
	return(value)
}

//198 (KONRAD) (no type check needed as we just pass whatever the type is to R, S, U)
function tulloss_t_combined_costs(struct MetricInputs scalar inp, type) {
	value = sqrt(tulloss_r_cost(inp, type) :* tulloss_s_cost(inp, type) :* tulloss_u_cost(inp, type))
	return(value)
}

// 199	Dragos
function two_afc_1(struct MetricInputs scalar inp, type) {
	if(type == "CS") {
		K = rows(inp.conf_mat)
		numer = 0
		denom = 0
		for (k=1; k<=K; k++) {
			for (l=1; l<=K; l++) {
				if(l == k) continue
				inner = 0
				for (i=1; i<=K; i++) {
					if(i == k) continue
					inner = inner + inp.conf_mat[k,k] * inp.conf_mat[i,l]
				}
				half_1 = 0
				for (i=1; i<=K; i++) {
					if(i == k) continue
					for (j=1; j<=K; j++) {
						if(j == k | j == l) continue
						half_1 = half_1 + inp.conf_mat[l,k] * inp.conf_mat[j,i]
					}
				}
				half_2 = 0
				for (i=1; i<=K; i++) {
					half_2 = half_2 + inp.conf_mat[i,k] * inp.conf_mat[i,l]
				}
				numer = numer + inner + 0.5 * (half_1 + half_2)
				denom = denom + inp.n_plus_1[k] * inp.n_plus_1[l]
			}
		}
		value = numer / denom
	}
	return(value)
}


// 200 (KONRAD)
function two_afc_2(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		num = 0
		denom = 0
		K = rows(inp.conf_mat)
		for (k=1; k<=K-1; k++) {
			for (l=k+1; l<=K; l++) {
				denom = denom + inp.n_plus_1[k] * inp.n_plus_1[l]
				for (i=1; i<=K-1; i++) {
					for (j=i+1; j<=K; j++) {
						num = num + inp.conf_mat[i,k] * inp.conf_mat[j,l]
					}
				}
				for (i=1; i<=K; i++) {
					num = num + 1/2 * inp.conf_mat[i,k] * inp.conf_mat[i,l]
				}
			}
		}
		value = num / denom
	}
	return(value)
}

// 201	Dragos
function upholt_s(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
        r = (2 :* inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1)) :^2 + (16:* inp.n_11) :/ (inp.n_1_plus :+ inp.n_plus_1)
		value = (- inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1) :+ 1:/2 :* sqrt(r)) :^ (1/inp.n)
	}
	else if(type == "CTS") {
		r = (2 :* (inp.n_11 :+ inp.n_22) :/ (inp.n_1_plus :+ inp.n_plus_1 :+ inp.n_2_plus :+ inp.n_plus_2)) :^2 + (16:* (inp.n_11 :+ inp.n_22)) :/ (inp.n_1_plus :+ inp.n_plus_1 :+ inp.n_2_plus :+ inp.n_plus_2)
		value = (- (inp.n_11 :+ inp.n_22) :/ (inp.n_1_plus :+ inp.n_plus_1 :+ inp.n_2_plus :+ inp.n_plus_2) :+ 1:/2 :* sqrt(r)) :^ (1/inp.n)
	}
	return(value)
}

//202 (KONRAD)
function van_der_maarel(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (2 :* inp.n_11 :- inp.n_12 :- inp.n_21) :/ (2 :* inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22 :- inp.n_12 :- inp.n_21) :/ inp.n
	}
	return(value)
}

// 203	Dragos
function warrens(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		value = 4 :* inp.n_11 :* inp.n_22 :/ (4 :* inp.n_11 :* inp.n_22 :+ (inp.n_11 :+ inp.n_22) :* (inp.n_12 :+ inp.n_21))
	}
	return(value)
}

//204 (KONRAD)
function weighted_kappa(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		s = sum(inp.kweights_mat :* (inp.n_1_plus' * inp.n_plus_1))
		value = (inp.n * sum(inp.kweights_mat :* inp.conf_mat) - s) / (inp.n^2 - s)
	}
	return(value)
}

//206 (KONRAD)
function woodcock(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 4 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ inp.n^2
	}
	return(value)
}

// 207	Dragos
function zhang(struct MetricInputs scalar inp, type) {
	if(type == "AS") {
		value = (inp.n :* inp.n_11 :- inp.n_1_plus :* inp.n_plus_1) :/ colmax((inp.n_11 :* inp.n_plus_2\ inp.n_plus_1 :* inp.n_12))
	}
	else if(type == "CS") {
		numer = inp.n :* (inp.n_11 :+ inp.n_22) :- inp.n_1_plus :* inp.n_plus_1 :- inp.n_2_plus :* inp.n_plus_2
        mx1 = colmax(inp.n_11:*inp.n_plus_2 \ inp.n_plus_1 :* inp.n_12)
        mx2 = colmax(inp.n_22 :* inp.n_plus_1 \ inp.n_plus_2 :* inp.n_21)
		value = numer :/ (mx1 :+ mx2)
	}
	else if(type == "TS") {
		numer = 2 :* (inp.n :* inp.n_11 :- inp.n_1_plus :* inp.n_plus_1)
        mx1 = colmax(inp.n_11:*inp.n_plus_2 \ inp.n_plus_1 :* inp.n_12)
        mx2 = colmax(inp.n_11 :* inp.n_2_plus \ inp.n_1_plus :* inp.n_21)
		value = numer :/ (mx1 :+ mx2)
	}
	return(value)
}

//208 (KONRAD)
function yao_liu_one_way_support(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_11 :/ inp.n_1_plus :* log2(inp.n :* inp.n_11 :/ (inp.n_1_plus :* inp.n_plus_1))
	}
	else if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ inp.n :* log2(inp.n :* (inp.n_11 :+ inp.n_22) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2))
	}
	else if (type == "TS") {
		value = 2 :* inp.n_11 :/ (inp.n_1_plus :+ inp.n_plus_1) :* log2(inp.n:*inp.n_11 :/ (inp.n_1_plus :* inp.n_plus_1))
	}
	return(value)
}

// 209	Dragos
function yao_liu_two_way_support(struct MetricInputs scalar inp, type) {
	if(type == "TS") {
		t1 = (inp.n_11 :/ inp.n) :* log2(inp.n :* inp.n_11 :/ (inp.n_1_plus :* inp.n_plus_1))
		// t1 = t1 :* (inp.n_11 :!= 0) //- possible fix for edge cases??
		value = t1
	}
	else if(type == "CTS") {
		t1 = ((inp.n_11 :+ inp.n_22) :/ (2 :* inp.n)) :* log2(inp.n :* (inp.n_11 :+ inp.n_22) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2))
		// t1 = t1 :* ((inp.n_11 :+ inp.n_22) :!= 0) // -- possible fix for edge cases??
		value = t1
	}
	return(value)
}

//210 (KONRAD)
function yao_liu_two_way_support_v(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* log2(inp.n:*inp.n_11 :/ (inp.n_1_plus:*inp.n_plus_1)) :+ inp.n_12 :* log2(inp.n:*inp.n_12 :/ (inp.n_1_plus :* inp.n_plus_2)) :+ inp.n_21 :* log2(inp.n :* inp.n_21 :/ (inp.n_2_plus :* inp.n_plus_1)) :+ inp.n_22 :* log2(inp.n :* inp.n_22 :/ (inp.n_2_plus :* inp.n_plus_2))) :/ inp.n
	}
	return(value)
}

// 211	Dragos
function yates_chi2(struct MetricInputs scalar inp, type) {
	if(type == "CTS") {
		value = inp.n :* (abs(inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :- inp.n:/2):^2 :/ (inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus)
	}
	return(value)
}

//212 (KONRAD)
function yule_colligation(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		a = sqrt(inp.n_11:*inp.n_22)
		b = sqrt(inp.n_12:*inp.n_21)
		value = (a :- b) :/ (a :+ b)
	}
	return(value)
}


// 213 Dragos
function yule_phi(struct MetricInputs scalar inp, type){
    if(type == "CTS"){
		value = (inp.n_11 :* inp.n_22 - inp.n_12 :* inp.n_21) :/ sqrt(inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus)
    }
    return(value)
}

//214 (KONRAD)
function yule_q(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11:*inp.n_22 :- inp.n_12:*inp.n_21) :/ (inp.n_11:*inp.n_22 :+ inp.n_12:*inp.n_21)
	}
	return(value)
}

// NEW METRICS FROM TODO LIST #4

function fossum(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n :* (inp.n_11 :- 0.5):^2) :/ (inp.n_1_plus :* inp.n_plus_1)
	}
	return(value)
}

function p4_score(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 4 :* inp.n_11 :* inp.n_22 :/ (4 :* inp.n_11 :* inp.n_22 :+ (inp.n_11 :+ inp.n_22) :* (inp.n_12 :* inp.n_21))
	}
	return(value)
}

function sokal_sneath_6(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = inp.sokal_w :* inp.n_11 :/ (inp.sokal_w :* inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	else if (type == "CTS") {
		value = inp.sokal_w :* (inp.n_11 :+ inp.n_22) :/ (inp.sokal_w :* (inp.n_11 :+ inp.n_22) :+ 2:*inp.n_12 :+ 2:*inp.n_21)
	}
	return(value)
}

function maxwell_B(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n * sum(inp.n_11) - inp.n^2 / cols(inp.conf_mat)) / (inp.n * sum(colmin(inp.n_1_plus \ inp.n_plus_1)) - inp.n^2 / cols(inp.conf_mat))
	}
	return(value)
}

function gower_legendre(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = sum(inp.n_11) / (sum(inp.n_11) + inp.gl_theta * (sum(inp.conf_mat) - sum(inp.n_11)))
	}
	return(value)
}

function pattern_difference(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 4 :* inp.n_12 :* inp.n_21 :/ (inp.n:^2)
	}
	return(value)
}

function shape_difference(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n :* (inp.n_12 :+ inp.n_21) :- (inp.n_12 :- inp.n_21):^2) :/ (inp.n^2)
	}
	return(value)
}

function size_difference(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_12 :- inp.n_21):^2 :/ (inp.n^2)
	}
	return(value)
}

function chord_distance(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = sqrt(2 :* (1 :- inp.n_11 :/ sqrt(inp.n_1_plus :* inp.n_plus_1)))
	}
	return(value)
}

function baulieu_13(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 1 :- inp.n_11:^2 :* inp.n_22:^2 :/ (inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus)
	}
	return(value)
}

function baulieu_22(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21 :- (inp.n_11 :+ 1/2) :* (inp.n_22 :+ 1/2) :* inp.n_22 :* inp.baulieu_kappa) :/ inp.n
	}
	return(value)
}

function baulieu_23(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21 :+ 1) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21 :+ 1)
	}
	return(value)
}

function baulieu_24(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21 :+ 1)
	}
	return(value)
}

function baulieu_25(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21) :/ (inp.n :+ inp.n_11 :* (inp.n_11 :- 4):^2)
	}
	return(value)
}

function baulieu_27(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = (inp.n_12 :+ 2:*inp.n_21) :/ (inp.n :+ inp.n_21)
	}
	return(value)
}

function baulieu_28(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_12 :+ inp.n_21 :+ colmax(inp.n_12 \ inp.n_21)) :/ (inp.n :+ colmax(inp.n_12 \ inp.n_21))
	}
	return(value)
}

function baulieu_29(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21) :/ (inp.n_12 :+ inp.n_21 :+ inp.n_22)
	}
	return(value)
}

function baulieu_30(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21 :- 1)
	}
	return(value)
}

function baulieu_31(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21 :+ inp.n_11 :* (inp.n_11 :- 4):^2)
	}
	return(value)
}

function baulieu_32(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = (inp.n_12 :+ 2:*inp.n_21) :/ (inp.n_11 :+ inp.n_12 :+ 2:*inp.n_21)
	}
	return(value)
}

function baulieu_33(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = (inp.n_12 :+ inp.n_21 :+ colmax(inp.n_12 \ inp.n_21)) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21 :+ colmax(inp.n_12 \ inp.n_21))
	}
	return(value)
}

function variance_dissimilarity(struct MetricInputs scalar inp, type){
	if (type == "CTS") {
		value = (inp.n_11 :+ inp.n_22) :/ inp.n
	}
	return(value)
}


function tversky(struct MetricInputs scalar inp, type) {
    if (type == "AS") {
        value = inp.n_11 :/ (inp.n_11 :+ inp.t_alpha :* inp.n_12 :+ inp.t_beta :* inp.n_21)
    }
    return(value)
}

// NEW METRICS FROM TODO LIST #4 feedback

function fleiss_levin_paik(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 2 :* inp.n_22 :/ (inp.n_2_plus :+ inp.n_plus_2)
	}
	return(value)
}

function pietra(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 1 / (2 * inp.n) * sum(abs (inp.conf_mat :- (inp.n_1_plus' * inp.n_plus_1) :/ inp.n))
	}
	return(value)
}

// NEW METRICS FROM TODO LIST #5'

function sdai(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = sqrt(1 :/ (inp.n - 1) :* (inp.n_11 :+ inp.n_22 :- (inp.n_11 :- inp.n_22):^2 :/ inp.n))
	}
	return(value)
}

function gen_fleiss_arithmetic_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2)
	}
	return(value)
}

function gen_fleiss_arithmetic_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 2 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/
			(inp.n_1_plus :* inp.n_plus_2 :+ inp.n_plus_1 :* inp.n_2_plus)
	}
	return(value)
}

function gen_fleiss_contraharmonic_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				(inp.n_1_plus :* inp.n_2_plus :+ inp.n_plus_1 :* inp.n_plus_2) :/
			( (inp.n_1_plus :* inp.n_2_plus):^2 :+ (inp.n_plus_1 :* inp.n_plus_2):^2 )
	}
	return(value)
}

function gen_fleiss_contraharmonic_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				(inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2) :/
			( (inp.n_1_plus :* inp.n_plus_1):^2 :+ (inp.n_2_plus :* inp.n_plus_2):^2 )
	}
	return(value)
}

// 91. Generalized Fleiss (contraharmonic) #3
function gen_fleiss_contraharmonic_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( inp.n_1_plus :* inp.n_plus_2 :+ inp.n_plus_1 :* inp.n_2_plus ) :/
				( (inp.n_1_plus :* inp.n_plus_2):^2 :+
				  (inp.n_plus_1 :* inp.n_2_plus):^2 )
	}
	return(value)
}

// 92. Generalized Fleiss (harmonic) #1
function gen_fleiss_harmonic_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( inp.n_1_plus :* inp.n_2_plus :+ inp.n_plus_1 :* inp.n_plus_2 ) :/
				( 2 :* inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus )
	}
	return(value)
}

// 93. Generalized Fleiss (harmonic) #2
function gen_fleiss_harmonic_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2 ) :/
				( 2 :* inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus )
	}
	return(value)
}


// 94. Generalized Fleiss (harmonic) #3
function gen_fleiss_harmonic_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( inp.n_1_plus :* inp.n_plus_2 :+ inp.n_plus_1 :* inp.n_2_plus ) :/
				( 2 :* inp.n_1_plus :* inp.n_plus_1 :* inp.n_plus_2 :* inp.n_2_plus )
	}
	return(value)
}


// 95. Generalized Fleiss (Heronian) #1
function gen_fleiss_heronian_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		// a = n_1_plus * n_2_plus, b = n_plus_1 * n_plus_2
		temp_a = inp.n_1_plus :* inp.n_2_plus
		temp_b = inp.n_plus_1 :* inp.n_plus_2

		value = 3 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/
				( temp_a :+ sqrt(temp_a :* temp_b) :+ temp_b )
	}
	return(value)
}

// 96. Generalized Fleiss (Heronian) #2
function gen_fleiss_heronian_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_plus_1
		temp_b = inp.n_2_plus :* inp.n_plus_2

		value = 3 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/
				( temp_a :+ sqrt(temp_a :* temp_b) :+ temp_b )
	}
	return(value)
}

// 97. Generalized Fleiss (Heronian) #3
function gen_fleiss_heronian_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_plus_2
		temp_b = inp.n_2_plus :* inp.n_plus_1

		value = 3 :* (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :/
				( temp_a :+ sqrt(temp_a :* temp_b) :+ temp_b )
	}
	return(value)
}

// 98. Generalized Fleiss (Hölder) #1
// uses p = inp.fleiss_holder_p
function gen_fleiss_holder_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		p     = inp.fleiss_holder_p
		inv_p = 1 / p

		num = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :* (2 ^ inv_p)

		den = ( (inp.n_1_plus :* inp.n_2_plus) :^ p :+
		        (inp.n_plus_1 :* inp.n_plus_2) :^ p ) :^ inv_p

		value = num :/ den
	}
	return(value)
}

// 99. Generalized Fleiss (Hölder) #2
// uses p = inp.fleiss_holder_p
function gen_fleiss_holder_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		p     = inp.fleiss_holder_p
		inv_p = 1 / p

		num = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :* (2 ^ inv_p)

		den = ( (inp.n_1_plus :* inp.n_plus_1) :^ p :+
		        (inp.n_2_plus :* inp.n_plus_2) :^ p ) :^ inv_p

		value = num :/ den
	}
	return(value)
}

function gen_fleiss_holder_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		p     = inp.fleiss_holder_p
		inv_p = 1 / p

		num = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :* (2 ^ inv_p)

		den = ( (inp.n_1_plus :* inp.n_plus_2) :^ p :+
		        (inp.n_plus_1 :* inp.n_2_plus) :^ p ) :^ inv_p

		value = num :/ den
	}
	return(value)
}

function gen_fleiss_identric_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		a = inp.n_plus_1 :* inp.n_plus_2 :* log(inp.n_plus_1 :* inp.n_plus_2)
		b = inp.n_1_plus :* inp.n_2_plus :* log(inp.n_1_plus :* inp.n_2_plus)
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = exp(1) :* c :* exp((a :- b) :/ (inp.n_1_plus :* inp.n_2_plus :- inp.n_plus_1 :* inp.n_plus_2))
		v2 = c :/ (inp.n_1_plus :* inp.n_2_plus)
		use_v2 = ((inp.n_1_plus :* inp.n_2_plus) :== (inp.n_plus_1 :* inp.n_plus_2))
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}
//////////////////////////////////////////////////////////

// 102
function gen_fleiss_identric_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		a = inp.n_2_plus :* inp.n_plus_2 :* log(inp.n_2_plus :* inp.n_plus_2)
		b = inp.n_1_plus :* inp.n_plus_1 :* log(inp.n_1_plus :* inp.n_plus_1)
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = exp(1) :* c :* exp((a :- b) :/ (inp.n_1_plus :* inp.n_plus_1 :- inp.n_2_plus :* inp.n_plus_2))
		v2 = c :/ (inp.n_1_plus :* inp.n_plus_1)
		use_v2 = ((inp.n_1_plus :* inp.n_plus_1) :== (inp.n_2_plus :* inp.n_plus_2))
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 103
function gen_fleiss_identric_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		a = inp.n_plus_1 :* inp.n_2_plus :* log(inp.n_plus_1 :* inp.n_2_plus)
		b = inp.n_1_plus :* inp.n_plus_2 :* log(inp.n_1_plus :* inp.n_plus_2)
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = exp(1) :* c :* exp((a :- b) :/ (inp.n_1_plus :* inp.n_plus_2 :- inp.n_plus_1 :* inp.n_2_plus))
		v2 = c :/ (inp.n_1_plus :* inp.n_plus_2)
		use_v2 = ((inp.n_1_plus :* inp.n_plus_2) :== (inp.n_plus_1 :* inp.n_2_plus))
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 104
// uses p = inp.fleiss_lehmer_p (default 1.5)
function gen_fleiss_lehmer_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		p = inp.fleiss_lehmer_p
		temp_a = inp.n_1_plus :* inp.n_2_plus
		temp_b = inp.n_plus_1 :* inp.n_plus_2
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( temp_a :^ (p - 1) :+ temp_b :^ (p - 1) ) :/
				( temp_a :^ p :+ temp_b :^ p )
	}
	return(value)
}

// 105
// uses p = inp.fleiss_lehmer_p (default 1.5)
function gen_fleiss_lehmer_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		p = inp.fleiss_lehmer_p
		temp_a = inp.n_1_plus :* inp.n_plus_1
		temp_b = inp.n_2_plus :* inp.n_plus_2
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( temp_a :^ (p - 1) :+ temp_b :^ (p - 1) ) :/
				( temp_a :^ p :+ temp_b :^ p )
	}
	return(value)
}

// 106
// uses p = inp.fleiss_lehmer_p (default 1.5)
function gen_fleiss_lehmer_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		p = inp.fleiss_lehmer_p
		temp_a = inp.n_1_plus :* inp.n_plus_2
		temp_b = inp.n_plus_1 :* inp.n_2_plus
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :*
				( temp_a :^ (p - 1) :+ temp_b :^ (p - 1) ) :/
				( temp_a :^ p :+ temp_b :^ p )
	}
	return(value)
}

// 107
function gen_fleiss_logarithmic_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_2_plus
		temp_b = inp.n_plus_1 :* inp.n_plus_2
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = c :* (log(temp_a) :- log(temp_b)) :/ (temp_a :- temp_b)
		v2 = c :/ temp_a
		use_v2 = (temp_a :== temp_b)
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 108
function gen_fleiss_logarithmic_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_plus_1
		temp_b = inp.n_2_plus :* inp.n_plus_2
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = c :* (log(temp_a) :- log(temp_b)) :/ (temp_a :- temp_b)
		v2 = c :/ temp_a
		use_v2 = (temp_a :== temp_b)
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 109
function gen_fleiss_logarithmic_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_plus_2
		temp_b = inp.n_plus_1 :* inp.n_2_plus
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = c :* (log(temp_a) :- log(temp_b)) :/ (temp_a :- temp_b)
		v2 = c :/ temp_a
		use_v2 = (temp_a :== temp_b)
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}



// 110
function gen_fleiss_quadratic_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :* sqrt(2) :/
				sqrt( (inp.n_1_plus :* inp.n_2_plus):^2 :+ (inp.n_plus_1 :* inp.n_plus_2):^2 )
	}
	return(value)
}

// 111
function gen_fleiss_quadratic_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :* sqrt(2) :/
				sqrt( (inp.n_1_plus :* inp.n_plus_1):^2 :+ (inp.n_2_plus :* inp.n_plus_2):^2 )
	}
	return(value)
}

// 112
function gen_fleiss_quadratic_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = (inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21) :* sqrt(2) :/
				sqrt( (inp.n_1_plus :* inp.n_plus_2):^2 :+ (inp.n_plus_1 :* inp.n_2_plus):^2 )
	}
	return(value)
}

// 113
function gen_fleiss_seiffert_1(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_2_plus
		temp_b = inp.n_plus_1 :* inp.n_plus_2
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = c :* (4 :* atan(sqrt(temp_a :/ temp_b)) :- pi()) :/ (temp_a :- temp_b)
		v2 = c :/ temp_a
		use_v2 = (temp_a :== temp_b)
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 114
function gen_fleiss_seiffert_2(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_plus_1
		temp_b = inp.n_2_plus :* inp.n_plus_2
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = c :* (4 :* atan(sqrt(temp_a :/ temp_b)) :- pi()) :/ (temp_a :- temp_b)
		v2 = c :/ temp_a
		use_v2 = (temp_a :== temp_b)
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 115
function gen_fleiss_seiffert_3(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		temp_a = inp.n_1_plus :* inp.n_plus_2
		temp_b = inp.n_plus_1 :* inp.n_2_plus
		c = inp.n_11 :* inp.n_22 :- inp.n_12 :* inp.n_21
		v1 = c :* (4 :* atan(sqrt(temp_a :/ temp_b)) :- pi()) :/ (temp_a :- temp_b)
		v2 = c :/ temp_a
		use_v2 = (temp_a :== temp_b)
		value = v1
		for (i=1; i<=cols(value); i++) {
			if (use_v2[i]) {
				value[i] = v2[i]
			}
		}
	}
	return(value)
}

// 167
function mak_rho(struct MetricInputs scalar inp, type){
	if (type == "CTS") {
		den = 4 :* inp.n_11 :* inp.n_22 - (inp.n_12 + inp.n_21) :^ 2 + (inp.n_12 + inp.n_21)
		num = (inp.n_1_plus :+ inp.n_plus_1) :* (inp.n_2_plus :+ inp.n_plus_2) :- (inp.n_12 + inp.n_21)
		value = den :/ num
	}
	return(value)
}

// 164
function log_forbes(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = log((inp.n :* inp.n_11) :/ (inp.n_1_plus :* inp.n_plus_1))
	}
	else if (type == "CTS") {
		value = log((inp.n :* (inp.n_11 :+ inp.n_22)) :/ (inp.n_1_plus :* inp.n_plus_1 :+ inp.n_2_plus :* inp.n_plus_2))
	}
	return(value)
}

function merton_CP(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = 1 / (cols(inp.conf_mat) - 1) * (sum(inp.n_11 :/ inp.n_plus_1) - 1)
	}
	return(value)
}

function hubert_arabie(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		A = sum(inp.conf_mat :* (inp.conf_mat :- 1) :/ 2)

		rowSum = rowsum(inp.conf_mat)
		colSum = colsum(inp.conf_mat)'

		B = sum(rowSum :* (rowSum :- 1) :/ 2)
		C = sum(colSum :* (colSum :- 1) :/ 2)

		D = inp.n * (inp.n - 1) / 2

		num = A :- (B :* C) :/ D
		den = 0.5 :* (B :+ C) :- (B :* C) :/ D

		value = num :/ den
	}
	return(value)
}

function neg_pred_value(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_22 :/ inp.n_2_plus
	}
	return(value)
}

function discriminant_power(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = sqrt(3) :/ pi() :* log(inp.n_11 :* inp.n_22 :/ (inp.n_12 :* inp.n_21))
	}
	return(value)
}

function goodman_unweighted_assc(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 1 :/ 4 :* log(inp.n_11 :* inp.n_22 :/ (inp.n_12 :* inp.n_21))
	}
	return(value)
}

function specificity(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_22 :/ inp.n_plus_2
	}
	return(value)
}

function hellinger_distance(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 2 :* sqrt(1 :- inp.n_11 :/ sqrt(inp.n_1_plus :* inp.n_plus_1))
	}
	return(value)
}

function johnson(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = inp.n_11 :/ inp.n_1_plus :+ inp.n_11 :/ inp.n_plus_1
	}
	return(value)
}

function predicted_negative_rate(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_2_plus :/ inp.n
	}
	return(value)
}

function error_rate(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 1 - 1 / inp.n * sum(inp.n_11)
	}
	return(value)
}

function balanced_error_rate(struct MetricInputs scalar inp, type) {
	if (type == "CS") {
		value = 1 - 1 / cols(inp.conf_mat) * sum(inp.n_11 :/ inp.n_plus_1)
	}
	return(value)
}

function van_rijsbergen(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		a = inp.ealpha
		value = (a :* inp.n_12 :+ (1 - a) :* inp.n_21) :/ (inp.n_11 :+ a :* inp.n_12 :+ (1 - a) :* inp.n_21)
	}
	return(value)
}

function replacement_comp_j(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 2 :* colmin(inp.n_12 \ inp.n_21) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	return(value)
}

function replacement_comp_s(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = 2 :* colmin(inp.n_12 \ inp.n_21) :/ (2 :* inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	return(value)
}

function replacement_comp_b(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = colmin(inp.n_12 \ inp.n_21) :/ (inp.n_11 :+ colmax(inp.n_12 \ inp.n_21))
	}
	return(value)
}

function richness_diff_j(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = abs(inp.n_12 :- inp.n_21) :/ (inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	return(value)
}

function richness_diff_s(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = abs(inp.n_12 :- inp.n_21) :/ (2 :* inp.n_11 :+ inp.n_12 :+ inp.n_21)
	}
	return(value)
}

function richness_diff_b(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = abs(inp.n_12 :- inp.n_21) :/ (inp.n_11 :+ colmax(inp.n_12 \ inp.n_21))
	}
	return(value)
}

function batagelj_bren(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = inp.n_12 :* inp.n_21 :/ (inp.n_11 :* inp.n_22)
	}
	return(value)
}

function theil_sym(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = -2 * sum(inp.conf_mat :* log(inp.conf_mat :* inp.n :/ (inp.n_1_plus' * inp.n_plus_1))) / (sum(inp.n_1_plus :* log(inp.n_1_plus :/ inp.n)) + sum(inp.n_plus_1 :* log(inp.n_plus_1 :/ inp.n)))
	}
	return(value)
}

function root_mean_sq_diff(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = sqrt((inp.n_12 :+ inp.n_21) :/ inp.n)
	}
	return(value)
}

function mantel_haenszel(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		idx = (1..cols(inp.conf_mat))
		num = (sum((idx' * idx) :* inp.conf_mat) -
			   (sum(idx :* inp.n_1_plus) * sum(idx :* inp.n_plus_1)) / inp.n)^2
		row_term = sum((idx:^2) :* inp.n_1_plus) -
				   (sum(idx :* inp.n_1_plus)^2) / inp.n
		col_term = sum((idx:^2) :* inp.n_plus_1) -
				   (sum(idx :* inp.n_plus_1)^2) / inp.n
		value = num / ((1 / (inp.n - 1)) * row_term * col_term)
	}
	return(value)
}

function mueller_schuessler(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		K = cols(inp.conf_mat)
		value = K / (K - 1) * (1 - sum((inp.n_plus_1 :/ inp.n):^2))
	}
	return(value)
}

function gini_impurity(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = 1 - sum((inp.n_plus_1 :/ inp.n):^2)
	}
	return(value)
}

function renkonen(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = 1 :- abs(inp.n_11 :/ inp.n_1_plus :- inp.n_21 :/ inp.n_2_plus)
	}
	return(value)
}

function kent_foster_1(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = - inp.n_12 :* inp.n_21 :/ (inp.n_12 :* inp.n_1_plus :+ inp.n_21 :* inp.n_plus_1 :+ inp.n_12 :* inp.n_21)
	}
	return(value)
}

function kent_foster_2(struct MetricInputs scalar inp, type) {
	if (type == "TS") {
		value = - inp.n_12 :* inp.n_21 :/ (inp.n_12 :* inp.n_2_plus :+ inp.n_21 :* inp.n_plus_2 :+ inp.n_12 :* inp.n_21)
	}
	return(value)
}

function freeman_tukey_statistic(struct MetricInputs scalar inp, type) {
	if (type == "CTS") {
		value = 4 * sum((sqrt(inp.conf_mat) :+ sqrt(inp.conf_mat :+ 1) :- sqrt(4 :* (inp.n_1_plus' * inp.n_plus_1) :/ inp.n :+ 1)):^2)
	}
	return(value)
}

function false_omission_rate(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_21 :/ inp.n_2_plus
	}
	return(value)
}

function false_positive_rate(struct MetricInputs scalar inp, type) {
	if (type == "AS") {
		value = inp.n_12 :/ inp.n_plus_2
	}
	return(value)
}
















end