/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDFATR09   บAutor  ณ Reinaldo Caldas    บ Data ณ  26/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Resumo de Vendas                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol Renovadora de Pneus LTDA.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DFATR09()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1      := "Relatorio de Resumo de Vendas Durapol   "
Private cDesc2      := ""
Private cDesc3      := ""
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 78
Private tamanho     := "P"
Private nomeprog    := "DFATR09"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Resumo de Vendas Durapol"
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := " "
Private Cabec2      := " "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DFATR09"
Private _cPerg     	:= "DFAT09"

Private cString 	:= "SF2"

dbSelectArea("SF2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_aRegs:={}

AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"03","Do  Motorista ?"   ,"Do Vendedor"    ,"Do Vendedor"    ,"mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"04","Ate Motorista ?"   ,"Ate Vendedor"   ,"Ate Vendedor"   ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"05","Do  Vendedor ?"    ,"Do Vendedor"    ,"Do Vendedor"    ,"mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"06","Ate Vendedor ?"    ,"Ate Vendedor"   ,"Ate Vendedor"   ,"mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"07","Do  Indicador ?"   ,"Do Vendedor"    ,"Do Vendedor"    ,"mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"08","Ate indicador ?"   ,"Ate Vendedor"   ,"Ate Vendedor"   ,"mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,_cPerg)

Pergunte(_cPerg,.F.)
aOrd := {"Por Motorista", "Vendedor","Indicador" }
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpRel   บAutor  ณ Reinaldo Caldas    บ Data ณ  26/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do relatorio                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpRel()

LOCAL _cQry
LOCAL cCodCli  := ""
LOCAL cNota    := ""
LOCAL _aTam    := _aEstrutura := {}
LOCAL nOrdem   := aReturn[8]
LOCAL Titulo   := Titulo + ' -   ' + aOrd[nOrdem]
LOCAL nTotVlr  := nTtPneu  :=  nTotRec := nTotal := 0

LOCAL cabec1   := " Cod.Cliente    Cliente                                           Valor               Reforma      Recusado"
LOCAL cabec2   := " "


ProcRegua(100)

IF Select("VEDFAT") > 0
	TRBFAT->(dbCloseArea())
EndIF

_cQry := "select F2_DOC ,F2_CLIENTE, A1_NOME, F2_VALFAT,D2_TES, D2_GRUPO "
_cQry += " from " + RetSqlName("SF2")+ " SF2, " + RetSqlName("SD2") + " SD2, " + RetSqlName("SA1") + " SA1 "
_cQry += " where SF2.D_E_L_E_T_ = ' ' "
_cQry += " and SD2.D_E_L_E_T_ = ' ' "
_cQry += " and SA1.D_E_L_E_T_ = ' ' "
_cQry += " and F2_FILIAL = '" + xFilial("SF2") + "' and D2_FILIAL = '" + xFilial("SD2") + "' "
_cQry += " and F2_EMISSAO >= '" + DtoS(mv_par01) + "' and F2_EMISSAO <= '" + DtoS(mv_par02) + "' "
_cQry += " and F2_VEND3 >= '" + mv_par03 + "' and F2_VEND3 <= '" + mv_par04 + "' "
_cQry += " and F2_DOC = D2_DOC and D2_CLIENTE = F2_CLIENTE and F2_LOJA = D2_LOJA and F2_CLIENTE = A1_COD "
_cQry += " and F2_LOJA = A1_LOJA "
_cQry += " order by F2_CLIENTE "

_cQry := ChangeQuery(_cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"VEDFAT",.F.,.T.)

dbSelectArea("VEDFAT")
dbGoTop()

_aEstrutura := {}

_aTam := TamSX3("D2_DOC")
aAdd(_aEstrutura,{"TMP_DOC"     ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("F2_CLIENTE")
aAdd(_aEstrutura,{"TMP_CLI"     ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("A1_NOME")
aAdd(_aEstrutura,{"TMP_NOME"    ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("D2_TES")
aAdd(_aEstrutura,{"TMP_TES"     ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("D2_GRUPO")
aAdd(_aEstrutura,{"TMP_GRUPO"   ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("F2_VALFAT")
aAdd(_aEstrutura,{"TMP_TOTAL"   ,"N",_aTam[1],_aTam[2]})
aAdd(_aEstrutura,{"TMP_REC"     ,"N",5,0})
aAdd(_aEstrutura,{"TMP_REF"     ,"N",5,0})

cNomArq := CriaTrab(_aEstrutura,.T.)

dbUseArea(.T.,,cNomArq,"TMP",.T.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cNomArq,"(Descend(Strzero(TMP_TOTAL,16,2))+TMP_CLI)",,,"Selecionando Registros")
dbSetIndex(cNomArq+OrdbagExt())

dbSelectArea("VEDFAT")	
While ! Eof()
	IF VEDFAT->D2_TES == "902"
		dbSkip()
		Loop
	EndIF
	IF VEDFAT->D2_TES == "903"
		nTotRec ++
	ElseIF VEDFAT->D2_TES == "901" .AND. VEDFAT->TMP_GRUPO == "SERV"
		nTtPneu ++
	EndIF
	IF VEDFAT->F2_DOC != cNota
		nTotal += VEDFAT->F2_VALFAT
	EndIF
    IF cCodCli != VEDFAT->F2_CLIENTE
    	cCodCli := VEDFAT->F2_CLIENTE
		Reclock("TMP",.T.)
			TMP->TMP_CLI     := VEDFAT->F2_CLIENTE
    	    TMP->TMP_NOME    := VEDFAT->A1_NOME
    	    TMP->TMP_TOTAL   := nTotal
			TMP->TMP_REF     := nTtPneu
			TMP->TMP_REC     := nTotRec			
		MsUnlock()
		nTotal := 0
	EndIF
	
	dbSelectArea("VEDFAT")	
	dbSkip()
EndDo

dbSelectArea("VEDFAT")
dbCloseArea()

dbSelectArea("TMP")
dbSetOrder(1)

While ! Eof()
	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
	IF nLin > 60
		Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin := 8
	EndIF
	
	@ nLin, 003 Psay TMP->TMP_CLI
	@ nLin, 013 Psay Alltrim(TMP->TMP_NOME)
	@ nLin, 023 Psay TMP->TMP_TOTAL Picture "@E 999,999,999.99"
	@ nLin, 057 Psay TMP->TMP_REF
	@ nLin, 077 Psay TMP->TMP_REC
	
	nTotVlr += TMP->TMP_TOTAL
	nTtPneu += TMP->TMP_REF
	nTotRec += TMP->TMP_REC
	
	TMP->(dbSkip())
	
EndDo

IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	Roda(cbcont,cbtxt,"G")
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPgEject(.F.)

dbSelectArea("TMP")
dbCloseArea()
fErase(cNomArq+OrdbagExt())

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndiF

MS_FLUSH()

Return
