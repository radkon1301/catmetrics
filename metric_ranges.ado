version 18.5
mata

//#1
function accuracy_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#2
function added_value_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(-1 + 1/n, 0.01))
        hi = strofreal(round(1 - 1/n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#3
function adjusted_noise_to_signal_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8592) + " 1 " + uchar(8592) + " " + hi + "]")
    }
    return("")
}

//#4
function alroy_corrected_forbes_F_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#5
function ample_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#6
function anderberg_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#7
function anderberg_D_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 0.5]")
    }
    return("")
}

//#8
function appleman_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        lo = strofreal(round(-n + 1, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#9
function atkinson_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#10
function goodall_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#11
function balanced_accuracy_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 0.5 " + uchar(8594) + " 1]")
    }
    return("")
}

//#12
function baroni_urbani_buser_one_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#13
function baroni_urbani_buser_two_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#14
function base_rate_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 (never), 1 (always)]")
    }
    return("")
}

//#19
function benini_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-n + 2, 0.01))
        return("[" + lo + " " + uchar(8592) + " 0 " + uchar(8592) + " 2]")
    }
    return("")
}

//#20
function benini_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n + 1, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#34
function benini_3_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(-n + 1, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#35
function benini_4_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(-n + 1, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#21
function bennett_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-1/(K - 1), 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#22
function berger_parker_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(1/K^2, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#23
function bias_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(n, 0.01))
        return("[0 " + uchar(8594) + " 1 " + uchar(8592) + " " + hi + "]")
    }
    return("")
}

//#24
function blaheta_johnson_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		lo = strofreal(round(2*log(2/(n-2)) - 3.29 * sqrt(2 + 4/(n-2)), 0.01))
		hi = strofreal(round(2*log(n/2 - 1) - 3.29 * sqrt(2 + 4/(n-2)), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#25
function braun_blanquet_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#26
function bray_curtis_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(1/K^2, 0.01))
        return("[" + lo + " (con), 1 (uni)]")
    }
    return("")
}

//#27
function brin_conviction_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(1/n, 0.01))
        hi = strofreal(round(n/4 + 1/2, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#28
function causal_confidence_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#29
function causal_confidence_confirmed_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#30
function causal_confirm_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-2 " + uchar(8594) + " 1]")
    }
    return("")
}

//#32
function clayton_skill_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#33
function clement_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        hi = strofreal(round(n, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#36
function cole_c5_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

function galton_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
}

//#37
function collective_strength_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("(-" + uchar(8734) + ", " + uchar(8734) + ")")
    }
    return("")
}

//#39
function confirm_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#40
function consonni_todeschini_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#41
function consonni_todeschini_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#42
function consonni_todeschini_3_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#43
function consonni_todeschini_4_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#44
function consonni_todeschini_5_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#45
function coverage_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 (never), 1 (always)]")
    }
    return("")
}

//#46
function cramer_concordance_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#47
function cressie_read_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		lambda = inp.crlambda
		if (lambda == 0) {
			return(likelihood_ratio_R(n, K, type, inp))
		}
		else if (lambda == -1) {
			return(mdis_R(n, K, type, inp))
		}
		else if (lambda == 1) {
			return(pearson_chi2_R(n, K, type, inp))
		}
		else if (abs(lambda - 2/3) < 1e-9) {
			hi = strofreal(round(2*n/(lambda*(lambda+1)) * (K^lambda - 1), 0.01))
			return("[0 " + uchar(8594) + " " + hi + "]")
		}
		return("")
    }
    return("")
}

//#48
function dennis_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-sqrt(n)/2, 0.01))
        hi = strofreal(round((n - 1)/sqrt(n), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#49
function dependency_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(1 - 1/n, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#50
function digby_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#51
function discrimination_distance_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		lo = strofreal(round(invnormal(2/n) - invnormal((n-2)/n), 0.01))
		hi = strofreal(round(invnormal((n-2)/n) - invnormal(2/n), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#52
function dominance_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8592) + " 1]")
    }
    return("")
}

//#53
function donaldson_bias_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8592) + " 1]")
    }
    return("")
}

