#INCLUDE "PROTHEUS.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MATR103 บ Autor ณ Aline Correa do Valeบ Data ณ  17/12/03   บฑฑ
ฑฑฬออออออออออุอออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Notas de Transferencia entre Filiais          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

USER Function RELDV001() 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1   := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2   := "de acordo com os parametros informados pelo usuario."
Local cDesc3   := "Rela็ใo de Notas Transfer๊ncia entre Filiais"
Local titulo   := "Rela็ใo de Notas Transfer๊ncia entre Filiais"
Local nLin     := 80

Local Cabec1   := "Data       Documento           Valor Mercadoria    Valor ICMS     Valor IPI   Valor Frete  Valor Seguro Vlr. Despesas     Total da Nota"
Local aOrd     := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "MATR103"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1} 
Private nLastKey    := 0
Private cPerg       := "MTR103"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "MATR103"

Private cString := "SF1"

dbSelectArea("SF1")
dbSetOrder(2)

pergunte(cPerg,.F.)

/********************************************************
* mv_par01 Da Filial
* mv_par02 Ate a Filial
* mv_par03 Imprime Itens?   Sim(1) / Nao(2)
* mv_par04 Imprimir:   Entradas(1) / Saidas(2) / Ambos(3)
* mv_par05 Emissao de
* mv_par06 Emissao ate
*********************************************************/

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Aline Correa do Vale บ Data ณ17/12/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Titulo,nLin)

Local aAreaSM0 := SM0->(GetArea())
Local aFornece := {}
Local aCliente := {}
Local cQuery   := ""
Local cQAdd    := ""
Local cIndex 	:= CriaTrab("",.F.)
Local cIndexF2 := CriaTrab("",.F.)
Local lContinua:= .T.
Local nX       := 0
Local cAliasSF1:= "SF1"
Local cAliasSD1:= "SD1"
Local cAliasSF2:= "SF2"
Local cAliasSD2:= "SD2"
#IFDEF TOP
	Local aStrucSF1:= {}
	Local aStrucSD1:= {}
	Local aStrucSF2:= {}
	Local aStrucSD2:= {}
#ENDIF
dbSelectArea(cString)
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

dbSelectArea("SD2")
dbSetOrder(3)
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SM0")
dbSetOrder(1)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura o CNPJ da Filial para localizar o Fornecedor e/ou Cliente cadastrado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(mv_par02)
	MsSeek(Subs(cNumEmp,1,2)+mv_par01,.T.)
	While SM0->M0_CODIGO+SM0->M0_CODFIL >= (Subs(cNumEmp,1,2)+mv_par01) .And.;
			SM0->M0_CODIGO+SM0->M0_CODFIL <= (Subs(cNumEmp,1,2)+mv_par02)
		If mv_par04 != 1
			dbSelectArea("SA1")
			dbSetOrder(3)
			If dbSeek(xFilial("SA1")+SM0->M0_CGC)
				aAdd(aCliente, {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME})
			EndIf
		EndIf
		If mv_par04 != 2
			dbSelectArea("SA2")
			dbSetOrder(3)
			If dbSeek(xFilial("SA2")+SM0->M0_CGC)
				aAdd(aFornece, {SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NOME})
			EndIf
		EndIf
		dbSelectArea("SM0")
		dbSkip()
	EndDo
EndIf

If !(Len(aFornece)+Len(aCliente)) > 0
	Help(" ",1,"RECNO")
   lContinua := .F.
EndIf

