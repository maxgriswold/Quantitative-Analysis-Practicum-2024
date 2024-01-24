*Note that this is the code I used for my final paper for Applied Stats 2023
*Uploading here to the Quantitative Practicum mainly to test GIT

*for 2017 CSv files
rename geographicareanamename country

rename yearyear year

rename naicscodenaics2017 NAICS

rename meaningofnaicscodenaics2017_labe NAICS_label

rename meaningoftypeofoperationcodetypo firm_type

rename meaningoffirmconcentrationcodeco firm_number

rename salesvalueofshipmentsorrevenueof market_concentration

*for 2012 CSV files
rename geographicareanamegeo_ttl country

rename yearyear year

rename naicscodenaics2012 NAICS

rename meaningof2012naicscodenaics2012_ NAICS_label

*might not be in data
rename meaningoftypeofoperationcodetypo firm_type

rename meaningoffirmconcentrationcodeco firm_number

rename revenueoflargestfirmsaspercentof market_concentration


***In CPS datafile

gen NAICS_label = ""

replace NAICS_label = "Accommodation and food services" if occ == 0340 | occ == 4000 | occ == 4010 | occ == 4020 | occ == 4030 | occ == 4040 | occ == 4050 | occ == 4060 | occ == 4110 | occ == 4120 | occ == 4130 | occ == 4140 | occ == 4150 | occ == 4160 | occ == 5300 | occ == 5400 | occ == 5410

replace NAICS_label = "Arts, entertainment, and recreation" if occ == 0500 | occ == 2600 | occ == 2630 | occ == 2850 | occ == 2700 | occ == 2710 | occ == 2740 | occ == 2750 | occ == 2760 | occ == 2860 | occ == 2900 | occ == 2910 | occ == 2920 | occ == 2960 

replace NAICS_label = "Educational services" if occ == 0230 | occ == 2200 | occ == 2300 | occ == 2310 | occ == 2320 | occ == 2330 | occ == 2340 | occ == 2540 | occ == 2550 

replace NAICS_label = "Finance and insurance" if occ == 0040 | occ == 0050 | occ == 0120 | occ == 0135 | occ == 0136 | occ == 0137 | occ == 0140 | occ == 0150 | occ == 0540 | occ == 0600 | occ == 0820 | occ == 0830 | occ == 0840 | occ == 0850 | occ == 0860 | occ == 0900 | occ == 0910 | occ == 0930 | occ == 0940 | occ == 0950 | occ == 1200 | occ == 4810 | occ == 4820 | occ == 5140 | occ == 5150 | occ == 5160 | occ == 5165 | occ == 5330 

replace NAICS_label = "Health care and social assistance" if occ == 0350 | occ == 1820 | occ == 3000 | occ == 3010 | occ == 3030 | occ == 3040 | occ == 3050 | occ == 3060 | occ == 3110 | occ == 3120 | occ == 3140 | occ == 3150 | occ == 3160 | occ == 3200 | occ == 3210 | occ == 3220 | occ == 3230 | occ == 3235 | occ == 3245 | occ == 3255 | occ == 3256 | occ == 3257 | occ == 3258 | occ == 3260 | occ == 3300 | occ == 3310 | occ == 3320 | occ == 3400 | occ == 3420 | occ == 3500 | occ == 3510 | occ == 3520 | occ == 3535 | occ == 3540 | occ == 3600 | occ == 3610 | occ == 3620 | occ == 3630 | occ == 3640 | occ == 3645 | occ == 3646 | occ == 3647 | occ == 3649 | occ == 3655

replace NAICS_label = "Information" if occ == 0110 | occ == 1000 | occ == 1005 | occ == 1006 | occ == 1007 | occ == 1010 | occ == 1020 | occ == 1030 | occ == 1050 | occ == 1060 | occ == 1105 | occ == 1106 | occ == 1107 | occ == 5800 | occ == 5810 | occ == 5820

*replace NAICS_label = "Other services (except public administration)" if occ == 

replace NAICS_label = "Real estate and rental and leasing" if occ == 0810 | occ == 4920 

replace NAICS_label = "Retail trade" if occ == 4760 | occ == 4800 | occ == 4950 | occ == 4965 

replace NAICS_label = "Professional, scientific, and technical services" if occ == 1210 | occ == 1230 | occ == 1240 | occ == 1300 | occ == 1310 | occ == 1320 | occ == 1330 | occ == 1340 | occ == 1350 | occ == 1360 | occ == 1400 | occ == 1410 | occ == 1420 | occ == 1430 | occ == 1440 | occ == 1450 | occ == 1460 | occ == 1500 | occ == 1510 | occ == 1520 | occ == 1530 | occ == 1540 | occ == 1550 | occ == 1560 | occ == 1600 |  occ == 1610 | occ == 1640 | occ == 1650 | occ == 1660 | occ == 1700 |  occ == 1710 | occ == 1720 | occ == 1740 | occ == 1760 | occ == 1800 | occ == 1815 | occ == 1830 | occ == 1840 | occ == 1860 | occ == 1900 | occ == 1910 | occ == 1920 | occ == 1930 | occ == 1940 | occ == 1950 | occ == 1965 

replace NAICS_label = "Transportation and warehousing" if occ == 0160 

*replace NAICS_label = "Utilities" if occ == 

replace NAICS_label = "Administrative and support and waste management and remediation services" if occ == 0030 | occ == 0100 

replace NAICS_label = "Wholesale trade" if occ == 4850 | occ == 5500 | occ == 5610 | occ == 5620 | occ == 5630 

*replace NAICS_label = "Utilities" if occ == 



***************************************
gen employed = .
replace employed = 1 if empstat2 == 1 | empstat2 == 10 | empstat2 == 12
replace employed = 0 if labforce == 2 & employed != 1

*numerator for non-disabled, 2012
tab employed if labforce == 2 & year == 2012 & diffany == 1

*denominator for non-disabled, 2012
tab labforce if year == 2012 & diffany == 1

*numerator for non-disabled, 2017
tab employed if labforce == 2 & year == 2017 & diffany == 1

*denominator for non-disabled, 2017
tab labforce if year == 2017 & diffany == 1

*numerator for disabled, 2012
tab employed if labforce == 2 & year == 2012 & diffany == 2

*denominator for disabled, 2012
tab labforce if year == 2012 & diffany == 2

*numerator for disabled, 2017
tab employed if labforce == 2 & year == 2017 & diffany == 2

*denominator for disabled, 2017
tab labforce if year == 2017 & diffany == 2


Arts, entertainment, and recreation
Educational services
Health care and social assistance
Professional, scientific, and technical services

regress employed market_concentration 