//#54
function doolittle_association_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		hi = strofreal(round(K - 1, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#55
function doolittle_raw_accuracy_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#56
function driver_kroeber_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#57
function ex_and_counterex_rate_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(-n + 2, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#58
function extremal_dependence_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#59
function extreme_dependency_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#60
function eyraud_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n^2/(n - 1), 0.01))
        hi = strofreal(round(n^2/(n - 1), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#61
function fager_mcgowan_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-1/2, 0.01))
        hi = strofreal(round(1 - 1/(2*sqrt(n)), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#62
function fager_mcgowan_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(1 - n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#63
function faith_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#64
function false_alarm_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8592) + " 1]")
    }
    return("")
}

//#65
function false_negative_rate_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8592) + " 1]")
    }
    return("")
}

//#66
function fisher_exact_statistic_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#69
function forbes_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        hi = strofreal(round(n, 0.01))
        return("[0 " + uchar(8594) + " 1 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#68
function forbes_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(1 - n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#70
function freeman_tukey_statistic_as_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(8*n*(1 - 1/sqrt(K)), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#71
function f_score_adjusted_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#72
function czekanowski_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#73
function f_b_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#74
function ganascia_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#75
function gerrity_skill_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#76
function gilbert_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#77
function gilbert_skill_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		lo = strofreal(round(-1/3, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#78
function gilbert_wells_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		lo = strofreal(round(ln(8/(pi()*n)) + 2 * ( lngamma(n+1) + 4*lngamma(n/4 + 1) - 4*lngamma(n/2 + 1) ), 0.01))
		hi = strofreal(round(ln(8/(pi()*n)) + 2 * ( lngamma(n+1) - 2*lngamma(n/2 + 1) ), 0.01))
        //lo = strofreal(round(log(4/(n + 2))/log(2), 0.01))
        //hi = strofreal(round(log(n)/log(2), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#80
function gini_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#81
function gini_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#82
function g_mean_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#83
function g_mean_adjusted_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#84
function goodman_concomitance_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n*sqrt(n/2), 0.01))
		t_star = 0.434976
		hi = strofreal(round((2*(1-t_star)*sqrt(t_star) + t_star*sqrt(1-t_star))*n*sqrt(n), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#85
function goodman_kruskal_gamma_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#86
function goodman_kruskal_lambda_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#87
function goodman_kruskal_lambda_w_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#88
function goodman_kruskal_lambda_r_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        lo = strofreal(round(1 - n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#89
function goodman_kruskal_tau_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#90
function goodman_kruskal_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#92
function goodman_kruskal_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#93
function goodman_weighted_association_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n^2 * log(n/2 - 1) / 2, 0.01))
        hi = strofreal(round(n^2 * log(n/2 - 1) / 2, 0.01))
        return("[" + lo + " "+ uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#94
function gorodkin_Rk_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#95
function gray_orlowska_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		lo = -1
		if (inp.goalpha == 0) {
			return("[0 ... 0]")
		}
		else if (inp.gobeta < inp.goalpha) {
			hi = strofreal(round((1/inp.n)^(inp.gobeta - inp.goalpha) - (1/inp.n)^inp.gobeta, 0.01))
		}
		else if (inp.gobeta == inp.goalpha) {
			hi = "1"
		}
		else {
			x = ((inp.gobeta - inp.goalpha) / inp.gobeta)^(1/inp.goalpha)
			hi = strofreal(round(x^(inp.gobeta - inp.goalpha) - x^inp.gobeta, 0.01))
		}
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "] (cl)")
    }
    return("")
}

//#96
function grier_B_bias_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8592) + " 1]")
    }
    return("")
}

//#97
function guttman_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#98
function hamann_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#99
function harris_lahey_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(n, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#100
function hawkins_dotson_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#101
function heidke_skill_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

function cohen_pi_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}