If mv_par04!=1 .And. Len(aCliente) > 0
	dbSelectArea("SF2")
	dbSetOrder(2)
	dbSeek(xFilial("SF2")+aCliente[1][1]+aCliente[1][2])

	#IFDEF TOP
      aStrucSF2 := SF2->(dbStruct())
      aStrucSD2 := SD2->(dbStruct())
		cQAdd := if(len(aCliente)>0,"(","")
		for nx:=1 to len(aCliente)
			if nx>1
				cQAdd += " OR "
			endif
			cQAdd += "(F2_CLIENTE='" +aCliente[nx][1] + "' AND F2_LOJA='"+aCliente[nx][2]+"')"
		next
		cQAdd += if(len(aCliente)>0,")","")

		cQuery := "SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_VALBRUT,"
		cQuery += "F2_VALMERC, F2_VALIPI, F2_VALICM, F2_FRETE, F2_DESPESA, F2_SEGURO, SF2.R_E_C_N_O_ SF2RECNO "
		If mv_par03 == 1 //lista itens
			cQuery += ",D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_VALICM, D2_VALIPI, D2_QUANT, D2_PRCVEN, D2_DESC, D2_TOTAL, "
			cQuery += "B1_COD, B1_DESC "
			cQuery += "FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF2") + " SF2, "
			cQuery += RetSqlName("SB1") + " SB1 "
			cQuery += "WHERE D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE "
			cQuery += "AND D2_LOJA = F2_LOJA AND D2_TIPO = F2_TIPO AND B1_COD = D2_COD "
			cQuery += "AND SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND "
		Else
			cQuery += "FROM " + RetSqlName("SF2") + " SF2 "
			cQuery += "WHERE "
		EndIf
		cQuery += "F2_EMISSAO >= '" + dToS(mv_par05)	+ "' AND "
		cQuery += "F2_EMISSAO <= '" + dToS(mv_par06)	+ "' AND "
		If Len(cQAdd) > 2
			cQuery += cQAdd + " AND "
		EndIf
		cQuery += "SF2.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY " + SqlOrder(SF2->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		cAliasSD2 := 'QRYSD2'
		cAliasSF2 := 'QRYSD2'
		cAliasSB1 := 'QRYSD2'
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'QRYSD2', .T., .T.)
      For nX := 1 to Len(aStrucSD2)
         If aStrucSD2[nX,2] != 'C' .And. FieldPos(aStrucSD2[nx,1]) > 0
            TCSetField('QRYSD2', aStrucSD2[nX,1], aStrucSD2[nX,2],aStrucSD2[nX,3],aStrucSD2[nX,4])
         EndIf	
      Next nX

      For nX := 1 to Len(aStrucSF1)
         If aStrucSF2[nX,2] != 'C'.And. FieldPos(aStrucSF2[nx,1]) > 0
            TCSetField('QRYSD2', aStrucSF2[nX,1], aStrucSF2[nX,2],aStrucSF2[nX,3],aStrucSF2[nX,4])
         EndIf	
      Next nX
	#ELSE
		cQAdd := if(len(aCliente)>0,"(","")
		for nx:=1 to len(aCliente)
			if nx>1
				cQAdd += " .OR. "
			endif
			cQAdd += "(F2_CLIENTE=='" +aCliente[nx][1] + "' .AND. F2_LOJA=='"+aCliente[nx][2]+"')"
		next
		cQAdd += if(len(aCliente)>0,")","")

		cQuery := "DTOS(F2_EMISSAO) >= '" + dToS(mv_par05)	+ "' .AND. "
		cQuery += "DTOS(F2_EMISSAO) <= '" + dToS(mv_par06) +"'"
		If Len(cQAdd) > 2
			cQuery += " .AND. " + cQAdd
		EndIf
	   IndRegua("SF2",cIndexF2,SF2->(indexkey()),,cQuery)
	#ENDIF
EndIf

