/* ------------------------------------------------------------

MEPS-HC: Service utilization and expenditures for mental health; 2018-2021
	
-----------------------------------------------------------------------------*/


clear
set more off
set maxvar 6000
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



/* Medical conditions file 2021 */
use h231.dta, clear
rename *, lower
save MEDCOND_2021, replace

/* Medical conditions file 2020 */
use h222.dta, clear
rename *, lower
save MEDCOND_2020, replace

/* Medical conditions file 2019 */
use h214.dta, clear
rename *, lower
save MEDCOND_2019, replace

/* Medical conditions file 2018 */
use h207.dta, clear
rename *, lower
save MEDCOND_2018, replace



/* OB visits, person-visit-level 2021 */
use h229g, clear
use  DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OBXP21X using h229g, clear 
rename *, lower
rename eventrn eventrn_ob
save OB_2021, replace

/* OB visits, person-visit-level 2020 */
use  DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OBXP20X using h220g, clear 
rename *, lower
rename eventrn eventrn_ob
save OB_2020, replace

/* OB visits, person-visitlevel 2019 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OBXP19X using h213g, clear 
rename *, lower
rename eventrn eventrn_ob
save OB_2019, replace

/* OB visits, person-visit-level 2018 */
use  DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OBXP18X using h206g, clear 
rename *, lower
rename eventrn eventrn_ob
save OB_2018, replace




/* OP visits, person-visit-level 2021 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OPXP21X using h229f, clear 
rename *, lower
rename eventrn eventrn_op
save OP_2021, replace

/* OP visits, person-visit-level 2020 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 VISITTYPE OPXP20X  using h220f, clear 
rename *, lower
rename eventrn eventrn_op
save OP_2020, replace

/* OP visits, person-visit-level 2019 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OPXP19X using h213f, clear 
rename *, lower
rename eventrn eventrn_op
save OP_2019, replace

/* OP visits, person-visit-level 2018 */
use DUPERSID EVNTIDX EVENTRN PANEL SEEDOC_M18 DRSPLTY_M18 MEDPTYPE_M18 OPXP18X using h206f, clear 
rename *, lower
rename eventrn eventrn_op
save OP_2018, replace




/* IP visits, person-visit-level 2021*/
use  DUPERSID EVNTIDX EVENTRN PANEL IPXP21X using h229d, clear 
rename *, lower
rename eventrn eventrn_ip
save IP_2021, replace
 
/* IP visits, person-visit-level 2020*/ 
use DUPERSID EVNTIDX EVENTRN PANEL IPXP20X using h220d, clear 
rename *, lower
rename eventrn eventrn_ip
save IP_2020, replace

/* IP visits, person-visit-level 2019*/
use DUPERSID EVNTIDX EVENTRN PANEL IPXP19X using h213d, clear 
rename *, lower
rename eventrn eventrn_ip
save IP_2019, replace

/* IP visits, person-visit-level 2018*/  
use DUPERSID EVNTIDX EVENTRN PANEL IPXP18X using h206d, clear 
rename *, lower
rename eventrn eventrn_ip
save IP_2018, replace




/*ER visits 2021*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP21X using h229e, clear 
rename *, lower
rename eventrn eventrn_er
save ER_2021, replace

/*ER visits 2020*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP20X using h220e, clear 
rename *, lower
rename eventrn eventrn_er
save ER_2020, replace

/*ER visits 2019*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP19X using h213e, clear 
rename *, lower
rename eventrn eventrn_er
save ER_2019, replace

/*ER visits 2018*/
use DUPERSID EVNTIDX EVENTRN PANEL ERXP18X using h206e, clear 
rename *, lower
rename eventrn eventrn_er
save ER_2018, replace


/* Longitudinal file, person-round level */
use h236, clear
rename *, lower
save PANEL23_18_21, replace

use duid pid dupersid panel yearind saqrds2468 saqrds246 all9rds region1-regiony4 proxy1-proxy9 begrfm1-endrfyy4 dobmm dobyy age1x-age9x sex racev1x hispanx marry1x-marry9x marryy1x marryy4x educyr ftstu1x-ftstuy4x rthlth1-rthlth9 mnhlth1-mnhlth9 hibpdxy1-hibpdxy4 bpmldxy1-bpmldxy4 chddxy1-chddxy4 angidxy1-angidxy4 ohrtdxy1-ohrtdxy4 strkdxy1-strkdxy4 choldxy1-choldxy4 cancery1-cancery4 diabdxy1_m18-diabdxy4_m18 arthdxy1-arthdxy4 asthdxy1-asthdxy4 actlim1-actlim7 soclim1-soclim7 coglim1-coglim7 anylmiy1-anylmiy4 phyexe3-oftsmk9 adgenh2-adgenh8 addaya2-addaya8 adpain2-adpain8 adpcfl2-adpcfl8 adengy2-adengy8 adsoca2-adsoca8 vpcs2-vpcs8 vmcs2-vmcs8 k6sum2-k6sum8 phq22-phq28 admntrt6 adonltrt6 adphontrt6 adapptrt6 adtrtexp6 adoftb2 adoftb6 ins1x-insaty4x famincy1-famincy4 empst1-empst9h lsaqwt longwt varpsu varstr using PANEL23_18_21, clear

save panel23_selectvars, replace



****************************************
* Merge conditions file with CLINK file
*****************************************

