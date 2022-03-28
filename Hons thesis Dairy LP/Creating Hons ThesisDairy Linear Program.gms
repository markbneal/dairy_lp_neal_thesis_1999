$Title Re-Creating an LP of a dairy farm based on my honours thesis (Neal, 1999)
$eolcom #
***OPTIONS***

option limrow = 12;
option limcol = 12;
option lp = conopt;
option dnlp=conopt;

***SETS***

Set s Seasons  / Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec /;
Set f Forages  / Kikuyu, Paspalum, Lucerne, Rye /;
Set g Grain    / Barley, Maize, Sorghum /;
Set m MilkMarkets   / Contract, Spot /;
Set h HarvestMethod / Hay, Silage /;
Set l LactPeriods   / Month1*Month12 /;
Set q ProdFnSteps   / PFStep1*PFStep5 /;
Set r SubstSteps    / SStep1*SStep3 /;

Set b Fibre types   / ADF, NDF /;
Set w ProtSet   / Protein /;
Set x MESet     / ME /;
Set y DMSet     / DM /;
Set z LitresSet / Litres /;
alias (c,s);    #The SSet c is the month that calving occurs

***DATA***
*** Pastures and Fertiliser

Scalar  TotalArea        Total area of land available (ha)      / 100 /;

Table GF(s,f)  Growth of Forage  (DM per day)
* Here is an example of reading data from an excel file saved in csv
$ondelim
$include GF.csv
$offdelim
display GF;

Table CF(s,f)  Cash use for forage (dol per ha)
$ondelim
$include CF.csv
$offdelim
display CF;

Table LF(s,f)  Labour use for forage (hrs per ha)
$ondelim
$include LF.csv
$offdelim
display LF;

*** Supplements (inc Grain)

Table CS(s,g)  Cash use for supplement (inc grain) (dol per t)
$ondelim
$include CS.csv
$offdelim
display CS;

Scalar LS      Labour use for supplement unloading (hrs per t) / 0.15 /;



*** Conserved Feed, making and feeding out

Scalar Utilisation Utilisation of forage and conserved feeds (1 divide by 65%) / 1.538 /;

** TO Check
Parameter LFH(h)     Labour for feeding conserved feed (hours per kg DM for month)
*                 / 1
*                   1.5 /;
* divide by 0.8, the multiply by 30/1000 to get labour per kg per day for the month
                 /  Hay    0.0375
                    Silage 0.05625 /;

Parameter CFH(h)     Tractor cost for feeding conserved feed (hours per kg DM for month)
*                 /  8.89
*                    6.67 /;
* divide by 0.8, the multiply by 30/1000 to get labour per kg per day for the month
                 / Hay    0.33333
                   Silage 0.25    /;


Parameter LMH(h)     Labour for making conserved feed   (hours per t DM)
*                 / 4
*                   2.7 /;
* divide by 0.8 for amount harvested (assume 20% losses)
                 / Hay    5
                   Silage 3.375 /;

Parameter CMH(h)     Tractor cost for making conserved feed (hours per t DM)
* tractor costs + twine/plastic
*                 /  24 + 16.15
*                    24 + 36.06 /;
* divide by 0.8 for amount harvested (assume 20% losses)
* it is already per tonne: doesn't require multiplying by 30/1000
                 /   Hay    50.185
                     Silage 75.072 /;

*** Nutritional data

*DM Dry Matter
Table DMS(g,r)  Dry matter used by kilo of supplement (kg DMI per kg DM)
$ondelim
$include DMS.csv
$offdelim
display DMS;

Table DMF(s,f)  Dry matter used by kilo of forage (kg DMI per kg DM)
$ondelim
$include DMF.csv
$offdelim
display DMF;

Table DMH(h,f)  Dry matter used by kilo of conserved feed (kg DMI per kg DM)
$ondelim
$include DMH.csv
$offdelim
display DMH;

*P Protein
Table PS(w,g)  P provided by kilo of supplement (% per kg DM)
$ondelim
$include PS.csv
$offdelim
display PS;