If mv_par04!=2 .And. Len(aFornece) > 0
	dbSelectArea("SF1")
	dbSetOrder(2)
	dbSeek(xFilial("SF1")+aFornece[1][1]+aFornece[1][2])

	#IFDEF TOP
      aStrucSF1 := SF1->(dbStruct())
      aStrucSD1 := SD1->(dbStruct())
      aStrucSB1 := SB1->(dbStruct())
		cQAdd := if(len(aFornece)>0,"(","")
		for nx:=1 to len(aFornece)
			if nx>1
				cQAdd += " OR "
			endif
			cQAdd += "(F1_FORNECE='"+aFornece[nx][1] + "' AND F1_LOJA='"+aFornece[nx][2]+"')"
		next
		cQAdd += if(len(aFornece)>0,")","")
		cQuery := "SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_VALBRUT,"
		cQuery += "F1_VALMERC, F1_VALIPI, F1_VALICM, F1_FRETE, F1_DESPESA, F1_SEGURO, SF1.R_E_C_N_O_ SF1RECNO "
		If mv_par03 == 1 //lista itens
			cQuery += ",D1_FILIAL ,D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_VALICM, D1_VALIPI, D1_QUANT, D1_VUNIT, D1_VALDESC, D1_TOTAL, "
			cQuery += "B1_COD, B1_DESC "
			cQuery += "FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SF1") + " SF1, "
			cQuery += RetSqlName("SB1") + " SB1 "
			cQuery += "WHERE D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE "
			cQuery += "AND D1_LOJA = F1_LOJA AND D1_TIPO = F1_TIPO AND B1_COD = D1_COD "
			cQuery += "AND SD1.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND "
		Else
			cQuery += "FROM " + RetSqlName("SF1") + " SF1 "
			cQuery += "WHERE "
		EndIf
		cQuery += "F1_STATUS <> ' ' AND F1_STATUS <> 'B' AND "
		cQuery += "F1_EMISSAO >= '" + dToS(mv_par05)	+ "' AND "
		cQuery += "F1_EMISSAO <= '" + dToS(mv_par06)	+ "' AND "
		If Len(cQAdd) > 2
			cQuery += cQAdd + " AND "
		EndIf
		cQuery += "SF1.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY " + SqlOrder(SF1->(IndexKey()))
		cAliasSD1 := 'QRYSD1'
		cAliasSF1 := 'QRYSD1'
		cAliasSB1 := 'QRYSD1'
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'QRYSD1', .T., .T.)
      For nX := 1 to Len(aStrucSD1)
         If aStrucSD1[nX,2] != 'C' .And. FieldPos(aStrucSD1[nx,1]) > 0
            TCSetField('QRYSD1', aStrucSD1[nX,1], aStrucSD1[nX,2],aStrucSD1[nX,3],aStrucSD1[nX,4])
         EndIf	
      Next nX

      For nX := 1 to Len(aStrucSF1)
         If aStrucSF1[nX,2] != 'C'.And. FieldPos(aStrucSF1[nx,1]) > 0
            TCSetField('QRYSD1', aStrucSF1[nX,1], aStrucSF1[nX,2],aStrucSF1[nX,3],aStrucSF1[nX,4])
         EndIf	
      Next nX
	
	#ELSE
		cQAdd := if(len(aFornece)>0,"(","")
		for nx:=1 to len(aFornece)
			if nx>1
				cQAdd += " .OR. "
			endif
			cQAdd += "(F1_FORNECE=='" +aFornece[nx][1] + "' .AND. F1_LOJA=='"+aFornece[nx][2]+"')"
		next
		cQAdd += if(len(aFornece)>0,")","")
		cQuery := "F1_STATUS <> ' ' .AND. F1_STATUS <> 'B' .AND. "
		cQuery += "DTOS(F1_EMISSAO) >= '" + dToS(mv_par05)	+ "' .AND. "
		cQuery += "DTOS(F1_EMISSAO) <= '" + dToS(mv_par06) +"'"
		If Len(cQAdd) > 2
			cQuery += " .AND. " + cQAdd
		EndIf
	   IndRegua("SF1",cIndex,SF1->(indexkey()),,cQuery)
	#ENDIF
EndIf

