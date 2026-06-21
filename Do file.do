* ===============================================================================
** STATA PROJECT: REGRESSION ANALYSIS ON WAGES DATA (Jeffrey Wooldridge's DATASET)
** DATE: JUNE-2026
* ================================================================================

clear all //clears momory

set more off //doesn't omit output

cd "C:\Users\PMLS\Desktop\Stata Project" //directory

import excel "wages_data.xlsx", firstrow clear

browse //opens a window in which we can take a look at our data

**Let's take a overview of data by the below command
describe

**check if there are any missing values in data
misstable summarize //no missing values were found after executing this command

**there are so many dummy variables and we will combine some of the dummy 
// variables into one with different categories merged

**label the variables

label variable wage "Average hourly earnings"
label variable educ "Years of education"
label variable exper "Years potential experience"
label variable tenure "Years with current employer"
label variable numdep "Number of dependents"
label variable lwage "log(wage)"
label variable expersq "Years potential experience squared (experience squared)"
label variable tenursq "Years with current employer squared (tenure squared)"
label variable smsa "urban area" // = 1 means employee lives in urban area

** log of variable wage and squares of some variables were already done in the dataset.

// we will merge 'northcen', 'south' and 'west' dummy variables into
// a single categorical variable with these mentioned dummy variables as categories.

gen region = .
replace region = 0 if northcen == 0 & south == 0 & west == 0 //defining region=0 because some employees have unknown region.
replace region = 1 if northcen == 1
replace region = 2 if south == 1
replace region = 3 if west == 1

// label the values of the variable region
label define region_label 0 "Unknown (Northeast)" 1 "North Central U.S" 2 "Southern Region" 3 "Western Region"
label values region region_label

*frequency table of variable region
tabulate region

// now we will merge different industry dummy variables into one
// categorical variable

gen industry = .
replace industry = 0 if construc == 0 & ndurman == 0 & trcommpu == 0 & trade == 0 & services == 0 & profserv == 0
replace industry = 1 if construc == 1
replace industry = 2 if ndurman == 1
replace industry = 3 if trcommpu == 1
replace industry = 4 if trade == 1
replace industry = 5 if services == 1
replace industry = 6 if profserv == 1

label define industry_label ///
	0 "Omitted industry" ///
	1 "Construction industry" ///
	2 "Nondurable manufacturing industry" ///
	3 "Transportation, communication, public utilities industry" ///
	4 "Wholesale or retail trade industry" ///
	5 "Services industry" ///
	6 "Professional services industry"
	
label values industry industry_label


// frequency table of industry
tabulate industry

// now we will merge 'profocc', 'clerocc', 'servocc' dummy variables into one 
// occupation categorical variable

gen occupation = .
replace occupation = 0 if profocc == 0 & clerocc == 0 & servocc == 0
replace occupation = 1 if profocc == 1
replace occupation = 2 if clerocc == 1
replace occupation = 3 if servocc == 1

label define occ_label 0 "Omitted Occupation" ///
					1 "Professional Occupation" ///
					2 "Clerical Occupation" ///
					3 "Service Occupation"
					
label values occupation occ_label



// frequency table
tab occupation

// labels new variables made
label variable region "Regions"
label variable industry "Industry"
label variable occupation "Occupation"

// cross tabulation table of occupation and industry variables
tabulate industry occupation

** Since, we have created the categorical variables of different dummy 
* variables combined so dummy variables will be dropped for simpler dataset that
* can be used for regression analysis.


// drop region dummy variables
drop northcen south west

//drop industries dummy variables
drop construc ndurman trcommpu trade services profserv

//drop occupation dummy variables
drop profocc clerocc servocc

gen time_id = _n // creates a new variable counting from 1 to the end of the data
** will be used in regression diagnostics **

label variable time_id "Time ID" 
 
// data cleaning has been done and now we move forward.	
// checking the distribution of our response variable wage

histogram wage, fcolor(ltblue) title(Wage distribution) //right-skewed distribution
graph export "wage_distribution.png", replace

//checking the distribution of 'lwage' (log(wage))
histogram lwage, normal fcolor(midblue) title("Distribution of ln(wage)")
graph export "lnwage_distribution.png", replace

** the distribution of ln(wage) is more symmetrical than the original variable wage and
** thus ln(wage) will be taken as a reponse variable.

// overview the summary statistics of below variables
summarize wage lwage educ exper tenure numdep

//correlation between variables
correlate wage lwage educ exper tenure numdep

***=======================================================================================***

ssc install estout //downlaods the package

eststo clear // clears any existing stored model in stata's memory

* Model 1: (Only Education and Experience)
eststo m1: regress lwage educ exper expersq tenure tenursq

*Model 2:
eststo m2: regress lwage ///
	educ exper expersq tenure tenursq ///
	nonwhite female married numdep smsa
// in model-2 output, it can be seen that the variables non-white, 
// numdep and married are
// statistically insignificant.


*Model 3: (The full model)

eststo m3: regress lwage ///
	educ exper expersq tenure tenursq ///
	nonwhite female married numdep smsa ///
	i.region i.industry i.occupation
	
// model-3 is our final model and the assumptions of OLS regression
// will be checked.

** Multicollinearity **
estat vif
// NO such multicollinearity in any variable leaving exper tenure and their
// squared variables which is okay.

** Heteroscedasticity assumption **
hettest
rvfplot, recast(scatter) title("Residuals VS Fitted Values") yline(0) 
//plot of residuals vs predicted values
graph export "Residuals VS Predicted values.png", replace
// the independence assumption isn't violated and the pattern of graph is random.	

** NORMALITY ASSUMPTION **
predict resid, residuals
pnorm resid, title("Normal Probability Plot of Residuals") //NPP plot of residuals
graph export "NPP_plot of residuals.png", replace
// normality assumption is checked and it is not violated.

** INDEPENDENCE ASSUMPTION **
tsset time_id
estat bgodfrey
// p-value > 0.05, fail to reject and error terms are independent.

** export the model's output **
// re-run all the three models
eststo clear
eststo m1: regress lwage educ exper expersq tenure tenursq

eststo m2: regress lwage ///
	educ exper expersq tenure tenursq ///
	nonwhite female married numdep smsa

eststo m3: regress lwage ///
	educ exper expersq tenure tenursq ///
	nonwhite female married numdep smsa ///
	i.region i.industry i.occupation
		
		
* exports to a publication-ready table to a microsoft word doc
esttab m1 m2 m3 using model_results.rtf, b(3) se(3) r2 star(* 0.10 ** 0.05 *** 0.01) label replace


// save the work
save "wage_project_final.dta", replace
