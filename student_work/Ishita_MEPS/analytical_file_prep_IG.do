/* ------------------------------------------------------------

MEPS-HC: Service utilization and expenditures for mental health; 2018-2021
	
-----------------------------------------------------------------------------*/


clear
set more off
capture log close
cd "C:\Users\ighai\OneDrive - RAND Corporation\Academics\2023-2024\Quantitative Data Analysis"
log using Ex1, replace 

/* Get data from web (you can also download manually) */

*--------------------
* Longitudinal File
*--------------------

/* Longitudinal File */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h236/h236dta.zip" "h236dta.zip", replace
unzipfile "h236dta.zip", replace


*-----------
* CLNK File
*-----------

/* CLNK file - 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229i/h229if1dta.zip" "h229if1dta.zip", replace
unzipfile "h229if1dta.zip", replace

/* CLNK file - 2020 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h220i/h220if1dta.zip" "h220if1dta.zip", replace
unzipfile "h220if1dta.zip", replace

/* CLNK file - 2019 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h213i/h213if1dta.zip" "h213if1dta.zip", replace
unzipfile "h213if1dta.zip", replace

/* CLNK file - 2018 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h206i/h206if1dta.zip" "h206if1dta.zip", replace
unzipfile "h206if1dta.zip", replace


*-----------------
* Conditions File
*-----------------

/* Conditions 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h231/h231dta.zip" "h231dta.zip", replace
unzipfile "h231dta.zip", replace

/* Conditions 2020 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h222/h222dta.zip" "h222dta.zip", replace 
unzipfile "h222dta.zip", replace

/* Conditions 2019 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h214/h214dta.zip" "h214dta.zip", replace
unzipfile "h214dta.zip", replace

/* Conditions 2018 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h207/h207dta.zip" "h207dta.zip", replace
unzipfile "h207dta.zip", replace

*--------------
* Visits files
*--------------

/* Office-based visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229g/h229gdta.zip" "h229gdta.zip", replace
unzipfile "h229gdta.zip", replace

/* Office-based visits 2020 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h220g/h220gdta.zip" "h220gdta.zip", replace
unzipfile "h220gdta.zip", replace

/* Office-based visits 2019 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h213g/h213gdta.zip" "h213gdta.zip", replace
unzipfile "h213gdta.zip", replace

/* Office-based visits 2018 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h206g/h206gdta.zip" "h206gdta.zip", replace
unzipfile "h206gdta.zip", replace



/* Outpatient visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229f/h229fdta.zip" "h229fdta.zip", replace
unzipfile "h229fdta.zip", replace

/* Outpatient visits 2020 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h220f/h220fdta.zip" "h220fdta.zip", replace
unzipfile "h220fdta.zip", replace

/* Outpatient visits 2019 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h213f/h213fdta.zip" "h213fdta.zip", replace
unzipfile "h213fdta.zip", replace

/* Outpatient visits 2018 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h206f/h206fdta.zip" "h206fdta.zip", replace
unzipfile "h206fdta.zip", replace




/* Inpatient visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229d/h229ddta.zip" "h229ddta.zip", replace
unzipfile "h229ddta.zip", replace

/* Inpatient visits 2020 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h220d/h220ddta.zip" "h220ddta.zip", replace
unzipfile "h220ddta.zip", replace

/* Inpatient visits 2019 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h213d/h213ddta.zip" "h213ddta.zip", replace
unzipfile "h213ddta.zip", replace

/* Inpatient visits 2018 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h206d/h206ddta.zip" "h206ddta.zip", replace
unzipfile "h206ddta.zip", replace




/* Emergency visits 2021 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h229e/h229edta.zip" "h229edta.zip", replace
unzipfile "h229edta.zip", replace

/* Emergency visits 2020 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h220e/h220edta.zip" "h220edta.zip", replace
unzipfile "h220edta.zip", replace

/* Emergency visits 2019 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h213e/h213edta.zip" "h213edta.zip", replace
unzipfile "h213edta.zip", replace

/* Emergency visits 2018 */
copy "https://meps.ahrq.gov/mepsweb/data_files/pufs/h206e/h206edta.zip" "h206edta.zip", replace
unzipfile "h206edta.zip", replace



****************
* Save files
****************

/* condition linkage file  2021*/
use h229if1, clear
rename *, lower
save CLNK_2021, replace

/* condition linkage file  2020*/
use h220if1, clear
rename *, lower
save CLNK_2020, replace

/* condition linkage file  2019*/
use h213if1, clear
rename *, lower
save CLNK_2019, replace

/* condition linkage file  2018*/
use h206if1, clear
rename *, lower
save CLNK_2018, replace



/* OB visits, person-visit-level 2021 */
use  DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OBXP21X using h229g, clear 
rename *, lower
save OB_2021, replace

/* OB visits, person-visit-level 2020 */
use  DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OBXP20X using h220g, clear 
rename *, lower
save OB_2020, replace

/* OB visits, person-visitlevel 2019 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OBXP19X using h213g, clear 
rename *, lower
save OB_2019, replace

/* OB visits, person-visit-level 2018 */
use  DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OBXP18X using h206g, clear 
rename *, lower
save OB_2018, replace




