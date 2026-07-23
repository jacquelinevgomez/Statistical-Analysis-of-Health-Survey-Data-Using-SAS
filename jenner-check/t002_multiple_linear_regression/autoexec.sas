/* cap input rows for the captured run */
options obs=100;

/* The original script opens libname meps "C:\Data\MEPS\Datasets" and reads   */
/* meps.phar5323 (a MEPS 2020 extract). That path is local to the author's    */
/* machine, so this autoexec points meps at WORK and builds a synthetic       */
/* stand-in with the same columns and types the analysis reads: VPCS42, age,  */
/* phlth_grp5, mhlth_grp5, er_vis. Values are generated (age carries the       */
/* negative association with VPCS42 the study describes), not real records.    */
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
