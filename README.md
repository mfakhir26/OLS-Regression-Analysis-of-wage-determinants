# OLS Regression Analysis of Wage Determinants Using Stata

# Project Overview
The objective of this project is to build a regression model on the response variable 'average hourly earnings'.

Conducted a comprehensive econometric analysis to identify the key factors influencing hourly wages using the U.S. Current Population Survey (CPS) dataset. Developed and compared multiple Ordinary Least Squares (OLS) regression models to evaluate the impact of education, work experience, tenure, demographic characteristics, occupation, industry, and geographic factors on earnings.

**Key Contributions:**
- Data Preparation including data cleaning, converting raw dummy variables into categorical variables and then using them in the model.
- Dropping unnecessary variables for cleaned data of less dimension.
- Built and interpreted three log-linear wage regression models using OLS Regression.
- Analyzed the effects of  years of education, experience, tenure, gender, marital status, race, urban residence, occupation, industry, and regional variables on wages.
- Incorporated non-linear relationships through squared terms for experience and tenure to capture diminishing returns and identified wage turning points.
- Evaluated model performance using R² statistics and statistical significance testing.
- Performed diagnostic tests to validate OLS assumptions, including normality, homoscedasticity, and independence of residuals.
- Identified significant wage determinants such as education, work experience, tenure, urban residence, occupation, and gender.
- Also, identified that only few categories in defined categorical variables had statistical significant impact on wages such as Professional Occupation, Service Industry, and wholesale or retail trade industry.
- Provided clear and precise interpretation for dummy variables that are included in the models in simple words.

  ## Data Source & Documentation
* **Dataset:** `wage1` (1976 Cross-Section)
* **Primary Compiler:** **Dr. Jeffrey Wooldridge** (Distinguished Professor of Economics at Michigan State University), featured in his textbook *Introductory Econometrics: A Modern Approach*.
* **Original Source:** U.S. Current Population Survey (CPS), 1976.
* **Data Repository:** Hosted by the Boston College Economics Data Archive (maintained by Christopher F. Baum).

In this project, the main focus was to use Stata software completely from data cleaning to training the model. The regression analysis was done and three different models were built and the results of all the models with the complete interpretation have been discussed in the file `final_analysis.pdf` attached with this repository. All of the key findings are included in this file.

Main files in this repository:
- DO file
- DATA
- stata file with 'dta' extension

Stata will run all of the above process in the do-file after setting the directory in do-file and running it after storing the data in that directory.

**Tools & Techniques:** Stata, Data preparation, Data Analysis, OLS Regression Analysis, Regression Diagnostics, Statistical Modeling, Hypothesis Testing, Data Interpretation.

=============================================================================================================================