nX := 1
If lContinua

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If mv_par04 == 1 .Or. mv_par04 == 3
	   For nX:=1 to Len(aFornece)
		   U_ImprSF1(aFornece, @nLin, nx, cAliasSF1, cAliasSD1, Cabec1, Titulo)
		Next
   	If nLin < 80
   		roda(cbcont,cbtxt,Tamanho)
		EndIf
	EndIf

   If mv_par04 == 2 .Or. mv_par04 == 3
   	nLin := 80
	   For nX:=1 to Len(aCliente)
		   U_ImprSF2(aCliente, @nLin, nx, cAliasSF2, cAliasSD2, Cabec1, Titulo)
		Next
   	If nLin < 80
   		roda(cbcont,cbtxt,Tamanho)
		EndIf
	EndIf
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea("SD2")
dbSetOrder(3)
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
#IFDEF TOP
	If Select(cAliasSF1) > 0
		dbSelectArea(cAliasSF1)
		dbCloseArea()
	EndIf
	If Select(cAliasSF2) > 0
		dbSelectArea(cAliasSF2)
		dbCloseArea()
	EndIf
#ENDIF
dbSelectArea("SF1")
set filter to
RetIndex("SF1")
If File(cIndex+OrdBagExt())
	Ferase(cIndex+OrdBagExt())
Endif
dbSelectArea("SF2")
RetIndex("SF2")
set filter to
If File(cIndexF2+OrdBagExt())
	Ferase(cIndexF2+OrdBagExt())
Endif

SM0->(RestArea(aAreaSM0))

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบFuno    ณ ImprSF1  บ Autor ณ Aline Correa do Vale บ Data ณ17/12/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ Imprime notas de entrada - SF1                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ImprSF1(aFornece, nLin, nX, cAliasSF1, cAliasSD1, Cabec1, Titulo)

Local cChaveSD1:= ""
Local nTValMerc:= 0
Local nTValBrut:= 0
Local nTValICM := 0
Local nTValIPI := 0
Local nTFrete  := 0
Local nTSeguro := 0
Local nTDespesa:= 0
Local cAliasSB1:= "SB1"
Local nTit := 0   

dbSelectArea(cAliasSF1)
#IFDEF TOP
	cAliasSB1 := cAliasSD1
#ELSE
	dbseek(xFilial("SF1")+aFornece[nx][1]+aFornece[nx][2])
#ENDIF

While xFilial("SF1")+aFornece[nx][1]+aFornece[nx][2] == F1_FILIAL+F1_FORNECE+F1_LOJA .AND. !Eof()
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo+" - ENTRADAS",Cabec1,"",NomeProg,Tamanho,nTipo) 
      nLin := 8
//    @ nLin, 00 pSay "Codigo / Loja: " + aFornece[nx][1] + "/" + aFornece[nx][2] + " - " + aFornece[nx][3] 
//    nLin := nLin + 2
   EndIf
   
	If nTit == 0 
      @ nLin, 00 pSay "*** CODIGO / LOJA: " + aFornece[nx][1] + " / " + aFornece[nx][2] + " - " + aFornece[nx][3] + " *** " 
      nLin := nLin + 1
      nTit := 1
 	EndIf

