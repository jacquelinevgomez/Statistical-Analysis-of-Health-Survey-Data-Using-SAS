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
