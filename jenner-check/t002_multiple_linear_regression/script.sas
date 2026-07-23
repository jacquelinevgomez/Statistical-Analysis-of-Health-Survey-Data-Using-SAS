options ls=232 ps=max nocenter nodate nosource;

/* The original script opened  libname meps "C:\Data\MEPS\Datasets"  and read  */
/* meps.phar5323 (a MEPS 2020 extract on the author's machine). To make this   */
/* bundle self-contained, meps points at WORK and a small synthetic stand-in   */
/* is built with the same columns/types the analysis reads. Values are         */
/* generated (age carries the negative VPCS42 association the study describes), */
/* not real survey records.                                                    */
libname meps (work);
data meps.phar5323;
  call streaminit(20240128);
  do i = 1 to 400;
    age        = round(18 + 62*rand('uniform'));
    phlth_grp5 = 1 + floor(5*rand('uniform'));
    mhlth_grp5 = 1 + floor(5*rand('uniform'));
    er_vis     = rand('poisson', 0.4);
    VPCS42     = 62 - 0.26*age - 1.8*phlth_grp5 - 1.1*mhlth_grp5
                 - 0.9*er_vis + rand('normal', 0, 7);
    if VPCS42 < 0  then VPCS42 = 0;
    if VPCS42 > 90 then VPCS42 = 90;
    VPCS42 = round(VPCS42, 0.01);
    output;
  end;
  drop i;
run;

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