//#102
function hit_rate_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#103
function hoeffding_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#104
function hoeffding_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#105
function iba_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		if (inp.ibam == 125) {
			if (inp.ibaalpha <= 0.5) {
				return("[0 " + uchar(8594) + " 1]")
			}
			else {
				x = (1 + inp.ibaalpha) / (3 * inp.ibaalpha)
				hi = strofreal(round((1 + inp.ibaalpha * (1 - x)) * sqrt(x), 0.01))
				return("[0 " + uchar(8594) + " " + hi + "]")
			}
		}
		else {
			return("range dependent on M")
		}
    }
    return("")
}

//#106
function information_quality_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#108
function j_measure_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		t = 0.365
		hi = strofreal(round(1/n * log(1 / ((1 - t) * (t*n + 1))) + t * log(n / (t*n + 1)), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "] (au)")
    }
    return("")
}

//#109
function kendall_tau_a_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-n*(K-1)/((n-1)*K), 0.01))
        hi = strofreal(round(n*(K-1)/((n-1)*K), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#110
function kendall_tau_b_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#111
function kendall_tau_c_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#112
function kitamura_matsumoto_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(log(2/(n + 1))/log(2), 0.01))
        hi = strofreal(round(log(n)/log(2), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#113
function klosgen_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		lo = strofreal(round(-4/27, 0.01))
		hi = strofreal(round(2/3 * sqrt(1/3), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#114
function koppen_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		if (K == 2) {
			return("[0.5 " + uchar(8594) + " 1]")
		}
		else {
			return("[0 " + uchar(8594) + " 1]")
		}
    }
    return("")
}

//#115
function krippendorff_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-1 + 1/n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#116
function kuder_richardson_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n*(n - 2)/(n - 1), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#117
function kuhns_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-1/2, 0.01))
        hi = strofreal(round(1 - 1/n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#118
function kuhns_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-(n - 2)*n*(n + 2)/(4*(2 + 3*n)), 0.01))
		hi = strofreal(round(35 * n / 204, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#119
function kulczynski_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#120
function kulczynski_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#121
function lakshmanamurti_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(2 - n/2, 0.01))
        hi = strofreal(round(1 - 2/(n - 2), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#122
function laplace_correction_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(1/(n + 2), 0.01))
        hi = strofreal(round((n + 1)/(n + 2), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#123
function least_contradiction_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(1 - n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#124
function lerman_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(-sqrt(n)/2, 0.01))
        hi = strofreal(round((n - 1)/sqrt(n), 0.01))
        return("[" + lo + " " + uchar(8592) + " 0 " + uchar(8592) + " " + hi + "]")
    }
    return("")
}

//#125
function leverage_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-1/4, 0.01))
        hi = strofreal(round(1/4, 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#126
function likelihood_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(2*n*log(K), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#130
function log_freq_biased_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(log(4/(n^2*(n + 2))), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0]")
    }
    return("")
}

//#131
function log_odds_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-2*log(n/2 - 1), 0.01))
        hi = strofreal(round(2*log(n/2 - 1), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#132
function log_odds_ratio_amended_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-2*log(n + 1), 0.01))
        hi = strofreal(round(2*log(n + 1), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#133
function maron_kuhns_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n/4, 0.01))
        hi = strofreal(round(n/4, 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#134
function maxwell_pilliner_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#135
function michael_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#136
function mcconnaughey_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#138
function mdis_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		a = (n-K^2)/2 + 1
		b = a + K - 1
		s1 = 4 * (b^2 / n * log(b^2 / (a*n)) + b^2 / n * log(b^2 / n))
		s2 = 8 * (K - 2) * (b * K / n * log(b * K / n))
		s3 = 2 * (K - 2)^2 * (K^2 / n * log(K^2 / n))
        hi = strofreal(round(s1 + s2 + s3, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#139
function mountford_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 2]")
    }
    return("")
}

//#140
function mutual_dependency_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-log(n/2*(n/2+1)), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0]")
    }
    return("")
}

