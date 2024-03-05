
*******************************************************************************
*                           MEPS Data Preparation File
* 							 Created on: 12-Mar-2023
*							 Modified on: 18-Aug-2023
*                            	 Modified by: IG		
*******************************************************************************


/*--------------- FILES USED ------------------*

* Full-year consolidated files
h229.dta // 2021
h224.dta // 2020 
h216.dta  // 2019 
h209.dta // 2018 

* Medical conditions files
h222.dta // 2020 
h214.dta  // 2019 
h207.dta  // 2018 

* Event files

h220d.dta // 2020 in-patient stays
h220e.dta // 2020 emergency room visits
h220f.dta // 2020 outpatient visits
h220g.dta // 2020 office-based medical provider visits
h213d.dta // 2019 in-patient stays
h213e.dta // 2019 emergency room visits
h213f.dta // 2019 outpatient visits
h213g.dta // 2019 office-based medical provider visits
h206d.dta // 2018 in-patient stays
h206e.dta // 2018 emergency room visits
h206f.dta // 2018 outpatient visits
h206g.dta // 2018 office-based medical provider visits

* Event-Medical condition-Full-year consolidated Merge file 
h220if1.dta // CLNK 2020
h213if1.dta // CLNK 2019
h206if1.dta // CLNK 2018

* Pooled variance linkage files
h36u20.dta  // Pooled Variance Linkage File
*/

**********************
* General Logistics
**********************

clear
set more off
set maxvar 6000
set seed 1234
capture log close
cd "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2023-2024\Quantitative Data Analysis"
log using Ex1, replace 

global raw_events "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\raw_files\MEPS\event_file"

global raw_fullyear "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\raw_files\MEPS\fullyear_file"

global raw_medcond "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\raw_files\MEPS\med_cond_file"

global raw_other "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\raw_files\MEPS\other_files"

global input_files "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\input_files"

global output_tables "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\output_tables"

global graph_files "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2022-2023\Fall 2022\Applied Statistics\Final Paper\graphs"

************************************
* Explore and prepare the raw files
************************************

*--------------------
* Prepare 2021 files
*---------------------

/* Full year consolidated file 2021 */
cd "$raw_fullyear"
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h233/h233dta.zip" "h233dta.zip", replace
unzipfile "h233dta.zip", replace

/* CLNK file - 2021 */
cd "$raw_other"
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229i/h229if1dta.zip" "h229if1dta.zip", replace
unzipfile "h229if1dta.zip", replace

/* Conditions 2021 */
cd "$raw_medcond"
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h231/h231dta.zip" "h231dta.zip", replace
unzipfile "h231dta.zip", replace

/* Office-based visits 2021 */
cd "$raw_events"
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229g/h229gdta.zip" "h229gdta.zip", replace
unzipfile "h229gdta.zip", replace

