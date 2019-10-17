#INCLUDE "Protheus.Ch"
#INCLUDE "Rwmake.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Della01  ³ Autor ³ Rodrigo Rodrigues     ³ Data ³ 17.09.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pick-List (Expedicao) - DellaVia                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DONIZETI     ³25/11/05³      ³Inclusão de Descriçao Loja no Titulo    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Della01
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel		:= "Della01"
LOCAL tamanho	:= "P"
LOCAL titulo    := "Pick-List (Expedicao) - " +SM0->M0_NOME
LOCAL cDesc1	:= "Emissao de produtos a serem separados pela expedicao, para"
LOCAL cDesc2	:= "determinada faixa de notas fiscais com a lista de NF´s"
LOCAL cDesc3	:= ""
LOCAL cString	:= "SD2"
LOCAL cPerg  	:= "MTR775" // criar perguntas especificas para este relatorio

PRIVATE aReturn		:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }	
PRIVATE nomeprog	:= "Della01"
PRIVATE nLastKey 	:= 0
PRIVATE nBegin		:= 0
PRIVATE aLinha		:= {}
PRIVATE li			:= 80
PRIVATE limite		:= 132
PRIVATE lRodape		:= .F.
PRIVATE m_pag       :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01	     	  Da Nota
//³ mv_par02	     	  Ate a Nota                             ³
//³ mv_par03	     	  Serie	                                ³
//³ mv_par04	     	  Mascara                                ³
//³ mv_par05	     	  Aglutina itens grade                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,.T.)


If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| Della01Imp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,;
			@cDesc2,@cDesc3)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Della01Imp³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Della01			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Della01Imp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,;
						cDesc3)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL cabec1 	 := "Codigo Nf     Desc. do Material                             UM       Qtde  Amz"
LOCAL cabec2	 := ""
LOCAL lContinua  := .T.
LOCAL lFirst 	 := .T.
LOCAL cPedAnt	 := ""
LOCAL nI		 := 0
LOCAL aTam    	 := {}
LOCAL cMascara 	 := GetMv("MV_MASCGRD")
LOCAL nTamRef  	 := Val(Substr(cMascara,1,2))
LOCAL cbtxt      := SPACE(10)
LOCAL cbcont	 := 0
LOCAL nTotQuant	 := 0
LOCAL aStruSD2   := {}
LOCAL nSD2       := 0
LOCAL cFilter    := ""
LOCAL cAliasSD2  := "SD2"
LOCAL cIndexSD2  := "" 
LOCAL cKey 	     := ""
LOCAL lQuery     := .F.
LOCAL lRet       := .F.
LOCAL cProdRef	 := ""
LOCAL lSkip		 := .F.    
LOCAL cCodProd 	 := ""
LOCAL nQtdIt   	 := 0
LOCAL cNf        := ""
LOCAL cDescProd	 := ""
LOCAL cGrade   	 := ""
LOCAL cUnidade 	 := ""
LOCAL cLocaliza	 := ""
LOCAL cLote	 	 := ""
LOCAL cLocal 	 := ""                
LOCAL cSubLote   := ""
LOCAL dDtValid   := dDatabase
LOCAL nPotencia  := 0
Local lPyme      := Iif(Type("__lPyme") <> "U",__lPyme,.F.)
Local nX         := 0
Local cName      := ""
Local cQryAd     := ""

If lPyme
	cabec1 	 := "Codigo Nf       Desc. do Material              UM Quantidade  Amz"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Pick-List (Expedicao) - " +SM0->M0_NOME

// "Codigo Nf     Desc. do Material                             UM       Qtde  Amz"
//            1         2         3         4         5         6         7         8         9        10        11        12        13      
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
// 																   999,999.99

#IFDEF TOP
	If TcSrvType() <> "AS/400"
	    cAliasSD2:= "Della01Imp"
	    aStruSD2  := SD2->(dbStruct())		
		lQuery    := .T.
		cQuery := "SELECT SD2.R_E_C_N_O_ SD2REC,"
		cQuery += "SD2.D2_DOC,SD2.D2_FILIAL,SD2.D2_SERIE,SD2.D2_QUANT,SD2.D2_COD, "
		cQuery += "SD2.D2_LOCAL,SD2.D2_GRADE,SD2.D2_LOTECTL,SD2.D2_POTENCI,"
		cQuery += "SD2.D2_NUMLOTE,SD2.D2_DTVALID"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esta rotina foi escrita para adicionar no select os campos do SD2 usados no filtro do usuario ³
		//³quando houver, a rotina acrecenta somente os campos que forem adicionados ao filtro testando  ³
	    //³se os mesmo ja existem no selec ou se forem definidos novamente pelo o usuario no filtro.     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aReturn[7])
			For nX := 1 To SD2->(FCount())
		 		cName := SD2->(FieldName(nX))
				If AllTrim( cName ) $ aReturn[7]
					If aStruSD2[nX,2] <> "M"
						If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += ",SD2."+ cName
						EndIf
					EndIf
				EndIf
			Next nX
		EndIf
		cQuery += cQryAd
		
		cQuery += " FROM "
		cQuery += RetSqlName("SD2") + " SD2 "
		cQuery += "WHERE "                   
		cQuery += "(SD2.D2_SERIE = '"+mv_par03+"' OR SD2.D2_QUANT > 0) AND "
		cQuery += "SD2.D2_DOC >= '"+mv_par01+"' AND " 
		cQuery += "SD2.D2_DOC <= '"+mv_par02+"' AND " 
		cQuery += "NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
		cQuery += "SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
		cQuery += "SD2.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_LOTECTL,"
		cQuery += "SD2.D2_NUMLOTE,SD2.D2_DTVALID"
				
		cQuery := ChangeQuery(cQuery)
    	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

		For nSD2 := 1 To Len(aStruSD2)
			If aStruSD2[nSD2][2] <> "C" .and.  FieldPos(aStruSD2[nSD2][1]) > 0
				TcSetField(cAliasSD2,aStruSD2[nSD2][1],aStruSD2[nSD2][2],aStruSD2[nSD2][3],aStruSD2[nSD2][4])
			EndIf
		Next nSD2
	Else
