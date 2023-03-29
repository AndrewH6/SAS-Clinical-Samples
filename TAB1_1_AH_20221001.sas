/*******************************************************************
* Client: AIRIS PHARMA Private Limited.                                                           
* Product:                                                   
* Project: Protocol 043-1810                                                  
* Program: TAB1_1_AH_20221001.SAS  
*
* Program Type: Listing
*
* Purpose: To produce the Table 14.1.1 Subject Assignment to Analysis Populations
* Usage Notes: 
*
* SAS� Version: 9.4 [TS2M0]
* Operating System: Windows 11 Standard Edition.                   
*
* Author: Andrew Huang
* Date Created: Oct 01, 2022
*******************************************************************/

LIBNAME adam "E:\ROSHE30730\ADAM DATASETS";
LIBNAME sdtm "E:\ROSHE30730\SDTM DATASETS";

%include "E:\ROSHE\PROGRAMS\_RTFSTYLE_.sas";
%_RTFSTYLE_;

DATA ADSL;
SET adam.ADSL;

OUTPUT;

TRT01P = "Overall";
TRT01PN = 5;

OUTPUT;

KEEP USUBJID TRT01P TRT01PN SAFFL;
RUN;

DATA ADSL;
SET ADSL;
IF TRT01PN NE .;
RUN;

PROC SQL NOPRINT;
CREATE TABLE TRT AS
SELECT TRT01PN, TRT01P, COUNT(DISTINCT USUBJID) AS DENOM FROM ADSL
GROUP BY TRT01PN, TRT01P
ORDER BY TRT01PN, TRT01P;

SELECT DENOM INTO: n1 -:n5 FROM TRT;
QUIT;

%PUT &n1 &n2 &n3 &n4 &n5;

PROC SQL NOPRINT;
CREATE TABLE SAF1 AS
SELECT TRT01PN, COUNT(DISTINCT USUBJID) AS NN,
"Safety Population" AS POP LENGTH=100,1 AS SQ FROM ADSL
WHERE SAFFL = "Y"
GROUP BY TRT01PN
ORDER BY TRT01PN;
QUIT;

DATA FINAL1;
SET SAF1;
LENGTH GRPA_1 $20.;

IF TRT01PN=1 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n1 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n1*100,4.1)||")";
END;

IF TRT01PN=2 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n2 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n2*100,4.1)||")";
END;

IF TRT01PN=3 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n3 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n3*100,4.1)||")";
END;

IF TRT01PN=4 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n4 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n4*100,4.1)||")";
END;

IF TRT01PN=5 THEN DO;
	IF NN=. OR NN=0 THEN GRPA_1="0";
ELSE IF NN=&n5 THEN GRPA_1=PUT(NN,3.)||" (100)";
ELSE GRPA_1=PUT(NN,3.)||" ("||PUT(NN/&n5*100,4.1)||")";
END;

RUN;

PROC SORT DATA=FINAL1;
BY SQ POP;
RUN;

PROC TRANSPOSE DATA=FINAL1 OUT=ALL_ PREFIX=t;
BY SQ POP;
ID TRT01PN;
VAR GRPA_1;
RUN;

DATA FINAL;
SET ALL_;
STAT="n (%)";
RUN;

TITLE J=L "AIRIS PHARMA Private Limited.";
TITLE J=L "Protocol: 043-1810";
TITLE J=C "Table 14.1.1 Subject Assignment to Analysis Populations";

FOOTNOTE1 J=L "E:\ROSHE30730\PROGRAMS\TAB1_1_AH_20221001.sas";
OPTIONS ORIENTATION=LANDSCAPE;
ODS ESCAPECHAR='^';

ODS RTF FILE = "E:\ROSHE30730\OUTPUTS\14_1_1.rtf" STYLE=styles.test;

PROC REPORT DATA=FINAL NOWD MISSING
STYLE = {OUTPUTWIDTH=100%} SPLIT="|" SPACING=1 WRAP
STYLE (HEADER) = [JUST=LEFT];

COLUMN SQ POP STAT T1 T2 T3 T4 T5;

DEFINE SQ/ORDER NOPRINT;
DEFINE POP/DISPLAY "Population"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=10%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=10%];

DEFINE STAT/DISPLAY "Statistic"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T1/DISPLAY "DRUG A|(N = &n1)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T2/DISPLAY "DRUG B|(N = &n2)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T3/DISPLAY "DRUG C|(N = &n3)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T4/DISPLAY "DRUG D|(N = &n4)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];

DEFINE T5/DISPLAY "ALL|(N = &n5)"
STYLE (HEADER) = [JUST=LEFT CELLWIDTH=5%]
STYLE (COLUMN) = [JUST=LEFT CELLWIDTH=5%];



COMPUTE BEFORE _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
ENDCOMP;

COMPUTE AFTER _PAGE_;
LINE@1 "^{STYLE [OUTPUTWIDTH=100% BORDERTOPCOLOR=BLACK BORDERTOPWIDTH=0.5pt]}";
ENDCOMP;

ODS _ALL_ CLOSE;