/* Outpatient visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229f/h229fdta.zip" "h229fdta.zip", replace
unzipfile "h229fdta.zip", replace

/* Inpatient visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229d/h229ddta.zip" "h229ddta.zip", replace
unzipfile "h229ddta.zip", replace

/* Emergency visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229e/h229edta.zip" "h229edta.zip", replace
unzipfile "h229edta.zip", replace



*---------------------
* Prepare event files
*---------------------

cd "$raw_events"

* Rename files, convert variable names to lowercase, select variables of interest from event files 
* Change "don't know, not applicable, cannot be computed" to missing

cls
clear all
local visit "ip er op ob"
local eb = 206
forvalues i = 18/20{
	local alpha1 "d e f g"
	local a = 1
	foreach j of local alpha1{
		use h`eb'`j'.dta, clear
		rename *, lower
		keep duid pid dupersid evntidx eventrn panel `:word `a' of `visit''xp`i'x 
		replace `:word `a' of `visit''xp`i'x = . if `:word `a' of `visit''xp`i'x < 0
		summ `:word `a' of `visit''xp`i'x 
		gen year = 20`i'
		label var year "Survey year"
		gen visit_type = "`:word `a' of `visit''"
		di "h`eb'`j' converts to `:word `a' of `visit''`i'" // double checking conversions 
		sort dupersid
		destring duid, replace
		save "$input_files/`: word `a' of `visit''`i'.dta", replace
		local a = `a'+1
	}
	local eb = `eb'+7
}

* IP 2021
use h229d.dta, clear
rename *, lower
keep duid pid dupersid evntidx eventrn panel ipxp21x 
replace ipxp21x = . if ipxp21x < 0
summ ipxp21x 
gen year = 2021
label var year "Survey year"
gen visit_type = "ip"
sort dupersid
destring duid, replace
save "$input_files/ip21.dta", replace

*ER 2021
use h229e.dta, clear
rename *, lower
keep duid pid dupersid evntidx eventrn panel erxp21x 
replace erxp21x = . if erxp21x < 0
summ erxp21x 
gen year = 2021
gen visit_type = "er"
label var year "Survey year"
sort dupersid
destring duid, replace
save "$input_files/er21.dta", replace


*OP 2021
use h229f.dta, clear
rename *, lower
keep duid pid dupersid evntidx eventrn panel opxp21x 
replace opxp21x = . if opxp21x < 0
summ opxp21x 
gen year = 2021
label var year "Survey year"
gen visit_type = "op"
sort dupersid
destring duid, replace
save "$input_files/op21.dta", replace

*OB 2021
use h229g.dta, clear
rename *, lower
keep duid pid dupersid evntidx eventrn panel obxp21x 
replace obxp21x = . if obxp21x < 0
summ obxp21x 
gen year = 2021
label var year "Survey year"
gen visit_type = "ob"
sort dupersid
destring duid, replace
save "$input_files/ob21.dta", replace

*---------------------------------------
* Prepare fullyear consolidated files
*---------------------------------------

* Rename files, convert variable names to lowercase, select variables of interest from event files
* Convert "don't know, not applicable, cannot be computed" into missing values
cd "$raw_fullyear"

local fls "h209 h216 h224 h233"
local a=18
foreach i of local fls{
	use "`i'.dta", clear
	rename *, lower
	keep duid pid dupersid panel famidyr saqwt`a'f region`a' povlev`a' povcat`a' faminc`a' ttlp`a'x educyr marry`a'x insurc`a' unins`a' inscov`a' racev1x age`a'x sex mnhlth53 mnhlth42 mnhlth31 phq242 k6sum42 rthlth31 rthlth42 rthlth53 cancerdx diabdx_m18 arthdx adhdaddx soclim31 coglim31
	rename (saqwt`a'f region`a' povlev`a' povcat`a' faminc`a' ttlp`a'x marry`a'x insurc`a' unins`a' inscov`a' age`a'x) (saqwt region povlev povcat faminc ttlpx marryx insurc unins inscov agex) 
	local vars "agex region marryx educyr rthlth31 rthlth42 rthlth53 mnhlth53 mnhlth42 mnhlth31 cancerdx diabdx_m18 arthdx adhdaddx soclim31 coglim31 phq242 k6sum42" 
	foreach j of local vars{
		replace `j' = . if `j' == -1 | `j' == -7 | `j' == -8 | `j' == -15
	}
	replace marryx = . if marryx == 6
	replace ttlpx = 0 if ttlpx < 0 // negative income; values < 0 don't mean that the response was skipped             
	replace faminc = 0 if faminc < 0 // negative income; values < 0 don't mean that the response was skipped
	gen year=20`a'
	label var year "Survey Year"
	sort dupersid
	destring duid, replace
	save "$input_files/fullyear`a'.dta", replace
	local a = `a'+1
}

// review how to get counts of visits.

*---------------------------------------
* Prepare medical conditions files
*---------------------------------------

cd "$raw_medcond"

* Rename files, convert variable names to lowercase, select variables of interest from event files
* Convert "don't know, not applicable, cannot be computed" into missing values

cls
local yearn=18
local filesn "h207 h214 h222 h231"
foreach x of local filesn{
    use `x', clear 
	rename *, lower
	icd10 check icd10cdx
	keep duid pid dupersid panel condn condidx condrn icd10cdx ccsr1x ccsr2x ccsr3x perwt`yearn'f varstr varpsu
	rename perwt`yearn'f perwt
	keep if strmatch(icd10cdx, "F")>0
	di "Distinct respondents in year `yearn'"
	distinct dupersid panel, joint
	sort dupersid
	destring duid, replace
	save "$input_files/medCond`yearn'.dta", replace
	local yearn = `yearn'+1
}

*****************
* Combine Files
*****************
cd "$raw_other"
	
* Combine event-condition files for condition-expenditure calculations; save the output as ExpbyCondYr file.
cls
local fls "h206 h213 h220 h229"
local yr = 18
foreach i of local fls{
	use `i'if1, clear
	rename *, lower
	merge m:1 dupersid condidx using "$input_files/medCond`yr'.dta", nogen
	gen exp = .
	local vars "ip er op ob"
	foreach j of local vars{
		merge m:1 dupersid evntidx using "$input_files/`j'`yr'.dta", keep(1 3) nogen
		replace exp = `j'xp`yr'x if `j'xp`yr'x != .
	}
	
	collapse (sum) obxp`yr'x opxp`yr'x ipxp`yr'x erxp`yr'x /*visits*/, by(dupersid panel icd10cdx visit_type) // preparing a person-icd-visit level file.
	save "$input_files/ExpbyCond`yr'.dta", replace
	local yr = `yr'+1
}

/* [IG TO CHECK] Combine fullyear files with the pooled variance files for survey assessment
forvalues i = 18/20{
	use "$input_files/fullyear`i'.dta", clear
	merge m:m panel dupersid using h36u20, keepusing(psu9620 stra9620) keep(3) nogen // merge pooled linkage file
	destring dupersid, replace
	save "$input_files/fullyear_pooledvar`i'.dta", replace
}*/