Table PF(s,f)  P provided by kilo of forage (% per kg DM)
$ondelim
$include PF.csv
$offdelim
display PF;

Table PH(h,f)  P provided by kilo of conserved feed (% per kg DM)
$ondelim
$include PH.csv
$offdelim
display PH;

* ME Metabolisable Energy
Table MES(x,g)  ME provided by kilo of supplement (ME per kg DM)
$ondelim
$include MES.csv
$offdelim
display MES;

Table MEF(s,f)  ME provided by kilo of forage (ME per kg DM)
$ondelim
$include MEF.csv
$offdelim
display MEF;

Table MEH(h,f)  ME provided by kilo of conserved feed (ME per kg DM)
$ondelim
$include MEH.csv
$offdelim
display MEH;

*F Fibre
Table FS(b,g)  Fibre provided by kilo of grain or supplement (ME per kg DM)
$ondelim
$include FS.csv
$offdelim
display FS;

Parameter FF(b,s,f)  Fibre provided by kilo of forage (ME per kg DM)
/
$ondelim
$include FF.csv
$offdelim
/;
display FF;

Parameter FH(f,h,b)  Fibre provided by kilo of conserved feed (ME per kg DM)
/
$ondelim
$include FH.csv
$offdelim
/;
display FH;

*Cow requirements

Table ProdRests(s,z)  Maximum litres for each step of production function (Litres)
$ondelim
$include ProdRests.csv
$offdelim
display ProdRests;

Parameter ProdRestAdv(c,s);
ProdRestAdv(c,s)=sum(z, ProdRests(s--(ord(c)-1),z) );
display ProdRestAdv;

** Required workaround when l indexing does not work
*Table ProdRestAdv(s,c)  Maximum litres for each step of production function (Litres)
*$ondelim
*$include ProdRestAdv.csv
*$offdelim
*display ProdRestAdv;

Table DMIs(s,y)  Dry matter Intake per day for lactation months (kg DM)
$ondelim
$include DMIs.csv
$offdelim
display DMIs;

Parameter DMIAdv(c,s,y);
DMIAdv(c,s,y)=DMIs(s--(ord(c)-1),y);
display DMIAdv;

*$ontext
Table Prots(s,w)  Protein percent for lactation months (kg DM)
$ondelim
$include Prots.csv
$offdelim
display Prots;

Parameter ProtAdv(c,s);
ProtAdv(c,s)=sum(w, Prots(s--(ord(c)-1),w) );
display ProtAdv;
*$offtext

Table MEMaints(s,x)  ME required per day for lactation months (ME)
$ondelim
$include MEMaints.csv
$offdelim
display MEMaints;

Parameter MEMaintAdv(c,s,x);
MEMaintAdv(c,s,x)=MEMaints(s--(ord(c)-1),x);
display MEMaintAdv;

Table MEProds(s,q)  ME required per litre at each step of production function (ME)
$ondelim
$include MEProds.csv
$offdelim
display MEProds;

Parameter MEProdAdv(c,s,q);
MEProdAdv(c,s,q)=MEProds(s--(ord(c)-1),q);
display MEProdAdv;

***  Diet parameters

Parameter Substitution(r) 3 marginal proportions of diet where substitution changes
                 /  SStep1 0.25
                    SStep2 0.25
                    SStep3 0.50 /;

Parameter FibreReq(b)    Fibre requirement (%)
                     / ADF 0.19
                       NDF 0.25 /;

*Scalar LC           Labour per cow  (hours per cow per season) / 0.75 /;
* Should be only when milking

*Scalar LCC          Labour when cow calving (hours)             / 0.9 /;
* tricky - first month of calving only

** Required workaround when l indexing does not work
Table LCCAdv(s,c)  Labour requirement per cow including requirement at calving
$ondelim
$include LCCAdv.csv
$offdelim
display LCCAdv;

Scalar CC           Cash costs per cow  (dol per cow per season) / 10 /;


*** Labour and other financial variables

Scalar LabCost      Cost of hired labour       (dol per hour) / 20.13 /;

