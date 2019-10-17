#include "Dellavia.ch"

User Function DGOLA14()
	Private Titulo      	:= "Atualiza Tabela AIB"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private cPerg           := "DGOL14"   
	Private aRegs           := {}  

	aAdd(aRegs,{cPerg,"01","Codigo do Fornecedor?"," "," ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""          })
	aAdd(aRegs,{cPerg,"02","Loja do Fornecedor  ?"," "," ","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"03","Tabela de Compra AIB?"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"04","Nome Arquivo Texto  ?"," "," ","mv_ch4","C",11,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
	
	aAdd(aSays,"Esta rotina faz a leitura de um arquivo TXT e faz a atualização da Tabela de Compra")
	aAdd(aSays,"na tabela AIB.")
	
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Import
	Local aEstru := {}
	Local nConta := 0
   Loca  cArq   := ""
	mv_par03 = upper(alltrim(mv_par03))
	mv_par04 = upper(alltrim(mv_par04)) 

	FechaBatch()

	aAdd(aEstru,{"T_TABELA","C",03,0})
 	aAdd(aEstru,{"T_CODIGO","C",06,0})
	aAdd(aEstru,{"T_VALOR" ,"N",10,2})
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"ARQ_TXT",.F.,.F.)

  	cArq := "\AIB\"+mv_par04
	Append From &cArq SDF
  	
	ProcRegua(LastRec())
	dbGotop()

	Do While !eof()
		incProc()
		
		if ARQ_TXT->T_Tabela != mv_par03 .or. ARQ_TXT->T_CODIGO < "000000" .or. ARQ_TXT->T_CODIGO > "999999" .or. ARQ_TXT->T_VALOR > 9999999.99
			MsgBox("Registro Invalido ...","AIB","STOP")
			dbSkip()
			loop
		endif
		 
		dbSelectArea("AIB")
		dbSetOrder(2)
		dbSeek(xFilial("AIB")+mv_par01+mv_par02+mv_par03+ARQ_TXT->T_CODIGO)
		if !eof()
			cSql := "UPDATE "+RetSqlName("AIB")
			cSql += " SET  AIB_PRCCOM  = "  + AllTrim(Str(ARQ_TXT->T_VALOR))
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   AIB_FILIAL = '"+xFilial("AIB")+"'"
			cSql += " AND   AIB_CODFOR = '" + mv_par01 + "'"
			cSql += " AND   AIB_LOJFOR = '" + mv_par02 + "'"
			cSql += " AND   AIB_CODTAB = '" + mv_par03 + "'"
			cSql += " AND   AIB_CODPRO = '" + ARQ_TXT->T_CODIGO + space(9) + "'"
			nUpdt := 0
			nUpdt := TcSqlExec(cSql)
			If nUpdt < 0
				MsgBox(TcSqlError(),"AIB","STOP")
			Else
				nConta++
			Endif  
		else 
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+ARQ_TXT->T_CODIGO+space(9))
			if eof()
				MsgBox("Produto Não Cadastrado:"+ARQ_TXT->T_CODIGO,"AIB","STOP")
			else
				vItem = ProxItem()
				dbSelectArea("AIB")
				if RecLock("AIB",.T.)
					AIB->AIB_CODFOR := mv_par01
					AIB->AIB_LOJFOR := mv_par02
					AIB->AIB_CODTAB := mv_par03
					AIB->AIB_ITEM   := vItem
					AIB->AIB_CODPRO := ARQ_TXT->T_CODIGO+space(9)
					AIB->AIB_PRCCOM := ARQ_TXT->T_VALOR
					AIB->AIB_QTDLOT := 999999.99  
					AIB->AIB_INDLOT := "000000000999999.99"
					MsUnlock()
					nConta++
				endif
			endif
		endif  
		dbSelectArea("ARQ_TXT")
		dbSkip()
	Enddo
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	msgbox(AllTrim(Str(nConta))+" registro(s) atualizado(s)","AIB","INFO")
Return nil     

Static Function ProxItem()
	Local aArea := GetArea()
	Local cProx := ""
	Local cSql  := ""

	cSql := "SELECT MAX(AIB_ITEM) AS ULT"
	csql += " FROM "+RetSqlName("AIB")
	csql += " WHERE D_E_L_E_T_ = ''"
	csql += " AND  AIB_FILIAL = '"+xFilial("AIB")+"'"
	csql += " AND  AIB_CODFOR = '"+mv_par01+"'"
	csql += " AND  AIB_LOJFOR = '"+mv_par02+"'"
	csql += " AND  AIB_CODTAB = '"+mv_par03+"'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_MAX", .T., .T.)
	cProx := StrZero(Val(ULT)+1,4)
	dbCloseArea("ARQ_MAX")
	RestArea(aArea)
Return cProx