//a       Documento           Valor Mercadoria    Valor ICMS     Valor IPI   Valor Frete  Valor Seguro Vlr. Despesas    Total da Nota
//10/2003 123456123456/123456 11123,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 11123,123,123,99
	
	@ nLin, 00 pSay (cAliasSF1)->F1_EMISSAO Picture PesqPict("SF1","F1_EMISSAO")
	@ nLin, 11 pSay (cAliasSF1)->F1_DOC+"/"+(cAliasSF1)->F1_SERIE
	@ nLin, 31 pSay (cAliasSF1)->F1_VALMERC Picture PesqPict("SF1","F1_VALMERC",16)
	@ nLin, 48 pSay (cAliasSF1)->F1_VALICM  Picture PesqPict("SF1","F1_VALICM",13)
	@ nLin, 62 pSay (cAliasSF1)->F1_VALIPI  Picture PesqPict("SF1","F1_VALIPI",13)
	@ nLin, 76 pSay (cAliasSF1)->F1_FRETE   Picture PesqPict("SF1","F1_FRETE",13)
	@ nLin, 90 pSay (cAliasSF1)->F1_SEGURO  Picture PesqPict("SF1","F1_SEGURO",13)
	@ nLin,104 pSay (cAliasSF1)->F1_DESPESA Picture PesqPict("SF1","F1_DESPESA",13)
	@ nLin,118 pSay (cAliasSF1)->F1_VALBRUT Picture PesqPict("SF1","F1_VALBRUT",16)
	nTValMerc += (cAliasSF1)->F1_VALMERC
	nTValIcm  += (cAliasSF1)->F1_VALICM
	nTValIPI  += (cAliasSF1)->F1_VALIPI
	nTFrete   += (cAliasSF1)->F1_FRETE
	nTSeguro  += (cAliasSF1)->F1_SEGURO
	nTDespesa += (cAliasSF1)->F1_DESPESA
	nTValBrut += (cAliasSF1)->F1_VALBRUT
	
   nLin := nLin + 1

   If mv_par03 == 1 //Lista itens
   	dbSelectArea(cAliasSD1)
   	cChaveSD1 := xFilial("SD1")+(cAliasSF1)->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
   	#IFNDEF TOP
   		dbSeek(cChaveSD1)
   	#ENDIF
   	If !Eof()
			@ nLin, 00 pSay "DESCRICAO DA MERCADORIA                            VALOR ICMS     VALOR IPI    QUANTIDADE  VLR UNITARIO VLR. DESCONTO    TOTAL DO ITEM"
			nLin ++
		EndIf
   	While cChaveSD1 == (cAliasSD1)->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .And. !Eof()

//CRICAO DA MERCADORIA                            VALOR ICMS     VALOR IPI    QUANTIDADE  VLR UNITARIO VLR. DESCONTO    TOTAL DO ITEM
//456789012345 123456789012345678901234567890  23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 11123,123,123,99
			#IFNDEF TOP
				(cAliasSB1)->(dbSeek(xFilial("SB1")+(cAliasSD1)->D1_COD))
			#ENDIF
			@ nLin, 00 pSay (cAliasSD1)->D1_COD Picture PesqPict("SD1","D1_COD")
			@ nLin, 16 pSay (cAliasSB1)->B1_DESC
			@ nLin, 48 pSay (cAliasSD1)->D1_VALICM  Picture PesqPict("SD1","D1_VALICM",13)
			@ nLin, 62 pSay (cAliasSD1)->D1_VALIPI  Picture PesqPict("SD1","D1_VALIPI",13)
			@ nLin, 76 pSay (cAliasSD1)->D1_QUANT   Picture PesqPict("SD1","D1_QUANT",13)
			@ nLin, 90 pSay (cAliasSD1)->D1_VUNIT   Picture PesqPict("SD1","D1_VUNIT",13)
			@ nLin,104 pSay (cAliasSD1)->D1_VALDESC Picture PesqPict("SD1","D1_VALDESC",13)
			@ nLin,118 pSay (cAliasSD1)->D1_TOTAL   Picture PesqPict("SD1","D1_TOTAL",16)
			nLin ++ 
    		dbSkip()
   	EndDo
   		nLin ++
   EndIf
   dbSelectArea(cAliasSF1)
   If !mv_par03 == 1
   	dbSkip() // Avanca o ponteiro do registro no arquivo se nao mostrar itens   
   EndIF
   cbcont ++
