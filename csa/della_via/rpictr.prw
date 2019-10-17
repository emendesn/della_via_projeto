#INCLUDE "Protheus.Ch"
#INCLUDE "Rwmake.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RPICTR  ³ Autor ³ Rodrigo Rodrigues     ³ Data ³ 05.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pick-List Distribuicao(Expedicao) - DellaVia               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RPICTR()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel		:= "RPICTR"
LOCAL tamanho	:= "P"
LOCAL titulo	:= "Pick-List Distribuicao (Expedicao) - DellaVia"
LOCAL cDesc1	:= "Emissao de produtos a serem separados pela expedicao no"
LOCAL cDesc2	:= "processo de distribucao de mercadorias em uma"
LOCAL cDesc3	:= "determinada faixa de distribuicao"
LOCAL cString	:= "SLN"                                                                           
//LOCAL cPerg  	:= "MTR775" 
LOCAL cPerg  	:= "RPICTR" // criar perguntas especificas para este relatorio

PRIVATE aReturn		:= {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }	
PRIVATE nomeprog	:= "RPICTR"
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
Perg(cPerg)
pergunte(cPerg,.F.)

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

RptStatus({|lEnd| RPICTRImp(@lEnd,wnRel,cString,cPerg,tamanho,@titulo,@cDesc1,;
			@cDesc2,@cDesc3)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RPICTRImp  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RPICTR			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RPICTRImp(lEnd,WnRel,cString,cPerg,tamanho,titulo,cDesc1,cDesc2,;
						cDesc3)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL cabec1 	 := "Codigo Transf.Desc. do Material                             UM       Qtde  Amz"
LOCAL cabec2	 := ""
LOCAL lContinua  := .T.
LOCAL lFirst 	 := .T.
LOCAL cPedAnt	 := ""
LOCAL nI		 := 0
LOCAL aTam    	 := {}
//LOCAL cMascara 	 := GetMv("MV_MASCGRD")
//LOCAL nTamRef  	 := Val(Substr(cMascara,1,2))
LOCAL cbtxt      := SPACE(10)
LOCAL cbcont	 := 0
LOCAL nTotQuant	 := 0
LOCAL aStruSLN   := {}
LOCAL nSLN       := 0
LOCAL cFilter    := ""
LOCAL cAliasSLN  := "SLN"
LOCAL cIndexSLN  := "" 
LOCAL cKey 	     := ""
LOCAL lQuery     := .F.
LOCAL lRet       := .F.
LOCAL cProdRef	 := ""
LOCAL lSkip		 := .F.    
LOCAL cCodProd 	 := ""
LOCAL nQtdIt   	 := 0
LOCAL cPedido        := ""
LOCAL cDescProd	 := ""
LOCAL cGrade   	 := ""
LOCAL cUnidade 	 := ""
LOCAL cLocaliza	 := ""
LOCAL cLote	 	 := ""
LOCAL cLocal 	 := ""                
LOCAL cSubLote   := ""
//LOCAL dDtValid   := dDatabase
LOCAL nPotencia  := 0
//Local lPyme      := Iif(Type("__lPyme") <> "U",__lPyme,.F.)
Local nX         := 0
Local cName      := ""
Local cQryAd     := ""
/*
If lPyme
	cabec1 	 := "Codigo Transf.Desc. do Material                             UM       Qtde  Amz"
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "PICK-LIST Transferencia - DellaVia"


// "Codigo Nf     Desc. do Material                             UM       Qtde  Amz"
//            1         2         3         4         5         6         7         8         9        10        11        12        13      
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
// 																   999,999.99

	    cAliasSLN:= "RPICTRImp"
	    aStruSLN  := SLN->(dbStruct())		
		lQuery    := .T.
		cQuery := "SELECT SLN.R_E_C_N_O_ SLNREC,"
		cQuery += "SLN.LN_PEDIDO,SLN.LN_FILIAL,SLN.LN_QUANT,SLN.LN_COD, "
		cQuery += "SLN.LN_LOCAL,SLN.LN_LOTECTL,"
		cQuery += "SLN.LN_NLOTE "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esta rotina foi escrita para adicionar no select os campos do SLN usados no filtro do usuario ³
		//³quando houver, a rotina acrecenta somente os campos que forem adicionados ao filtro testando  ³
	    //³se os mesmo ja existem no selec ou se forem definidos novamente pelo o usuario no filtro.     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aReturn[7])
			For nX := 1 To SLN->(FCount())
		 		cName := SLN->(FieldName(nX))
				If AllTrim( cName ) $ aReturn[7]
					If aStruSLN[nX,2] <> "M"
						If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += ",SLN."+ cName
						EndIf
					EndIf
				EndIf
			Next nX
		EndIf
		cQuery += cQryAd
		
		cQuery += " FROM "
		cQuery += RetSqlName("SLN") + " SLN "
		cQuery += "WHERE "                   
		cQuery += "SLN.LN_QUANT > 0 AND "
		cQuery += "SLN.LN_PEDIDO >= '"+mv_par01+"' AND " 
		cQuery += "SLN.LN_PEDIDO <= '"+mv_par02+"' AND " 
		cQuery += "SLN.LN_EMISSAO >= '"+mv_par03+"' AND "
        cQuery += "SLN.LN_EMISSAO <= '"+mv_par04+"' AND "		
		cQuery += "SLN.LN_FILIAL = '"+xFilial("SLN")+"' AND "
		cQuery += "SLN.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SLN.LN_FILIAL,SLN.LN_PEDIDO,SLN.LN_CLIENTE,SLN.LN_LOJA,SLN.LN_COD,SLN.LN_LOTECTL,"
		cQuery += "SLN.LN_NLOTE"
				
		cQuery := ChangeQuery(cQuery)
    	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSLN,.T.,.T.)

		For nSLN := 1 To Len(aStruSLN)
			If aStruSLN[nSLN][2] <> "C" .and.  FieldPos(aStruSLN[nSLN][1]) > 0
				TcSetField(cAliasSLN,aStruSLN[nSLN][1],aStruSLN[nSLN][2],aStruSLN[nSLN][3],aStruSLN[nSLN][4])
			EndIf
		Next nSLN

While (cAliasSLN)->(!Eof())
	//	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	³ Valida o produto conforme a mascara         ³
	//	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc((cAliasSLN)->LN_COD,MV_PAR04)
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
		dbSeek(xFilial("SB1") + (cAliasSLN)->LN_COD)
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2") + (cAliasSLN)->LN_COD + (cAliasSLN)->LN_LOCAL )
		cCodProd := Subs((cAliasSLN)->LN_COD,1,6)
		cPedido      := (cAliasSLN)->LN_PEDIDO 
		nQtdIt   := (cAliasSLN)->LN_QUANT
		cDescProd:= Subs(SB1->B1_DESC,1,45)
//		cGrade   := (cAliasSLN)->LN_GRADE
		cUnidade := SB1->B1_UM		             
		cLocaliza:= SB2->B2_LOCALIZ                      
		cLote	 := (cAliasSLN)->LN_LOTECTL
		cLocal 	 := (cAliasSLN)->LN_LOCAL                
		cSubLote := (cAliasSLN)->LN_NLOTE              
//		dDtValid := (cAliasSLN)->LN_DTVALID
//		nPotencia:= (cAliasSLN)->LN_POTENCI      

/*
		IF !lPyme .And. cGrade == "S" .and. MV_PAR05 == 1
			cProdRef 	:=Substr(cCodProd,1,nTamRef)
			nTotQuant	:=0
			While (cAliasSLN)->(!Eof()) .And. cProdRef == Substr((cAliasSLN)->LN_COD,1,nTamRef) .And.;
				(cLote == (cAliasSLN)->LN_LOTECTL .And. cSubLote == (cAliasSLN)->LN_NUMLOTE)
				nTotQuant += (cAliasSLN)->LN_QUANT
				(cAliasSLN)->(dbSkip())
				lSkip := .T.
			End
		Endif
*/
// "Codigo Nf     Desc. do Material                             UM       Qtde  Amz"
//            1         2         3         4         5         6         7         8         9        10        11        12        13      
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
// 																   999,999.99
 
		@ li, 00 Psay cCodProd  Picture "@!"
		@ li, 07 Psay cPedido Picture "@!"
		@ li, 14 Psay cDescProd	Picture "@!"
		@ li, 60 Psay cUnidade Picture "@!"
		@ li, 63 Psay nQtdIt Picture "@E 999,999.99"
		@ li, 76 Psay cLocal
//		If !lPyme
//			@ li, 66 Psay cLocaliza
//			@ li, 81 Psay cLote	Picture "@!"
//			@ li, 91 Psay cSubLote	Picture "@!"
//			@ li,101 Psay dDtValid	Picture PesqPict("SLN","LN_DTVALID")
//			@ li,116 PSay nPotencia Picture PesqPict("SLN","LN_POTENCI")
//		EndIf	
		li++
	EndIf

	If !lQuery .Or. !lSkip	
		dbSelectArea(cAliasSLN)
		dbSkip()
	EndIf	
	
End

IF lRodape
	roda(cbcont,cbtxt,"M")
Endif

If lQuery   
    dbSelectArea(cAliasSLN)
	dbCloseArea()  
	dbSelectArea("SLN")
Else
	RetIndex("SLN")   
	Ferase(cIndexSLN+OrdBagExt())
	dbSelectArea("SLN")
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Perg          ³ Autor ³ Rosane Luciane Chene  ³            Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Perguntas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RPICTR			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function Perg(_cPerg)
       //
       Local _cAlias
       //
       _cAlias  := Alias()
       _cPerg   := PADR(_cPerg,6)
       _aRegs    := {}
       //
       dbSelectArea("SX1")
       dbSetOrder(1)
       
 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01	     	  Da Transf
//³ mv_par02	     	  Ate aTransf                             ³
//³ mv_par03	     	  Data Inicial                   ³
//³ mv_par04	     	  Data Final                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       //
       AADD(_aRegs,{_cPerg,"01","Transf de                    ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"02","Transf Ate                   ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"03","Data Inicial                 ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","",dtoc(dDatabase),"","","","","","","","","","","","","","","","","","","","","",""})
       AADD(_aRegs,{_cPerg,"04","Data Final                   ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","",dtoc(dDatabase),"","","","","","","","","","","","","","","","","","","","","",""})
       //
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
       //
Return