* Create a unique row with event counts for each ICD code per individual using the medical conditions file
* Combine medical conditions with expenditure-condition file for the final condition-event#-expenditures 

cd "$input_files"
forvalues i = 18/21{
	use medCond`i', clear
	destring dupersid, replace
	tab icd10cdx if strmatch(icd10cdx, "F")>0
	collapse (sum) ipnum opnum obnum ernum, by(dupersid panel icd10cdx)
	merge 1:1 dupersid panel icd10cdx using ExpbyCond`i'
	save "medCondExp`i'.dta", replace
	gen anymhuse = (strmatch(icd10cdx, "F")>0)
	bys dupersid panel: egen anyMHUse = sum(anymhuse)
	bys year: tab anyMHUse
	save "medCondExp`i'_1.dta", replace
}

* Check var names and change to standard names without "yr" in fullyear_pooledvar and medCondExp files. (done in earlier loops)
* Merge each year's fullyear_pooledvar and medCondExp files


cls
forvalues i =18/20{
	use medCondExp`i', clear
	drop _merge
	merge m:1 dupersid using fullyear_pooledvar`i'
	save meps_final`i', replace
	di "Distinct respondents in year `yearn'"
	distinct dupersid panel, joint
}

* Append files together to get the final dataset for analysis
cd "$input_files"
use meps_final18, clear
append using meps_final19 meps_final20, gen(source_file)
save meps_all_1820, replace

* Create pooled person-level weight and subpop 
gen poolsaqwt=saqwt/3  // Use this for all the analyses!!

* Label some vars to reflect descriptions
label var poolsaqwt "SAQ pool-adjusted weight for 2018-2020"
label var hhnum "# Home health visits for condition (ICD) in year (Year)"
label var ipnum "# In-patient stays for condition (ICD) in year (Year)"
label var opnum "# Outpatient visits for  condition (ICD) in year (Year)"
label var obnum "# Office-based visits for condition (ICD) in year (Year)"
label var rxnum "# Prescribed medications for condition (ICD) in year (Year)"
label var ernum "# ER visits for condition (ICD) in year (Year)"
label var totcondexp "Total expenditures for  condition (ICD) in year (Year)"
label var inscov "Health insurance coverage indicator"
label var insurc "Full year insurance coverage status"
order duid-famidyr