//#141
function mutual_information_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round((K^2 - K)/n * log(K^2/n) + (n - K^2 + K)/n * log((K*n - K^2*(K - 1))/n), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#142
function neg_likelihood_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8592) + " 1 " + uchar(8592) + " " + hi + "]")
    }
    return("")
}

//#143
function neyman_modified_chi2_statistic_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		a = (n - K^2) / 2 + 1
		b = a + K - 1
		s1 = 2/a * (a - b^2 / n)^2
		s2 = 2 * (1 - b^2 / n)^2
		s3 = 4 * (K - 2) * (1 - b * K / n)^2
		s4 = (K - 2)^2 * (1 - K^2 / n)^2
        hi = strofreal(round(s1 + s2 + s3 + s4, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#144
function norm_google_dist_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(-log(n - 1)/log(n), 0.01))
        hi = strofreal(round(log(n - 1)/(log(n) - log(n - 1)), 0.01))
        return("[" + lo + " " + uchar(8592) + " " + hi + "]")
    }
    return("")
}

//#145
function odds_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round((n/2 - 1)^2, 0.01))
        return("[0 " + uchar(8594) + " 1 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#146
function odds_ratio_amended_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(1/(n + 1)^2, 0.01))
        hi = strofreal(round((n + 1)^2, 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#147
function optimized_precision_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        lo = strofreal(round(-1 + 1/n, 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#148
function pearson_contingency_c_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(sqrt((K - 1)/K), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#149
function pearson_phi_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		hi = strofreal(round(sqrt(K - 1), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#150
function pearson_heron_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#151
function pearson_chi2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(n*(K - 1), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#152
function peirce_skill_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#154
function poisson_stirling_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		lo = 9999
		for (x=1; x<=colmin(n \ 1000); x++) {
			v = x * (log(x) + log(x^2 / n) - 1)
			if (v > lo) {
				x = 1000
			}
			else {
				lo = v
				if (x == 1000) {
					errprintf("WARNING: lower bound for Poisson-Stirling (152) range may be inaccurate (extremely large n).")
				}
			}
		}
		lo = strofreal(round(lo, 0.01))
        hi = strofreal(round(n*(2*log(n) - 1), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#155
function pollack_norman_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		mid = strofreal(round(1/2, 0.01))
        return("[0 " + uchar(8594) + " " + mid + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#156
function pollaczek_geiringer_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#157
function pos_likelihood_ratio_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8594) + " 1 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#158
function positive_matching_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        hi = strofreal(round((n - 1)*log(n/(n - 1)), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#159
function precision_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#160
function prevalence_threshold_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		mid = strofreal(round(1/2, 0.01))
        return("[0 " + uchar(8592) + " " + mid + " " + uchar(8592) + " 1]")
    }
    return("")
}

//#161
function putative_causal_dependency_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round((7 - 3*n)/(2*n) - 2, 0.01))
        hi = strofreal(round(2 - 1/(2*n), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#162 - used to be called quetelet_1
function relative_risk_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8594) + " 1 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#163 - used to be called quetelet_2
function relative_quetelet_index_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#166
function rogers_tanimoto_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#167
function rogot_goldberg_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(K/2, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#168
function rousseau_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 3]")
    }
    return("")
}

//#169
function roux_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#170
function roux_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-1 + 4/n, 0.01))
        hi = strofreal(round(n/(n - 1), 0.01))
        return("[" + lo + " " + uchar(8592) + " " + hi + "]")
    }
    return("")
}

//#171
function russell_rao_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#172
function schrank_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        lo = strofreal(round(-n^2, 0.01))
        hi = strofreal(round(n^2/2, 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#173
function scott_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#174
function scott_pi_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

function fleiss_kappa_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}


//#175
function sebag_schoenauer_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#176
function simple_matching_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#177
function sokal_sneath_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#178
function sokal_sneath_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(n - 1, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#179
function sokal_sneath_3_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		mid = strofreal(round(1/2, 0.01))
        return("[0 " + uchar(8594) + " " + mid + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#180
function sokal_sneath_4_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#181
function sokal_sneath_5_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#182
function somers_d_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#183
function sorensen_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#184
function steffensen_psi2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#185
function steffensen_omega_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#186
function stiles_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		lo = strofreal(round(log(4)/log(10) - 3 * log(n) / log(10), 0.01))
        hi = strofreal(round(log(16)/log(10) + 2*log(n^2/4 - n/2)/log(10) - 3*log(n)/log(10), 0.01))
        return("[" + lo + " " + uchar(8594) + " " + hi + "] (cl)")
    }
    return("")
}

//#187
function success_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        hi = strofreal(round((n - 1)/(n + 1), 0.01))
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#188
function szymkiewicz_simpson_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#189
function tarantula_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		mid = strofreal(round(1/2, 0.01))
        return("[0 " + uchar(8594) + " " + mid + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#190
function theil_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#191
function tonnies_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		if (K == 2) {
			return("[-1 " + uchar(8594) + " 1]")
		}
		else {
			return("[-2 " + uchar(8594) + " 2]")
		}
    }
    return("")
}

//#192
function tschuprow_t_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#193
function tschuprow_t_bias_corrected_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#194
function t_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round(1/2 - n/4, 0.01))
        hi = strofreal(round(2/3*sqrt(n/3), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#195
function tulloss_r_cost_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#196
function tulloss_s_cost_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        lo = strofreal(round((log(2 + n/2)/log(2))^(-1/2), 0.01))
        return("[" + lo + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#197
function tulloss_u_cost_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#198
function tulloss_t_combined_costs_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#199
function two_afc_1_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CS") {
		mid = strofreal(round(1/2, 0.01))
        return("[0 " + uchar(8594) + " " + mid + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#200
function two_afc_2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
		mid = strofreal(round(1/2, 0.01))
        return("[0 " + uchar(8594) + " " + mid + " " + uchar(8594) + " 1]")
    }
    return("")
}

//#201
function upholt_s_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#202
function van_der_maarel_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

//#203
function warrens_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

// XXX v
//#204
function weighted_kappa_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		if (K == 2 | all(inp.kweights_mat :== I(K)) | !inp.custom_kweights) {
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
		else {
			return("[-" + uchar(8734) + " " + uchar(8594) + " 0 " + uchar(8594) + " 1] (cl)")
		}
    }
    return("")
}
// XXX ^

//#206
function woodcock_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#207
function zhang_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#208
function yao_liu_one_way_support_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        lo = strofreal(round(1/3*log(n/(3*(n - 2)))/log(2), 0.01))
        hi = strofreal(round(log(n)/log(2), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#209
function yao_liu_two_way_support_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
		lo = strofreal(round(1/6 * log(24/49) / log(2), 0.01))
		hi = strofreal(round(11/30 * log(30/11) / log(2), 0.01))
        return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#210
function yao_liu_two_way_support_v_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(2/n*log(4/n)/log(2) + (n - 2)/n*log((2*n - 4)/n)/log(2), 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#211
function yates_chi2_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        hi = strofreal(round(n*(1 - 2/n)^2, 0.01))
        return("[0 " + uchar(8594) + " " + hi + "]")
    }
    return("")
}

//#212
function yule_colligation_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#213
function yule_phi_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

//#214
function yule_q_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
    }
    return("")
}

// NEW METRICS FROM TODO LIST #4

function fossum_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		lo = strofreal(round(n / (n+1)^2, 0.01))
		hi = strofreal(round((n - 1/2)^2 / n, 0.01))
		return("[" + lo + " " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function p4_score_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
        return("[-1 " + uchar(8594) + " 1]")
    }
    return("")
}

function sokal_sneath_6_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "TS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

function maxwell_B_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		if (K == 2) {
			if (mod(n, 4) == 0) {
				lo = strofreal(round(-n/2 + 1, 0.01))
				hi = strofreal(round(n/2 - 1, 0.01))
			}
			else if (mod(n, 4) == 1) {
				lo = strofreal(round(-n+2, 0.01))
				hi = strofreal(round(n, 0.01))
			}
			else if (mod(n, 4) == 2) {
				lo = strofreal(round(-n/2, 0.01))
				hi = strofreal(round(n/2, 0.01))
			}
			else {
				lo = strofreal(round(-n, 0.01))
				hi = strofreal(round(n-2, 0.01))
			}
		}
		else {
			x = round(n/K)
			m = 9999
			M = -9999
			for (i=x-2; i<=x+2; i++) {
				v = (-n^2 / K) / (n*i - n^2/K)
				if (v < m & v != .) {
					m = v
				}
				if (v > M & v != .) {
					M = v
				}
			}
			lo = strofreal(round(m, 0.01))
			hi = strofreal(round(M, 0.01))
		}
		return("[" + lo + " " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function gower_legendre_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
        return("[0 " + uchar(8594) + " 1]")
    }
    return("")
}

function pattern_difference_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function shape_difference_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function size_difference_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function chord_distance_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		hi = strofreal(round(sqrt(2), 0.01))
		return("[0 " + uchar(8592) + " " + hi + "]")
	}
	return("")
}

