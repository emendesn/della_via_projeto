#Include "rwmake.ch"
#include "font.ch"
#Include "topconn.ch"
#Define VK_F12 123

User Function DVLOJC03
	Private aRotina   := {}
	Private aCores    := {}
	Private aCpos     := {}
	Private cCadastro := "Consulta NF de saida"
	Private cNomTmp   := ""
	Private cNomSIX   := ""

	// Matriz de definição dos menus
	aadd(aRotina,{"Pesquisar" ,"AxPesqui"     ,0,1}) // Pesquisar
	aadd(aRotina,{"Visualizar","U_DVLJC03V()" ,0,2}) // Visualizar
	aadd(aRotina,{"Info. Adicionais","U_DVLJC03I()" ,0,2}) // Informações Adicionais
	aadd(aRotina,{"Parametros","U_DVLJC03A()" ,0,2}) // Parametros
	aadd(aRotina,{"Legenda"   ,"U_DVLJC03L()" ,0,3}) // Legenda

	// Matriz de definição de cores da legenda
	aadd(aCores,{"DEL=' ' .and. Empty(D1_DOC)" ,"BR_VERDE"   })
	aadd(aCores,{"DEL='*' .and. Empty(D1_DOC)" ,"BR_VERMELHO"})
	aadd(aCores,{"DEL=' ' .and. !Empty(D1_DOC)","BR_AMARELO" })

	// Matriz de campos a serem exibidos no Browse
	aadd(aCpos,{"Filial"     ,"F2_FILIAL"  })
	aadd(aCpos,{"Documento"  ,"F2_DOC"     })
	aadd(aCpos,{"Serie"      ,"F2_SERIE"   })
	aadd(aCpos,{"Tp. Venda"  ,"PAG_DESC"   })
	aadd(aCpos,{"Cliente"    ,"F2_CLIENTE" })
	aadd(aCpos,{"Loja"       ,"F2_LOJA"    })
	aadd(aCpos,{"Nome"       ,"A1_NREDUZ"  })
	aadd(aCpos,{"Vendedor"   ,"A3_NOME"    })
	aadd(aCpos,{"Emissao"    ,"F2_EMISSAO" })
	aadd(aCpos,{"Cond. Pagto","F2_COND"    })
	aadd(aCpos,{"Descr. Cond","E4_DESCRI"  })
	aadd(aCpos,{"NF Devol"   ,"D1_DOC"     })

	cPerg    := "DVLJ03"
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Loja            ?"," "," ","mv_ch1","C", 02,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Loja         ?"," "," ","mv_ch2","C", 02,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Da Emissao         ?"," "," ","mv_ch3","D", 08,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"04","Ate a Emissao      ?"," "," ","mv_ch4","D", 08,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""          ,"","","","",""          ,"","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"05","Mostra             ?"," "," ","mv_ch5","N", 01,0,0,"C","","mv_par05","Todas"  ,"","","","","Normais","","","","","Canceladas","","","","","Devolvidas","","","","","","","","","   ","","","",""          })


	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	if (mv_par04-mv_par03) >= 15
		if !ApMsgNoYes("Voce selecionou um periodo muito grande, a consulta pode demorar muito para ser executada, deseja continuar assim mesmo ?","Consulta")
			Return nil
		Endif
	Endif

	MsgRun("Consultando banco de dados...",,{ || AbreCom(.T.) })

	Set Key VK_F12 TO U_DVLJC03A()

	lLoop := .T.
	Do While lLoop
		dbSelectArea("TMP")
		mBrowse(,,,,"TMP",aCpos,,,,,aCores) // Cria o browse
		lLoop := !msgBox("Deseja realmente sair da consulta?","Consulta","YESNO")
	Enddo
	
	Set Key VK_F12 TO

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	dbSelectArea("SIX")
	dbCloseArea()
	fErase(cNomSIX+GetDbExtension())
	fErase(cNomSIX+OrdBagExt())
	
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")
Return nil

