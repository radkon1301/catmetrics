capture program drop catmetrics
program catmetrics, rclass
	version 18.5
	capture syntax varlist(min=1 max=2) [, PROBS(varlist) PREDict POWER(real 1.5) PSEUDOspherical(real 1.5) FBETA(real 1.5) GOALPHA(real 2) GOBETA(real 2) IBAALPHA(real 0.5) SOKALW(real 3) GLTHETA(real 1.5) BKAPPA(real -9999) TALPHA(real -9999) TBETA(real -9999) GFHOLDERP(real 0.5) GFLEHMERP(real 1.5) ECEQ(real 1) ECEM(real 10) GAINK(real 0.1) LIFTK(real 0.1) MCEQ(real 1) MCEM(real 10) EALPHA(real 0.5) IBAM(real 125) CRLAMBDA(real -9999) KWEIGHTS(string) METRICS(string) EXCEL(string) NOEXCEL CLASSMETrics SYMMETRIC] // KONRAD (20)

	if _rc {
		capture syntax[, MAT(string) POWER(real 1.5) PSEUDOspherical(real 1.5) FBETA(real 1.5) GOALPHA(real 2) GOBETA(real 2) IBAALPHA(real 0.5) SOKALW(real 3) GLTHETA(real 1.5) BKAPPA(real -9999) TALPHA(real -9999) TBETA(real -9999) GFHOLDERP(real 0.5) GFLEHMERP(real 1.5) ECEQ(real 1) ECEM(real 10) GAINK(real 0.1) LIFTK(real 0.1) MCEQ(real 1) MCEM(real 10) EALPHA(real 0.5) IBAM(real 125) CRLAMBDA(real -9999) KWEIGHTS(string) METRICS(string) EXCEL(string) NOEXCEL CLASSMETrics SYMMETRIC]
		if _rc { 
			noisily display as err "Wrong input given. Please consult the help file for the correct way of input."
		}
		else{
			if "`noexcel'" != "noexcel" {
				mata: excel = xl()
				if `"`excel'"' == "" {
					local excel "Catmetrics"
				}
				capture mata: excel.create_book("`excel'", "Probabilistic scores")
				mata: excel.load_book("`excel'")
				capture mata: excel.add_sheet("Probabilistic scores")
				capture mata: excel.add_sheet("Association measures")
				mata: excel.close_book()
			}
		
			mata: catmetrics("Contingency", "Contingency", "`power'", "`pseudospherical'", "`fbeta'", "`goalpha'", "`gobeta'", "`ibaalpha'", "`sokalw'", "`gltheta'", "`bkappa'", "`talpha'", "`tbeta'", "`gfholderp'", "`gflehmerp'", "`eceq'", "`ecem'", "`gaink'", "`liftk'", "`mceq'", "`mcem'", "`ealpha'", "`ibam'", "`crlambda'", "`kweights'", "`metrics'", "`mat'", "`excel'", "`noexcel'", "`classmetrics'", "`symmetric'")
		}
	}
	else{
		capture confirm numeric variable `varlist'
		if _rc { 
			noisily display as err "The variables are supposed to take on only numeric values."
			exit
		}
		
		if "`noexcel'" != "noexcel" {
			mata: excel = xl()
			if `"`excel'"' == "" {
				local excel "Catmetrics"
			}
			capture mata: excel.create_book("`excel'", "Probabilistic scores")
			mata: excel.load_book("`excel'")
			capture mata: excel.add_sheet("Probabilistic scores")
			capture mata: excel.add_sheet("Association measures")
			mata: excel.close_book()
		}

		if "`predict'" == "predict" {
			mata: y = st_data(., "`varlist'")
			mata: yunique = uniqrows(y)
			mata: ycount = rows(yunique) - any(rowmissing(yunique))
	
			mata: st_local("ycount", strofreal(ycount))
			capture predict p1-p`ycount'
			if _rc {
				predict p1
				local probs p1
			}
			else {
				mata: st_local("probs", invtokens("p" :+ strofreal(1::ycount)'))
			}
			mata: catmetrics("`varlist'", "`probs'", "`power'", "`pseudospherical'", "`fbeta'", "`goalpha'", "`gobeta'", "`ibaalpha'", "`sokalw'", "`gltheta'", "`bkappa'", "`talpha'", "`tbeta'", "`gfholderp'", "`gflehmerp'", "`eceq'", "`ecem'", "`gaink'", "`liftk'", "`mceq'", "`mcem'", "`ealpha'", "`ibam'", "`crlambda'", "`kweights'", "`metrics'", "`mat'", "`excel'", "`noexcel'", "`classmetrics'", "`symmetric'")
			capture drop p1-p`ycount'
			capture drop p1
		} 
		
		if "`predict'" != "predict" {
			mata: catmetrics("`varlist'","`probs'", "`power'", "`pseudospherical'", "`fbeta'", "`goalpha'", "`gobeta'", "`ibaalpha'", "`sokalw'", "`gltheta'", "`bkappa'", "`talpha'", "`tbeta'", "`gfholderp'", "`gflehmerp'", "`eceq'", "`ecem'", "`gaink'", "`liftk'","`mceq'", "`mcem'", "`ealpha'", "`ibam'", "`crlambda'", "`kweights'", "`metrics'", "`mat'", "`excel'", "`noexcel'", "`classmetrics'", "`symmetric'")
		}
	}


end