function baulieu_13_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_22_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		lo = strofreal(round(-(n/3 + 1/2)*(2*n/3 + 1/2)*2*inp.baulieu_kappa/3, 0.01))
		return("[" + lo + " " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_23_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		lo = strofreal(round(1/(n+1), 0.01))
		return("[" + lo + " " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_24_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		hi = strofreal(round(1 - 1/(n+1), 0.01))
		return("[0 " + uchar(8592) + " " + hi + "]")
	}
	return("")
}

function baulieu_25_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_27_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_28_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_29_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_30_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 2]")
	}
	return("")
}

function baulieu_31_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_32_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function baulieu_33_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function tversky_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function variance_dissimilarity_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "CTS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function fleiss_levin_paik_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function pietra_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		hi = strofreal(round(1 - 1/K, 0.01))
		return("[0 " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

// NEW METRICS FROM TODO LIST #5

function sdai_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		hi = strofreal(round(sqrt(n / (n - 1)), 0.01))
		return("[0 " + uchar(8594) + " " + hi + "]")
	}
}

function gen_fleiss_arithmetic_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_arithmetic_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_contraharmonic_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_contraharmonic_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_contraharmonic_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_harmonic_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_harmonic_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		hi = strofreal(round(1/(2*(n-1)) + (n-1)/2, 0.01))
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function gen_fleiss_harmonic_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		lo = strofreal(round(-1/(2*(n-1)) - (n-1)/2, 0.01))
		return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_heronian_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_heronian_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_heronian_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_holder_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_holder_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		p = inp.fleiss_holder_p
		if (p > 0) {
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
		else if (p < 0) {
			hi = strofreal(round((n - 1) * 2^(1/p) / (1 + (n - 1)^(2*p))^(1/p), 0.01))
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
		}
	}
	return("")
}