EndDo
If nTValBrut > 0
	@ nLin, 00 PSAY "TOTAL ENTRADAS >>>>>>>>>>>>>>>>"
	@ nLin, 31 pSay nTValMerc Picture PesqPict("SF1","F1_VALMERC",16)
	@ nLin, 48 pSay nTValICM  Picture PesqPict("SF1","F1_VALICM",13)
	@ nLin, 62 pSay nTValIPI  Picture PesqPict("SF1","F1_VALIPI",13)
	@ nLin, 76 pSay nTFrete   Picture PesqPict("SF1","F1_FRETE",13)
	@ nLin, 90 pSay nTSeguro  Picture PesqPict("SF1","F1_SEGURO",13)
	@ nLin,104 pSay nTDespesa Picture PesqPict("SF1","F1_DESPESA",13)
	@ nLin,118 pSay nTValBrut Picture PesqPict("SF1","F1_VALBRUT",16)
	nLin := nLin +  3 // ACRESCENTADO POR RODRIGO RODRIGUES 
    nTit := 0 // Variavel para impressao do cab. ref a loja
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบFuno    ณ ImprSF2  บ Autor ณ Aline Correa do Vale บ Data ณ17/12/2003 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ Imprime notas de saidas - SF2                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ImprSF2(aCliente, nLin, nX, cAliasSF2, cAliasSD2, Cabec1, Titulo)

Local cChaveSD2:= ""
Local nTValMerc:= 0
Local nTValBrut:= 0
Local nTValICM := 0
Local nTValIPI := 0
Local nTFrete  := 0
Local nTSeguro := 0
Local nTDespesa:= 0
Local cAliasSB1:= "SB1"
Local nTit := 0   


dbSelectArea(cAliasSF2)
#IFDEF TOP
	cAliasSB1 := cAliasSD2
#ELSE
	dbseek(xFilial("SF2")+aCliente[nx][1]+aCliente[nx][2])
#ENDIF

While xFilial("SF2")+aCliente[nx][1]+aCliente[nx][2] == F2_FILIAL+F2_CLIENTE+F2_LOJA .AND. !Eof()
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo+" - SAIDAS",Cabec1,"",NomeProg,Tamanho,nTipo) 
      nLin := 8
//    @ nLin, 00 pSay "Codigo / Loja: "+ aCliente[nx][1] + "/" + aCliente[nx][2] + " - " + aCliente[nx][3] 
//    nLin := nLin + 2
   EndIf

   If nTit == 0 
      @ nLin, 00 pSay "*** Codigo / Loja: "+ aCliente[nx][1] + "/" + aCliente[nx][2] + " - " + aCliente[nx][3]+ " *** "  
      nLin := nLin + 1
      nTit := 1
   EndIf

//a       Documento           Valor Mercadoria    Valor ICMS     Valor IPI   Valor Frete  Valor Seguro Vlr. Despesas    Total da Nota
//10/2003 123456123456/123456 11123,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 11123,123,123,99
	@ nLin, 00 pSay (cAliasSF2)->F2_EMISSAO Picture PesqPict("SF2","F2_EMISSAO")
	@ nLin, 11 pSay (cAliasSF2)->F2_DOC+"/"+(cAliasSF2)->F2_SERIE
	@ nLin, 31 pSay (cAliasSF2)->F2_VALMERC Picture PesqPict("SF2","F2_VALMERC",16)
	@ nLin, 48 pSay (cAliasSF2)->F2_VALICM  Picture PesqPict("SF2","F2_VALICM",13)
	@ nLin, 62 pSay (cAliasSF2)->F2_VALIPI  Picture PesqPict("SF2","F2_VALIPI",13)
	@ nLin, 76 pSay (cAliasSF2)->F2_FRETE   Picture PesqPict("SF2","F2_FRETE",13)
	@ nLin, 90 pSay (cAliasSF2)->F2_SEGURO  Picture PesqPict("SF2","F2_SEGURO",13)
	@ nLin,104 pSay (cAliasSF2)->F2_DESPESA Picture PesqPict("SF2","F2_DESPESA",13)
	@ nLin,118 pSay (cAliasSF2)->F2_VALBRUT Picture PesqPict("SF2","F2_VALBRUT",16)
	nTValMerc += (cAliasSF2)->F2_VALMERC
	nTValIcm  += (cAliasSF2)->F2_VALICM
	nTValIPI  += (cAliasSF2)->F2_VALIPI
	nTFrete   += (cAliasSF2)->F2_FRETE
	nTSeguro  += (cAliasSF2)->F2_SEGURO
	nTDespesa += (cAliasSF2)->F2_DESPESA
	nTValBrut += (cAliasSF2)->F2_VALBRUT
	
    nLin := nLin + 1

   If mv_par03 == 1 //Lista itens
   	dbSelectArea(cAliasSD2)
   	cChaveSD2 := xFilial("SD2")+(cAliasSF2)->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
   	#IFNDEF TOP
   		dbSeek(cChaveSD2)
   	#ENDIF
   	If !Eof()
			@ nLin, 00 pSay "DESCRICAO DA MERCADORIA                            VALOR ICMS     VALOR IPI    QUANTIDADE  VLR UNITARIO VLR. DESCONTO    TOTAL DO ITEM"
			nLin ++
		EndIf
   	While cChaveSD2 == (cAliasSD2)->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) .And. !Eof()