Scalar OwnLab       Owner labour       (hours per season)         / 0 /;

Scalar FixedLabour  Fixed labour (dairy fixed and other)     / 360.25 /;

Scalar FixedCosts   Fixed farm costs   (dol per season)    / 13731.48 /;
* ^ 159,000/12 months
Scalar OpCash       Opening cash                 (dol)        / 40000 /;

Scalar MaxOD        Maximum overdraft            (dol)        / 50000 /;

Scalar ODInt        Overdraft interest(1 plus (i per season)) / 1.015 /;

Table MP(s,m)       Prices for milk     (Dol per L)
$ondelim
$include MP.csv
$offdelim
display MP;

Scalar ContractVol  Contract volume     (L per season)            / 0 /;
* no obligation contract. Requires more constraints if delivery is compulsory


*** Miscellaneous scalars

Scalar PDM          Percentage dry matter in t (as fed) of grain / 0.88 /;

Scalar kgT          Kilograms in a tonne         (1000)        / 1000 /;

Scalar dim          Days in a month              (30)            / 30 /;

Scalar MaxCows      Maximum number of cows       (cows)         / 450 /;

***Test excel results in this GAMS model

$ontext
Parameter ExcelForages(f) Optimal forages reported by Excel and WBv7
                 /  Kikuyu   15.97
                    Paspalum 2.09
                    Lucerne  81.93
                    Rye      0.     /;
$offtext

***VARIABLES***

Variables        vForageArea(f)         ForageArea planted to forage(p)   (ha)
                 vDMProduction(s,f)     Transfer forage to DM             (DM)
                 vConserved(s,f,h)      Conserved as hay or silage        (DM)
                 vSupplPurch(s,g)       Supplement Purchase               (T)
                 vGrainToCows(s,c,g,r)  Transfer grain to cows            (DM)
                 vForageToCows(s,c,f)   Transfer conserved feed to cows   (DM)
                 vConsToCows(s,c,f,h)   Transfer grain to cows            (DM)
                 vNumberCows(c)         Number of cows in season(s)       (cows)
                 vMilkProd(c,s,q)       Production in each month of lact  (L)
                 vMilkSold(s,m)         Milk sold to m markets            (L)
                 vFixedCosts            Fixed costs (the variable)        (dol)
                 vHireLab(s)            Hire of labour in season(s)       (hours)
                 vCashTransfer(s)       Transfer of cash between seasons  (dol)
                 vOverdraft(s)          Overdraft and transfers (s)       (dol)
                 vObjective             Value of final cash balance       ($)
                 vFibreSlack(b)         Removes Fibre Restrictions
                 vProtSlack             Removes Protein Restrictions
                 vTCForageEstab(s)      Total cost of ($)
                 vTCSupplPurch(s)       Total cost of ($)
                 vTCCowCosts(s)         Total cost of ($)
                 vTRMilkSales(s)        Total cost of ($)
                 vTCMakingConserved(s)  Total cost of ($)
                 vTCFeedingConserved(s) Total cost of ($)
                 vTCHiredLabour(s)      Total cost of ($)
                 vTCFixedCosts(s)       Total cost of ($)
;

Positive Variables
                 vForageArea(f)
                 vDMProduction(s,f)
                 vConserved(s,f,h)
                 vSupplPurch(s,g)
                 vGrainToCows(s,c,g,r)
                 vForageToCows(s,c,f)
                 vConsToCows(s,c,f,h)
                 vNumberCows(c)
                 vMilkProd(c,s,q)
                 vMilkSold(s,m)
                 vFixedCosts
                 vHireLab(s)
                 vCashTransfer(s)
                 vOverdraft(s)
                 vFibreSlack(b)
                 vProtSlack
                 vTCForageEstab(s)
                 vTCSupplPurch(s)
                 vTCCowCosts(s)
                 vTRMilkSales(s)
                 vTCMakingConserved(s)
                 vTCFeedingConserved(s)
                 vTCHiredLabour(s)
                 vTCFixedCosts(s)
;

