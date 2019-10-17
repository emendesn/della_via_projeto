#include "Dellavia.ch"

User Function DGOLA15()
	Private Titulo      	:= "Atualiza Tabela DA1"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private cPerg           := "DGOL15"   
	Private aRegs           := {}  

	aAdd(aRegs,{cPerg,"01","Tabela de Venda  DA1?"," "," ","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Nome Arquivo Texto  ?"," "," ","mv_ch2","C",11,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
 
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
	
	aAdd(aSays,"Esta rotina faz a leitura de um arquivo TXT e faz a atualiza��o da Tabela de Compra")
	aAdd(aSays,"na tabela DA1.")
	
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Import
	Local aEstru := {}
	Local nConta := 0
	Local cArq   := ""

	FechaBatch()
    
	aAdd(aEstru,{"T_TABELA","C",03,0})
	aAdd(aEstru,{"T_CODIGO","C",06,0})
	aAdd(aEstru,{"T_VALOR" ,"N",10,2})
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"ARQ_TXT",.F.,.F.)

  	cArq := "\AIB\" + AllTrim(mv_par02)
	Append From &cArq sdf
  	
	ProcRegua(LastRec())
	dbGotop()

	Do While !eof()
		incProc()
		
		if ARQ_TXT->T_Tabela != mv_par01 .or. ARQ_TXT->T_CODIGO < "000000" .or. ARQ_TXT->T_CODIGO > "999999" .or. ARQ_TXT->T_VALOR > 9999999.99
			MsgBox("Registro Invalido ...","DA1","STOP")
			dbSkip()
			loop
		endif
	
		dbSelectArea("DA1")
		dbSetOrder(1)
		dbSeek(xFilial("DA1")+mv_par01+ARQ_TXT->T_CODIGO+space(9))
		if !eof()
			cSql := "UPDATE "+RetSqlName("DA1")
			cSql += " SET   DA1_PRCVEN  = "  + AllTrim(Str(ARQ_TXT->T_VALOR))
			cSql += " WHERE D_E_L_E_T_ = ''"
			cSql += " AND   DA1_FILIAL = '"  + xFilial("DA1")    + "'"
			cSql += " AND   DA1_CODTAB = '"  + mv_par01          + "'"
			cSql += " AND   DA1_CODPRO = '"  + ARQ_TXT->T_CODIGO + space(9) + "'"
			nUpdt := 0
			nUpdt := TcSqlExec(cSql)
			If nUpdt < 0
				MsgBox(TcSqlError(),"DA1","STOP")
			Else
				nConta++
			Endif  
		else 
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+ARQ_TXT->T_CODIGO+space(9))
			if eof()
				MsgBox("Produto N�o Cadastrado: "+ARQ_TXT->T_CODIGO,"DA1","STOP")
			else
				vItem = ProxItem()
				dbSelectArea("DA1")
				if RecLock("DA1",.T.)
					DA1->DA1_CODTAB := mv_par01
					DA1->DA1_ITEM   := vItem
					DA1->DA1_CODPRO := ARQ_TXT->T_CODIGO+space(9)
					DA1->DA1_PRCVEN := ARQ_TXT->T_VALOR
					DA1->DA1_VLRDES := 0.00
					DA1->DA1_PERDES := 0.0000
					DA1->DA1_ATIVO  := "1"
					DA1->DA1_FRETE  := 0.00
					DA1->DA1_TPOPER := "4"
					DA1->DA1_QTDLOT := 999999.99  
					DA1->DA1_INDLOT := "000000000999999.99"
					DA1->DA1_MOEDA  := 1
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

	msgbox(AllTrim(Str(nConta))+" registro(s) atualizado(s)","DA1","INFO")
Return nil     

Static Function ProxItem()
	Local aArea := GetArea()
	Local cProx := ""
	Local cSql  := ""

	cSql := "SELECT MAX(DA1_ITEM) AS ULT"
	csql += " FROM "+RetSqlName("DA1")
	csql += " WHERE D_E_L_E_T_ = ''"
	csql += " AND  DA1_FILIAL = '" + xFilial("DA1") + "'"
	csql += " AND  DA1_CODTAB = '" + mv_par01       + "'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_MAX", .T., .T.)
	cProx := StrZero(Val(ULT)+1,4)
	dbCloseArea("ARQ_MAX")
	RestArea(aArea)
Return cProx