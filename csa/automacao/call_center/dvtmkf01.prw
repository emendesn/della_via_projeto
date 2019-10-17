#include "DellaVia.ch"

User Function DVTMKF01(cOper,cOrc,cSol)
	Local aArea   := GetArea()
	Local aUser   := {}
	Local cEmail  := ""
	Local cSql    := ""
	Local aTipo   := {}
	Local cMaxSeq := ""

	aadd(aTipo,{"F","Cons.Final"    })
	aadd(aTipo,{"L","Produtor Rural"})
	aadd(aTipo,{"R","Revendedor"    })
	aadd(aTipo,{"S","Solidario"     })
	aadd(aTipo,{"X","Exportacao"    })

	cSql := "SELECT U7_CODUSU FROM "+RetSqlName("SU7")
	cSql += " WHERE U7_COD = '"+cOper+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_USU", .T., .T.)
	dbSelectArea("SQL_USU")
	cUsrId := AllTrim(U7_CODUSU)
	dbCloseArea()


	cSql := "SELECT (ZX2_ITEM || MAX(ZX2_SEQ)) AS SEQ"
	cSql += " FROM "+RetSqlName("ZX2")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   ZX2_FILIAL = '"+xFilial("SUA")+"'"
	cSql += " AND   ZX2_ORC = '"+cOrc+"'"
	cSql += " AND   ZX2_NUM = '"+cSol+"'"
	cSql += " GROUP BY ZX2_ITEM"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MAX", .T., .T.)
	dbSelectArea("SQL_MAX")
	Do While !eof()
		cMaxSeq += "'"+SEQ+"',"
		dbSkip()
	Enddo
	dbCloseArea()
	cMaxSeq := Substr(cMaxSeq,1,Len(cMaxSeq)-1)


	// Busca e-mail pelo ID do usuário
	PswOrder(1)
	if PswSeek(cUsrId,.T.)
		aUser  := PswRet()
		cEmail := Lower(AllTrim(aUser[1,14]))
	Endif

	cSql := "SELECT UA_FILIAL,UA_NUM,UA_CLIENTE,UA_LOJA
	cSql += " ,     UA_CONDPG,E4_DESCRI,UA_VEND,A3_NOME,ZX2_OBSGER"
	cSql += " ,     UB_ITEM,UB_PRODUTO,B1_DESC,UB_QUANT,ZX2_PRCTAB,ZX2_VRUNIT,ZX2_VDESC,ZX2_PDESC,ZX2_TOTAL,ZX2_OBS,ZX2_OBSLIB"
	cSql += " ,     UB_PRCTAB,UB_VRUNIT,UB_VALDESC,UB_DESC,UB_VLRITEM"

	cSql += " FROM   "+RetSqlName("SUA")+" SUA"

	cSql += " JOIN "+RetSqlName("SUB")+" SUB"
	cSql += " ON   SUB.D_E_L_E_T_ = ''"
	cSql += " AND  UB_FILIAL = UA_FILIAL"
	cSql += " AND  UB_NUM = UA_NUM"

	cSql += " LEFT JOIN "+RetSqlName("ZX2")+" ZX2"
	cSql += " ON   ZX2.D_E_L_E_T_ = ''"
	cSql += " AND  ZX2_FILIAL = UB_FILIAL"
	cSql += " AND  ZX2_ORC = UB_NUM"
	cSql += " AND  ZX2_NUM = '"+cSol+"'"
	cSql += " AND  ZX2_ITEM = UB_ITEM"
	cSql += " AND  ZX2_ITEM || ZX2_SEQ IN("+cMaxSeq+")"

	cSql += " LEFT JOIN "+RetSqlName("SE4")+" SE4"
	cSql += " ON   SE4.D_E_L_E_T_ = ''"
	cSql += " AND  E4_FILIAL = '"+xFilial("SE4")+"'"
	cSql += " AND  E4_CODIGO = UA_CONDPG"

	cSql += " LEFT JOIN "+RetSqlName("SA3")+" SA3"
	cSql += " ON   SA3.D_E_L_E_T_ = ''"
	cSql += " AND  A3_FILIAL = '"+xFilial("SA3")+"'"
	cSql += " AND  A3_COD = UA_VEND"

	cSql += " LEFT JOIN "+RetSqlName("SB1")+" SB1"
	cSql += " ON   SB1.D_E_L_E_T_ = ''"
	cSql += " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND  B1_COD = UB_PRODUTO"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '"+xFilial("SUA")+"'"
	cSql += " AND   UA_NUM = '"+cOrc+"'"
	cSql += " ORDER BY UB_NUM,UB_ITEM"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_MAIL", .T., .T.)
	TcSetField("SQL_MAIL","UB_QUANT"  ,"N",11,0)
	TcSetField("SQL_MAIL","ZX2_PRCTAB","N",14,2)
	TcSetField("SQL_MAIL","ZX2_VRUNIT","N",14,2)
	TcSetField("SQL_MAIL","ZX2_VDESC" ,"N",14,2)
	TcSetField("SQL_MAIL","ZX2_PDESC" ,"N",06,2)
	TcSetField("SQL_MAIL","ZX2_TOTAL" ,"N",14,2)
	dbSelectArea("SQL_MAIL")

	If !Eof()
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SQL_MAIL->(UA_CLIENTE+UA_LOJA))
		dbSelectArea("SQL_MAIL")

		cTipo := aTipo[aScan(aTipo,{|x| alltrim(x[1]) == SA1->A1_TIPO}),2]

		oProcess:= TWFProcess():New("Descontos","Aprovação de descontos") //Inicia Processo
		oProcess:NewTask("Descontos","\workflow\html\descontos\wf.htm")   //Carrega HTML modelo
		oProcess:cSubject := "Aprovação de descontos - "+cOrc             //Assunto do e-mail
		oProcess:cTo := cEmail                                            //Destinatarios
		oHtml := oProcess:oHTML                                           //Define Objeto
	
		cObs := MSMM(SQL_MAIL->ZX2_OBSGER,80)

		dbSelectArea("SQL_MAIL")

		// Preenche as variaveis do e-mail
		oHtml:ValByName("UA_FILIAL" ,UA_FILIAL  )
		oHtml:ValByName("UA_NUM"    ,UA_NUM     )
		oHtml:ValByName("UA_CLIENTE",UA_CLIENTE )
		oHtml:ValByName("UA_LOJA"   ,UA_LOJA    )
		oHtml:ValByName("A1_NOME"   ,SA1->A1_NOME    )
		oHtml:ValByName("TIPOCLI"   ,cTipo                )
		oHtml:ValByName("CONDPG"    ,UA_CONDPG+" - "+E4_DESCRI)
		oHtml:ValByName("UA_VEND"   ,UA_VEND    )
		oHtml:ValByName("NOMVEND"   ,A3_NOME    )
		oHtml:ValByName("ZX2_OBSGER",cObs )
        
		dbSelectArea("SQL_MAIL")
		nTotDesc := 0
		nTotTab  := 0
		nTotGer  := 0
		Do While !eof()
			aadd((oHtml:valByName("T.ZX2_COD"))    ,UB_PRODUTO                                  )
			aadd((oHtml:valByName("T.B1_DESC"))    ,B1_DESC                                     )
			aadd((oHtml:valByName("T.ZX2_QUANT"))  ,Transform(UB_QUANT  ,"@E 99,999,999,999")   )
			aadd((oHtml:valByName("T.ZX2_PRCTAB")) ,Transform(iif(ZX2_PDESC > 0,ZX2_PRCTAB,UB_PRCTAB ),"@E 99,999,999,999.99"))
			aadd((oHtml:valByName("T.ZX2_VRUNIT")) ,Transform(iif(ZX2_PDESC > 0,ZX2_VRUNIT,UB_VRUNIT ),"@E 99,999,999,999.99"))
			aadd((oHtml:valByName("T.ZX2_VDESC"))  ,Transform(iif(ZX2_PDESC > 0,ZX2_VDESC ,UB_VALDESC),"@E 99,999,999,999.99"))
			aadd((oHtml:valByName("T.ZX2_PDESC"))  ,Transform(iif(ZX2_PDESC > 0,ZX2_PDESC ,UB_DESC   ),"@E 999.99")           )
			aadd((oHtml:valByName("T.ZX2_TOTAL"))  ,Transform(iif(ZX2_PDESC > 0,ZX2_TOTAL ,UB_VLRITEM),"@E 99,999,999,999.99"))
			aadd((oHtml:valByName("T.ZX2_OBS"))    ,iif(ZX2_PDESC > 0,iif(empty(ZX2_OBSLIB),ZX2_OBS,ZX2_OBSLIB),"&nbsp;")     )
			nTotDesc += UB_QUANT*iif(ZX2_PDESC > 0,ZX2_VRUNIT ,UB_VRUNIT)
			nTotTab  += UB_PRCTAB*UB_QUANT
			nTotGer  += iif(ZX2_PDESC > 0,ZX2_TOTAL ,UB_VLRITEM)
			dbSkip()
		Enddo

		oHtml:ValByName("TOT_ORC"   ,Transform(nTotGer,"@E 99,999,999,999.99"))
		oHtml:ValByName("DESC_MEDIO",Transform(100-((nTotDesc/nTotTab)*100),"@E 999.99"))

		//Envia e-mail
		oProcess:Start()
	Endif
	dbSelectArea("SQL_MAIL")
	dbCloseArea()
	RestArea(aArea)
Return nil