function gen_fleiss_holder_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		p = inp.fleiss_holder_p
		if (p > 0) {
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
		else if (p < 0) {
			lo = strofreal(round(-(n - 1) * 2^(1/p) / (1 + (n - 1)^(2*p))^(1/p), 0.01))
			return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
	}
	return("")
}

function gen_fleiss_identric_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}


////////////////////////////////

function gen_fleiss_identric_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_identric_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_lehmer_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_lehmer_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		p = inp.fleiss_lehmer_p
		if (p >= 0.5) {
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
		else {
			hi = strofreal(round((n-1) * (1 + (n-1)^(2*(p-1))) / (1 + (n-1)^(2*p)), 0.01))
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " " + hi + "]")
		}
	}
	return("")
}

function gen_fleiss_lehmer_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		p = inp.fleiss_lehmer_p
		if (p >= 0.5) {
			return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
		else {
			lo = strofreal(round(-(n-1) * (1 + (n-1)^(2*(p-1))) / (1 + (n-1)^(2*p)), 0.01))
			return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
		}
	}
	return("")
}
function gen_fleiss_logarithmic_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}
function gen_fleiss_logarithmic_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}
function gen_fleiss_logarithmic_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

// 110
function gen_fleiss_quadratic_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_quadratic_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_quadratic_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_seiffert_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_seiffert_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gen_fleiss_seiffert_3_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function mak_rho_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[-1 " + uchar(8594) + " 1]")
	}
	return("")
}

