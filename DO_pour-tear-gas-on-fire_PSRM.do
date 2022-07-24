******************************************************************************************************
******************************************************************************************************
//-----------POUR (TEAR) GAS ON FIRE? VIOLENT CCONFRONTATIONS AND ANTI-GOVERNMENT BACKLASH----------//
//--------------------------PPOLITICAL SCIENCE RESEARCH AND METHODS---------------------------------//
//-------------------------------For Replication and Publication------------------------------------//
******************************************************************************************************
******************************************************************************************************

//---------------NOTES---------------//
*Please use Stata 15 or above (for figure 3 please use Stata 16 or above)
*Please install the following packages
ssc install cem
ssc install combomarginsplot


//---------------PSRM REPLICATION DATA---------------//
*Please cd to the folder that includes all of our data and files
cd "C:\Users\yama8\Desktop\PSRM_2022-724\PSRM_stata_2022-724"


use DATA_pour-tear-gas-on-fire_PSRM.dta

**IMPORTANT: The shapefile must be in the same/current directory
**This command sets the name of the shapefile
spset, modify shpfile(DATA_pour-tear-gas-on-fire_PSRM_Stata_Shapefile.dta)
// Gen 2sls data
// First order neighbour (all with spectral normalisation)
spmatrix create contiguity W1
// second order neighbour
spmatrix create contiguity W2, second
// weighed first and second order neighbour
. spmatrix create contiguity W3, first second(0.5)
// inverse distance
spmatrix create idistance W4


//---------------VARIABLES CONSTRUCTION---------------//
g tg_binary=0
replace tg_binary=1 if tgfreq>0
recode tgfreq 1/5=1 6/10=2 11/15=3 16/184=4, gen(tg_rank4)

g tg=tgfreq
g tg_logp1=log(tg+.1)
g tg_log1=log(tg+1)

encode district19, gen(district19_num)
list district19 district19_num name_c, nol
recode district19_num 1 2 3 4=1 5 6 7=2 8 9=3 10 11 12 17 18=4 13 14 15 16=5, gen(dlegco)

g eventfreq=event_freq
g eventbinary=event_binary
g log_eventfreq=log(eventfreq+.1)
g density=population/size
g logdensity=log(density)
g log_tgclosest= log(centroid_from_closest_tg)
g tgaway_1km=centroid_from_closest_tg>1000
g tgaway_2km=centroid_from_closest_tg>2000
g tgaway_3km=centroid_from_closest_tg>3000
g tgaway_4km=centroid_from_closest_tg>4000
g tgaway_0km=centroid_from_closest_tg<1001


//---------------STANDARDIZED VARIABLES---------------//
egen zdegree = std(degree)
egen zmedianage = std(mediage)
egen zmedianincome = std(medianincome)
egen zprivate = std(private)
egen ztg_log1 = std(tg_log1)
egen ztg_logp1= std(tg_logp1)
egen znew_reg_percent = std(new_reg_percent)
egen zlog_tgclosest = std(log_tgclosest)
egen zlogdensity=std(logdensity)
egen zdensity=std(density)
egen zlog_eventfreq=std(log_eventfreq)


//---------------LABELS---------------//
lab var tg_binary "Tear gas (\emph{binary})"
lab var ztg_log1 "Tear gas (\emph{log})"
lab var tg_rank4 "Tear gas: 4 rank"
lab var incumbent_est "Pro-Beijing incumbency"
lab var newdistrict "New district"
lab var turnout "Turnout"
lab var znew_reg_percent "Newly registered voters\%"
lab var zdegree "Degree holders\%"
lab var zmedianage "Median age"
lab var zmedianincome "Median income"
lab var zprivate "Private housing\%"
lab var tg_rank4 "Tear Gas: 4 Rank"
lab var ztg_logp1 "Tear Gas \emph{log+.1}"
lab var zlogdensity "Population density (\emph{log})"
lab var zdensity "Population density"
lab var eventbinary "Mobilization events (\emph{binary})"
lab var zlog_eventfreq "Mobilization events frequency (\emph{log})"
lab var zlog_tgclosest "Distance to nearest tear gas exposure (\emph{log})"
lab var tgaway_0km "Tear gas exposure $\leqslant$ 1km"
lab var tgaway_1km "Tear gas exposure $>$ 1km"
lab var tgaway_2km "Tear gas exposure $>$ 2km"
lab var tgaway_3km "Tear gas exposure $>$ 3km"
lab var tgaway_4km "Tear gas exposure $>$ 4km"