***EQUATIONS***

Equations  eObjFunction(s)        ObjectiveFunction -> max final cash balance
           eAreaSum               ForageArea must be less than TotalArea
*           eExcelForageCon(f)     Forage area at least what excel said          #Can be removed if not required
           eForageProd(s,f)       Forage production
           eForageUse(s,f)        Forage use
           eStockCons(h,f)        Stock of conserved feed
           eRestProdFn(c,s,q)     Restrictions on Production function
           eDMSupply(s,c)         Dry Matter supply
           eMESupply(s,c)         ME Supply
           eFSupply(s,c,b)        Fibre Supply
*           eSlackCon              Constrains one of the fibre variables         #Can be removed if not required
           ePsupply(s,c)          Protein Supply
           eSupplRest(s,c,r)      Supplement restriction
           eSupplSupply(s,g)      Supplement Supply
           eMilkLitres(s)         Milk Balance
           eContractLimit(s)      Contract Balance
           eLabourLimit(s)        Labour Balance
           eCashLimit(s)          Cash Balance
           eTCForageEstab(s)      Calculating total cost of
           eTCSupplPurch(s)       Calculating total cost of
           eTCCowCosts(s)         Calculating total cost of
           eTRMilkSales(s)        Calculating total cost of
           eTCMakingConserved(s)  Calculating total cost of
           eTCFeedingConserved(s) Calculating total cost of
           eTCHiredLabour(s)      Calculating total cost of
           eTCFixedCosts(s)       Calculating total cost of
           eOverdraftLimit(s)     Overdraft limit
           eCowsEqual(c)          Cows equal in all seasons
           eCowsLimit(c)          Not more than a certain number of cows each period
           eSumCowsLimit          Not more than a certain total number of cows
           eFixedCostsLimit       Fixed costs equal one
;

eObjFunction(s)..
  vCashTransfer(s)$(ord(s)=card(s)) - ODInt*vOverdraft(s)$(ord(s)=card(s))
                               =e= vObjective$(ord(s)=card(s));
eAreaSum..
  + sum(f, vForageArea(f)     )                  =l= TotalArea;

*eExcelForageCon(f)..
*  + vForageArea(f)                               =g= ExcelForages(f);          # can be removed if note required

eForageProd(s,f)..
  - GF(s,f) * vForageArea(f)   +   vDMProduction(s,f)    =l= 0;

eForageUse(s,f)..
  - 30   *          vDMProduction(s,f)
  + 1000 * Utilisation * sum(h, vConserved(s,f,h)    )
  + 30   * Utilisation * sum(c, vForageToCows(s,c,f) )   =l= 0;

eStockCons(h,f)..
  - 1000        * sum(s, vConserved(s,f,h)    )
  + 30   * sum(s, sum(c, vConsToCows(s,c,f,h) ))         =l= 0;

eRestProdFn(c,s,q)..
  - vNumberCows(c) * ProdRestAdv(s,c) + vMilkProd(c,s,q) =l= 0;


eDMSupply(s,c)..
  + sum(g, sum(r, DMS(g,r)    * vGrainToCows(s,c,g,r) ))
  +        sum(f, DMF(s,f)    * vForageToCows(s,c,f)  )
  + sum(h, sum(f, DMH(h,f)    * vConsToCows(s,c,f,h)  ))
  - sum(y, vNumberCows(c)     * DMIAdv(c,s,y)         )
                                                         =l= 0;
eMESupply(s,c)..
  - sum(g, sum(r, MES('ME',g) * vGrainToCows(s,c,g,r) ))
  -        sum(f, MEF(s,f)    * vForageToCows(s,c,f)  )
  - sum(h, sum(f, MEH(h,f)    * vConsToCows(s,c,f,h)  ))
  + sum(x, vNumberCows(c)     * MEMaintAdv(c,s,x)     )
  + sum(q, MEProdAdv(c,s,q)   * vMilkProd(c,s,q)      )
                                                         =l= 0;