* 2021
use CLNK_2021, clear
merge m:1 dupersid condidx using MEDCOND_2021
keep dupersid condidx evntidx clnkidx eventype panel condn condrn icd10cdx ccsr1-ccsr3 
keep if strmatch(icd10cdx, "F*")>0

merge m:1 evntidx using OB_2021
drop if _merge == 2
drop _merge

merge m:1 evntidx using IP_2021
drop if _merge == 2
drop _merge

merge m:1 evntidx using OP_2021
drop if _merge == 2
drop _merge

merge m:1 evntidx using ER_2021
drop if _merge == 2
drop _merge

//tab condrn eventrn

tab panel

keep if panel == 23

save 2021_conditions_event, replace

* 2020
use CLNK_2020, clear
merge m:1 dupersid condidx using MEDCOND_2020
keep dupersid condidx evntidx clnkidx eventype panel condn condrn icd10cdx ccsr1-ccsr3 
keep if strmatch(icd10cdx, "F*")>0

merge m:1 evntidx using OB_2020
drop if _merge == 2
drop _merge

merge m:1 evntidx using IP_2020
drop if _merge == 2
drop _merge

merge m:1 evntidx using OP_2020
drop if _merge == 2
drop _merge

merge m:1 evntidx using ER_2020
drop if _merge == 2
drop _merge

//tab condrn eventrn

tab panel

keep if panel == 23

save 2020_conditions_event, replace

* 2019
use CLNK_2019, clear
merge m:1 dupersid condidx using MEDCOND_2019
keep dupersid condidx evntidx clnkidx eventype panel condn condrn icd10cdx ccsr1-ccsr3 
keep if strmatch(icd10cdx, "F*")>0

merge m:1 evntidx using OB_2019
drop if _merge == 2
drop _merge

merge m:1 evntidx using IP_2019
drop if _merge == 2
drop _merge

merge m:1 evntidx using OP_2019
drop if _merge == 2
drop _merge

merge m:1 evntidx using ER_2019
drop if _merge == 2
drop _merge

//tab condrn eventrn

tab panel

keep if panel == 23

save 2019_conditions_event, replace

* 2018
use CLNK_2018, clear
merge m:1 dupersid condidx using MEDCOND_2018
keep dupersid condidx evntidx clnkidx eventype panel condn condrn icd10cdx ccsr1-ccsr3 
keep if strmatch(icd10cdx, "F*")>0

merge m:1 evntidx using OB_2018
drop if _merge == 2
drop _merge

merge m:1 evntidx using IP_2018
drop if _merge == 2
drop _merge

merge m:1 evntidx using OP_2018
drop if _merge == 2
drop _merge

merge m:1 evntidx using ER_2018
drop if _merge == 2
drop _merge

//tab condrn eventrn

tab panel

keep if panel == 23

save 2018_conditions_event, replace

* Panel 23, medical conditions and event files - 2018-2021

///// START FROM HERE
///// Create one variable that has the eventround info for all visit types. 


* Preparing 2021 file for merging
use 2021_conditions_event, clear
tab eventype
drop if eventype == 7 | eventype == 8

gen xp21x = .
	replace xp21x = opxp21x if opxp21x !=.
	replace xp21x = obxp21x if obxp21x !=.
	replace xp21x = ipxp21x if ipxp21x !=.
	replace xp21x = erxp21x if erxp21x !=.
	

	
di 949+8616+14+26 // xp21x spans all records

bys eventype: summ xp21x

gen year = 2021
save 2021_conditions_event, replace

* Preparing 2020 file for merging
use 2020_conditions_event, clear
tab eventype
drop if eventype == 7 | eventype == 8

gen xp20x = .
	replace xp20x = opxp20x if opxp20x !=.
	replace xp20x = obxp20x if obxp20x !=.
	replace xp20x = ipxp20x if ipxp20x !=.
	replace xp20x = erxp20x if erxp20x !=.
	
di 1086+11597+38+45 // xp21x spans all records

bys eventype: summ xp20x

gen year = 2020
save 2020_conditions_event, replace

* Preparing 2019 file for merging
use 2019_conditions_event, clear
tab eventype
drop if eventype == 7 | eventype == 8

gen xp19x = .
	replace xp19x = opxp19x if opxp19x !=.
	replace xp19x = obxp19x if obxp19x !=.
	replace xp19x = ipxp19x if ipxp19x !=.
	replace xp19x = erxp19x if erxp19x !=.
	
di 1052+17610+82+139 // xp19x spans all records

bys eventype: summ xp19x

gen year = 2019
save 2019_conditions_event, replace

* Preparing 2018 file for merging
use 2018_conditions_event, clear
tab eventype
drop if eventype == 7 | eventype == 8

gen xp18x = .
	replace xp18x = opxp18x if opxp18x !=.
	replace xp18x = obxp18x if obxp18x !=.
	replace xp18x = ipxp18x if ipxp18x !=.
	replace xp18x = erxp18x if erxp18x !=.
	
di 1216+16807+83+134 // xp18x spans all records

bys eventype: summ xp18x

gen year = 2018
save 2018_conditions_event, replace

distinct icd10cdx dupersid  if eventype == 1, joint
distinct icd10cdx dupersid if eventype == 2, joint
distinct icd10cdx dupersid if eventype == 3, joint
distinct icd10cdx dupersid if eventype == 4, joint


* Appending all files