Static Function AbreCom(lSIX)
	Local   cSql      := ""

	cSql := "SELECT DISTINCT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,A1_NREDUZ,F2_COND,F2_EMISSAO
	cSql += ",D1_DOC,SF2.D_E_L_E_T_ AS DEL,E4_DESCRI,F2_VEND1,A3_NOME,F2_TIPVND,PAG_DESC,PA0_DESC"
	cSql += ",PA1_DESC,F2_DESCONT,F2_PLACA,F2_ORIGEM,F2_CODCON,PA6_DESC"
	cSql += " FROM "+RetSqlName("SF2")+" SF2"

	cSql += " LEFT JOIN "+RetSqlName("SD1")+" SD1"
	cSql += " ON   SD1.D_E_L_E_T_ = ''"
	cSql += " AND  D1_NFORI = F2_DOC"
	cSql += " AND  D1_SERIORI = F2_SERIE"
	cSql += " AND  D1_TIPO = 'D'"

	cSql += " LEFT JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON   SA1.D_E_L_E_T_ = ''"
	cSql += " AND  A1_COD = F2_CLIENTE"
	cSql += " AND  A1_LOJA = F2_LOJA"

	cSql += " LEFT JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_COD = F2_VEND1"

	cSql += " LEFT JOIN "+RetSqlName("SE4")+" SE4"
	cSql += " ON   SE4.D_E_L_E_T_ = ''"
	cSql += " AND  E4_CODIGO = F2_COND"

	cSql += " LEFT JOIN "+RetSqlName("PAG")+" PAG"
	cSql += " ON   PAG.D_E_L_E_T_ = ''"
	cSql += " AND  PAG_TIPO = F2_TIPVND"

	cSql += " LEFT JOIN "+RetSqlName("PA0")+" PA0"
	cSql += " ON   PA0.D_E_L_E_T_ = ''"
	cSql += " AND  PA0_COD = F2_CODMAR"

	cSql += " LEFT JOIN "+RetSqlName("PA1")+" PA1"
	cSql += " ON   PA1.D_E_L_E_T_ = ''"
	cSql += " AND  PA1_COD = F2_CODMOD"

	cSql += " LEFT JOIN "+RetSqlName("PA6")+" PA6"
	cSql += " ON   PA6.D_E_L_E_T_ = ''"
	cSql += " AND  PA6_COD = F2_CODCON"

	cSql += " WHERE F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	cSql += " AND   F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	if mv_par05 = 2 // Normais
		cSql += " AND SF2.D_E_L_E_T_ = ''"
		cSql += " AND D1_DOC IS NULL"
	Elseif mv_par05 = 3 // Canceladas
		cSql += " AND SF2.D_E_L_E_T_ = '*'"
		cSql += " AND D1_DOC IS NULL"
	Elseif mv_par05 = 4 // Devolvidas
		cSql += " AND SF2.D_E_L_E_T_ = ''"
		cSql += " AND NOT D1_DOC IS NULL"
	Endif
	cSql += " ORDER BY F2_FILIAL,F2_DOC,F2_SERIE"

	cSql := ChangeQuery(cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	dbSelectArea("ARQ_SQL")
	TcSetField("ARQ_SQL","F2_EMISSAO","D")

	cNomTmp := CriaTrab(,.F.)
	Copy to &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"F2_FILIAL+F2_DOC+F2_SERIE",,,"Selecionando Registros...")

	If lSIX
		dbSelectArea("SIX")
		aEstru := dbStruct()
		dbCloseArea()
		cNomSIX := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
		IndRegua("SIX",cNomSIX,"INDICE+ORDEM",,,"Selecionando Registros...")

		If RecLock("SIX",.T.)
			SIX->INDICE    := "TMP"
			SIX->ORDEM     := "1"
			SIX->CHAVE     := "F2_FILIAL+F2_DOC+F2_SERIE"
			SIX->DESCRICAO := "Filial + Documento + Serie"
			SIX->DESCSPA   := ""
			SIX->DESCENG   := ""
			SIX->PROPRI    := "U"
			SIX->F3        := ""
			SIX->NICKNAME  := ""
			SIX->SHOWPESQ  := "S"
			MsUnLock()
		Endif
	Endif
Return nil

User Function DVLJC03A()
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	if (mv_par04-mv_par03) >= 15
		if !ApMsgNoYes("Voce selecionou um periodo muito grande, a consulta pode demorar muito para ser executada, deseja continuar assim mesmo ?","Consulta")
			Return nil
		Endif
	Endif

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())

	MsgRun("Consultando banco de dados...",,{ || AbreCom(.F.) })
	dbSelectArea("TMP")
Return nil

User Function DVLJC03V()
	If TMP->DEL = "*"
		msgbox("Não é possivel consultar uma  NF canceleda","Visualizar","STOP")
		Return nil
	Endif

	cFilSystem := cFilAnt

	dbSelectArea("SIX")
	dbCloseArea()
	dbUseArea(.T.,,"SIX"+Substr(cNumEmp,1,2)+"0","SIX",.T.,.F.)
	dbSetIndex("SIX"+Substr(cNumEmp,1,2)+"0")

	cFilAnt := TMP->F2_FILIAL

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(TMP->F2_FILIAL+TMP->F2_DOC+TMP->F2_SERIE)

	Mc090Visual()

	cFilAnt := cFilSystem

	dbSelectArea("SIX")
	dbCloseArea()
	dbUseArea(.T.,,cNomSIX,"SIX",.F.,.F.)
	dbSetIndex(cNomSIX)
