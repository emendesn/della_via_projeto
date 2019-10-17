#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR15   บAutor  ณ RXXXXXXXXXXXXX    บ Data ณ  11/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Lista pre-lote de produ็ใo                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol Renovadora de Pneus LTDA.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DESTR15()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Lista pre-lote de produ็ใo "
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "DESTR15"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Lista Pre-Lote de Produ็ใo "
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := " "
Private Cabec2      := " "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DESTR15"
Private _cPerg     	:= "DEST15"

Private cString 	:= "SZL"

dbSelectArea("SZL")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_aRegs:={}

AAdd(_aRegs,{_cPerg,"01","Data Emissao   ? ","Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Ate Emissao    ? ","Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"05","Pre-Lote       ? ","Da  Data"       ,"Da  Data"       ,"mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZL"})
AAdd(_aRegs,{_cPerg,"06","Ate Pre-Lote   ? ","Ate Data"       ,"Ate Data"       ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZL"})

ValidPerg(_aRegs,_cPerg)

Pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( {|| ImpRel() } )

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpRel   บAutor  ณ Reinaldo Caldas    บ Data ณ  25/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do relatorio                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpRel()

LOCAL cCod     := ""
LOCAL cabec1   := "|  Or   |   Num.OP        |   Carcaca           |   Desenho      |   Serie/Num.Fogo   |   Nome do Cliente                                                          |   Dt.Entrega   |"
                  *|  XX   |   XXXXXX - XX   |   XXXXXXXXXXXXXXX   |   XXXXXXXXXX   |   XXXXXXXXXXXXXX   |   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                 |   99/99/99     |
                  *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                  *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

LOCAL cabec2   := " "


ProcRegua(100)

IF Select("TMP") > 0
	TMP->(dbCloseArea())
EndIF

_cQry := " select ZL_NUMLOTE, ZL_X_ORDEM, ZL_NUMOP, ZL_EMISSAO, ZL_DTENTRE, ZL_CLIENTE, ZL_X_HRINI, C2_X_DESEN, C2_SERIEPN, C2_NUMFOGO, C2_PRODUTO "
_cQry += " from " + RetSqlName("SZL")+ " ZL, " + RetSqlName("SC2") + " C2 "
_cQry += " where ZL.D_E_L_E_T_ = ' ' "
_cQry += "   and C2.D_E_L_E_T_ = ' ' "      
_cqry += "   and ZL_FILIAL  = " + " '" + xFilial("SZL") + "' "
_cQry += "   and ZL_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' "
_cQry += "   and ZL_NUMLOTE BETWEEN '" + mv_par03 + "' and '" + mv_par04 + "' "
_cQry += "   and ZL_NUMOP = C2_NUM||C2_ITEM||C2_SEQUEN"
_cQry += " order by ZL_FILIAL, ZL_NUMLOTE, ZL_X_ORDEM "

_cQry := ChangeQuery(_cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TMP",.F.,.T.)

TCSetField( "TMP", "ZL_DTENTRE", "D", 8 )

dbSelectArea("TMP")
dbGoTop()
cLote := ""
While ! Eof()

	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
	IF nLin > 60 .or. cLote != TMP->ZL_NUMLOTE
		
		cLote:= TMP->ZL_NUMLOTE		
		Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		
		nLin := 8
		
		@ nLin, 001 Psay "Pre-Lote: " + TMP->ZL_NUMLOTE
		@ nLin, 022 Psay "Horario: " + TMP->ZL_X_HRINI 
		
		nLin +=2
		@ nLin, 001 Psay IniFatLine+FimFatLine
		nLin ++
		
	EndIF

		SA1->(dbSetOrder(5))
		SA1->(dbSeek(xFilial("SA1") + TMP->ZL_CLIENTE ) )
		
 		@ nLin, 000 Psay "|"
 		@ nLin, 003 Psay TMP->ZL_X_ORDEM
 		@ nLin, 008 Psay "|"
		@ nLin, 012 Psay Substr(TMP->ZL_NUMOP,1,6)+"-"+Substr(TMP->ZL_NUMOP,7,2)
		@ nLin, 026 Psay "|"
		@ nLin, 030 Psay Padr(TMP->C2_PRODUTO,15)
		@ nLin, 048 Psay "|"
		@ nLin, 052 Psay Padr(TMP->C2_X_DESEN,10)
		@ nLin, 065 Psay "|"

		If Len(AllTrim(Padr(TMP->C2_SERIEPN,14))) > 0 .AND. Len(AllTrim(Padr(TMP->C2_NUMFOGO,14))) > 0
			// Imprime Serie / Num. Fogo
			@ nLin, 069 Psay AllTrim(Padr(TMP->C2_SERIEPN,6)) + " / " + AllTrim(Padr(TMP->C2_NUMFOGO,6))
		Elseif Len(AllTrim(Padr(TMP->C2_SERIEPN,14))) > 0
			// Imprime Serie
			@ nLin, 069 Psay AllTrim(Padr(TMP->C2_SERIEPN,14))
		Elseif Len(AllTrim(Padr(TMP->C2_NUMFOGO,14))) > 0
			// Imprime Num. Fogo
			@ nLin, 069 Psay AllTrim(Padr(TMP->C2_NUMFOGO,14))
		Endif

		@ nLin, 086 Psay "|"
		@ nLin, 090 Psay Padr(SA1->A1_NOME,40)
		@ nLin, 163 Psay "|"
		@ nLin, 167 Psay TMP->ZL_DTENTRE
		@ nLin, 180 Psay "|"

		nLin ++
		@ nLin, 001 Psay IniFatLine+FimFatLine
		nLin ++
		
	dbSelectArea("TMP")
	dbSkip()
EndDo
		
dbSelectArea("TMP")
dbCloseArea()

IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	Roda(cbcont,cbtxt,"M")
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPgEject(.F.)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