***************************************
** Prepare final dataset for analysis
***************************************

* Prepare vars for finalization of the main analysis dataset
* 1) Convert 2019 and 2020 expenditure values to 2018 USD
gen totcondexp2018 = .
	replace totcondexp2018 = totcondexp if year == 2018
	replace totcondexp2018 = totcondexp*0.98 if year == 2019
	replace totcondexp2018 = totcondexp*0.96 if year == 2020
	replace totcondexp2018 = totcondexp*0.94 if year == 2021
label var totcondexp2018 "Total expenditures (in 2018 Dollars) for condition (ICD) in year (Year)"
order totcondexp2018, after(totcondexp)

* 2) Variables measured over several rounds need to be harmonized. Since the K6 scores and PHQ-2 scores are from rounds 4/2 for the panels, we will use those for other variables, whenever available. 
drop rthlth31 rthlth53 mnhlth31 mnhlth53
rename (rthlth42 mnhlth42) (rthlth mnhlth)

* 3) ADHD was likely measured for those who were under 18 years (there are 23,188 entries for people < 17 years of age, but for those over 18, there are only 746 entries). Therefore, remove the adhd indicator.
drop adhdaddx

* 4) Exclude participants who were less than 18 years of age, or had missing k6sum score or physical or mental health measures. Years only 2018-2020.
cls
tab year
tab agex year if agex < 18
bysort year: distinct dupersid panel if agex < 18 & agex != ., joint
drop if agex < 18 | agex == . //

tab k6sum42 year if k6sum42 < 0 | k6sum42 == .
bysort year: distinct dupersid panel if k6sum42 == ., joint // cannot be computed
drop if k6sum42 == .

tab rthlth year, missing
bysort year: distinct dupersid panel if rthlth == ., joint
drop if rthlth == .

tab mnhlth year, missing
bysort year: distinct dupersid panel if mnhlth == ., joint
drop if mnhlth == .

***** Preliminary dataset; distinct obs
bysort year: distinct dupersid year, joint // 2018: 18,606; 2019: 16,984; 2020: 13,820. 
save prelim_analysis_file, replace

***************************
** Additional Procedures
***************************

* 5) Create expense and visits variables for expenses/visits associated with mental health. 

cd "$input_files"
use prelim_analysis_file, clear

* check expenditure distribution
bys year: summ totcondexp2018 if strpos(icd10cdx, "F")
sort totcondexp

gen icd = substr(icd10cdx, 1, 1)
order icd, after(icd10cdx)
 
// Assess whether there is missingness in rows with some visit data
cls
bys year: distinct dupersid if hhnum == 0 & ipnum == 0 & opnum == 0 & obnum == 0 & ernum == 0 & rxnum == 0 // There are none

bys year: distinct dupersid  if hhnum == . & ipnum == . & opnum == . & obnum == . & ernum == . & rxnum == .  // 4557 (2018), 4006 (2019), and 2996 (2020) observations 

bys year: distinct dupersid if hhnum != . & ipnum != . & opnum != . & obnum != . & ernum == . & rxnum == !. // There are no observations where one of the visits is missing; its either a full row with values or all missing. Therefore, we will now impute missings with 0, assuming that a missing indicates that there were no visits.

tab totcondexp2018 if hhnum == . , missing // 11,559 values that are all missing; used hhnum, because when any of the visits value is missing, the others are missing as well.

bys year: distinct dupersid // 2018: 18,606; 2019: 16,984; 2020: 13,820

* Replacing the missings with 0; here, we are assuming that there were no visits if the values were blank. This is to ensure that everyone remains in the analysis.  
replace hhnum = 0 if hhnum == .
replace ipnum = 0 if ipnum == .
replace opnum = 0 if opnum == .
replace ernum = 0 if ernum == .
replace rxnum = 0 if rxnum == .
replace obnum = 0 if obnum == .
replace totcondexp = 0 if totcondexp == .
replace totcondexp2018 = 0 if totcondexp2018 == .
replace icd = "NA" if icd == "" & hhnum == 0 & ipnum == 0 & opnum == 0 & obnum == 0 & ernum == 0 & rxnum == 0