Return nil

User Function DVLJC03L()
	BrwLegenda(cCadastro,"Legenda", {{"BR_VERDE"    ,"Normal"   },;
									 {"BR_VERMELHO" ,"Cancelada"},;
									 {"BR_AMARELO"  ,"Devolvida" }} ) 
Return nil

User Function DVLJC03I()
	If TMP->DEL = "*"
		msgbox("Não é possivel consultar uma  NF canceleda","Visualizar","STOP")
		Return nil
	Endif

	Define Font oFontBold Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 215,640 DIALOG oDlg1 TITLE "Informações Adicionais - NF "+F2_DOC+"/"+F2_SERIE+" - Loja "+F2_FILIAL
	@ 005,005 TO 050,315
	@ 010,010 SAY "Tipo de Venda:"  Object oLbl01
	@ 010,155 SAY "Cond. Pagto:"    Object oLbl02
	@ 020,010 SAY "Vendedor:"       Object oLbl03
	@ 030,010 SAY "Convenio:"       Object oLbl04  
	@ 040,010 SAY "Desc. Médio:"    Object oLbl05

	@ 055,005 TO 080,315
	@ 060,010 SAY "Marca / Modelo:" Object oLbl06
	@ 060,155 SAY "Placa:"          Object oLbl07
	@ 070,010 SAY "Origem:"         Object oLbl08

	@ 085,005 TO 105,315
	@ 090,280 BMPBUTTON TYPE  1 ACTION Close(oDlg1)

	@ 010,060 SAY F2_TIPVND + " - " + PAG_DESC
	@ 010,200 SAY F2_COND   + " - " + E4_DESCRI
	@ 020,060 SAY F2_VEND1  + " - " + A3_NOME
	@ 030,060 SAY F2_CODCON + " - " + PA6_DESC
	@ 040,060 SAY AllTrim(Transform(DescMedio(),"@e 99,999,999,999.99"))

	@ 060,060 SAY AllTrim(PA0_DESC) + " - " + AllTrim(PA1_DESC)
	@ 060,200 SAY Substr(F2_PLACA,1,3) + "-" + Substr(F2_PLACA,4,4)
	@ 070,060 SAY F2_ORIGEM
	
	if DEL=" " .and. !Empty(D1_DOC)
		@ 092,010 SAY "Nota Fiscal Devolvida - NF Devol: "+D1_DOC
	Endif

	oLbl01:oFont := oFontBold
	oLbl02:oFont := oFontBold
	oLbl03:oFont := oFontBold
	oLbl04:oFont := oFontBold
	oLbl05:oFont := oFontBold
	oLbl06:oFont := oFontBold
	oLbl07:oFont := oFontBold
	oLbl08:oFont := oFontBold
	ACTIVATE DIALOG oDlg1 CENTERED
Return nil

Static Function DescMedio()
	Local cSqlDesc := ""
	Local nRet     := 0

	cSqlDesc := "SELECT (Sum(D2_DESC) / Sum(D2_TOTAL))*100 AS DMEDIO"
	cSqlDesc += " FROM "+RetSqlName("SF2")+" SF2"

	cSqlDesc += " JOIN "+RetSqlName("SD2")+" SD2"
	cSqlDesc += " ON   SD2.D_E_L_E_T_ = ''"
	cSqlDesc += " AND  D2_FILIAL = F2_FILIAL"
	cSqlDesc += " AND  D2_DOC = F2_DOC"
	cSqlDesc += " AND  D2_SERIE = F2_SERIE"

	cSqlDesc += " WHERE SF2.D_E_L_E_T_ = ''"
	cSqlDesc += " AND   F2_FILIAL = '"+F2_FILIAL+"'"
	cSqlDesc += " AND   F2_DOC = '"+F2_DOC+"'"
	cSqlDesc += " AND   F2_SERIE = '"+F2_SERIE+"'"

	cSqlDesc := ChangeQuery(cSqlDesc)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSqlDesc),"ARQ_DESC", .T., .T.)
	dbSelectArea("ARQ_DESC")
	TcSetField("ARQ_DESC","DMEDIO","N",14,2)

	dbSelectArea("ARQ_DESC")
	nRet := ARQ_DESC->DMEDIO
	dbCloseArea()
	dbSelectArea("TMP")
Return nRet