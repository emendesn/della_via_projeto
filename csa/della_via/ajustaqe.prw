#include "Protheus.Ch"
/*
Programa reestruturado para alterar atravez de UPDATE, e não mais na SBZ, mas sim na SB1
Denis Francisco Tofoli
10/07/06
*/

User Function AjustaQE()
	Local oDlg
	Local cTitulo := "Alteracao de quantidade por embalagem"
	Local _cPerg  := "AJUQE"

	Perg(_cPerg)
	If !Pergunte(_cPerg,.T.)
		Return
	Endif

     DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 155,350 PIXEL
            @ 10,10 SAY "  Este programa ira ajustar a quantidade por embalagem " SIZE 150,10 PIXEL OF oDlg
            @ 20,10 SAY "  na tabela de indicador de produtos conforme os para- " SIZE 150,10 PIXEL OF oDlg
            @ 30,10 SAY "  metros do usuario.                                   " SIZE 150,10 PIXEL OF oDlg

            DEFINE SBUTTON FROM 060,060 TYPE 1 ACTION (Processa({|| FAjusta()}), oDlg:End()) ENABLE OF oDlg
            DEFINE SBUTTON FROM 060,100 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
            DEFINE SBUTTON FROM 060,140 TYPE 5 ACTION Pergunte(_cPerg,.T.) ENABLE OF oDlg
	 ACTIVATE MSDIALOG oDlg CENTER
Return

Static Function FAjusta()
	Local cSql := ""
	Local nUpdt := 0

	cSql := "UPDATE "+RetSqlName("SB1")
	cSql += " SET B1_QE = "+Alltrim(Str(mv_par05))
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql += " AND   B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cSql += " AND   B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	nUpdt := TcSqlExec(cSql)
	If nUpdt < 0
		MsgBox(TcSqlError(),"Quantidade por embalagem","STOP")
	Endif

	/*
	Comentado por Denis

	Local cAliasTmp,aStru,cQuery,cFiltro:="",cIndTmp,nIndex,nX,_nTotRec,cQuery2
	Local cAlias, cCampo, _nTotSaldo

	cAliasTmp := "AJUQE"
	//
	//  --------------------------------------------------------------------------------------------------------------------
	//
	cAlias := "SBZ"
	cCampo := "BZ"
	//
	cQuery  := "SELECT Count(*) AS Soma "
	//
	cQuery2 := "FROM "+RetSqlName(cAlias)+" "+cAlias+", "+RetSqlName("SB1")+" SB1 "
	cQuery2 += "WHERE "
	cQuery2 += cAlias + "." + cCampo + "_FILIAL BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' AND "
	cQuery2 += cAlias + "." + cCampo + "_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery2 += cAlias + "." + cCampo + "_COD = SB1.B1_COD AND SB1.B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery2 += cAlias + ".D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' "
	//cQuery2 += "ORDER BY "+cAlias + "." + cCampo + "_FILIAL, "+cAlias + "." + cCampo + "_COD"
	//
	cQuery += cQuery2
	//
	//Memowrite("SQL.TXT",cQuery)
	//
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
	_nTotRec := (cAliasTmp)->SOMA
	dbCloseArea()
	//
	cAliasTmp := "AJUQE"
	cQuery := "SELECT "+cAlias+".R_E_C_N_O_ NREG "
	cQuery += cQuery2
	//
	cQuery := ChangeQuery(cQuery)
	//
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
	//
	//TcSetField(cAliasTmp,"B2_QATU","N",TamSx3("B2_QATU")[1], TamSx3("B2_QATU")[2] )
	//
	dbSelectArea(cAliasTmp)
	DbGoTop()
	ProcRegua(_nTotRec)
	Do While ( !Eof() ) 
		//
		dbSelectArea("SBZ") 
		DbGoTo((cAliasTmp)->&("NREG"))
		If RecLock("SBZ",.F.)
			SBZ->BZ_QE := mv_par05
			msUnlock()
		Endif
		//
		IncProc("Filial: "+SBZ->BZ_FILIAL+" - Produto: " + SBZ->BZ_COD+" Quant/Emb.: "+Alltrim(Str(mv_par05,8)))
		dbSelectArea(cAliasTmp)
		dbSkip()
		//
	Enddo
	//
	dbSelectArea(cAliasTmp)
	dbCloseArea()
	dbSelectArea(cAlias)
	//
	*/
Return

Static Function Perg(_cPerg)
	Local _cAlias
	Local _lAtualiza:=.f.

	_cAlias := Alias()
	_cPerg  := PADR(_cPerg,6)
	_aRegs  := {}

	dbSelectArea("SX1")
	dbSetOrder(1)

	AADD(_aRegs,{_cPerg,"01","Produto de                   ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	AADD(_aRegs,{_cPerg,"02","Produto Ate                  ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1",""})
	AADD(_aRegs,{_cPerg,"03","Grupo de                     ?","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
	AADD(_aRegs,{_cPerg,"04","Grupo Ate                    ?","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","SBM",""})
	AADD(_aRegs,{_cPerg,"05","Quantidade por embalagem     ?","","","mv_ch5","N",08,0,0,"G","","mv_par05","","","",1,"","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"06","Filial de                    ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","01","","","","","","","","","","","","","","","","","","","","","SM0",""})
	AADD(_aRegs,{_cPerg,"07","Filial Ate                   ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","99","","","","","","","","","","","","","","","","","","","","","SM0",""})

	For i := 1 to Len(_aRegs)
		If !DbSeek(_cPerg+_aRegs[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	DbSelectArea(_cAlias)
Return