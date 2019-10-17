#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFINR02   ºAutor  ³ RXXXXXXXXXXXXXXXXXXº Data ³  15/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pre analise de credito cliente                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFINR02()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1      := "Relatorio de Analise situacao de credito"
Private cDesc2      := ""
Private cDesc3      := ""
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 78
Private tamanho     := "G"
Private nomeprog    := "DFINR02"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Analise situacao credito"
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := " Cliente Nome                                          Coleta    Dt.Entrada Dt.Entrega   Qtd.Serv.   Risco  Sit.Credito                    Ult.Mov.   Mov.(dias)    Lim.Cred.      Saldo Dupl.  Atraso Atual  Media Atraso"
Private Cabec2      := ""
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DFINR02"
Private _cPerg     	:= "DFIN02"

Private cString 	:= "SF1"

dbSelectArea("SF1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs:={}
AAdd(_aRegs,{_cPerg,"01","Lista por Data ?"    ,"Lista por Data?","Lista por Data?","mv_ch1","N", 1,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Da  Data ?"          ,"Da  Data"       ,"Da  Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"03","Ate Data ?"          ,"Ate Data"       ,"Ate Data"       ,"mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"04","Do  Cliente ?"       ,"Ate Data"       ,"Ate Data"       ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AAdd(_aRegs,{_cPerg,"05","Ate Cliente ?"       ,"Ate Cliente"    ,"Ate Data"       ,"mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AAdd(_aRegs,{_cPerg,"06","Da  Loja ?"          ,"Da Loja"        ,"Ate Data"       ,"mv_ch6","C", 2,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"07","Ate Loja ?"          ,"Ate Loja"       ,"Ate Loja"       ,"mv_ch7","C", 2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})

                                                              
ValidPerg(_aRegs,_cPerg)
Pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus( {|lEnd| ImpRel(@lEnd,wnrel,cString)},Titulo )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpRelºAutor  ³ Reinaldo Caldas       º Data ³  15/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do relatorio                         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel(lEnd,wnrel,cString)

Local _nX,_nPos,_cQry
Local nItem := nValAtraso := 0
Local cCliNew := cCliOut := cCliChq := cCliExc := ""
Private _dDataDe   := mv_par02
Private _dDataAte  := mv_par03
Private _cClieDe   := mv_par04
Private _cClieAte  := mv_par05
Private _cLjCliDe  := mv_par06
Private _cLjCliAte := mv_par07

                                   
// Seleciona NFS do periodo escolhido
_cQry := " Select DISTINCT(F1_DOC), F1_FORNECE ,A1_NOME, F1_DTDIGIT, C2_DATPRF, A1_ULTCOM, A1_LC, A1_SALDUP, A1_RISCO, A1_METR, F1_SERIE, F1_LOJA, A1_DTULTIT, A1_DTULCHQ, A1_TITPROT, A1_CHQDEVO "
_cQry += " From " + RetSqlName("SF1") + " SF1, " + RetSqlName("SC2") + " SC2, " + RetSqlName("SA1") + " SA1 " 
_cQry += " Where SF1.D_E_L_E_T_ = ' ' "
_cQry += " and SA1.D_E_L_E_T_ = ' ' "
_cQry += " and SC2.D_E_L_E_T_ = ' ' "
_cQry += " and C2_FILIAL = '" + xFilial("SC2") + "' "
_cQry += " and F1_FILIAL = '" + xFilial("SF1") + "' "
_cQry += " and F1_DTDIGIT >= '" +Dtos(_dDataDe)+ "' and F1_DTDIGIT <= '" +Dtos(_dDataAte)+ "' " 
_cQry += " and F1_FORNECE >= '" +_cClieDe+ "' and F1_FORNECE <= '" +_cClieAte+ "'" 
_cQry += " and F1_LOJA >= '"+_cLjCliDe+"' and F1_LOJA <= '"+_cLjCliAte+"' and F1_TIPO ='B'"
_cQry += " and F1_DOC = C2_NUMD1 " 
_cQry += " and F1_FORNECE = A1_COD and F1_LOJA = A1_LOJA AND A1_FILIAL = '"+xFilial("SA1")+"'"
IF mv_par01 == 1
	_cQry += " Order by F1_DTDIGIT "		
Elseif mv_par01 == 2
	_cQry += " Order by C2_DATPRF "	
Else
	_cQry += " ORDER BY F1_FORNECE,F1_DOC"
EndIF	

_cQry := ChangeQuery(_cQry)
		
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

TcSetField("TRB", "F1_DTDIGIT", "D")
TcSetField("TRB", "C2_DATPRF",  "D")
TcSetField("TRB", "A1_ULTCOM",  "D")
TcSetField("TRB", "A1_DTULTIT", "D")
TcSetField("TRB", "A1_DTULCHQ", "D")
dbGotop()

dbSelectArea("TRB")
ProcRegua(0)
dbGoTop()

nItTotal := 0
While ! Eof()
	IF lEnd
		@Prow()+1,001 Psay "Cancelado pelo operador"
		Exit
	EndIF	
	
	IncProc("Imprimindo ...")
	nItem   := 0
	cCliNew := ""
	cCliOut := ""
	cCliChq := ""
	cCliExc := ""
	_lnImp  := .F.
	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+TRB->F1_DOC+TRB->F1_SERIE+TRB->F1_FORNECE+TRB->F1_LOJA))
	While !Eof() .and. xFilial("SD1") == SD1->D1_FILIAL .and. TRB->F1_DOC == SD1->D1_DOC .and. ;
		TRB->F1_SERIE == SD1->D1_SERIE .and. TRB->F1_FORNECE == SD1->D1_FORNECE .and. TRB->F1_LOJA == SD1->D1_LOJA
		IncProc("Imprimindo ...")
		nITem ++
		dbSelectArea("SD1")
		dbSkip()
	EndDo
	IF Empty(TRB->A1_ULTCOM)     //Cliente Novo		
		cCliNew := "Cl.Novo"
	EndIF
	IF dDataBase - TRB->A1_ULTCOM >= 120 //Cliente sem movimento
		cCliOut := "S.Mov"
	EndIF
	//Cliente com cheques devolvidos ou protestado
	IF (TRB->A1_TITPROT > 0 .and. (dDatabase - TRB->A1_DTULTIT) > 3) .or. (TRB->A1_CHQDEVO > 0 .and. (dDatabase - TRB->A1_DTULCHQ) > 3)
		cCliChq := "ChqDev"
	EndIF
	IF TRB->A1_LC <  TRB->A1_SALDUP //Cliente limite excedido
		cCliExc := "S.Lim"
	EndIF
	IF Empty(cCliNew) .and. Empty(cCliOut) .and. Empty(cCliChq) .and. Empty(cCliExc)
		_lnImp := .T.
	EndIF
	nValAtraso := SomaAtraso(SM0->M0_CODFIL,TRB->F1_FORNECE,TRB->F1_LOJA)
	
	IF nLin > 58
		cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin := 8
	EndIF

/*
 Cliente Nome                                          Coleta    Dt.Entrada Dt.Entrega   Qtd.Serv    Risco  Sit.Credito                    Ult.Mov    Mov.(dias)    Lim.Cred.      Saldo Dupl.  Atraso Atual  Media Atraso
 XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      XXXXXX    99/99/99   99/99/99          999    X      XXXXXXXXXXXXX                  99/99/99          999 9,999,999.99    99,999,999.99  9,999,999.99        999.99
 1       9                                             55        65         76                94     101    108                            139               157 161             177            192                 212
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
*/


	@ nLin , 001 Psay TRB->F1_FORNECE
	@ nLin , 009 Psay Alltrim(TRB->A1_NOME)
	@ nLin , 055 Psay TRB->F1_DOC
	@ nLin , 065 Psay TRB->F1_DTDIGIT
	@ nLin , 076 Psay TRB->C2_DATPRF
	@ nLin , 094 Psay nItem Picture "999"
	@ nLin , 101 Psay TRB->A1_RISCO
	IF !_lnImp
		@ nLin , 108 Psay IIF(!Empty(cCliNew),cCliNew+"/","")+IIF(!Empty(cCliOut),cCliOut+"/","")+cCliExc
	Else
		@ nLin , 108 Psay "Cred.Liberado" Picture "@E"
	EndIF
	@ nLin , 139 Psay TRB->A1_ULTCOM
	@ nLin , 157 Psay ddatabase - TRB->A1_ULTCOM Picture "@z 999"
	@ nLin , 161 Psay TRB->A1_LC     Picture "@Z 9,999,999.99"
	@ nLin , 177 Psay TRB->A1_SALDUP Picture "@Z 99,999,999.99"		
	@ nLin , 192 Psay nValAtraso     Picture "@R 9,999,999.99"	 //Saldo atraso
	@ nLin , 212 Psay TRB->A1_METR  Picture "@E 999.99"	
	nLin ++	
	nItTotal += nItem
	
	dbSelectArea("TRB")
	dbSkip()
Enddo       
IF nlin != 80
	nLin ++
	IF nlin > 58
		cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	EndIF
	@ nLin , 005 PSAY "T O T A L"
	@ nLin , 092 Psay nItTotal Picture "@e 9,999"
	Roda(1,"","G")	
EndIF


dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPgEject(.F.)
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function SomaAtraso(cFilNew,cCliente,cLoja)

Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cSalvFil   := cFilAnt
Local cAliasSE1  := "SE1"

Local lQuery     := .F.
Local nValAtraso := 0

#IFDEF TOP 
	Local aStruSE1   := {}
	Local cQuery     := ""	
	Local nX         := 0	
#ENDIF 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Troca a filial corrente                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilNew := cFilAnt
cFilAnt := cFilNew
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial()+cCliente+cLoja)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa os titulos em aberto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(8)
#IFDEF TOP
	aStruSE1  := SE1->(dbStruct())
	cAliasSE1 := "SOMAATRASO"
	lQuery    := .T.

	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
	cQuery += "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
	cQuery += "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
	cQuery += "SE1.E1_STATUS='A' AND "
	cQuery += "SE1.D_E_L_E_T_=' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
	For nX := 1 To Len(aStruSE1)
		If aStruSE1[nX][2] <> "C"
			TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
		EndIf
	Next nX
#ELSE
	MsSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA+"A")
#ENDIF
While ( !Eof() .And. (cAliasSE1)->E1_FILIAL == xFilial("SE1") .And. ;
		(cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA == SA1->A1_COD+SA1->A1_LOJA .And.;
		(cAliasSE1)->E1_STATUS == "A" )
	If ( dDataBase > (cAliasSE1)->E1_VENCREA )
		If (cAliasSE1)->E1_TIPO $ MVABATIM
			nValAtraso += xMoeda( (cAliasSE1)->E1_SALDO , (cAliasSE1)->E1_MOEDA , 1 )
		ElseIf !((cAliasSE1)->E1_TIPO $ MVRECANT+"/"+MVPROVIS+"/"+MV_CRNEG)
			nValAtraso -= xMoeda( (cAliasSE1)->E1_SALDO , (cAliasSE1)->E1_MOEDA , 1 )
		Endif
	EndIf
	dbSelectArea(cAliasSE1)
	dbSkip()
EndDo
If lQuery
	dbSelectArea(cAliasSE1)
	dbCloseArea()
	dbSelectArea("SE1")
EndIf
dbSetOrder(1)
cFilAnt := cSalvFil
RestArea(aAreaSE1)
RestArea(aArea)
Return (nValAtraso)
