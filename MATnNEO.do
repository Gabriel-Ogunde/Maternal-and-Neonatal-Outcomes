
import spss using "C:\Users\USER\Desktop\Projects\y2022\yr 2022\MATnNEO.sav"

***************DATA MANAGEMENT*********************

drop VAR00006 VAR00007 VAR00001 VAR00002 VAR00003 VAR00005 VAR00027
rename VAR00004 id
gen site=., after(id)
replace site=1 in 1/256
replace site=2 in 257/480
replace site =3 in 481/780
replace site =4 in 781/959
replace site =5 in 960/1162
label define site 1 Jericho 2 Agbongbon 3 Adeoyo 4 Oranyan 5 UCH
label value site site
recode site (2 4=1 "Primary") (1=2 Secondary) (3 5=3 Tertiary),gen(institution)


recode QA3 (min/19=1 "15-19 yrs") (20/24=2 "20-24 yrs") (25/29=3 "25-29 yrs") (30/34=4 "30-34 yrs") (35/39=5 "35-39 yrs") (40/max=6 "40and above"), gen(age)
recode QA9 (0 1=1 "Single") (2=2 "Married") (3 4=3 "Divorced/Separated"), gen(marital_stat)
recode QA23 (1=0 "Unimproved") (1/4=1 Improved), gen(toilet)
recode QA24 (1 4 8=0 Unimproved) (2 3 5 6 7=1 Improved), gen(water)
replace QA15=0 if QA15==5
replace QA21=0 if QA21==2 & QA22==.
replace QA21=1 if QA21==2
replace QA24=8 if QA24==0
recode QA16 (0=0) (1/max=1 "Multiparous"), gen(parity)
recode QA11 (1 5=1 "Civil servants") (2=2 Housewives) (3 4=3 "Self-employed"), gen(mat_occupation)

gen base_muac=1 if QE1A<23
replace base_muac=0 if QE1A>22.99
label define base_muac 0 No 1 Yes
label value base_muac base_muac

gen muac_i=1 if QE1B<23
replace muac_i=0 if QE1B>22.99
label value muac_i base_muac

gen muac_ii=1 if QE1C<23
replace muac_ii=0 if QE1C>22.99
label value muac_ii base_muac

gen muac_iii=1 if QE1D<23
replace muac_iii=0 if QE1D>22.99
label value muac_iii base_muac

recode QA7 (1=1 Yoruba) (else=2 "Non-Yoruba"), gen(ethnicity)
recode QA10 (0 1=1 "<= Primary") (2=2 Secondary) (3=3 Diploma) (4/6=4 "Higher diploma/Degree"), gen(educ)

*******mddw********
replace QB3=1 if QB3==3
egen mddw = rowtotal( QB1 - QB10)
recode mddw (min/5=1 "1-5") (6/10=2 "6-10"), gen(mddw_r)
replace QC7A=3 if QC7A==4
egen hh_fsecurity = rowtotal(QC1A QC2A QC3A QC4A QC5A QC6A QC7A QC8A QC9A)


gen flp=1 if QFMAT1!=.
replace flp=1 if flp==. &  QFMAT2!=.
replace flp=1 if flp==. &  QFMAT3!=.
replace flp=1 if flp==. &  QFMAT4!=.
replace flp=1 if flp==. &  QFMAT4A!=""
replace flp=1 if flp==. &  QFNEO1A !=.
replace flp=1 if flp==. &  QFNEO1B !=.
replace flp=1 if flp==. &  QFNEO2!=.
replace flp=1 if flp==. &  QFNEO3!=.
replace flp=1 if flp==. &  QFNEO4!=.
replace flp=1 if flp==. &  QFNEO5!=.
replace flp=0 if flp==.
label define flp 0 No 1 Yes
label value flp flp
label variable flp "Follow-up"

replace QD4=0 if QD4==6
recode marital_stat (2=0 Married) (1 3=1 "Not currently married"),gen(marital)
******************RETENTION RATE************
fre QE1A QE2A QE3A

fre QE1B if flp==1 
fre QE1C if flp==1
fre QE1D if flp==1

fre QE2B if flp==1 
fre QE2C if flp==1
fre QE2D if flp==1