eFSupply(s,c,b)..
  - sum(g, sum(r, FS(b,g)     * vGrainToCows(s,c,g,r) ))
  -        sum(f, FF(b,s,f)   * vForageToCows(s,c,f)  )
  - sum(h, sum(f, FH(f,h,b)   * vConsToCows(s,c,f,h)  ))
  + sum(y, vNumberCows(c)     * DMIAdv(c,s,y) * FibreReq(b)  )
*  - vFibreSlack(b)                                                              #This tests what happens if fibre was not a constraint
                                                         =l= 0;

*eSlackCon..
*  + vFibreSlack('NDF')                                   =l= 0;                 #This can be removed if not required

ePSupply(s,c)..
  - sum(g, sum(r, sum(w, PS(w,g) )  * vGrainToCows(s,c,g,r) ))
  -        sum(f, PF(s,f)   * vForageToCows(s,c,f)  )
  - sum(h, sum(f, PH(h,f)   * vConsToCows(s,c,f,h)  ))
  + sum(y, vNumberCows(c)     * DMIAdv(c,s,y) * ProtAdv(c,s)  )
*  - vProtSlack                                                              #This tests what happens if Protein was not a constraint
                                                         =l= 0;

eSupplRest(s,c,r)..
  + sum(g, vGrainToCows(s,c,g,r)                            )
  - sum(y, vNumberCows(c) * Substitution(r) * DMIAdv(c,s,y) )
                                                         =l= 0;

eSupplSupply(s,g)..
  - 1000 * PDM * vSupplPurch(s,g)
  + 30   * sum(c, sum(r, vGrainToCows(s,c,g,r) ))        =l= 0;

eMilkLitres(s)..
  - sum(q, sum(c, vMilkProd(c,s,q) ))
  +        sum(m, vMilkSold(s,m)   )                     =l= 0;


eContractLimit(s)..
  vMilkSold(s, 'Contract')                     =l= ContractVol;

eLabourLimit(s)..
                  Sum(f, vForageArea(f)      * LF(s,f) )
  +               Sum(g, vSupplPurch(s,g)    * LS      )
  +        Sum(h, sum(f, vConserved(s,f,h)   * LMH(h)  ))
  + Sum(h, Sum(c, sum(f, vConsToCows(s,c,f,h)* LFH(h)  )))
  +               Sum(c, vNumberCows(c) * LCCAdv(s,c)  )
  + vFixedCosts * FixedLabour
  - vHireLab(s)                                     =l= OwnLab;

*Summing Total Costs
eCashLimit(s)..
  + vTCForageEstab(s)     + vTCSupplPurch(s)
  + vTCCowCosts(s)        - vTRMilkSales(s)
  + vTCMakingConserved(s) + vTCFeedingConserved(s)
  + vTCHiredLabour(s)     + vTCFixedCosts(s)
  + vCashTransfer(s)      - vCashTransfer(s-1)$(ord(s) > 1)
  -  vOverdraft(s)        + vOverdraft(s-1)$(ord(s) > 1)*ODInt
                                       =l= (ord(s) = 1)*OpCash;
*Costs by Category (this is substantially more complex for GAMS than
*subsuming all costs into a single total costs equation, but allows easy categorisation of costs)
eTCForageEstab(s)..
                       Sum(f, vForageArea(f)   * CF(s,f)       )   =l= vTCForageEstab(s);
eTCSupplPurch(s)..
                       Sum(g, vSupplPurch(s,g) * CS(s,g)       )   =l= vTCSupplPurch(s) ;
eTCCowCosts(s)..
                       Sum(c, vNumberCows(c)   * CC            )   =l= vTCCowCosts(s)   ;
eTRMilkSales(s)..
    30 *              Sum(m, vMilkSold(s, m)  * MP(s, m)      )    =g= vTRMilkSales(s)     ;
eTCMakingConserved(s)..
    Sum(h, sum(f, CMH(h)  * vConserved(s,f,h)      ))  =l= vTCMakingConserved(s) ;
eTCFeedingConserved(s)..
    Sum(h,      Sum(c, sum(f, CFH(h)  * vConsToCows(s,c,f,h)   ))) =l= vTCFeedingConserved(s) ;
