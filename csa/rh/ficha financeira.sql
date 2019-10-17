-- SERVIDOR 192.1.1.73 ( sa ) 
USE FATORHW
SELECT SUBSTRING(D.CCVARFIL,6,2) RD_FILIAL,B.CCVARFUN RD_MAT,F.PARA RD_PD,CAST(A.CVANOFICFIN AS CHAR(4))+'0'+CAST(A.CVMESFICFIN AS CHAR(2)) RD_DATARQ,'0'+CAST(A.CVMESFICFIN AS CHAR(2)) RD_MES,STR(A.CVVLRBASFICFIN,12,2) RD_HORAS,STR(A.CVVLRFIMFICFIN,12,2) RD_VALOR,CAST(C.CDDATPGTOLOT  AS CHAR(12)) RD_DATPGTO
FROM   FATORHW..TBLFICFIN A, FATORHW..TBLFUNCIONARIO B, FATORHW..TBLLOTE C, FATORHW..TBLFILIAL D, FATORHW..TBLEVENTO E, PEDIDOSASP..DE_PARA F
WHERE  A.CVCODFUN    = B.CVCODFUN
   AND B.CVCODFIL    = D.CVCODFIL
   AND A.CVCODLOT    = C.CVCODLOT
   AND A.CVCODEVE    = E.CVCODEVE
   AND A.CVANOFICFIN = 2005
   AND A.CVMESFICFIN = 7
   AND A.CVVLRFIMFICFIN <> 0
   AND A.CVCODEVE    = F.DE
   AND F.PARA IS NOT NULL     
   AND SUBSTRING(B.CCVARFUN,1,1) IN('0','9')
   AND B.CCVARFUN    = '999991'
GROUP BY 1,2,3,4,5
ORDER BY 1,2,3,4,5 --D.SUBSTRING(D.CCVARFIL,6,2),B.CCVARFUN,F.PARA


SELECT A.CCVAREVE,A.CCNOMEVE,B.PARA
FROM  FATORHW..TBLEVENTO A, PEDIDOSASP..DE_PARA B
WHERE  A.CVCODEVE = B.DE
ORDER BY A.CCVAREVE

--SELECT * FROM TBLFUNCIONARIO
--SELECT * FROM TBLFILIAL
--SELECT * FROM TBLLOTE
--SELECT * FROM TBLFICFIN
--SELECT * FROM TBLEVENTO 

--use pedidosasp

--USE 
--CREATE TABLE DE_PARA (DE INT, PARA CHAR(3))
SELECT SUBSTRING(D.CCVARFIL,6,2) RD_FILIAL,B.CCVARFUN RD_MAT,F.PARA RD_PD,CAST(A.CVANOFICFIN AS CHAR(4))+'0'+CAST(A.CVMESFICFIN AS CHAR(2)) RD_DATARQ,'0'+CAST(A.CVMESFICFIN AS CHAR(2)) RD_MES,CAST(C.CDDATPGTOLOT  AS CHAR(12)) RD_DATPGT,STR(SUM(A.CVVLRBASFICFIN),12,2) RD_HORAS,STR(SUM(A.CVVLRFIMFICFIN),12,2) RD_VALOR
FROM   FATORHW..TBLFICFIN A, FATORHW..TBLFUNCIONARIO B, FATORHW..TBLLOTE C, FATORHW..TBLFILIAL D, FATORHW..TBLEVENTO E, PEDIDOSASP..DE_PARA F
WHERE  A.CVCODFUN    = B.CVCODFUN
   AND B.CVCODFIL    = D.CVCODFIL
   AND A.CVCODLOT    = C.CVCODLOT
   AND A.CVCODEVE    = E.CVCODEVE
   AND A.CVANOFICFIN = 2005
   AND A.CVMESFICFIN = 9 --AND A.CVMESFICFIN < 10
   AND A.CVVLRFIMFICFIN <> 0
   AND A.CVCODEVE    = F.DE
   AND F.PARA IS NOT NULL
   AND SUBSTRING(B.CCVARFUN,1,1) IN('0','9')
GROUP BY SUBSTRING(D.CCVARFIL,6,2),B.CCVARFUN ,F.PARA,CAST(A.CVANOFICFIN AS CHAR(4))+'0'+CAST(A.CVMESFICFIN AS CHAR(2)) ,'0'+CAST(A.CVMESFICFIN AS CHAR(2)),CAST(C.CDDATPGTOLOT  AS CHAR(12)) 
ORDER BY 1,2,3,4,5,6 


use pedidosasp
select * from de_para
order by para

UPDATE DE_PARA
SET PARA = NULL
WHERE PARA = '   '