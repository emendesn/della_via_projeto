#include "RwMake.ch"
#include "TopConn.ch"

User Function DVLOJF02
	Private Titulo      := "Preço de venda - Tabela -> Cadastro"
	Private aSays       := {}
	Private aButtons    := {}
	Private cPerg       := "DLOJ02"
	Private aRegs       := {}
	Private lAbortPrint := .F.

	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	aAdd(aRegs,{cPerg,"01","Do Produto         ?"," "," ","mv_ch1","C", 15,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"02","Ate o Produto      ?"," "," ","mv_ch2","C", 15,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SB1","","","",""          })
	aAdd(aRegs,{cPerg,"03","Do Grupo           ?"," "," ","mv_ch3","C", 04,0,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"04","Ate o Grupo        ?"," "," ","mv_ch4","C", 04,0,0,"G","","mv_par04",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","SBM","","","",""          })
	aAdd(aRegs,{cPerg,"05","Tabela             ?"," "," ","mv_ch5","C", 03,0,0,"G","","mv_par05",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })

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
	Pergunte(cPerg,.F.)

	aAdd(aSays,"Esta rotina procura os produtos na tabela de preço de venda de acordo com os")
	aAdd(aSays,"parametros definidos pelo usuário, e atualiza o preço no cadastro de produtos.")
	aAdd(aSays,"")
	aAdd(aSays,"Tabelas:")
	aAdd(aSays,Space(10)+"SB1 - Descrição genérica de produto")
	aAdd(aSays,Space(10)+"DA1 - Itens da tabela de preço")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| ProcAtu() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                           }})
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                    }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function ProcAtu
	Local cSql := ""

	If !msgbox("Confirma processamento ?","Tabela de preço","YESNO")
		Return nil
	Endif

	FechaBatch()

	cSql := cSql + "SELECT DA1_CODPRO,DA1_PRCVEN"
	cSql := cSql + " FROM "+RetSqlName("DA1")+" DA1"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND  B1_COD = DA1_CODPRO"
	cSql := cSql + " AND  B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	cSql := cSql + " WHERE DA1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   DA1_FILIAL = '"+xFilial("DA1")+"'"
	cSql := cSql + " AND   DA1_CODTAB = '"+mv_par05+"'"
	cSql := cSql + " AND   DA1_CODPRO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql := cSql + " ORDER BY DA1_CODPRO"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","DA1_PRCVEN","N",14,2)
	
	ProcRegua(ContaSql("ARQ_SQL"))
	dbGoTop()
	Do While !eof() .and. !lAbortPrint
		incProc("Processando ("+AllTrim(DA1_CODPRO)+") ...")
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		dbSeek(xFilial("SB1")+ARQ_SQL->DA1_CODPRO)
		if Found()
			If RecLock("SB1",.F.)
				SB1->B1_PRV1 := ARQ_SQL->DA1_PRCVEN
				MsUnlock()
			Endif
		Endif

		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo
	dbCloseArea()
	If !lAbortPrint
		MsgBox("Produtos atualizados com sucesso","Tabela de preço","INFO")
	Else
		MsgBox("Programa abortado pelo usuário","Tabela de preço","ALERT")
	Endif
Return nil

Static Function ContaSql(cAlias)
	Local nRegs := 0
	Local aArea := GetArea()
	dbSelectArea(cAlias)
	dbGoTop()
	Do While !eof()
		nRegs++
		dbSkip()
	Enddo
	dbGoTop()
	RestArea(aArea)
Return nRegs