eTCFixedCosts(s)..
    FixedCosts * vFixedCosts                                       =l= vTCFixedCosts(s) ;
eTCHiredLabour(s)..
    vHireLab(s) * LabCost                                          =l= vTCHiredLabour(s) ;


eOverdraftLimit(s)..
  vOverdraft(s)                                      =l= MaxOD;
eCowsEqual(c)..
  vNumberCows(c) - vNumberCows(c--1)                     =e= 0;
eCowsLimit(c)..
  vNumberCows(c)                                   =l= MaxCows;
eSumCowsLimit..
  sum(c, vNumberCows(c))                           =l= MaxCows;
eFixedCostsLimit..
  vFixedCosts                                            =e= 1;

***MODEL AND SOLVE***

Model DairyFarm  / All / ;

Option SAVEPOINT=1
            
Solve DairyFarm using lp maximizing vObjective;

Display                 vForageArea.l
Display                 vDMProduction.l
Display                 vConserved.l
Display                 vSupplPurch.l
*Display                 vGrainToCows.l
*Display                 vForageToCows.l
*Display                 vConsToCows.l
Display                 vNumberCows.l
**Display                 vMilkProd.l
*Display                 vMilkProd.l
Display                 vMilkSold.l
*Display                 vFixedCosts.l
Display                 vHireLab.l
Display                 vCashTransfer.l
*Display                 vOverdraft.l



$ontext
***PLOTTING OUTPUT***
* Plot Forage Production
Parameter ForageProd(s,f) The optimal Forage production;
ForageProd(s,f)= vForageArea.l(f)*GF(s,f);
$set domain s
$set labels s
$set series f

$libinclude xlchart ForageProd
$offtext

$ontext
* Plot Supplement use
Parameter SupplUse(s,g) The optimal Supplement Use;
SupplUse(s,g)=vSupplPurch.l(s,g);
$set domain s
$set labels s
$set series g

$libinclude xlchart SupplUse

$ontext
* Plot cows calved
Parameter Cows(c) Cows calved in each month;
Cows(c)= vNumberCows.l(c);
$set domain c
$set labels c
*$set series

$libinclude xlchart Cows

* Plot Milk sold
Parameter Milk(s,m) Milk sold to contract and to spot market;
Milk(s,m)= vMilkSold.l(s,m);
$set domain s
$set labels s
$set series m

$libinclude xlchart Milk
*$offtext

* Plot Labour Requirement
Parameter FTES(s) The optimal Full time Equivalent Labour Requirement;
FTES(s)= vHireLab.l(s)/160;
* 48 weeks worked per year per FTE with 40 hour weeks divided by 12 months is 160 hours per FTE per month
$set domain s
$set labels s
*$set series

$libinclude xlchart FTES

$offtext

$ontext
* Plot Cash at end of month
Parameter CashAtEOM(s) The cash BAlance at the End of the Month;
CashAtEOM(s)= vCashTransfer.l(s);
$set domain s
*$set labels s
$set series

$libinclude xlchart CashAtEOM

$offtext

$ontext
***PLOTTING SCATTER XY GRAPHS***

*Illustrate gnupltxy usage

SETS
LINES      Lines in graph /A,B/
POINTS     Points on line /1*10/
ORDINATES  ORDINATES      /X-AXIS,Y-AXIS/  ;

TABLE GRAPHDATA(LINES,POINTS,ORDINATES)
       X-AXIS   Y-AXIS
A.1       1       1
A.2       2       4
A.3       3       9
A.4       5      25
A.5      10     100
B.1       1       2
B.2       3       6
B.3       7      15
B.4      12      36
;
*$LIBINCLUDE GNUPLTXY GRAPHDATA Y-AXIS X-AXIS
$offtext

$ontext
#user model library stuff
Main topic Output
Featured item 1 Graphics
Featured item 2 GNUPLTXY.gms
Featured item 3
Featured item 4
Description
Illustrate GNUPLTXY usage
$offtext