function log_forbes_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		lo = strofreal(round(log(4*n / (n+1)^2), 0.01))
		hi = strofreal(round(log(n), 0.01))
		return("[" + lo + " " + uchar(8594) + " " + hi +"]")
	}
	return("")
}

function merton_CP_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CS") {
		lo = strofreal(round(-1 / (K-1), 0.01))
		return("[" + lo + " " + uchar(8594) + " 0 " + uchar(8594) + " 1]")
	}
	return("")
}

function hubert_arabie_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		lo = strofreal(round(-1/2, 0.01))
		return("[" + lo + " " + uchar(8594) + " 1] (cl)")
	}
	return("")
}

function neg_pred_value_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function discriminant_power_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		lo = strofreal(round(-2 * sqrt(3) / pi() * log(n/2 - 1), 0.01))
		hi = strofreal(round(2 * sqrt(3) / pi() * log(n/2 - 1), 0.01))
		return("[" + lo + " " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function goodman_unweighted_assc_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		lo = strofreal(round(-1 / 2 * log(n/2 - 1), 0.01))
		hi = strofreal(round(1 / 2 * log(n/2 - 1), 0.01))
		return("[" + lo + " " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function specificity_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function hellinger_distance_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 2]")
	}
	return("")
}

function johnson_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8594) + " 2]")
	}
	return("")
}

function predicted_negative_rate_R(n, K, type, struct MetricInputs scalar inp) {
    if (type == "AS") {
        return("[0 (never), 1 (always)]")
    }
    return("")
}

function error_rate_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function balanced_error_rate_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CS") {
		return("[0 " + uchar(8592) + " 0.5 " + uchar(8592) + " 1]")
	}
	return("")
}

function van_rijsbergen_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function replacement_comp_j_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function replacement_comp_s_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function replacement_comp_b_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function richness_diff_j_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function richness_diff_s_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function richness_diff_b_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function batagelj_bren_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		hi = strofreal(round((n/2 - 1)^2, 0.01))
		return("[0 " + uchar(8592) + " 1 " + uchar(8592) + " " + hi + "]")
	}
	return("")
}

function theil_sym_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function root_mean_sq_diff_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function mantel_haenszel_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		hi = strofreal(round(n - 1, 0.01))
		return("[0 " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function mueller_schuessler_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8594) + " 1]")
	}
	return("")
}

function gini_impurity_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		hi = strofreal(round(1 - 1/K, 0.01))
		return("[0 " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function renkonen_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function kent_foster_1_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		lo = strofreal(round(-1/3, 0.01))
		return("[" + lo + " " + uchar(8594) + " 0]")
	}
	return("")
}

function kent_foster_2_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "TS") {
		lo = strofreal(round(-1/3, 0.01))
		return("[" + lo + " " + uchar(8594) + " 0]")
	}
	return("")
}

function freeman_tukey_statistic_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "CTS") {
		lo = strofreal(round(4 * (sqrt(n) + sqrt(n+1) - sqrt(4*n+1))^2, 0.01))
		hi = strofreal(round(4 * (K*(sqrt(n/K) + sqrt(n/K+1) - sqrt(4*n/K^2+1))^2 + K*(K-1)*(1-sqrt(4*n/K^2+1))^2), 0.01))
		return("[" + lo + " " + uchar(8594) + " " + hi + "]")
	}
	return("")
}

function false_omission_rate_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

function false_positive_rate_R(n, K, type, struct MetricInputs scalar inp) {
	if (type == "AS") {
		return("[0 " + uchar(8592) + " 1]")
	}
	return("")
}

end