/* OP visits, person-visit-level 2021 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OPXP21X using h229f, clear 
rename *, lower
save OP_2021, replace

/* OP visits, person-visit-level 2020 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OPXP20X  using h220f, clear 
rename *, lower
save OP_2020, replace

/* OP visits, person-visit-level 2019 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OPXP19X using h213f, clear 
rename *, lower
save OP_2019, replace

/* OP visits, person-visit-level 2018 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OPXP18X using h206f, clear 
rename *, lower
save OP_2018, replace




/* IP visits, person-visit-level 2021*/
use  DUPERSID EVNTIDX EVENTRN PANEL IPXP21X using h229d, clear 
rename *, lower
save IP_2021, replace
 
/* IP visits, person-visit-level 2020*/ 
use DUPERSID EVNTIDX EVENTRN PANEL IPXP20X using h220d, clear 
rename *, lower
save IP_2020, replace

/* IP visits, person-visit-level 2019*/
use DUPERSID EVNTIDX EVENTRN PANEL IPXP19X using h213d, clear 
rename *, lower
save IP_2019, replace

/* IP visits, person-visit-level 2018*/  
use DUPERSID EVNTIDX EVENTRN PANEL IPXP18X using h206d, clear 
rename *, lower
save IP_2018, replace




/*ER visits 2021*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP21X using h229e, clear 
rename *, lower
save ER_2021, replace

/*ER visits 2020*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP20X using h220e, clear 
rename *, lower
save ER_2020, replace

/*ER visits 2019*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP19X using h213e, clear 
rename *, lower
save ER_2019, replace

/*ER visits 2018*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP18X using h206e, clear 
rename *, lower
save ER_2018, replace


/// [12Feb2023] START FROM HERE; working on the merge!

/* Longitudinal file, person-round level */
use h236, clear
rename *, lower
save PANEL23_18_21, replace






/* Conditions file, person-condition-level, subset to hyperlipidemia */
use DUPERSID CONDIDX ICD10CDX CCSR1X-CCSR3X using h231, clear
rename *, lower
keep if ccsr1x=="END010" | ccsr2x=="END010" | ccsr3x=="END010" // clinical classification codes and might not always correspond to ICD10, which are more for billing. 

// inspect conditions file
describe 

/* merge to CLNK file by dupersid and condidx, drop unmatched */
merge m:m condidx using CLNK_2021, keep(1 3) // m:m merge is possible and we can pre-process the conditions file and the CLNK file to avoid the duplicative merges; need to think through it on my own as the presenter recommended that I do. 

// inspect file
describe

// drop observations for that do not match
drop _merge


/* merge to prescribed meds file by dupersid and evntidx, drop unmatched */
merge m:m evntidx using PM_2021, keep(1 3) nogen 

// inspect file

// drop observations for that do not match


// drop duplicates 
duplicates drop rxrecidx, force // drop duplicates at the fill level - if there are more than one rows with a duplicate drug fill, that's where the issue will arise. This is an important step here. 

// inspect file 
describe // n = 21,239

/* collapse to person-level (DUPERSID), sum to get number of fills and expenditures */
gen one=1
collapse (sum) num_rx=one (sum) exp_rx=rxxp21x, by(dupersid)

describe // n = 4,513

/* merge to FY file, create flag for any Rx fill for HL */
merge 1:1 dupersid using FY_2021

replace num_rx = 0 if _merge == 2
replace exp_rx = 0 if _merge == 2

desc

/* Set survey options */
svyset varpsu [pw = perwt21f], strata(varstr) vce(linearized) singleunit(centered)

gen any_rx=(num_rx>0)

cls
/* total number of people with 1+ Rx fills for HL */
svy: total any_rx
matrix list r(table)
di %15.0f r(table)[1,1]
di %15.0f r(table)[2,1]

/* Total rx fills for the treatment of hyperlipidemia */
svy: total num_rx 
matrix list r(table)
di %15.0f r(table)[1,1]
di %15.0f r(table)[2,1]

/* Total rx expenditures for the treatment of hyperlipidemia */
svy: total exp_rx 
matrix list r(table)
di %15.0f r(table)[1,1]
di %15.0f r(table)[2,1]

/* percent of people with PMED fills for HL */
svy: mean any_rx
svy, sub(if choldx==1): mean any_rx

/* mean number of Rx fills for hyperlipidemia per person */
svy, sub(if choldx==1): mean num_rx
svy, sub(if any_rx==1): mean num_rx

/* mean expenditures on Rx fills for hyperlipidemia per person, among those with any  */
svy, sub(if choldx==1): mean exp_rx
svy, sub(if any_rx==1): mean exp_rx

/* percent of people with PMED fills for HL by race */
svy, sub(if choldx==1): mean any_rx, over(racethx)

/* logistic regression coefficients on any Rx fills for hyperlipidemia, among those with any hyperlipidemia */
svy, sub(if choldx==1): logit any_rx i.raceth i.sex i.insurc21 i.povcat21

save final_file, replace
exit,clear