clear
/// set the working directory
cd "C:\Users\robba\Dropbox\STATA_municipalities_project"

/// import dataset
import delimited "C:\Users\robba\Dropbox\STATA_municipalities_project\pdata_mar27.csv"

/// drop nans
drop if ln_zaisei_indicator == "NA"
drop if ln_income_pc == "NA"
drop if merged_mun == "NA"
drop if may_age == "NA"
drop if ln_ldp_perc == "NA"

/// below only if want to use mayoral attribute variables
//drop if may_ldp == "NA"
//drop if may_reelect == "NA"

//destring may_reelect, replace
//destring may_ldp, replace


/// numerize the problem variables 
destring ln_zaisei_indicator, replace
destring ln_income_pc, replace
encode merged_mun, generate(merged_mun_2)
destring may_age, replace
destring ln_ldp_perc, replace
encode may_female, generate(may_female_2)


/// table of descriptive statistics
sum year mutohyo_mayor mutohyo_city pop_o65_perc merged_mun tot_pop  income_pc tot_area_ha  total_expenses_estat totseat_city primary_ind_perc perc_did may_age may_female may_incumbent fiscal_autonomy zaisei_indicator ldp_perc

/// set panel variables 
xtset muncode year

/// regression modelling
//tests 

regress ln_fiscal_autonomy mutohyo_mayor mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent // models give similar but not identical output to R  - perhaps R models should be 

/// table 2 main models
xtpcse ln_zaisei_indicator mutohyo_mayor ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent, pairwise
est store m1_xt

xtpcse ln_zaisei_indicator mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m2_xt

xtpcse ln_zaisei_indicator mutohyo_mayor mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m3_xt

xtpcse ln_zaisei_indicator mutohyo_mayor##mutohyo_city ln_pop_o65_perc merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m4_xt

xtpcse ln_zaisei_indicator mutohyo_mayor##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m5_xt

xtpcse ln_zaisei_indicator mutohyo_mayor##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m6_xt

xtpcse ln_zaisei_indicator mutohyo_city##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m7_xt

xtpcse ln_zaisei_indicator mutohyo_city##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pairwise
est store m8_xt

outreg2 [m1_xt m2_xt m3_xt m4_xt m5_xt m6_xt m7_xt m8_xt] using main_mods, dec(2) word excel replace label


// model 1 replications
xtreg ln_zaisei_indicator mutohyo_mayor ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_mayor ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_mayor ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_1, dec(2) word excel replace label

// model 2 replications

xtreg ln_zaisei_indicator mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_2, dec(2) word excel replace label

// model 3 replications

xtreg ln_zaisei_indicator mutohyo_mayor mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_mayor mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_mayor mutohyo_city ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_3, dec(2) word excel replace label

// model 4_1 replications

xtreg ln_zaisei_indicator mutohyo_mayor##mutohyo_city ln_pop_o65_perc merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_mayor##mutohyo_city ln_pop_o65_perc merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_mayor##mutohyo_city ln_pop_o65_perc merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_4_1, dec(2) word excel replace label


// model 4 replications

xtreg ln_zaisei_indicator mutohyo_mayor##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_mayor##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_mayor##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_4, dec(2) word excel replace label

// model 5 replications

xtreg ln_zaisei_indicator mutohyo_mayor##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_mayor##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_mayor##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_5, dec(2) word excel replace label

// model 6 replications

xtreg ln_zaisei_indicator mutohyo_city##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_city##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_city##c.ln_pop_o65_perc  merged_mun_2 ln_tot_pop_10k ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_6, dec(2) word excel replace label
// model 7 replications

xtreg ln_zaisei_indicator mutohyo_city##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,re cluster(muncode)
est store ind_2b_re

xtreg ln_zaisei_indicator mutohyo_city##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,be
est store ind_2b_be

xtreg ln_zaisei_indicator mutohyo_city##c.ln_tot_pop_10k ln_pop_o65_perc merged_mun_2 ln_income_pc ln_tot_area_ha ln_lag_exp totseat_city ln_ldp_perc ln_primary_ind_perc ln_perc_did may_age may_female_2 may_incumbent,pa
est store ind_2b_pa

outreg2 [ind_2b_re ind_2b_be ind_2b_pa] using mod_7, dec(2) word excel replace label









