options ls=232 ps=max nocenter nodate nosource;
/* libname meps "C:\Data\MEPS\Datasets";  -- provided by autoexec (WORK stand-in) */

/************************************/ 
/* Multiple Linear Regression Model */
/* Data: MEPS 2020 Household file   */
/*                                  */ 
/* Jacqueline Gomez                 */
/* 04 February 2024                  */
/************************************/

/* Test Multicollinearity */
proc corr data = meps.phar5323  
	(keep = VPCS42 
			age 
			phlth_grp5 
			mhlth_grp5 
			er_vis);
	var age phlth_grp5 mhlth_grp5 er_vis;
run;

proc reg data = meps.phar5323 
	(keep = VPCS42 
			age 
			phlth_grp5 
			mhlth_grp5 
			er_vis);  
   model VPCS42 = age phlth_grp5 mhlth_grp5 er_vis /tol vif;
run;

proc means data = meps.phar5323  
	(keep = VPCS42 
			age 
			phlth_grp5 
			mhlth_grp5 
			er_vis) n mean max min Q1 median Q3;
run; 

/* Multiple Linear Regression */
ods graphics on / imagename="VPCS42_MLR";
proc reg data = meps.phar5323  
	(keep = VPCS42 
			age 
			phlth_grp5 
			mhlth_grp5 
			er_vis) ;  
   model VPCS42 = age phlth_grp5 mhlth_grp5 er_vis;
run;

ods graphics off;

/* Test Hypothesis */
proc means data = meps.phar5323
	(keep = VPCS42 
			age 
			phlth_grp5 
			mhlth_grp5 
			er_vis) n mean max min Q1 median Q3;
run;
 
proc reg data = meps.phar5323 
	(keep = VPCS42 
			age 
			phlth_grp5 
			mhlth_grp5 
			er_vis);  
   model VPCS42 = age phlth_grp5 mhlth_grp5 er_vis;
   TEST1: test age = phlth_grp5;
   TEST2: test age = mhlth_grp5;
   TEST3: test age = er_vis;
   TEST4: test phlth_grp5= mhlth_grp5;
   TEST5: test phlth_grp5 = er_vis;
   TEST6: test mhlth_grp5 = er_vis;
run;