collapse (sum) hhnum ipnum opnum obnum ernum rxnum totcondexp totcondexp2018 (mean) region agex sex racev1x marryx educyr rthlth mnhlth cancerdx diabdx_m18 arthdx soclim31 coglim31 k6sum42 phq242 ttlpx faminc povlev unins inscov insurc saqwt stra9620 psu9620 poolsaqwt, by(dupersid icd panel year)

* Check if we have all dupersids from all years still
bys year: distinct dupersid // YEP! 2018: 18,606; 2019: 16,984; 2020: 13,820

save penultimate_dataset, replace

* Generating dummies for service use
bys year: summ totcondexp2018 if icd == "F"
gen anymhuse = (icd == "F")
bys dupersid panel year: egen anyMHUse = sum(anymhuse)
bys year: tab anyMHUse

bys year: distinct dupersid if icd == "NA"
gen noServUse = (icd == "NA")

* Setting up a person-level dataset from a person-icd level dataset 
/*If person has an ICD "F" code, keep the visits, expenditure, rx as is
 - Though, if person does not have an ICD "F", then make a row with visits = 0, expenditures = 0, rx = 0; 
 here we are essentially saying that they had no expenses or service use for mental health. */

sort dupersid panel year
 
bys dupersid panel year: gen unique_val = (_n == 1)
tab unique_val year
replace icd = "F" if unique_val == 1 & anyMHUse == 0
drop if icd != "F"
sort year
by year: distinct dupersid // / We have all! 2018: 18,606; 2019: 16,984; 2020: 13,820
by year: tab anyMHUse

by year: tab anyMHUse k6sum42

