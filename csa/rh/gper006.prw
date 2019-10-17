#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºPrograma  ? GPER006  ºAutor  ?Reginaldo           º Data ?  16/02/05   º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºDesc.     ? Relacao de Diferencas de LIquidos                          º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºUso       ? ASOEC                                                      º??
??ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GPER006()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Declara Variavel ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   cDesc1   := "DIFERENCA DE LIQUIDOS "
Local   cDesc2   := "Sera impresso de acordo com os parametros solicitados pelo"
Local   cDesc3   := "usuario."
Local   cString  := "SRC"
Private nLastKey := 0
Private NomeProg := "GPER006"
Private cbtxt    := SPACE(10)
Private Tamanho  := "P"
Private Titulo   := "Diferenca de Liquidos " + MesExtenso(dDataBase) + "/"+Strzero(year(dDataBase),4)
Private Cabec1   := "Fl Matric  Nome                         Valor Somado   Valor Calculado  Diferenca"
Private Cabec2   := ""
Private WnRel    := "GPER006"
Private nTipo    := 15
Private nOrdem   := 1
Private cbcont   := 0
Private Li       := 80
Private m_pag    := 1
Private nTit     := 0
Private aReturn  := {"Zebrado",1,"Administracao",1,2,1,"",1}
Private aRegs    := {}
Private cPerg    := "GPER06"

aAdd(aRegs,{cPerg,"01","Filial de      "," " ," ","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial ate     "," " ," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Abre tela de Impressao ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

WnRel:=SetPrint(cString,WnRel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Executa o relatorio ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| ImpRel(@lEnd,WnRel,cString)},titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºPrograma  ? PROCSA2  º Autor ?Cleyton Jr          º Data ?  16/02/05   º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºUso       ? ASOEC                                                      º??
??ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IMPREL(lEnd,WnRel,cString)

Local cQuery  := ""

Local cFil     := ""
Local cCat     := ""

Local nTotFil1 := 0
Local nTotFil2 := 0
Local nTotCat  := 0
Local nTotEmp1 := 0
Local nTotEmp2 := 0
Local lImpFil  := .T.
Local lImpCat  := .T.
Local nTotFun1 := 0
Local nTotFun2 := 0
Local nTotFEm1 := 0
Local nTotFEm2 := 0
    
cQuery := "SELECT RC_FILIAL, RC_MAT,'1' AS TIPO ,SUM(RC_VALOR) AS TOTFUN "
cQuery += "FROM " + RetSqlName("SRC") + " SRC, "  + RetSqlName("SRV") + " SRV "
cQuery += "WHERE RC_FILIAL >= '"+mv_par01+"' AND RC_FILIAL <= '"+mv_par02+"' "
cQuery += "AND RC_PD = RV_COD "
cQuery += "AND RV_TIPOCOD = '1' "
cQuery += "AND SRC.D_E_L_E_T_ = ' ' "
cQuery += "AND SRV.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY RC_FILIAL,RC_MAT,3 "
cQuery += "UNION "
cQuery += "SELECT RC_FILIAL, RC_MAT,'2' AS TIPO ,SUM(RC_VALOR) AS TOTFUN "
cQuery += "FROM " + RetSqlName("SRC") + " SRC, "  + RetSqlName("SRV") + " SRV "
cQuery += "WHERE RC_FILIAL >= '"+mv_par01+"' AND RC_FILIAL <= '"+mv_par02+"' "
cQuery += "AND RC_PD = RV_COD "
cQuery += "AND RV_TIPOCOD = '2' "
cQuery += "AND SRC.D_E_L_E_T_ = ' ' "
cQuery += "AND SRV.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY RC_FILIAL,RC_MAT,3 "
cQuery += "ORDER BY RC_FILIAL,RC_MAT,3 "

dbUseArea(.T.,"TopConn",TcGenQry(,,cQuery),"TRB",.T.,.T.)
aFunc := {}

dbSelectArea("TRB")
dbGoTop()
SetRegua(trb->(reccount()))
While ! eof()

    IF !TRB->RC_FILIAL $ fValidFil()
       DbSkip()
       Loop
    EndIF   

    If ( nPos := Ascan(aFunc,{ |X| x[1] = trb->rc_filial .and. x[2] = trb->rc_mat } )) > 0
       If Trb->tipo = "1"
          aFunc[nPos,4] += trb->totfun
       Else   
          aFunc[nPos,4] -= trb->totfun 
       EndIF
    Else
       aAdd(aFunc,{TRB->RC_FILIAL,TRB->RC_MAT,TRB->TIPO,TRB->TOTFUN})
    EndIF
    DbSkip()

EndDO             

TRB->(dbCloseArea())

SetRegua(Len(aFunc))
For n := 1 to Len(aFunc)


	IncRegua()
	
	If Li > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	nLiq := 0
	DbSelectArea("SRC")
	If DbSeek(aFunc[n,1]+aFunc[n,2]+"999")
	   While aFunc[n,1]+aFunc[n,2]+"999" == SRC->RC_FILIAL+SRC->RC_MAT+SRC->RC_PD
	      nLiq += SRC->RC_VALOR
	      DbSkip()
	   EndDo   
	EndIf
	
	If AFunc[n,4] <> nLiq
	      @LI, 01 PSAY aFunc[n,1]+"-"+aFunc[n,2] +'-'+Posicione("SRA",1,aFunc[n,1]+aFunc[n,2],"RA_NOME") + Transform(AFunc[n,4], '@e 9,999,999.99') +  Transform(nLiq, '@e 9,999,999.99') + "  " + Transform(AFunc[n,4] - nLiq, '@e 9,999,999.99') 
	      li ++
	EndIF
	      
	
Next 

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(WnRel)
EndIf

Ms_Flush()

Return
