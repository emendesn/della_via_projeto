/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR08   บAutor  ณ Reinaldo Caldas    บ Data ณ  27/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consumo de bandas na producao mensal                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol Renovadora de Pneus LTDA.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DESTR08()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1      := "Este relatorio ira imprimir as informacoes de acordo"
Private cDesc2      := "com os dados informados nos parametros pelo usuario."
Private cDesc3      := "Consumo de bandas mensal"
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 78
Private tamanho     := "P"
Private nomeprog    := "DESTR08"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Consumo de Bandas Mensal"
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := ""
Private Cabec2      := " Banda           Largura              Total                    Qtd.OP Produzida "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DESTR08"
Private _cPerg     	:= "DEST08"

Private cString 	:= "SC2"

dbSelectArea("SC2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_aRegs:={}

AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,_cPerg)

Pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

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
ฑฑบPrograma  ณ ImpRel   บAutor  ณ Reinaldo Caldas    บ Data ณ  27/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do relatorio                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpRel()

LOCAL _cQry := cCodBand := cLargura := ""
LOCAL _aITProd := {}
LOCAL nQtdBand := nQtSegum := nQtdOP := nTotGer := nTot2UM := nTotPro := 0


Cabec1 := " Periodo de "+dtoc(mv_par01)+" at้ "+dtoc(mv_par02)

ProcRegua(100)

IF Select("TRB") > 0
	TRB->(dbCloseArea())
EndIF

_cQry := "select D3_OP, D3_X_PROD, D3_COD, D3_QUANT, D3_QTSEGUM "
_cQry += " from " + RetSqlName("SD3")+ " SD3 " 
_cQry += " where SD3.D_E_L_E_T_ = ' ' "
_cQry += " and D3_FILIAL = '" + xFilial("SD3") + "' "
_cQry += " and D3_EMISSAO >= '" + DtoS(mv_par01) + "' and D3_EMISSAO <= '" + DtoS(mv_par02) + "' "
_cQry += " and D3_ESTORNO <> 'S' and D3_COD = D3_X_PROD "
_cQry += " order by D3_X_PROD "

_cQry := ChangeQuery(_cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

While ! Eof()
   	SB1->(dbSetOrder(1))
    SB1->(dbSeek(xFilial("SB1")	+ TRB->D3_X_PROD))
     	
    nQtdBand += TRB->D3_QUANT
    nQtSegum += IIF( SB1->B1_TIPCONV == 'D', TRB->D3_QUANT / SB1->B1_CONV,TRB->D3_QUANT * SB1->B1_CONV)
    nQtdOP   += 1  
    cLargura := SB1->B1_XLARG
    cCodBand := TRB->D3_X_PROD
	
	dbSelectArea("TRB")
	dbSkip()
	
	IF cCodBand != TRB->D3_X_PROD
		aAdd(_aITProd,{cCodBand,cLargura,nQtdBand,nQtSegum,nQtdOP})
		nQtdBand := nQtSegum := nQtdOP := 0
	EndIF
EndDo

dbSelectArea("TRB")
dbCloseArea()

For _i := 1  To Len(_aITProd)

	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
	IF nLin > 60
		nLin := Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin := nLin + 2
	EndIF

	@ nLin, 001 Psay _aITProd[_i][1]
	@ nLin, 017 Psay _aITProd[_i][2]
	@ nLin, 036 Psay _aITProd[_i][3] Picture "@E 9999.99"
//	@ nLin, 050 Psay _aITProd[_i][4] Picture "@E 999.999"
	@ nLin, 075 Psay _aITProd[_i][5] Picture "@E 9999"
	
	nLin ++
	
	nTotGer += _aITProd[_i][3]
	nTot2UM += _aITProd[_i][4]
	nTotPro += _aITProd[_i][5]

Next _i

IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	
	nLin := nLin + 2
	
	@ nLin, 001 Psay "Total : "
	@ nLin, 031 Psay nTotGer Picture "@E 9,999,999.99"
//	@ nLin, 045 Psay nTot2UM Picture "@E 9,999,999.99"
	@ nLin, 075 Psay nTotPro Picture "@E 9999"
	
	Roda(cbcont,cbtxt,"P")
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPgEject(.F.)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndiF

MS_FLUSH()

Return