local vars "hhnum ipnum opnum obnum ernum rxnum totcondexp totcondexp2018"
foreach i of local vars{
	replace `i' = 0 if anyMHUse == 0
}

save penultimate_dataset2, replace

* Final labeling of variables
label var icd "ICD10 code: first character"
label var region "Census region (as of year end)"
label var agex "Age (as of year end)"
label var sex "Sex"
label var racev1x "Race (imputed/edited)"
label var marryx "Marital status (as of year end)"
label var educyr "Years of education when first entered MEPS"
label var rthlth "Perceived health status (round 4/2)"  
label var mnhlth "Perceived mental health status (round 4/2)"  
label var cancerdx "Cancer diagnosis (1 = yes)"
label var diabdx_m18 "Diabetes diagnosis (1 = yes)"
label var arthdx "Arthritis diagnosis (1 = yes)"
label var soclim31 "Social limitations (round 4/2)" // Tried taking 4/2 since the K6 and PHQ-2 were measured during that round; but not available for 2018, 2019. 
label var coglim31 "Cognitive limitations (round 4/2)" // Tried taking 4/2 since the K6 and PHQ-2 were measured during that round; but not available for 2018, 2019.
label var k6sum42 "Kessler-6 total score"
label var phq242 "PHQ-2 total score"
label var ttlpx "Person's total income"
label var faminc "Family's total income"
label var povlev "Poverty level as % of poverty line"
label var unins "Uninsured all of year"
label var saqwt "SAQ survey weight"
label var stra9620 "Combined variance: stratum (1996-2020)"
label var psu9620 "Combined variance: PSU (1996-2020)"
label var poolsaqwt "SAQ pool-adjusted weight for 2018-2020"
label var hhnum "# Home health visits for behavioral health in year (Year)"
label var ipnum "# In-patient stays for behavioral health in year (Year)"
label var opnum "# Outpatient visits for behavioral health in year (Year)"
label var obnum "# Office-based visits for behavioral health in year (Year)"
label var rxnum "# Prescribed medications for behavioral health in year (Year)"
label var ernum "# ER visits for behavioral health in year (Year)"
label var totcondexp "Total expenditures for behavioral health in year (Year), nominal"
label var totcondexp2018 "Total expenditures for behavioral health in 2018 USD, real"
label var inscov "Health insurance coverage indicator"
label var insurc "Full year insurance coverage status"

save final_analysis_file, replace

*--------------------------------
* Creating additional variables
*--------------------------------

cd "$input_files"
use final_analysis_file, clear

* Age (cat)
summ agex
egen agecat = cut(agex), at(18,40,60,86)
tab agex agecat
label var agecat "Age (as of year end; categorical)"
recode agecat (18=0) (40=1) (60=2)
label define agecat1 0 "18-39 years" 1 "40-59 years" 2 "60-85 years"
label values agecat agecat1

* Education (cat)
summ educyr
tab educyr, missing
egen educat = cut(educyr), at(0,12,13,18)
tab educyr educat                             // check distribution
recode educat (0=0) (12=1) (13=2)
label define educ 0 "Less than High School" 1 "High School Certificate" 2 "Some college or higher"
label values educat educ
label var educat "Education status when first entered MEPS (categorical)"

* Gender binary
tab sex 
gen female = (sex == 2)
tab sex female
label var female "Female (Binary)"
label define fem 0 "Male" 1 "Female"
label values female fem

* Race
tab racev1x, missing
label define race1 1 "White" 2 "Black" 3 "American Indian Alaskan Native" 4 "Asian or Native Hawaiian" 6 "Mutiple races"
label values racev1x race1

* Marital status binary
tab marryx 
gen marrybin = (marryx ==1)
tab marryx marrybin 
label define marryn 0 "Not married" 1 "Married"
label var marrybin "Marital status at year end (Binary)"
label values marrybin marryn

* Poverty level - create cat based on MEPS cutoffs (https://meps.ipums.org/meps-action/variables/POVCAT#description_section)
summ povlev
egen povcat = cut(povlev), at(-2373, 100, 125, 200, 400, 4470)
tab povcat year
bys povcat: summ povlev 
recode povcat (-2373=0) (100=1) (125=2) (200=3) (400=4)
label define povcat1 0 "Poor/negative" 1 "Near poor" 2 "Low income" 3 "Middle income" 4 "High income"
label var povcat "Family income as % poverty line (categorical)"
label values povcat povcat1

*Insurance Status binary  
tab insurc year 
codebook insurc
gen insurbin = 0
replace insurbin = 1 if insurc == 4 | insurc == 5 |insurc == 6 |insurc == 1 |insurc == 2 | insurc == 8
tab insurc insurbin
label var insurbin "Full year insurance coverage status (Binary)"
label define insurbin1 0 "Uninsured" 1 "Insured"
label values insurbin insurbin1

* K6 binary (K6 >=13)
gen k6bin = (k6sum>=13) // 13 or higher = serious mental illness (Kessler et. al., 2003)
tab k6sum k6bin 
tab k6bin year, col // score higher than 13 is rare: 4.2% (2018), 4.2% (2019); 4.5% (2020)
label var k6bin "K6 >= 13" 
label define k6 0 "No serious mental distress" 1 "Serious mental distress"
label values k6bin k6

* Expenditure ln vars - Total exp
cd "$graph_files"
hist totcondexp2018, by(year) freq
gen totcondexp2018_gt0 = totcondexp2018 if totcondexp2018>0
boxcox totcondexp2018_gt0 // theta = -0.003; closest to 0, therefore use log transformation.

* Create an indicator for treatment (COVID/not COVID)
gen treat_covid = (year == 2020)
label var treat_covid "COVID year"
label define treat1 0 "Not COVID year" 1 "COVID year"
label values treat_covid treat1

* Drop non-essential variables
drop unique_val anymhuse
tab noServUse

label var noServUse "Indicator for no service use (= 1 if no health services used)"
label var anyMHUse "Indicator for any behavioral health service used (= 1 if any mental health services used)"

save final_analysis_file_15Aug23.dta, replace 






