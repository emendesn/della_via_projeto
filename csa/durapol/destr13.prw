/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESTR13   ºAutor  ³ Reinaldo Caldas    º Data ³  22/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lista Lotes de produção                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol Renovadora de Pneus LTDA.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DESTR13()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Lista Lotes de produção "
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 78
Private tamanho     := "G"
Private nomeprog    := "DESTR13"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Lista Lotes de Produção "
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := " "
Private Cabec2      := " "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private nHrPadProd  := GetMV("MV_PADPROD") //Numero de horas considerada como padrao para a realizacao da producao
Private wnrel      	:= "DESTR13"
Private _cPerg     	:= "DEST13"

Private cString 	:= "SZM"

dbSelectArea("SZM")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs:={}

AAdd(_aRegs,{_cPerg,"01","Data Autoclave ? ","Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Autoclave      ? ","Ate Data"       ,"Ate Data"       ,"mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"03","Da  OP ?"         ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","C", 13,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
AAdd(_aRegs,{_cPerg,"04","Ate OP ?"         ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","C", 13,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SC2"})
AAdd(_aRegs,{_cPerg,"05","Lote Produção? "  ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","C",  6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZM"})
AAdd(_aRegs,{_cPerg,"06","Ate Lote Producao","Ate Data"       ,"Ate Data"       ,"mv_ch2","C",  6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SZM"})

ValidPerg(_aRegs,_cPerg)

Pergunte(_cPerg,.F.)


wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( {|| ImpRel() } )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpRel   ºAutor  ³ Reinaldo Caldas    º Data ³  25/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do relatorio                         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel()

LOCAL cCod     := ""
LOCAL cabec1   := " Lote Producao  Hr.Inicial  Hr.Final Dif.Producao  OP do Lote    Produto          Servico          Nome Cliente                               Dt.Entrega "
LOCAL cabec2   := " "
LOCAL cHrFabr  := ""
LOCAL nDias    := 0


ProcRegua(100)

IF Select("TMP") > 0
	TMP->(dbCloseArea())
EndIF

_cQry := "select C2_XNUMLOT, ZM_X_HRINI, ZM_X_HRFIM, ZM_X_DTFIM, ZM_X_DTINI, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_SERVPCP, C2_XNREDUZ, C2_DATPRF "
_cQry += " from " + RetSqlName("SC2")+ " C2, " + RetSqlName("SZM") + " ZM "
_cQry += " where C2.D_E_L_E_T_ = ' ' "
_cQry += " and ZM.D_E_L_E_T_ = ' ' "
_cQry += " and C2_XDTCLAV = '" + DtoS(mv_par01) + "' and C2_XACLAVE = '" + mv_par02 + "' "
_cQry += " and C2_NUM||C2_ITEM||C2_SEQUEN >='" + mv_par03 + "' and C2_NUM||C2_ITEM||C2_SEQUEN <= '" + mv_par04 + "' "
_cQry += " and C2_XNUMLOT = ZM_NUMLOTE "
_cQry += " and ZM_NUMLOTE >= '" + mv_par05 + "' and ZM_NUMLOTE <= '" + mv_par06 + "' "
_cQry += " order by C2_XNUMLOT "

_cQry := ChangeQuery(_cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TMP",.F.,.T.)

TCSetField( "TMP", "C2_DATPRF"  , "D", 8 )
TCSetField( "TMP", "ZM_X_DTFIM" , "D", 8 )
TCSetField( "TMP", "ZM_X_DTINI" , "D", 8 )

dbSelectArea("TMP")
dbGoTop()

While ! Eof()

	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
	IF nLin > 60
		Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		nLin := 8
	EndIF
/*
" Lote Producao  Hr.Inicial  Hr.Final Dif.Producao  OP do Lote    Produto          Servico        Nome Cliente                 "
"    XXXXX        XX:XX       XX:XX    XXXX        XXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
     6            19          31       40          52             67               84             99                                    
     */
   	IF cCod <> TMP->C2_XNUMLOT
		cCod :=  TMP->C2_XNUMLOT
		cHrFabr := CalcDifHr(TMP->ZM_X_HRINI,TMP->ZM_X_HRFIM,TMP->ZM_X_DTFIM-TMP->ZM_X_DTINI,1)
		nDias   := TMP->ZM_X_DTFIM-TMP->ZM_X_DTINI
		@ nLin, 001 Psay TMP->C2_XNUMLOT
		@ nLin, 016 Psay TMP->ZM_X_HRINI Picture "99:99"
		@ nLin, 028 Psay TMP->ZM_X_HRFIM Picture "99:99"
		@ nLin, 037 Psay CalcDifHr(TMP->ZM_X_HRINI,TMP->ZM_X_HRFIM,TMP->ZM_X_DTFIM-TMP->ZM_X_DTINI,1)
		@ nLin, 051 Psay TMP->C2_NUM + TMP->C2_ITEM + TMP->C2_SEQUEN
		@ nLin, 065 Psay TMP->C2_PRODUTO
		@ nLin, 082 Psay GetServ(TMP->C2_NUM,TMP->C2_ITEM)
		dbSelectArea("SA1")
		dbSetOrder(5)
		dbSeek(xFilial("SA1") + TMP->C2_XNREDUZ )
		@ nLin, 099 Psay Padr(SA1->A1_NOME,40)
		@ nLin, 142 Psay TMP->C2_DATPRF
		
		nLin ++
		
	Else
		//@ nLin, 019 Psay TMP->ZM_X_HRINI Picture "99:99"
		//@ nLin, 031 Psay TMP->ZM_X_HRFIM Picture "99:99"
		//@ nLin, 040 Psay TMP->ZM_X_HRINI - TMP->ZM_X_HRFIM
		@ nLin, 051 Psay TMP->C2_NUM + TMP->C2_ITEM + TMP->C2_SEQUEN
		@ nLin, 065 Psay TMP->C2_PRODUTO
		@ nLin, 082 Psay GetServ(TMP->C2_NUM,TMP->C2_ITEM)
		
		dbSelectArea("SA1")
		dbSetOrder(5)
		dbSeek(xFilial("SA1") + TMP->C2_XNREDUZ )
		
		@ nLin, 099 Psay Padr(SA1->A1_NOME,40)
		@ nLin, 142 Psay TMP->C2_DATPRF
		
		nLin ++
		
	EndIF	 
		
	dbSelectArea("TMP")
	dbSkip()
	If cCod <> TMP->C2_XNUMLOT
		//cCod := TMP->C2_XNUMLOT
		nLin += 2
		@ nLin, 006 Psay "- Diferenca de Producao padrao - "
		nLin +=2
		@ nLin, 006 Psay "Producao padrao: "
		@ nLin, 030 Psay nHrPadProd
		@ nLin, 040 Psay "Producao real: "
		@ nLin, 061 Psay Alltrim(cHrFabr)
		@ nLin, 074 Psay "Diferenca :"
		@ nLin, 098 Psay CalcDifHr(nHrPadProd,cHrFabr,nDias,2)
		nLin ++
		@ nLin, 006 Psay "Autoclave: " + mv_par02
		nLin +=2
	EndIf
EndDo
	
	
dbSelectArea("TMP")
dbCloseArea()

IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	Roda(cbcont,cbtxt,"P")
EndIF

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

Static Function CalcDifHr(cHrIni,cHrFim,nHrs,cTp)

Local nHrIni  := Iif(Substr(cHrIni,3,1) == ":",Val(Substr(cHrIni,1,2)),Val(Substr(cHrIni,1,1)) )
Local nMinIni := Iif(Substr(cHrIni,3,1) == ":",Val(Substr(cHrIni,4,2)),Val(Substr(cHrIni,3,2)) )
Local nHrFim  := Iif(Substr(cHrFim,3,1) == ":",Val(Substr(cHrFim,1,2)),Val(Substr(cHrFim,1,1)) )
Local nMinFim := Iif(Substr(cHrFim,3,1) == ":",Val(Substr(cHrFim,4,2)),Val(Substr(cHrFim,3,2)) )
Local _lMin   := .F.

If nMinFim == 0 
	nMinFim := 60
	_lMin   := .T.
EndIf
If nMinIni == 0 .And. nHrIni > nHrFim 
	nMinIni := 60
	_lMin   := .T.
EndIf
IF nMinFim < nMinIni
	nRtMin := Alltrim(Str(nMinIni - nMinFim))
ElseIF nMinFim >= nMinIni
	nRtMin := Alltrim(Str(nMinFim - nMinIni))
EndIF
nHrFim := ( (nHrs * 24) + Iif(nHrs > 0 .And. cTp == 1,nHrFim,Iif(nHrs <= 1 .And. nHrs > 0 .And. cTp == 2 , nHrs,;
			Iif(nHrs > 1 .And. cTp == 2 ,1,nHrFim ))) )
IF nHrFim < nHrIni
	nRtHrFim := Alltrim(Str((nHrIni - nHrFim) - Iif(_lMin,1,0)))
ElseIF nHrFim >= nHrIni
	nRtHrFim := Alltrim(Str((nHrFim - nHrIni) - Iif(_lMin,1,0))) 
EndIF

cRet := nRtHrFim + ":" + nRtMin

Return(cRet)

Static Function GetServ(cNumOP,cItemOP)

Local _aArea  := GetArea()
Local cOP     := cNumOP + cItemOP + '001'
Local cRet    := ""
Local cAliasP := GetNextAlias()

cQuery := "SELECT D1_SERVICO"
cQuery += " FROM " + RetSqlName("SC2") + " SC2, " + RetSqlName("SD1") + " SD1"
cQuery += " WHERE SC2.D_E_L_E_T_ = ''"
cQuery += " AND   SD1.D_E_L_E_T_ = ''"
cQuery += " AND   C2_FILIAL = '" + xFilial('SC2') + "'"
cQuery += " AND   C2_NUM = '"+cNumOP+"'"
cQuery += " AND   C2_ITEM = '"+cItemOP+"'"
cQuery += " AND   D1_FILIAL = C2_FILIAL"
cQuery += " AND   D1_DOC = C2_NUMD1"
cQuery += " AND   D1_SERIE = C2_SERIED1"
cQuery += " AND   D1_ITEM = C2_ITEMD1"
cQuery += " AND   D1_TIPO = 'B'"

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAliasP , .F., .T. )

cRet := (cAliasP)->D1_SERVICO
dbSelectArea(cAliasP)
dbCloseArea()

RestArea(_aArea)

Return(cRet)