//---------------ENVIROMENT---------------//
global cov incumbent_est  znew_reg_percent zdegree zmedianage zmedianincome zprivate



**************************************************************************
**************************************************************************
//----------------------------TABLES------------------------------------//
**************************************************************************
**************************************************************************
*First order neighbour (all with spectral normalisation)
*Please rerun the following command if "weighting matrix W1 not found" is shown
*spmatrix create contiguity W1


//---------------TABLE 1---------------//
eststo clear
eststo m1: reghdfe percent_dem  tg_binary incumbent_est , a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  tg_binary $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (tg_binary  =yoshinoya ) incumbent_est , a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (tg_binary  =yoshinoya )  $cov, a(dlegco)  cluster(district19) 
spmatrix create contiguity W1 
eststo m5: spivregress percent_dem  (tg_binary  =yoshinoya ) incumbent_est  i.dlegco, dvarlag(W1) force  
eststo m6: spivregress percent_dem  (tg_binary  =yoshinoya ) $cov i.dlegco, dvarlag(W1) force

//---------------TABLE 2---------------//
eststo clear
eststo m1: reghdfe percent_dem  ztg_log1 incumbent_est , a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  ztg_log1  $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (ztg_log1  =yoshinoya ) incumbent_est , a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (ztg_log1  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m5: spivregress percent_dem  (ztg_log1  =yoshinoya ) incumbent_est  i.dlegco, dvarlag(W1) force  
eststo m6: spivregress percent_dem  (ztg_log1  =yoshinoya ) $cov i.dlegco, dvarlag(W1) force



//---------------TABLE 3---------------//
g tgbinXestincumbent=tg_binary*incumbent_est
g tglogXestincumbent=ztg_log1*incumbent_est
g yoshinoyaXincumbent=yoshinoya*incumbent_est
lab var tgbinXestincumbent "Tear gas (binary) x Pro-Beijing incumbency"
lab var tglogXestincumbent "Tear gas (log) x Pro-Beijing incumbency"

**Binary
eststo clear
eststo m1: reghdfe turnout  tg_binary    if incumbent_est==1 , a(dlegco)  cluster(district19)
eststo m2: ivreghdfe turnout  (tg_binary= yoshinoya)   if incumbent_est==1, a(dlegco)  cluster(district19)
eststo m3: spivregress turnout  (tg_binary= yoshinoya) i.dlegco  if incumbent_est==1, dvarlag(W1) force
eststo m4: reghdfe turnout  tg_binary    if incumbent_est==0 , a(dlegco)  cluster(district19)
eststo m5: ivreghdfe turnout  (tg_binary= yoshinoya)   if incumbent_est==0, a(dlegco)  cluster(district19)
eststo m6: spivregress turnout  (tg_binary= yoshinoya) i.dlegco  if incumbent_est==0, dvarlag(W1) force
eststo m7: reghdfe turnout  tg_binary incumbent_est tgbinXestincumbent , a(dlegco)  cluster(district19)
eststo m8: ivreghdfe turnout  tg_binary incumbent_est (tgbinXestincumbent=yoshinoyaXincumbent) , a(dlegco)  cluster(district19)
eststo m9: spivregress turnout  tg_binary incumbent_est (tgbinXestincumbent=yoshinoyaXincumbent) i.dlegco,  dvarlag(W1) force

**Log
eststo clear
eststo m1: reghdfe turnout  ztg_log1    if incumbent_est==1 , a(dlegco)  cluster(district19)
eststo m2: ivreghdfe turnout  (ztg_log1= yoshinoya)   if incumbent_est==1, a(dlegco)  cluster(district19)
eststo m3: spivregress turnout  (ztg_log1= yoshinoya) i.dlegco  if incumbent_est==1, dvarlag(W1) force
eststo m4: reghdfe turnout  ztg_log1    if incumbent_est==0 , a(dlegco)  cluster(district19)
eststo m5: ivreghdfe turnout  (ztg_log1= yoshinoya)   if incumbent_est==0, a(dlegco)  cluster(district19)
eststo m6: spivregress turnout  (ztg_log1= yoshinoya) i.dlegco  if incumbent_est==0, dvarlag(W1) force
eststo m7: reghdfe turnout  ztg_log1 incumbent_est tglogXestincumbent, a(dlegco)  cluster(district19)
eststo m8: ivreghdfe turnout  ztg_log1 incumbent_est (tglogXestincumbent=yoshinoyaXincumbent) , a(dlegco)  cluster(district19)
eststo m9: spivregress turnout  ztg_log1 incumbent_est (tglogXestincumbent=yoshinoyaXincumbent) i.dlegco,  dvarlag(W1) force




//---------------TABLE A.1---------------//
estpost summarize percent_dem tg_binary  tg_log1 tg_logp1  tg_rank4  log_tgclosest tgaway_0km tgaway_1km tgaway_2km  tgaway_3km tgaway_4km yoshinoya incumbent_est  turnout new_reg_percent degree mediage medianincome private density eventbinary log_eventfreq  


//---------------TABLE A.2---------------//
eststo clear
eststo m1: reghdfe percent_dem  tg_binary incumbent_est , a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  tg_binary $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (tg_binary  =yoshinoya ) incumbent_est , a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (tg_binary  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m5: spivregress percent_dem  (tg_binary  =yoshinoya ) incumbent_est  i.dlegco, dvarlag(W1) force  
eststo m6: spivregress percent_dem  (tg_binary  =yoshinoya ) $cov i.dlegco, dvarlag(W1) force


//---------------TABLE A.3---------------//
eststo clear
eststo m1: reghdfe percent_dem  ztg_log1 incumbent_est , a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  ztg_log1  $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (ztg_log1  =yoshinoya ) incumbent_est , a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (ztg_log1  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m5: spivregress percent_dem  (ztg_log1  =yoshinoya ) incumbent_est  i.dlegco, dvarlag(W1) force  
eststo m6: spivregress percent_dem  (ztg_log1  =yoshinoya ) $cov i.dlegco, dvarlag(W1) force


//---------------TABLE A.4---------------//
eststo clear
eststo m1: reghdfe percent_dem  tg_rank4 $cov, a(dlegco)  cluster(district19)  
eststo m2: ivreghdfe  percent_dem (tg_rank4  =yoshinoya ) $cov, a(dlegco)  cluster(district19) 
eststo m3: spivregress percent_dem  (tg_rank4  =yoshinoya ) $cov i.dlegco, dvarlag(W1) force
eststo m4: reghdfe percent_dem  ztg_logp1 $cov, a(dlegco)  cluster(district19)  
eststo m5: ivreghdfe  percent_dem (ztg_logp1  =yoshinoya ) $cov, a(dlegco)  cluster(district19) 
eststo m6: spivregress percent_dem  (ztg_logp1  =yoshinoya ) $cov i.dlegco, dvarlag(W1) force


//---------------TABLE A.5---------------//
eststo clear
eststo m1: reghdfe percent_dem  tg_binary $cov if tgfreq<101, a(dlegco)  cluster(district19) 
eststo m2: ivreghdfe  percent_dem (tg_binary  =yoshinoya ) $cov if tgfreq<101, a(dlegco)  cluster(district19) 
eststo m3: spivregress percent_dem  (tg_binary  =yoshinoya ) $cov i.dlegco if tgfreq<101, dvarlag(W1) force
eststo m4: reghdfe percent_dem  tg_binary $cov if tgfreq<51, a(dlegco)  cluster(district19) 
eststo m5: ivreghdfe  percent_dem (tg_binary  =yoshinoya ) $cov if tgfreq<51, a(dlegco)  cluster(district19) 
eststo m6: spivregress percent_dem  (tg_binary  =yoshinoya ) $cov i.dlegco if tgfreq<51, dvarlag(W1) force
eststo m7: reghdfe percent_dem  ztg_log1 $cov if tgfreq<101, a(dlegco)  cluster(district19) 
eststo m8: ivreghdfe  percent_dem (ztg_log1  =yoshinoya ) $cov if tgfreq<101, a(dlegco)  cluster(district19) 
eststo m9: spivregress percent_dem  (ztg_log1  =yoshinoya ) $cov i.dlegco if tgfreq<101, dvarlag(W1) force
eststo m10: reghdfe percent_dem  ztg_log1 $cov if tgfreq<51, a(dlegco)  cluster(district19) 
eststo m11: ivreghdfe  percent_dem (ztg_log1  =yoshinoya ) $cov if tgfreq<51, a(dlegco)  cluster(district19) 
eststo m12: spivregress percent_dem  (ztg_log1  =yoshinoya ) $cov i.dlegco if tgfreq<51, dvarlag(W1) force


//---------------TABLE A.6---------------//
eststo clear
eststo m1: reghdfe turnout  tg_binary incumbent_est , a(dlegco)  cluster(district19)  
eststo m2: ivreghdfe  turnout (tg_binary  =yoshinoya) incumbent_est , a(dlegco)  cluster(district19) 
eststo m3: spivregress turnout  (tg_binary  =yoshinoya ) incumbent_est  i.dlegco, dvarlag(W1) force
eststo m4: reghdfe turnout  ztg_log1 incumbent_est , a(dlegco)  cluster(district19)  
eststo m5: ivreghdfe  turnout (ztg_log1  =yoshinoya ) incumbent_est , a(dlegco)  cluster(district19) 
eststo m6: spivregress turnout  (ztg_log1  =yoshinoya ) incumbent_est i.dlegco, dvarlag(W1) force


//---------------TABLE A.7---------------//
g tgbinaryXdemvote = tg_binary*percent_dem
g tglog1Xdemvote = ztg_log1*percent_dem
lab var tgbinaryXdemvote "TG \emph{binary} $\times$ Pro-Democratic vote share"
lab var tglog1Xdemvote "TG \emph{log} $\times$ Pro-Democratic vote share"
eststo clear
eststo m1: reghdfe turnout  tg_binary percent_dem incumbent_est znew_reg_percent, a(dlegco)  cluster(district19) 
eststo m2: reghdfe turnout  ztg_log1 percent_dem incumbent_est znew_reg_percent, a(dlegco)  cluster(district19) 
eststo m3: reghdfe turnout  tg_binary percent_dem  tgbinaryXdemvote incumbent_est znew_reg_percent, a(dlegco)  cluster(district19) 
eststo m4: reghdfe turnout  ztg_log1 percent_dem tglog1Xdemvote incumbent_est znew_reg_percent, a(dlegco)  cluster(district19) 


//---------------TABLE A.8---------------//
eststo clear
eststo m1: reghdfe percent_dem  zlog_tgclosest  $cov  , a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  tgaway_0km      $cov  , a(dlegco)  cluster(district19)  
eststo m3: reghdfe percent_dem  tgaway_1km      $cov  , a(dlegco)  cluster(district19)  
eststo m4: reghdfe percent_dem  tgaway_2km      $cov  , a(dlegco)  cluster(district19)  
eststo m5: reghdfe percent_dem  tgaway_3km      $cov , a(dlegco)  cluster(district19)  
eststo m6: reghdfe percent_dem  tgaway_4km      $cov  , a(dlegco)  cluster(district19)  


//---------------TABLE A.9---------------//
eststo clear
eststo m1: ivreghdfe percent_dem  (zlog_tgclosest  =yoshinoya )  $cov , a(dlegco)  cluster(district19)  
eststo m2: ivreghdfe percent_dem  (tgaway_0km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (tgaway_1km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (tgaway_2km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m5: ivreghdfe percent_dem  (tgaway_3km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
eststo m6: ivreghdfe percent_dem  (tgaway_4km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  


//---------------TABLE A.10---------------//
**Binary
eststo clear
eststo m1: reghdfe percent_dem  tg_binary eventbinary $cov, a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  tg_binary zlog_eventfreq $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (tg_binary  =yoshinoya )  eventbinary $cov, a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (tg_binary  =yoshinoya )  zlog_eventfreq $cov, a(dlegco)  cluster(district19)  
eststo m5: spivregress percent_dem  (tg_binary  =yoshinoya ) eventbinary $cov i.dlegco, dvarlag(W1) force
eststo m6: spivregress percent_dem  (tg_binary  =yoshinoya ) zlog_eventfreq $cov i.dlegco, dvarlag(W1) force

**Log
eststo clear
eststo m1: reghdfe percent_dem  ztg_log1 eventbinary $cov, a(dlegco)  cluster(district19)  
eststo m2: reghdfe percent_dem  ztg_log1 zlog_eventfreq $cov, a(dlegco)  cluster(district19)  
eststo m3: ivreghdfe percent_dem  (ztg_log1  =yoshinoya )  eventbinary $cov, a(dlegco)  cluster(district19)  
eststo m4: ivreghdfe percent_dem  (ztg_log1  =yoshinoya )  zlog_eventfreq $cov, a(dlegco)  cluster(district19)  
eststo m5: spivregress percent_dem  (ztg_log1  =yoshinoya ) eventbinary $cov i.dlegco, dvarlag(W1) force
eststo m6: spivregress percent_dem  (ztg_log1  =yoshinoya ) zlog_eventfreq $cov i.dlegco, dvarlag(W1) force


//---------------TABLE A.11---------------//
eststo clear
eststo m1: reghdfe percent_dem  tg_binary zdensity $cov, a(dlegco)  cluster(district19)  
eststo m2: ivreghdfe percent_dem  (tg_binary  =yoshinoya )  zdensity $cov, a(dlegco)  cluster(district19)  
eststo m3: spivregress percent_dem  (tg_binary  =yoshinoya ) zdensity $cov i.dlegco, dvarlag(W1) force
eststo m4: reghdfe percent_dem  ztg_log1 zdensity $cov, a(dlegco)  cluster(district19)  
eststo m5: ivreghdfe percent_dem  (ztg_log1  =yoshinoya )  zdensity $cov, a(dlegco)  cluster(district19)  
eststo m6: spivregress percent_dem  (ztg_log1  =yoshinoya ) zdensity $cov i.dlegco, dvarlag(W1) force


//---------------TABLE A.12---------------//
imb     private    degree  medianincome mediage if percent_dem!=. & tg_binary!=., treatment(tg_binary)
cem     private    degree  medianincome mediage if percent_dem!=. & tg_binary!=., treatment(tg_binary)

eststo clear
eststo m1: reghdfe percent_dem  tg_binary  $cov [aweight=cem_weights], a(dlegco)  cluster(district19)  
eststo m2: ivreghdfe percent_dem  (tg_binary  =yoshinoya )  $cov  [aweight=cem_weights], a(dlegco)  cluster(district19)  


//---------------TABLE A.13---------------//
ttest medianincome if cem_matched==1, by(tg_binary)
ttest medianincome , by(tg_binary)
ttest mediage if cem_matched==1, by(tg_binary)
ttest mediage , by(tg_binary)
ttest degree if cem_matched==1, by(tg_binary)
ttest degree , by(tg_binary)
ttest private if cem_matched==1, by(tg_binary)
ttest private , by(tg_binary)


//---------------TABLE A.14---------------//
**CME: SIMPLE REG
reg percent_dem tg_binary incumbent_est [aweight=cem_weights]
**CEM1: LEGCO FE
reghdfe percent_dem tg_binary incumbent_est    [aweight=cem_weights], a(dlegco) 
**CEM2: IV w/ LEGCO FE
ivreghdfe percent_dem (tg_binary = yoshinoya) incumbent_est    [aweight=cem_weights], a(dlegco) 
**NNMATCH
nnmatch percent_dem tg_binary  private degree  medianincome mediage   if percent_dem!=. & tg_binary!=.,  m(4) exact(incumbent_est ) 
**NNMATCH1
nnmatch percent_dem tg_binary  private degree  medianincome mediage   if percent_dem!=. & tg_binary!=., bias(degree  medianincome mediage ) m(4) exact(incumbent_est ) 
**NNMATCH2 (w/cem sample)
nnmatch percent_dem tg_binary    private medianincome mediage   if percent_dem!=. & tg_binary!=. & cem_matched==1, bias(degree  medianincome mediage ) m(4) exact(incumbent_est ) 
**PSMATCH
teffects psmatch (percent_dem) (tg_binary degree  medianincome mediage private incumbent_est i.dlegco ), nn(2) 




//---------------TABLE A.15---------------//
ttest mediage, by( yoshinoya )
ttest medianincome, by( yoshinoya )
ttest degree , by( yoshinoya )



//---------------TABLE A.16---------------//
eststo clear
eststo m1: ivreghdfe  percent_dem (tg_binary  =yoshinoya)  , a(dlegco)  cluster(district19) first savefirst savefprefix(st20)
eststo m2: ivreghdfe  percent_dem (tg_binary  =yoshinoya) incumbent_est znew_reg_percent , a(dlegco)  cluster(district19) first savefirst savefprefix(st21)
eststo m3: ivreghdfe  percent_dem (ztg_log1  =yoshinoya)  , a(dlegco)  cluster(district19) first savefirst savefprefix(st22) 
eststo m4: ivreghdfe  percent_dem (ztg_log1  =yoshinoya) incumbent_est znew_reg_percent , a(dlegco)  cluster(district19)  first savefirst savefprefix(st23)



//---------------TABLE A.17: PLACEBO 15 OLS---------------//
spmatrix create contiguity W1
eststo clear 
eststo m1: reghdfe percent_dem_15  tg_binary if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m2: reghdfe percent_dem_15  tg_binary incumbent_est if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m3: reghdfe percent_dem_15  tg_binary incumbent_est znew_reg_percent if percent_dem_15>0, a(dlegco)  cluster(district19)
eststo m4: reghdfe percent_dem_15  tg_binary incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m5: reghdfe percent_dem_15  ztg_log1 if percent_dem_15>0, a(dlegco)  cluster(district19)
eststo m6: reghdfe percent_dem_15  ztg_log1 incumbent_est if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m7: reghdfe percent_dem_15  ztg_log1 incumbent_est znew_reg_percent if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m8: reghdfe percent_dem_15  ztg_log1 incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_15>0, a(dlegco)  cluster(district19) 


//---------------TABLE A.18: PLACEBO 15 2SLS---------------//
eststo clear
eststo m1: ivreghdfe percent_dem_15  (tg_binary = yoshinoya) if percent_dem_15>0, a(dlegco)  cluster(district19)
eststo m2: ivreghdfe percent_dem_15  (tg_binary = yoshinoya) incumbent_est if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m3: ivreghdfe percent_dem_15  (tg_binary = yoshinoya) incumbent_est znew_reg_percent if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m4: ivreghdfe percent_dem_15  (tg_binary = yoshinoya) incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m5: ivreghdfe percent_dem_15  (ztg_log1 =  yoshinoya) if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m6: ivreghdfe percent_dem_15  (ztg_log1 =  yoshinoya) incumbent_est if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m7: ivreghdfe percent_dem_15  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent if percent_dem_15>0, a(dlegco)  cluster(district19) 
eststo m8: ivreghdfe percent_dem_15  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_15>0, a(dlegco)  cluster(district19) 


//---------------TABLE A.19: PLACEBO 15 S-2SLS---------------//
eststo clear
eststo m1: spivregress percent_dem_15  (tg_binary = yoshinoya) i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m2: spivregress percent_dem_15  (tg_binary = yoshinoya) incumbent_est i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m3: spivregress percent_dem_15  (tg_binary = yoshinoya) incumbent_est znew_reg_percent ///
i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m4: spivregress percent_dem_15  (tg_binary = yoshinoya) incumbent_est znew_reg_percent ///
zdegree  zmedianage  zmedianincome zprivate i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m5: spivregress percent_dem_15  (ztg_log1 =  yoshinoya) i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m6: spivregress percent_dem_15  (ztg_log1 =  yoshinoya) incumbent_est i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m7: spivregress percent_dem_15  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent ///
i.dlegco if percent_dem_15>0, dvarlag(W1) force
eststo m8: spivregress percent_dem_15  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent ///
zdegree  zmedianage  zmedianincome zprivate i.dlegco if percent_dem_15>0, dvarlag(W1) force




//----------------TABLE A.20: PLACEBO 11 OLS---------------//
eststo clear
eststo m1: reghdfe percent_dem_11  tg_binary if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m2: reghdfe percent_dem_11  tg_binary incumbent_est if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m3: reghdfe percent_dem_11  tg_binary incumbent_est znew_reg_percent if percent_dem_11>0, a(dlegco)  cluster(district19)
eststo m4: reghdfe percent_dem_11  tg_binary incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m5: reghdfe percent_dem_11  ztg_log1 if percent_dem_11>0, a(dlegco)  cluster(district19)
eststo m6: reghdfe percent_dem_11  ztg_log1 incumbent_est if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m7: reghdfe percent_dem_11  ztg_log1 incumbent_est znew_reg_percent if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m8: reghdfe percent_dem_11  ztg_log1 incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_11>0, a(dlegco)  cluster(district19) 




//---------------TABLE A.21: PLACEBO 11 2SLS---------------//
eststo clear
eststo m1: ivreghdfe percent_dem_11  (tg_binary = yoshinoya) if percent_dem_11>0, a(dlegco)  cluster(district19)
eststo m2: ivreghdfe percent_dem_11  (tg_binary = yoshinoya) incumbent_est if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m3: ivreghdfe percent_dem_11  (tg_binary = yoshinoya) incumbent_est znew_reg_percent if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m4: ivreghdfe percent_dem_11  (tg_binary = yoshinoya) incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m5: ivreghdfe percent_dem_11  (ztg_log1 =  yoshinoya) if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m6: ivreghdfe percent_dem_11  (ztg_log1 =  yoshinoya) incumbent_est if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m7: ivreghdfe percent_dem_11  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent if percent_dem_11>0, a(dlegco)  cluster(district19) 
eststo m8: ivreghdfe percent_dem_11  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate if percent_dem_11>0, a(dlegco)  cluster(district19) 


//---------------TABLE A.22: PLACEBO 11 S-2SLS---------------//
eststo clear
eststo m1: spivregress percent_dem_11  (tg_binary = yoshinoya) i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m2: spivregress percent_dem_11  (tg_binary = yoshinoya) incumbent_est i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m3: spivregress percent_dem_11  (tg_binary = yoshinoya) incumbent_est znew_reg_percent i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m4: spivregress percent_dem_11  (tg_binary = yoshinoya) incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m5: spivregress percent_dem_11  (ztg_log1 =  yoshinoya) i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m6: spivregress percent_dem_11  (ztg_log1 =  yoshinoya) incumbent_est i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m7: spivregress percent_dem_11  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent i.dlegco if percent_dem_11>0, dvarlag(W1) force
eststo m8: spivregress percent_dem_11  (ztg_log1 =  yoshinoya) incumbent_est znew_reg_percent zdegree  zmedianage  zmedianincome zprivate i.dlegco if percent_dem_11>0, dvarlag(W1) force

 



 
 
 
**************************************************************************
**************************************************************************
//----------------------------FIGURES-----------------------------------//
**************************************************************************
**************************************************************************

//---------------FIGURE 2: DISTANCE---------------//
set scheme plottig
graph set window fontface "Arial"
grstyle init
		grstyle set legend 2, inside
        grstyle set plain, horizontal grid
		grstyle set noextend
		grstyle symbolsize p medium

quietly ivreghdfe percent_dem  (tgaway_0km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
est store dis0
quietly ivreghdfe percent_dem  (tgaway_1km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
est store dis1
quietly ivreghdfe percent_dem  (tgaway_2km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
est store dis2
quietly ivreghdfe percent_dem  (tgaway_3km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
est store dis3
quietly ivreghdfe percent_dem  (tgaway_4km  =yoshinoya )  $cov, a(dlegco)  cluster(district19)  
est store dis4

coefplot   (dis0, offset(-0.05) msymbol(O) mcolor(black)) dis1  dis2 dis3 dis4 , vertical ciopts(color(black)) color(black) ///
keep( tgaway_0km  tgaway_1km tgaway_2km tgaway_3km tgaway_4km) ///
coeflabels(tgaway_0km="In 1km" tgaway_1km="1km away" tgaway_2km="2km away" tgaway_3km="3km away" tgaway_4km="4km away",   wrap(18)) ///
yline(0, lcolor(black))  ytitle("{bf:Predicted Pro-Democratic Voteshare}", size(small) height(-5))  xtitle("{bf:Distance to Nearest Tear Gas Exposure}") legend (off) plotregion(lcolor(black))

graph save Figure_2, replace 




//---------------FIGURE A.3: DISTANCE---------------//

gen pipe = "|"
gen where = 0.44
twoway qfitci percent_dem log_tgclosest || scatter where log_tgclosest, ms(none) mlabpos(0) mlabel(pipe) mlabcolor(black) color(black) plotr(lcolor(black)) legend(off) ///
ytitle("Predicted Pro-Democratic Vote Shares") xtitle("(Log of) Distance to Nearest Tear Gas Expourse")

graph save Figure_A3, replace 


//---------------FIGURE 3: Marginplot---------------//
set scheme plottig
graph set window fontface "Arial"

grstyle init
        grstyle set plain, horizontal grid
		grstyle set noextend
	
reghdfe turnout  tg_log1   if incumbent_est==1, a(dlegco)  cluster(district19) 
margins , at (tg_log1=(0(0.5)5) ) saving(gr1, replace)
reghdfe turnout  tg_log1   if incumbent_est==0, a(dlegco)  cluster(district19) 
margins , at (tg_log1=(0(0.5)5) ) saving(gr2, replace)

combomarginsplot gr1 gr2,  recast(line) ciopts(recast(rarea) lpatter(none)) title("")   ///
plot1opt(lcolor("blue%50")) plot2opt(lcolor("orange%50") lpattern(longdash) ) ///
	plotr(lcolor(black)) ///
	ci1opt(color("blue%25")) ci2opt(color("orange%15"))   ///
	ytitle("{bf:Turnout}") ///
	addplot(kdensity  tg_log1  if tg_log1<=5,    yaxis(2) ytitle("{bf:Kernel Density}", axis(2)) yscale(alt axis(2) )  below color("black%5") lcolor("black%10") ///
	legend(order(1 "{bf:Pro-Beijing}" "{bf:incumbency}" 2 "{bf:Non Pro-Beijing}" "{bf:incumbency}" )))   ///
	xtitle("") b2title("{bf:Tear Gas ({it:log})}", size(small))  xlabel(-2(1)4, grid glcolor(gs15)) 

graph save Figure_3, replace 



//---------------------------------------------------------------THE END-----------------------------------------------------------------------//

