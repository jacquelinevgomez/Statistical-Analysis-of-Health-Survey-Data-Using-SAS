options ls=232 ps=max nocenter nodate nosource;
/* libname meps "C:\Data\MEPS\Datasets";  -- provided by autoexec (WORK stand-in) */

/**********************************/ 
/* Simple Linear Regression Model */
/* Data: MEPS 2020 Household file */
/*                                */ 
/* Jacqueline Gomez               */
/* 28 January 2024                */
/**********************************/

/* Simple Linear Regression */
proc reg data = meps.phar5323;
	model VPCS42 = age;
run;