#ENDIF	         
		dbSelectArea(cString)
		cIndexSD2  := CriaTrab(nil,.f.)
		cKey :="D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_LOTECTL+D2_NUMLOTE+DTOS(D2_DTVALID)"		
		cFilter := "D2_FILIAL = '" + xFilial("SD2") + "' .And. "
		cFilter += "(D2_SERIE = '"+mv_par03+"' .or. D2_QUANT > 0) .And. "
		cFilter += "D2_DOC >= '"+mv_par01+"' .And. " 
		cFilter += "D2_DOC <= '"+mv_par02+"'" 
		cFilter += '.And. !('+IsRemito(2,'SD2->D2_TIPODOC')+')'		

		IndRegua(cAliasSD2,cIndexSD2,cKey,,cFilter,"Selecionando Registros...")
		#IFNDEF TOP
			DbSetIndex(cIndexSD2+OrdBagExt())
		#ENDIF                           
		SetRegua(RecCount())		// Total de Elementos da regua
		DbGoTop()
		
#IFDEF TOP
	Endif
#ENDIF	

While (cAliasSD2)->(!Eof())
	//	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	³ Valida o produto conforme a mascara         ³
	//	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasSD2)->D2_COD,MV_PAR04)
	If lRet .and. !Empty(aReturn[7])    
		lRet := &(aReturn[7])
	Endif
	If lRet
		IF lEnd
			@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif 
		If !lQuery
			IncRegua()
		EndIf	
		IF li > 55 .or. lFirst
			lFirst  := .f.
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			lRodape := .T.
		Endif
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1") + (cAliasSD2)->D2_COD)
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2") + (cAliasSD2)->D2_COD + (cAliasSD2)->D2_LOCAL )
		cCodProd := Subs((cAliasSD2)->D2_COD,1,6)
		cNf      := (cAliasSD2)->D2_DOC 
		nQtdIt   := (cAliasSD2)->D2_QUANT
		cDescProd:= Subs(SB1->B1_DESC,1,45)
		cGrade   := (cAliasSD2)->D2_GRADE
		cUnidade := SB1->B1_UM		             
		cLocaliza:= SB2->B2_LOCALIZ                      
		cLote	 := (cAliasSD2)->D2_LOTECTL
		cLocal 	 := (cAliasSD2)->D2_LOCAL                
		cSubLote := (cAliasSD2)->D2_NUMLOTE              
		dDtValid := (cAliasSD2)->D2_DTVALID
		nPotencia:= (cAliasSD2)->D2_POTENCI
		IF !lPyme .And. cGrade == "S" .and. MV_PAR05 == 1
			cProdRef 	:=Substr(cCodProd,1,nTamRef)
			nTotQuant	:=0
			While (cAliasSD2)->(!Eof()) .And. cProdRef == Substr((cAliasSD2)->D2_COD,1,nTamRef) .And. (cAliasSD2)->D2_GRADE == "S" .And.;
				(cLote == (cAliasSD2)->D2_LOTECTL .And. cSubLote == (cAliasSD2)->D2_NUMLOTE)
				nTotQuant += (cAliasSD2)->D2_QUANT
				(cAliasSD2)->(dbSkip())
				lSkip := .T.
			End
		Endif
// "Codigo Nf     Desc. do Material                             UM       Qtde  Amz"
//            1         2         3         4         5         6         7         8         9        10        11        12        13      
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
// 																   999,999.99
		@ li, 00 Psay IIF(!lPyme .And. cGrade=="S" .And. MV_PAR05 == 1,Substr(cCodProd,1,ntamref),cCodProd)  Picture "@!"
		@ li, 07 Psay cNf Picture "@!"
		@ li, 14 Psay cDescProd	Picture "@!"
		@ li, 60 Psay cUnidade Picture "@!"
		@ li, 63 Psay IIF(!lPyme .And. cGrade=="S" .And. MV_PAR05 == 1,nTotQuant,nQtdIt) Picture "@E 999,999.99"
		@ li, 76 Psay cLocal
//		If !lPyme
//			@ li, 66 Psay cLocaliza
//			@ li, 81 Psay cLote	Picture "@!"
//			@ li, 91 Psay cSubLote	Picture "@!"
//			@ li,101 Psay dDtValid	Picture PesqPict("SD2","D2_DTVALID")
//			@ li,116 PSay nPotencia Picture PesqPict("SD2","D2_POTENCI")
//		EndIf	
		li++
	EndIf

	If !lQuery .Or. !lSkip	
		dbSelectArea(cAliasSD2)
		dbSkip()
	EndIf	
	
End

IF lRodape
	roda(cbcont,cbtxt,"M")
Endif

If lQuery   
    dbSelectArea(cAliasSD2)
	dbCloseArea()  
	dbSelectArea("SD2")
Else
	RetIndex("SD2")   
	Ferase(cIndexSD2+OrdBagExt())
	dbSelectArea("SD2")
	dbClearFilter()
	dbSetOrder(1)
	dbGotop()
Endif	

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
