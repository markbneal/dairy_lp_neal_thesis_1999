* mps2gms 1.1   Aug  1, 2005 WIN.FR.NA 22.0 003.000.000.VIS P3PC
*
* MPS Input File = BACKUP.mps
*
* line        1 NAME          LPFROMSPREADSHEET
* line        2 ROWS
* line        3  N  Obj
* line     1741 COLUMNS
* line    24658 RHS
* line    24659     RHS       ODFeb      50000.0
* line    24674 ENDATA
*
* Number of MPS rows    =      1738 (N:1 L:1725 G:0 E:12)
* Number of MPS columns =      3797 (C:3797 I:0)
* Number of MPS coefs   =     22916 (N:2 L:22891 G:0 E:23)
* Number of MPS Qs      =         0 (empty rows:0)
* Number of MPS cones   =         0
* Number of MPS errors  =         0


sets i      all rows in MPS order
     ig(i)  greater-than-or equal rows
     il(i)  less-than-or equal rows
     ie(i)  equality rows
     ir(i)  ranged rows
     ik(i)  cones;

equations eobj   objective function
          eg(i)  greater-than-or equal equs
          el(i)  less-than-or equal equs
          ee(i)  equality equs;

sets j        all columns in MPS order
     jc (j)   continuous columns
     jb (j)   binary columns
     ji (j)   integer columns
     jsc(j)   semi-continuous columns
     jsi(j)   semi-integer columns
     s        sos sets
     js1(s,j) sos 1 columns
     js2(s,j) sos 2 columns;


         variables obj        objective variable
positive variables xc (j)     continuous variables
                   r  (i)     ranged row variables
binary   variables xb (j)     binary variables
integer  variables xi (j)     integer variables
semicont variables xsc(j)     semi-continuous variables
semiint  variables xsi(j)     semi-integer variables
sos1     variables xs1(s,j)   sos 1 variables
sos2     variables xs2(s,j)   sos 2 variables;


parameters  c(j)        objective coefs
            cobj        objective constant
            b(i)        right hand sides
            ac (i,jc)   matrix coefs: continuous variables
            ab (i,jb)   matrix coefs: binary variables
            ai (i,ji)   matrix coefs: integer variables
            asc(i,jsc)  matrix coefs: semi-continuous variables
            asi(i,jsi)  matrix coefs: semi-integer variables
            as1(i,s,j)  matrix coefs: sos 1 variables
            as2(i,s,j)  matrix coefs: sos 2 variables;


eobj.. obj =e= sum(jc,       c(jc  )*xc (jc ))
              + cobj;

eg(ig)..       sum(jc,  ac (ig,jc )*xc (jc ))
              =g= b(ig);

el(il)..       sum(jc,  ac (il,jc )*xc (jc ))
              =l= b(il);

ee(ie)..       sum(jc,  ac (ie,jc )*xc (jc ))
              =e= b(ie);

model m / all /;


set mps2gms; parameter mps2gmsstats(mps2gms);

$gdxin HonsThesisDairy.gdx
$load i j mps2gms s mps2gmsstats
$load ig il ie ir ik
$load jc jb ji jsc jsi js1 js2
$load cobj c b
$load ac ab ai asc asi as1 as2
$load xc xb xi xsc xsi xs1 xs2 r

$gdxin

option limcol=0,limrow=0,solprint=off;

option rmip = conopt;

option lp = conopt;

solve m using lp maximising obj;