fre QE3B if flp==1 
fre QE3C if flp==1
fre QE3D if flp==1

********************** TABLE 1: SOCIO-DEMOGRAPHICS**************************************

sum QA3, d
sum QA17, d
tab1 site age ethnicity QA8 marital_stat educ QA11 A13 A14 QA15 QA20 QA21 toilet water

***********TABLE 2: PREVALENCE OF UNDER NUTRITION*********************
tab site base_muac, row chi
tab age base_muac, row chi
tab ethnicity base_muac, row chi
tab QA8 base_muac, row chi
tab marital_stat base_muac, row chi
tab educ base_muac, row chi
tab QA11 base_muac, row chi



**************TABLE 3: PARASITIC PREVALENCE AND ASSOCIATED FACTORS***************
replace QE4=1 if QE4==0 & QE4A!=""
encode QE4A, gen(QE4A_r)
replace QE4=0 if QE4A_r==12
replace QE4A_r=2 if QE4A_r==3 | QE4A_r==4
replace QE4A_r=5 if QE4A_r==1 | QE4A_r==6 | QE4A_r==7 | QE4A_r==8 | QE4A_r==9 | QE4A_r==10 | QE4A_r==13 | QE4A_r==14 | QE4A_r==15 | QE4A_r==16 | QE4A_r==17 | QE4A_r==21
replace QE4A_r=19 if QE4A_r==20
replace QE4A_r=11 if QE4A_r==18
replace QE4A_r=0 if QE4==0
keep if QE4!=.

tab site QE4  if QE4!=., row chi exact
tab age QE4  if QE4!=., row chi exact
tab ethnicity QE4  if QE4!=., row chi exact
tab QA8 QE4  if QE4!=., row chi exact
tab marital_stat QE4  if QE4!=., row chi exact
tab educ QE4  if QE4!=., row chi exact // improve
tab QA11 QE4  if QE4!=., row chi exact
tab A13 QE4  if QE4!=., row chi exact   // significant

logistic QE4 i.institution, nolog allbase
logistic QE4 ib6.age, nolog allbase
logistic QE4 i.ethnicity, nolog allbase
logistic QE4 i.QA8, nolog allbase
logistic QE4 i.marital, nolog allbase

logistic QE4 i.QA21, nolog

recode QFMAT1 (0=0 No) (1/3=1 Yes), gen(anaemic)
tab site anaemic  , row chi 
tab age anaemic  , row chi
tab ethnicity anaemic  , row chi
tab QA8 anaemic  , row chi
tab marital_stat anaemic  , row chi
tab educ anaemic  , row chi

rename (QE1A QE1B QE1C QE1D) (x1 x2 x3 x4)
rename ( QE2A QE2B QE2C QE2D) (y1 y2 y3 y4)
rename ( QE3A QE3B QE3C QE3D) (z1 z2 z3 z4)
reshape long x y z, i(id_no) j(visit)
rename (x y z) (muac maternal_weight_gain hb_conc)
xtset id_no

xtgee base_muac i.site, family(binomial) link(logit) corr(exch) eform allbase
xtgee base_muac i.age, family(binomial) link(logit) corr(exch) eform nolog allbase
xtgee base_muac i.ethnicity, family(binomial) link(logit) corr(exch) eform nolog allbase
xtgee base_muac i.QA8, family(binomial) link(logit) corr(exch) eform nolog allbase // not converging but sorted with codes below
xtgee base_muac i.marital_stat, family(binomial) link(logit) corr(exch) eform nolog allbase // not converging
xtgee base_muac i.educ, family(binomial) link(logit) corr(exch) eform nolog allbase // not converging
xtgee base_muac i.QA11, family(binomial) link(logit) corr(exch) eform nolog allbase
xtgee base_muac i.A13, family(binomial) link(logit) corr(exch) eform nolog allbase
xtgee base_muac i.A14, family(binomial) link(logit) corr(exch) eform nolog allbase // not converging
xtgee base_muac i.QA15, family(binomial) link(logit) corr(exch) eform nolog allbase

xtgee base_muac i.site i.age i.ethnicity i.QA8 i.marital_stat i.educ i.QA11 i.A13 i.A14 i.QA15 i.QA21 i.parity_ii, family(binomial) link(logit) corr(exch) eform