//CRICAO DA MERCADORIA                            VALOR ICMS     VALOR IPI    QUANTIDADE  VLR UNITARIO VLR. DESCONTO    TOTAL DO ITEM
//456789012345 123456789012345678901234567890  23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 23,123,123,99 11123,123,123,99
			#IFNDEF TOP
				(cAliasSB1)->(dbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))
			#ENDIF
			@ nLin, 00 pSay (cAliasSD2)->D2_COD Picture PesqPict("SD2","D2_COD")
			@ nLin, 16 pSay (cAliasSB1)->B1_DESC
			@ nLin, 48 pSay (cAliasSD2)->D2_VALICM  Picture PesqPict("SD2","D2_VALICM",13)
			@ nLin, 62 pSay (cAliasSD2)->D2_VALIPI  Picture PesqPict("SD2","D2_VALIPI",13)
			@ nLin, 76 pSay (cAliasSD2)->D2_QUANT   Picture PesqPict("SD2","D2_QUANT",13)
			@ nLin, 90 pSay (cAliasSD2)->D2_PRCVEN  Picture PesqPict("SD2","D2_PRCVEN",13)
			@ nLin,104 pSay (cAliasSD2)->D2_DESC    Picture PesqPict("SD2","D2_DESC",13)
			@ nLin,118 pSay (cAliasSD2)->D2_TOTAL   Picture PesqPict("SD2","D2_TOTAL",16)
 			nLin ++
    		dbSkip()
   	EndDo
  		nLin ++
   EndIf
   dbSelectArea(cAliasSF2)
   If !mv_par03 == 1		
   	dbSkip() // Avanca o ponteiro do registro no arquivo se nao mostrar itens   	
   EndIF		
   cbcont ++
EndDo
If nTValBrut > 0
	@ nLin, 00 PSAY "TOTAL SAIDAS >>>>>>>>>>>>>>>>"
	@ nLin, 31 pSay nTValMerc Picture PesqPict("SF2","F2_VALMERC",16)
	@ nLin, 48 pSay nTValICM  Picture PesqPict("SF2","F2_VALICM",13)
	@ nLin, 62 pSay nTValIPI  Picture PesqPict("SF2","F2_VALIPI",13)
	@ nLin, 76 pSay nTFrete   Picture PesqPict("SF2","F2_FRETE",13)
	@ nLin, 90 pSay nTSeguro  Picture PesqPict("SF2","F2_SEGURO",13)
	@ nLin,104 pSay nTDespesa Picture PesqPict("SF2","F2_DESPESA",13)
	@ nLin,118 pSay nTValBrut Picture PesqPict("SF2","F2_VALBRUT",16)
	nLin := nLin +  3 // ACRESCENTADO POR RODRIGO RODRIGUES 
	nTit := 0 // Variavel para impressao do cab. ref a loja
EndIf

Return()